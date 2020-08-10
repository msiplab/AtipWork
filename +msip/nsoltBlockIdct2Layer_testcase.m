classdef nsoltBlockIdct2Layer_testcase < matlab.unittest.TestCase
    %BIVARIATEIDCTLAYER_TESTCASE このクラスの概要をここに記述
    %   詳細説明をここに記述
    
    properties (TestParameter)
        stride = { [2 2], [4 4] };
        datatype = { 'single', 'double' };
        nComponents = struct('grayscale',1,'rgbcolor',3);
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
            layer = nsoltBlockIdct2Layer(stride,expctdName);
            
            % Actual values
            actualName = layer.Name;
            actualDescription = layer.Description;
            
            % Evaluation
            testCase.verifyEqual(actualName,expctdName);
            testCase.verifyEqual(actualDescription,expctdDescription);
        end
        
        function testPredict(testCase, ...
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
                    Y = blockproc(X(:,:,iComponent,iSample),...
                        stride,...
                        @testCase.permuteIdctCoefs_);
                    expctdZ(:,:,iComponent,iSample) = ...
                        blockproc(Y,...
                        stride,...
                        @(x) idct2(x.data));
                end
            end
            
            % Instantiation of target class
            import msip.*
            layer = nsoltBlockIdct2Layer(stride,'E0~');
            
            % Actual values
            actualZ = layer.predict(X);
            
            % Evaluation
            testCase.verifyInstanceOf(actualZ,datatype);
            testCase.verifyThat(actualZ,...
                IsEqualTo(expctdZ,'Within',tolObj));
            
        end
        
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
            layer = nsoltBlockIdct2Layer(stride,'E0~');
            
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
            layer = nsoltBlockIdct2Layer(stride,'E0~');
            
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

