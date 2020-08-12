classdef nsoltChannelSeparationLayer_testcase < matlab.unittest.TestCase
    %NSOLTCHANNELSEPARATIONLAYER_TESTCASE
    %
    %   １コンポーネント入力(nComponents=1のみサポート):
    %      nRows x nCols x nChsTotal x nSamples
    %
    %   ２コンポーネント出力(nComponents=2のみサポート):
    %      nRows x nCols x 1 x nSamples
    %      nRows x nCols x (nChsTotal-1) x nSamples    
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
        nchs = { [3 3], [4 4] };
        datatype = { 'single', 'double' };
        nrows = struct('small', 4,'medium', 8, 'large', 16);
        ncols = struct('small', 4,'medium', 8, 'large', 16);
    end
    
    methods (Test)
        
        function testConstructor(testCase)
            
            % Expected values
            expctdName = 'Sp';
            expctdDescription = "Channel separation";
            
            % Instantiation of target class
            import msip.*
            layer = nsoltChannelSeparationLayer('Name',expctdName);
            
            % Actual values
            actualName = layer.Name;
            actualDescription = layer.Description;
            
            % Evaluation
            testCase.verifyEqual(actualName,expctdName);    
            testCase.verifyEqual(actualDescription,expctdDescription);
        end
        
        function testPredict(testCase,nchs,nrows,ncols,datatype)
            
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance
            tolObj = AbsoluteTolerance(1e-6,single(1e-6));
            
            % Parameters
            nSamples = 8;
            nChsTotal = sum(nchs);
            % nRows x nCols x nChsTotal x nSamples
            X = randn(nrows,ncols,nChsTotal,nSamples,datatype);
            
            % Expected values
            % nRows x nCols x 1 x nSamples
            expctdZ1 = X(:,:,1,:);
            % nRows x nCols x (nChsTotal-1) x nSamples 
            expctdZ2 = X(:,:,2:end,:);
            
            % Instantiation of target class
            import msip.*
            layer = nsoltChannelSeparationLayer('Name','Sp');
            
            % Actual values
            [actualZ1,actualZ2] = layer.predict(X);
            
            % Evaluation
            testCase.verifyInstanceOf(actualZ1,datatype);
            testCase.verifyInstanceOf(actualZ2,datatype);            
            testCase.verifyThat(actualZ1,...
                IsEqualTo(expctdZ1,'Within',tolObj));
            testCase.verifyThat(actualZ2,...
                IsEqualTo(expctdZ2,'Within',tolObj));            
            
        end

    end
    
end

