classdef nsoltChannelConcatenationLayer_testcase < matlab.unittest.TestCase
    %NSOLTCHANNELCONCATENATIONLAYER_TESTCASE
    %
    %   ２コンポーネント入力(nComponents=2のみサポート):
    %      nRows x nCols x 1 x nSamples
    %      nRows x nCols x (nChsTotal-1) x nSamples    
    %
    %   １コンポーネント出力(nComponents=1のみサポート):
    %      nRows x nCols x nChsTotal x nSamples
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
            expctdName = 'Cn';
            expctdDescription = "Channel concatenation";
            
            % Instantiation of target class
            import msip.*
            layer = nsoltChannelConcatenationLayer('Name',expctdName);
            
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
            % nRows x nCols x 1 x nSamples
            X1 = randn(nrows,ncols,1,nSamples,datatype);
            % nRows x nCols x (nChsTotal-1) x nSamples 
            X2 = randn(nrows,ncols,nChsTotal-1,nSamples,datatype);
            
            % Expected values
            % nRows x nCols x nChsTotal x nSamples
            expctdZ = cat(3,X1,X2);
            
            % Instantiation of target class
            import msip.*
            layer = nsoltChannelConcatenationLayer('Name','Cn');
            
            % Actual values
            actualZ = layer.predict(X1,X2);
            
            % Evaluation
            testCase.verifyInstanceOf(actualZ,datatype);
            testCase.verifyThat(actualZ,...
                IsEqualTo(expctdZ,'Within',tolObj));
            
        end

    end
    
end

