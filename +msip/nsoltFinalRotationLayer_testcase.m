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
                Ai = col2im(Zi,stride,[height width],'distinct');
                % Inverse perumation in each block
                expctdZ(:,:,1,iSample) = ...
                    blockproc(Ai,stride,@testCase.permuteIdctCoefs_);
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
            % nRows x nCols x nChs x nSamples
            X = randn(nrows,ncols,sum(nchs),nSamples,datatype);
            angles = randn((nChsTotal-2)*nChsTotal/4,1);
            
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
            
            % Instantiation of target class
            import msip.*
            layer = nsoltFinalRotationLayer(nchs,stride,'V0~');
            
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
            layer = nsoltFinalRotationLayer(nchs,stride,'V0~');
            
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
            layer = nsoltFinalRotationLayer(nchs,stride,'V0~');
            
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
    
    methods (Static, Access = private)
        
        function value = permuteIdctCoefs_(x)
            coefs = x.data;
            decY_ = x.blockSize(1);
            decX_ = x.blockSize(2);
            nQDecsee = ceil(decY_/2)*ceil(decX_/2);
            nQDecsoo = floor(decY_/2)*floor(decX_/2);
            nQDecsoe = floor(decY_/2)*ceil(decX_/2);
            cee = coefs(         1:  nQDecsee);
            coo = coefs(nQDecsee+1:nQDecsee+nQDecsoo);
            coe = coefs(nQDecsee+nQDecsoo+1:nQDecsee+nQDecsoo+nQDecsoe);
            ceo = coefs(nQDecsee+nQDecsoo+nQDecsoe+1:end);
            value = zeros(decY_,decX_);
            value(1:2:decY_,1:2:decX_) = reshape(cee,ceil(decY_/2),ceil(decX_/2));
            value(2:2:decY_,2:2:decX_) = reshape(coo,floor(decY_/2),floor(decX_/2));
            value(2:2:decY_,1:2:decX_) = reshape(coe,floor(decY_/2),ceil(decX_/2));
            value(1:2:decY_,2:2:decX_) = reshape(ceo,ceil(decY_/2),floor(decX_/2));
        end
        
    end
end

