classdef nsoltBlockCircularShiftLayer_testcase < matlab.unittest.TestCase
    %NSOLTFINALROTATIONLAYER_TESTCASE このクラスの概要をここに記述
    %   詳細説明をここに記述
    %
    %   コンポーネント別に入力(nComponents):
    %      nRows x nCols x nChsTotal x nSamples
    %
    %   コンポーネント別に出力(nComponents):
    %      nRows x nCols x nChsTotal x nSamples
    %
    
    properties (TestParameter)
        nchs = { [3 3] };
        datatype = { 'single', 'double' };
        nrows = struct('small', 4,'medium', 8, 'large', 16);
        ncols = struct('small', 4,'medium', 8, 'large', 16);
        dir = { 'Right', 'Left', 'Up', 'Down' };
    end
    
    methods (Test)
        
        function testConstructor(testCase, nchs)
            
            % Expected values
            expctdName = 'Qn~';
            expctdDirection = 'Right';
            expctdTargetChannels = 'Lower';
            expctdDescription = "Right shift Lower Coefs. " ...
                + "(ps,pa) = (" ...
                + nchs(1) + "," + nchs(2) + ")";
            
            % Instantiation of target class
            import msip.*
            layer = nsoltBlockCircularShiftLayer(nchs,...
                expctdName,expctdDirection,expctdTargetChannels);
            
            % Actual values
            actualName = layer.Name;
            actualDirection = layer.Direction;
            actualTargetChannels = layer.TargetChannels;
            actualDescription = layer.Description;
            
            % Evaluation
            testCase.verifyEqual(actualName,expctdName);
            testCase.verifyEqual(actualDirection,expctdDirection);
            testCase.verifyEqual(actualTargetChannels,expctdTargetChannels);            
            testCase.verifyEqual(actualDescription,expctdDescription);
        end
        
        function testPredictGrayscaleShiftLowerCoefs(testCase, ...
                nchs, nrows, ncols, dir, datatype)
            
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance
            tolObj = AbsoluteTolerance(1e-6,single(1e-6));
            
            % Parameters
            nSamples = 8;
            nChsTotal = sum(nchs);
            target = 'Lower';
            % nRows x nCols x nChsTotal x nSamples
            X = randn(nrows,ncols,nChsTotal,nSamples,datatype);
            
            % Expected values
            if strcmp(dir,'Right')
                shift = [ 0 0  1 0 ];
            elseif strcmp(dir,'Left')
                shift = [ 0 0 -1 0 ];
            elseif strcmp(dir,'Down')
                shift = [ 0  1 0 0 ];
            elseif strcmp(dir,'Up')
                shift = [ 0 -1 0 0 ];
            else
                shift = [ 0 0 0 0 ];
            end
            % nRows x nCols x nChsTotal x nSamples
            ps = nchs(1);
            pa = nchs(2);
            Y = permute(X,[3 1 2 4]); % [ch ver hor smpl]
            Y(ps+1:ps+pa,:,:,:) = circshift(Y(ps+1:ps+pa,:,:,:),shift);
            expctdZ = ipermute(Y,[3 1 2 4]);
            
            % Instantiation of target class
            import msip.*
            layer = nsoltBlockCircularShiftLayer(nchs,'Qn~',dir,target);
            
            % Actual values
            actualZ = layer.predict(X);
            
            % Evaluation
            testCase.verifyInstanceOf(actualZ,datatype);
            testCase.verifyThat(actualZ,...
                IsEqualTo(expctdZ,'Within',tolObj));
            
        end
        
        function testPredictGrayscaleShiftUpperCoefs(testCase, ...
                nchs, nrows, ncols, dir, datatype)
            
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance
            tolObj = AbsoluteTolerance(1e-6,single(1e-6));
            
            % Parameters
            nSamples = 8;
            nChsTotal = sum(nchs);
            target = 'Upper';
            % nRows x nCols x nChsTotal x nSamples
            X = randn(nrows,ncols,nChsTotal,nSamples,datatype);
            
            % Expected values
            if strcmp(dir,'Right')
                shift = [ 0 0  1 0 ];
            elseif strcmp(dir,'Left')
                shift = [ 0 0 -1 0 ];
            elseif strcmp(dir,'Down')
                shift = [ 0  1 0 0 ];
            elseif strcmp(dir,'Up')
                shift = [ 0 -1 0 0 ];
            else
                shift = [ 0 0 0 0 ];
            end
            % nRows x nCols x nChsTotal x nSamples
            ps = nchs(1);
            Y = permute(X,[3 1 2 4]); % [ch ver hor smpl]
            Y(1:ps,:,:,:) = circshift(Y(1:ps,:,:,:),shift);
            expctdZ = ipermute(Y,[3 1 2 4]);
            
            % Instantiation of target class
            import msip.*
            layer = nsoltBlockCircularShiftLayer(nchs,'Qn~',dir,target);
            
            % Actual values
            actualZ = layer.predict(X);
            
            % Evaluation
            testCase.verifyInstanceOf(actualZ,datatype);
            testCase.verifyThat(actualZ,...
                IsEqualTo(expctdZ,'Within',tolObj));
            
        end
        %{
        function testPredictGrayscaleWithRandomAngles(testCase, ...
                nchs, nrows, ncols, mus, datatype)
            
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance
            tolObj = AbsoluteTolerance(1e-6,single(1e-6));
            import msip.*
            genU = orthmtxgen();
            
            % Parameters
            nSamples = 8;
            nChsTotal = sum(nchs);
            % nRows x nCols x nChs x nSamples
            X = randn(nrows,ncols,nChsTotal,nSamples,datatype);
            angles = randn((nChsTotal-2)*nChsTotal/8,1);
            
            % Expected values
            % nRows x nCols x nChsTotal x nSamples
            ps = nchs(1);
            pa = nchs(2);
            UnT = transpose(genU.generate(angles,mus));
            Y = permute(X,[3 1 2 4]);
            Ya = reshape(Y(ps+1:ps+pa,:,:,:),pa,nrows*ncols*nSamples);
            Za = UnT*Ya;
            Y(ps+1:ps+pa,:,:,:) = reshape(Za,pa,nrows,ncols,nSamples);
            expctdZ = ipermute(Y,[3 1 2 4]);
            
            % Instantiation of target class
            import msip.*
            layer = nsoltBlockCircularShiftLayer(nchs,'Vn~');
            
            % Actual values
            layer.Mus = mus;
            layer.Angles = angles;
            actualZ = layer.predict(X);
            
            % Evaluation
            testCase.verifyInstanceOf(actualZ,datatype);
            testCase.verifyThat(actualZ,...
                IsEqualTo(expctdZ,'Within',tolObj));
            
        end
        
        function testPredictGrayscaleAnalysisMode(testCase, ...
                nchs, nrows, ncols, mus, datatype)
            
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance
            tolObj = AbsoluteTolerance(1e-6,single(1e-6));
            import msip.*
            genU = orthmtxgen();
            
            % Parameters
            nSamples = 8;
            nChsTotal = sum(nchs);
            % nRows x nCols x nChs x nSamples
            X = randn(nrows,ncols,nChsTotal,nSamples,datatype);
            angles = randn((nChsTotal-2)*nChsTotal/8,1);
            
            % Expected values
            % nRows x nCols x nChsTotal x nSamples
            ps = nchs(1);
            pa = nchs(2);
            Un = genU.generate(angles,mus);
            Y = permute(X,[3 1 2 4]);
            Ya = reshape(Y(ps+1:ps+pa,:,:,:),pa,nrows*ncols*nSamples);
            Za = Un*Ya;
            Y(ps+1:ps+pa,:,:,:) = reshape(Za,pa,nrows,ncols,nSamples);
            expctdZ = ipermute(Y,[3 1 2 4]);
            expctdDescription = "Analysis NSOLT intermediate rotation " ...
                + "(ps,pa) = (" ...
                + nchs(1) + "," + nchs(2) + ")";
            
            % Instantiation of target class
            import msip.*
            layer = nsoltBlockCircularShiftLayer(nchs,'Vn~','Analysis');
            
            % Actual values
            layer.Mus = mus;
            layer.Angles = angles;
            actualZ = layer.predict(X);
            actualDescription = layer.Description;
            
            % Evaluation
            testCase.verifyInstanceOf(actualZ,datatype);
            testCase.verifyThat(actualZ,...
                IsEqualTo(expctdZ,'Within',tolObj));
            testCase.verifyEqual(actualDescription,expctdDescription);            
            
        end
        %}
        
    end
    
end

