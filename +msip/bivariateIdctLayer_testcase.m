classdef bivariateIdctLayer_testcase < matlab.unittest.TestCase
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
            expctdDescription = "Bivariate IDCT of size " ...
                + stride(1) + "x"' + stride(2);
            
            % Instantiation of target class
            import msip.*
            layer = bivariateIdctLayer(stride,expctdName);
            
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
                    expctdZ(:,:,iComponent,iSample) = ...
                        blockproc(X(:,:,iComponent,iSample),...
                        stride,@(x) idct2(x.data));
                end
            end
            
            % Instantiation of target class
            import msip.*
            layer = bivariateIdctLayer(stride,'E0~');
            
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
            layer = bivariateIdctLayer(stride,'E0~');
            
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
            layer = bivariateIdctLayer(stride,'E0~');
            
            % Actual values
            actualdLdX = layer.backward([],[],dLdZ,[]);
            
            % Evaluation
            testCase.verifyInstanceOf(actualdLdX,datatype);
            testCase.verifyThat(actualdLdX,...
                IsEqualTo(expctddLdX,'Within',tolObj));
        end
        %}
    end
end

