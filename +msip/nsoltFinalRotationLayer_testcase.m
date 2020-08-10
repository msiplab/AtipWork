classdef nsoltFinalRotationLayer_testcase < matlab.unittest.TestCase
    %NSOLTFINALROTATIONLAYER_TESTCASE このクラスの概要をここに記述
    %   詳細説明をここに記述
    %
    %   コンポーネント別に入力(nComponents): 
    %      nRows x nCols x nChs x nSamples
    %
    %   ベクトル配列をブロック配列にして出力:
    %      (Stride(1)xnRows) x (Stride(2)xnCols) x nComponents x nSamples
    %
    
    properties (TestParameter)
        nchs = { [3 3] };
        stride = { [2 2] };
        datatype = { 'single', 'double' };
        nrows = struct('small', 4,'medium', 8, 'large', 16);
        ncols = struct('small', 4,'medium', 8, 'large', 16);
    end
    
    methods (Test)
        
        function testConstructor(testCase, nchs, stride)
            
            % Expected values
            expctdName = 'V0~';
            expctdDescription = "NSOLT final rotation ( " ...
                + "(ps,pa) = (" ...
                + nchs(1) + "," + nchs(2) + "), "  ...
                + "(mv,mh) = (" ...
                + stride(1) + "," + stride(2) + ")" ...
                + " )";
            
            % Instantiation of target class
            import msip.*
            layer = nsoltFinalRotationLayer(nchs,stride,expctdName);
            
            % Actual values
            actualName = layer.Name;
            actualDescription = layer.Description;
            
            % Evaluation
            testCase.verifyEqual(actualName,expctdName);
            testCase.verifyEqual(actualDescription,expctdDescription);
        end
        
        function testPredictGrayscale(testCase, ...
                nchs, stride, nrows, ncols, datatype)
                
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance
            tolObj = AbsoluteTolerance(1e-6,single(1e-6));
            
            % Parameters
            nSamples = 8;
            nDecs = prod(stride);
            % nRows x nCols x nChs x nSamples
            X = randn(nrows,ncols,sum(nchs),nSamples,datatype);
            
            % Expected values
            % (Stride(1)xnRows) x (Stride(2)xnCols) x nComponents x nSamples
            height = stride(1)*nrows;
            width = stride(2)*ncols;
            ps = nchs(1);
            pa = nchs(2);
            W0T = eye(ps,datatype);
            U0T = eye(pa,datatype);
            Y = permute(X,[3 1 2 4]);
            Ys = reshape(Y(1:ps,:,:,:),ps,nrows*ncols*nSamples);
            Ya = reshape(Y(ps+1:ps+pa,:,:,:),pa,nrows*ncols*nSamples);
            Zsa = [ W0T(1:nDecs/2,:)*Ys; U0T(1:nDecs/2,:)*Ya ];
            expctdZ = zeros(height,width,1,nSamples,datatype);
            nBlks = nrows*ncols;
            for iSample=1:nSamples
                Zi = Zsa(:,(iSample-1)*nBlks+1:iSample*nBlks);
                expctdZ(:,:,1,iSample) = ...
                    col2im(Zi,stride,[height width],'distinct');    
            end
            
            % Instantiation of target class
            import msip.*
            layer = nsoltFinalRotationLayer(nchs,stride,'V0~');
            
            % Actual values
            actualZ = layer.predict(X);
            
            % Evaluation
            testCase.verifyInstanceOf(actualZ,datatype);
            testCase.verifyThat(actualZ,...
                IsEqualTo(expctdZ,'Within',tolObj));
            
        end
        
        
        function testPredictGrayscaleRandomAngles(testCase, ...
                nchs, stride, nrows, ncols, datatype)
                
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance
            tolObj = AbsoluteTolerance(1e-6,single(1e-6));
            
            % Parameters
            nSamples = 8;
            nDecs = prod(stride);
            % nRows x nCols x nChs x nSamples
            X = randn(nrows,ncols,sum(nchs),nSamples,datatype);
            
            % Expected values
            % (Stride(1)xnRows) x (Stride(2)xnCols) x nComponents x nSamples
            height = stride(1)*nrows;
            width = stride(2)*ncols;
            ps = nchs(1);
            pa = nchs(2);
            W0T = eye(ps,datatype);
            U0T = eye(pa,datatype);
            Y = permute(X,[3 1 2 4]);
            Ys = reshape(Y(1:ps,:,:,:),ps,nrows*ncols*nSamples);
            Ya = reshape(Y(ps+1:ps+pa,:,:,:),pa,nrows*ncols*nSamples);
            Zsa = [ W0T(1:nDecs/2,:)*Ys; U0T(1:nDecs/2,:)*Ya ];
            expctdZ = zeros(height,width,1,nSamples,datatype);
            nBlks = nrows*ncols;
            for iSample=1:nSamples
                Zi = Zsa(:,(iSample-1)*nBlks+1:iSample*nBlks);
                expctdZ(:,:,1,iSample) = ...
                    col2im(Zi,stride,[height width],'distinct');    
            end
            
            % Instantiation of target class
            import msip.*
            layer = nsoltFinalRotationLayer(nchs,stride,'V0~');
            
            % Actual values
            actualZ = layer.predict(X);
            
            % Evaluation
            testCase.verifyInstanceOf(actualZ,datatype);
            testCase.verifyThat(actualZ,...
                IsEqualTo(expctdZ,'Within',tolObj));
            
        end
        
        
        %{
        function testForwardGrayScale(testCase, ...
                stride, nComponents, height, width, datatype)
                        
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance
            tolObj = AbsoluteTolerance(1e-6,single(1e-6));
            
            % Parameters
            nSamples = 8;
            X = rand(height,width,nComponents,nSamples, type);
            
            % Expected values
            expctdZ = zeros(size(X),type);
            for iSample = 1:nSamples
                for iComponent = 1:nComponents
                    expctdZ(:,:,iComponent,iSample) = ...
                        blockproc(X(:,:,iComponent,iSample),...
                        stride,@(x) idct2(x.data));
                end
            end
            
            % Instantiation of target class
            import msip.*
            layer = bivariateIdctLayer(stride,'E0~');
            
            % Actual values
            actualZ = layer.forward(X);
            
            % Evaluation
            testCase.verifyInstanceOf(actualZ,type);
            testCase.verifyThat(actualZ,...
                IsEqualTo(expctdZ,'Within',tolObj));
            
        end
        
        function testBackwardGrayScale(testCase, ...
                stride, nComponents, height, width, type)
                        
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance
            tolObj = AbsoluteTolerance(1e-6,single(1e-6));
            
            % Parameters
            nSamples = 8;
            dLdZ = rand(height,width,nComponents,nSamples, type);
            
            % Expected values
            expctddLdX = zeros(size(dLdZ),type);
            for iSample = 1:nSamples
                for iComponent = 1:nComponents
                    expctddLdX(:,:,iComponent,iSample) = ...
                        blockproc(dLdZ(:,:,iComponent,iSample),...
                        stride,@(x) dct2(x.data));
                end
            end
            
            % Instantiation of target class
            import msip.*
            layer = bivariateIdctLayer(stride,'E0~');
            
            % Actual values
            actualdLdX = layer.backward([],[],dLdZ,[]);
            
            % Evaluation
            testCase.verifyInstanceOf(actualdLdX,type);
            testCase.verifyThat(actualdLdX,...
                IsEqualTo(expctddLdX,'Within',tolObj));
        end
        %}
    end
end

