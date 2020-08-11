classdef nsoltInitialRotationLayer_testcase < matlab.unittest.TestCase
    %NSOLTFINALROTATIONLAYER_TESTCASE このクラスの概要をここに記述
    %   詳細説明をここに記述
    %
    %   コンポーネント別に入力(nComponents):
    %      nRows x nCols x nDecs x nSamples
    %
    %   コンポーネント別に出力(nComponents):
    %      nRows x nCols x nChs x nSamples
    %
    
    properties (TestParameter)
        nchs = { [3 3], [4 4] };
        stride = { [2 2] };
        datatype = { 'single', 'double' };
        nrows = struct('small', 4,'medium', 8, 'large', 16);
        ncols = struct('small', 4,'medium', 8, 'large', 16);
    end
    
    methods (Test)
        
        function testConstructor(testCase, nchs, stride)
            
            % Expected values
            expctdName = 'V0';
            expctdDescription = "NSOLT initial rotation ( " ...
                + "(ps,pa) = (" ...
                + nchs(1) + "," + nchs(2) + "), "  ...
                + "(mv,mh) = (" ...
                + stride(1) + "," + stride(2) + ")" ...
                + " )";
            
            % Instantiation of target class
            import msip.*
            layer = nsoltInitialRotationLayer(nchs,stride,expctdName);
            
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
            nChsTotal = sum(nchs);
            % nRows x nCols x nDecs x nSamples            
            X = randn(nrows,ncols,nDecs,nSamples,datatype);
            
            % Expected values
            % nRows x nCols x nChs x nSamples
            ps = nchs(1);
            pa = nchs(2);
            W0 = eye(ps,datatype);
            U0 = eye(pa,datatype);
            expctdZ = zeros(nrows,ncols,nChsTotal,nSamples,datatype);
            Y  = zeros(nChsTotal,nrows,ncols,datatype);
            for iSample=1:nSamples
                % Perumation in each block                
                Ai = permute(X(:,:,:,iSample),[3 1 2]); 
                Yi = reshape(Ai,nDecs,nrows,ncols);
                %
                Ys = Yi(1:nDecs/2,:);
                Ya = Yi(nDecs/2+1:end,:);
                Y(1:ps,:,:) = ...
                    reshape(W0(:,1:nDecs/2)*Ys,ps,nrows,ncols);
                Y(ps+1:ps+pa,:,:) = ...
                    reshape(U0(:,1:nDecs/2)*Ya,pa,nrows,ncols);
                expctdZ(:,:,:,iSample) = ipermute(Y,[3 1 2]);                
            end
            
            % Instantiation of target class
            import msip.*
            layer = nsoltInitialRotationLayer(nchs,stride,'V0');
            
            % Actual values
            actualZ = layer.predict(X);
            
            % Evaluation
            testCase.verifyInstanceOf(actualZ,datatype);
            testCase.verifyThat(actualZ,...
                IsEqualTo(expctdZ,'Within',tolObj));
            
        end
        
        function testPredictGrayscaleWithRandomAngles(testCase, ...
                nchs, stride, nrows, ncols, datatype)
            
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance
            tolObj = AbsoluteTolerance(1e-6,single(1e-6));
            import msip.*
            genW = orthmtxgen();
            genU = orthmtxgen();
            
            % Parameters
            nSamples = 8;
            nDecs = prod(stride);
            nChsTotal = sum(nchs);
            % nRows x nCols x nDecs x nSamples            
            X = randn(nrows,ncols,nDecs,nSamples,datatype);
            angles = randn((nChsTotal-2)*nChsTotal/4,1);
            
            % Expected values
            % nRows x nCols x nChs x nSamples
            ps = nchs(1);
            pa = nchs(2);
            W0 = genW.generate(angles(1:length(angles)/2),1);
            U0 = genU.generate(angles(length(angles)/2+1:end),1);
            expctdZ = zeros(nrows,ncols,nChsTotal,nSamples,datatype);
            Y  = zeros(nChsTotal,nrows,ncols,datatype);
            for iSample=1:nSamples
                % Perumation in each block                
                Ai = permute(X(:,:,:,iSample),[3 1 2]); 
                Yi = reshape(Ai,nDecs,nrows,ncols);
                %
                Ys = Yi(1:nDecs/2,:);
                Ya = Yi(nDecs/2+1:end,:);
                Y(1:ps,:,:) = ...
                    reshape(W0(:,1:nDecs/2)*Ys,ps,nrows,ncols);
                Y(ps+1:ps+pa,:,:) = ...
                    reshape(U0(:,1:nDecs/2)*Ya,pa,nrows,ncols);
                expctdZ(:,:,:,iSample) = ipermute(Y,[3 1 2]);
            end
            
            % Instantiation of target class
            import msip.*
            layer = nsoltInitialRotationLayer(nchs,stride,'V0~');
            
            % Actual values
            layer.Angles = angles;
            actualZ = layer.predict(X);
            
            % Evaluation
            testCase.verifyInstanceOf(actualZ,datatype);
            testCase.verifyThat(actualZ,...
                IsEqualTo(expctdZ,'Within',tolObj));
            
        end

        %{
        function testForwardGrayscaleWithRandomAngles(testCase, ...
                nchs, stride, nrows, ncols, datatype)
            
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance
            tolObj = AbsoluteTolerance(1e-6,single(1e-6));
            import msip.*
            genW = orthmtxgen();
            genU = orthmtxgen();
            
            % Parameters
            nSamples = 8;
            nDecs = prod(stride);
            nChsToTal = sum(nchs);
            % nRows x nCols x nChs x nSamples
            X = randn(nrows,ncols,sum(nchs),nSamples,datatype);
            angles = randn((nChsToTal-2)*nChsToTal/4,1);
            
            % Expected values
            % (Stride(1)xnRows) x (Stride(2)xnCols) x nComponents x nSamples
            height = stride(1)*nrows;
            width = stride(2)*ncols;
            ps = nchs(1);
            pa = nchs(2);
            W0T = transpose(genW.generate(angles(1:length(angles)/2),1));
            U0T = transpose(genU.generate(angles(length(angles)/2+1:end),1));
            Y = permute(X,[3 1 2 4]);
            Ys = reshape(Y(1:ps,:,:,:),ps,nrows*ncols*nSamples);
            Ya = reshape(Y(ps+1:ps+pa,:,:,:),pa,nrows*ncols*nSamples);
            Zsa = [ W0T(1:nDecs/2,:)*Ys; U0T(1:nDecs/2,:)*Ya ];
            expctdZ = zeros(height,width,1,nSamples,datatype);
            nBlks = nrows*ncols;
            for iSample=1:nSamples
                Zi = Zsa(:,(iSample-1)*nBlks+1:iSample*nBlks);
                Ai = col2im(Zi,stride,[height width],'distinct');
                % Inverse perumation in each block
                expctdZ(:,:,1,iSample) = ...
                    blockproc(Ai,stride,@testCase.permuteIdctCoefs_);
            end
            expctdMem = X;
            
            % Instantiation of target class
            import msip.*
            layer = nsoltInitialRotationLayer(nchs,stride,'V0~');
            
            % Actual values
            layer.Angles = angles;
            [actualZ,actualMem] = layer.forward(X);
            
            % Evaluation
            testCase.verifyInstanceOf(actualZ,datatype);
            testCase.verifyInstanceOf(actualMem,datatype);
            testCase.verifyThat(actualZ,...
                IsEqualTo(expctdZ,'Within',tolObj));
            testCase.verifyThat(actualMem,...
                IsEqualTo(expctdMem,'Within',tolObj));
            
        end

        function testBackwardGrayscaleWithRandomAngle(testCase, ...
                nchs, stride, nrows, ncols, datatype)
            
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance
            tolObj = AbsoluteTolerance(1e-6,single(1e-6));
            import msip.*
            genW = orthmtxgen();
            genU = orthmtxgen();
            
            % Parameters
            nSamples = 8;
            nDecs = prod(stride);
            nChsTotal = sum(nchs);
            % nRows x nCols x nChs x nSamples
            dLdZ = randn(nrows,ncols,sum(nchs),nSamples,datatype); % 2-D DCT output
            memory = []; % X
            angles = randn((nChsTotal-2)*nChsTotal/4,1);
            
            % Expected values
            % (Stride(1)xnRows) x (Stride(2)xnCols) x nComponents x nSamples
            height = stride(1)*nrows;
            width = stride(2)*ncols;
            ps = nchs(1);
            pa = nchs(2);
            W0T = transpose(genW.generate(angles(1:length(angles)/2),1));
            U0T = transpose(genU.generate(angles(length(angles)/2+1:end),1));
            %{
            Y = permute(dLdZ,[3 1 2 4]);
            Ys = reshape(Y(1:ps,:,:,:),ps,nrows*ncols*nSamples);
            Ya = reshape(Y(ps+1:ps+pa,:,:,:),pa,nrows*ncols*nSamples);
            Zsa = [ W0T(1:nDecs/2,:)*Ys; U0T(1:nDecs/2,:)*Ya ];
            expctddLdX = zeros(,1,nSamples,datatype);
            nBlks = nrows*ncols;
            for iSample=1:nSamples
                Zi = Zsa(:,(iSample-1)*nBlks+1:iSample*nBlks);
                Ai = col2im(Zi,stride,[height width],'distinct');
                % Inverse perumation in each block
                expctddLdX(:,:,1,iSample) = ...
                    blockproc(Ai,stride,@testCase.permuteIdctCoefs_);
            end
            %}
            expctddLdx = [];
            expctddLdW = [];
            
            % Instantiation of target class
            import msip.*
            layer = nsoltInitialRotationLayer(nchs,stride,'V0~');
            
            % Actual values
            layer.Angles = angles;
            [actualdLdX,actualdLdW] = layer.backward([],[],dLdZ, memory);
            
            % Evaluation
            testCase.verifyInstanceOf(actualdLdX,datatype);
            testCase.verifyInstanceOf(actualdLdW,datatype);            
            testCase.verifyThat(actualdLdX,...
                IsEqualTo(expctddLdX,'Within',tolObj));
            testCase.verifyThat(actualdLdW,...
                IsEqualTo(expctddLdW,'Within',tolObj));            
        end
        %}
    end
    
    %{
    methods (Static, Access = private)

        
        function value = permuteDctCoefs_(x)
            coefs = x.data;
            decY_ = x.blockSize(1);
            decX_ = x.blockSize(2);
            cee = coefs(1:2:end,1:2:end);
            coo = coefs(2:2:end,2:2:end);
            coe = coefs(2:2:end,1:2:end);
            ceo = coefs(1:2:end,2:2:end);
            value = [ cee(:) ; coo(:) ; coe(:) ; ceo(:) ];
            value = reshape(value,decY_,decX_);
        end
        
    end
    %}
end

