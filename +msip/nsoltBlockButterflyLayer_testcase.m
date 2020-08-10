classdef nsoltBlockButterflyLayer_testcase < matlab.unittest.TestCase
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
        nchs = { [3 3], [4 4] };
        datatype = { 'single', 'double' };
        nrows = struct('small', 4,'medium', 8, 'large', 16);
        ncols = struct('small', 4,'medium', 8, 'large', 16);
    end
    
    methods (Test)
        
        function testConstructor(testCase, nchs)
            
            % Expected values
            expctdName = 'B';
            expctdDescription = "NSOLT block butterfly " ...
                + "(ps,pa) = (" ...
                + nchs(1) + "," + nchs(2) + ")";
            
            % Instantiation of target class
            import msip.*
            layer = nsoltBlockButterflyLayer(nchs,expctdName);
            
            % Actual values
            actualName = layer.Name;
            actualDescription = layer.Description;
            
            % Evaluation
            testCase.verifyEqual(actualName,expctdName);
            testCase.verifyEqual(actualDescription,expctdDescription);
        end
        
        function testPredictGrayscale(testCase, ...
                nchs, nrows, ncols, datatype)
            
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance
            tolObj = AbsoluteTolerance(1e-6,single(1e-6));
            
            % Parameters
            nSamples = 8;
            nChsTotal = sum(nchs);
            % nRows x nCols x nChsTotal x nSamples
            X = randn(nrows,ncols,nChsTotal,nSamples,datatype);
            
            % Expected values
            % nRows x nCols x nChsTotal x nSamples
            ps = nchs(1);
            pa = nchs(2);
            Y = permute(X,[3 1 2 4]); % [ch ver hor smpl]
            Ys = Y(1:ps,:,:,:);
            Ya = Y(ps+1:ps+pa,:,:,:);
            Y =  [ Ys+Ya ; Ys-Ya ]/sqrt(2);
            expctdZ = ipermute(Y,[3 1 2 4]);
            
            % Instantiation of target class
            import msip.*
            layer = nsoltBlockButterflyLayer(nchs,'B');
            
            % Actual values
            actualZ = layer.predict(X);
            
            % Evaluation
            testCase.verifyInstanceOf(actualZ,datatype);
            testCase.verifyThat(actualZ,...
                IsEqualTo(expctdZ,'Within',tolObj));
            
        end

    end
    
end

