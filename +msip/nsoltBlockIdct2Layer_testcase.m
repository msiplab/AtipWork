classdef nsoltBlockIdct2Layer_testcase < matlab.unittest.TestCase
    %NSOLTBLOCKIDCT2LAYER_TESTCASE
    %
    %   コンポーネント別に入力(nComponents=1のみサポート):
    %      nRows x nCols x nDecs x nSamples
    %
    %   ベクトル配列をブロック配列にして出力(nComponents=1のみサポート):
    %      (Stride(1)xnRows) x (Stride(2)xnCols) x nComponents x nSamples
    %
    % Requirements: MATLAB R2020a
    %
    % Copyright (c) 2020, Shogo MURAMATSU
    %
    % All rights reserved.
    %
    % Contact address: Shogo MURAMATSU,
    %                Faculty of Engineering, Niigata University,
    %                8050 2-no-cho Ikarashi, Nishi-ku,
    %                Niigata, 950-2181, JAPAN
    %
    % http://msiplab.eng.niigata-u.ac.jp/    
    
    properties (TestParameter)
        stride = { [2 2], [4 4] };
        datatype = { 'single', 'double' };
        height = struct('small', 8,'medium', 16, 'large', 32);
        width = struct('small', 8,'medium', 16, 'large', 32);
    end
    
    methods (Test)
        
        function testConstructor(testCase, stride)
            
            % Expected values
            expctdName = 'E0~';
            expctdDescription = "Block IDCT of size " ...
                + stride(1) + "x"' + stride(2);
            
            % Instantiation of target class
            import msip.*
            layer = nsoltBlockIdct2Layer(...
                'DecimationFactor',stride,...
                'Name',expctdName);
            
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
            nrows = height/stride(1);
            ncols = width/stride(2);
            nDecs = prod(stride);
            nComponents = 1;
            X = rand(nrows,ncols,nDecs,nSamples,datatype);
            
            % Expected values
            expctdZ = zeros(height,width,datatype);
            for iSample = 1:nSamples
                A = reshape(permute(X(:,:,:,iSample),[3 1 2]),...
                    nDecs*nrows,ncols);
                Y = blockproc(A,[nDecs 1],...
                    @(x) testCase.permuteIdctCoefs_(x.data,stride));
                expctdZ(:,:,nComponents,iSample) = ...
                    blockproc(Y,...
                    stride,...
                    @(x) idct2(x.data));
            end
            
            % Instantiation of target class
            import msip.*
            layer = nsoltBlockIdct2Layer(...
                'DecimationFactor',stride,...
                'Name','E0~');
            
            % Actual values
            actualZ = layer.predict(X);
            
            % Evaluation
            testCase.verifyInstanceOf(actualZ,datatype);
            testCase.verifyThat(actualZ,...
                IsEqualTo(expctdZ,'Within',tolObj));
            
        end
        
    end
    
    methods (Static, Access = private)
        
        function value = permuteIdctCoefs_(x,blockSize)
            coefs = x;
            decY_ = blockSize(1);
            decX_ = blockSize(2);
            nQDecsee = ceil(decY_/2)*ceil(decX_/2);
            nQDecsoo = floor(decY_/2)*floor(decX_/2);
            nQDecsoe = floor(decY_/2)*ceil(decX_/2);
            cee = coefs(         1:  nQDecsee);
            coo = coefs(nQDecsee+1:nQDecsee+nQDecsoo);
            coe = coefs(nQDecsee+nQDecsoo+1:nQDecsee+nQDecsoo+nQDecsoe);
            ceo = coefs(nQDecsee+nQDecsoo+nQDecsoe+1:end);
            value = zeros(decY_,decX_,'like',x);
            value(1:2:decY_,1:2:decX_) = reshape(cee,ceil(decY_/2),ceil(decX_/2));
            value(2:2:decY_,2:2:decX_) = reshape(coo,floor(decY_/2),floor(decX_/2));
            value(2:2:decY_,1:2:decX_) = reshape(coe,floor(decY_/2),ceil(decX_/2));
            value(1:2:decY_,2:2:decX_) = reshape(ceo,ceil(decY_/2),floor(decX_/2));
        end
        
    end
end

