classdef nsoltBlockDct2Layer_testcase < matlab.unittest.TestCase
    %BIVARIATEIDCTLAYER_TESTCASE このクラスの概要をここに記述
    %   詳細説明をここに記述
    %
    %   ベクトル配列をブロック配列を入力:
    %      (Stride(1)xnRows) x (Stride(2)xnCols) x nComponents x nSamples
    %
    %   コンポーネント別に出力(nComponents):
    %      nRows x nCols x nDecs x nSamples
    %    
    
    properties (TestParameter)
        stride = { [2 2], [4 4] };
        datatype = { 'single', 'double' };
        height = struct('small', 8,'medium', 16, 'large', 32);
        width = struct('small', 8,'medium', 16, 'large', 32);
    end
    
    methods (Test)
        
        function testConstructor(testCase, stride)
            
            % Expected values
            expctdName = 'E0';
            expctdDescription = "Block DCT of size " ...
                + stride(1) + "x"' + stride(2);
            
            % Instantiation of target class
            import msip.*
            layer = nsoltBlockDct2Layer(stride,expctdName);
            
            % Actual values
            actualName = layer.Name;
            actualDescription = layer.Description;
            
            % Evaluation
            testCase.verifyEqual(actualName,expctdName);
            testCase.verifyEqual(actualDescription,expctdDescription);
        end
        
        function testPredictGrayScale(testCase, ...
                stride, height, width, datatype)
                
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance
            tolObj = AbsoluteTolerance(1e-6,single(1e-6));
            
            % Parameters
            nSamples = 8;
            nComponents = 1;
            X = rand(height,width,nComponents,nSamples, datatype);
            
            % Expected values
            nrows = height/stride(1);
            ncols = width/stride(2);
            ndecs = prod(stride);
            expctdZ = zeros(nrows,ncols,ndecs,nSamples,datatype);
            for iSample = 1:nSamples
                % Block DCT
                Y = blockproc(X(:,:,nComponents,iSample),...
                    stride,@(x) dct2(x.data));
                % Rearrange the DCT Coefs.
                A = blockproc(Y,...
                    stride,@testCase.permuteDctCoefs_);
                expctdZ(:,:,:,iSample) = ...
                    permute(reshape(A,ndecs,nrows,ncols),[2 3 1]);                
            end
            
            % Instantiation of target class
            import msip.*
            layer = nsoltBlockDct2Layer(stride,'E0');
            
            % Actual values
            actualZ = layer.predict(X);
            
            % Evaluation
            testCase.verifyInstanceOf(actualZ,datatype);
            testCase.verifyThat(actualZ,...
                IsEqualTo(expctdZ,'Within',tolObj));
            
        end
        %}
        %{
        function testForward(testCase, ...
                stride, nComponents, height, width, datatype)
                        
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance
            tolObj = AbsoluteTolerance(1e-6,single(1e-6));
            
            % Parameters
            nSamples = 8;
            X = rand(height,width,nComponents,nSamples, datatype);
            
            % Expected values
            expctdZ = zeros(size(X),datatype);
            for iSample = 1:nSamples
                for iComponent = 1:nComponents
                    expctdZ(:,:,iComponent,iSample) = ...
                        blockproc(X(:,:,iComponent,iSample),...
                        stride,@(x) idct2(x.data));
                end
            end
            
            % Instantiation of target class
            import msip.*
            layer = nsoltBlockDct2Layer(stride,'E0~');
            
            % Actual values
            actualZ = layer.forward(X);
            
            % Evaluation
            testCase.verifyInstanceOf(actualZ,datatype);
            testCase.verifyThat(actualZ,...
                IsEqualTo(expctdZ,'Within',tolObj));
            
        end
        
        function testBackward(testCase, ...
                stride, nComponents, height, width, datatype)
                        
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance
            tolObj = AbsoluteTolerance(1e-6,single(1e-6));
            
            % Parameters
            nSamples = 8;
            dLdZ = rand(height,width,nComponents,nSamples, datatype);
            
            % Expected values
            expctddLdX = zeros(size(dLdZ),datatype);
            for iSample = 1:nSamples
                for iComponent = 1:nComponents
                    expctddLdX(:,:,iComponent,iSample) = ...
                        blockproc(dLdZ(:,:,iComponent,iSample),...
                        stride,@(x) dct2(x.data));
                end
            end
            
            % Instantiation of target class
            import msip.*
            layer = nsoltBlockDct2Layer(stride,'E0~');
            
            % Actual values
            actualdLdX = layer.backward([],[],dLdZ,[]);
            
            % Evaluation
            testCase.verifyInstanceOf(actualdLdX,datatype);
            testCase.verifyThat(actualdLdX,...
                IsEqualTo(expctddLdX,'Within',tolObj));
        end
        %}
    end
    
    methods (Static, Access = private)
        
        function value = permuteDctCoefs_(x)
            coefs = x.data;
            cee = coefs(1:2:end,1:2:end);
            coo = coefs(2:2:end,2:2:end);
            coe = coefs(2:2:end,1:2:end);
            ceo = coefs(1:2:end,2:2:end);
            value = [ cee(:) ; coo(:) ; coe(:) ; ceo(:) ];
        end
        
    end
    
end

