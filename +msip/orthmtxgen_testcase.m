classdef orthmtxgen_testcase < matlab.unittest.TestCase
    %ORTHONORMALMATRIXGENERATIONSYSTEMTESTCASE Test case for orthmtxgen
    %
    % Exported and modified from SaivDr package
    %
    %    https://github.com/msiplab/SaivDr
    %
    % Requirements: MATLAB R2015bRequirements: MATLAB R2015b
    %
    % Copyright (c) 2014-2020, Shogo MURAMATSU
    %
    % All rights reserved.
    %
    % Contact address: Shogo MURAMATSU,
    %                Faculty of Engineering, Niigata University,
    %                8050 2-no-cho Ikarashi, Nishi-ku,
    %                Niigata, 950-2181, JAPAN
    %
    % http://msiplab.eng.niigata-u.ac.jp/    
    %
    properties
        omgs
    end
    
    methods (TestMethodTeardown) 
        function deleteObject(testCase)
            delete(testCase.omgs);
        end
    end
    
    methods (Test)

        % Test for default construction
        function testConstructor(testCase)
            
            % Expected values
            coefExpctd = [
                1 0 ;
                0 1 ];
            
            % Instantiation of target class
            import msip.*
            testCase.omgs = orthmtxgen();
            
            % Actual values
            coefActual = generate(testCase.omgs,0,1);
            
            % Evaluation
            testCase.verifyEqual(coefExpctd,coefActual);
        end

        % Test for default construction
        function testConstructorWithAngles(testCase)
            
            % Expected values
            coefExpctd = [
                cos(pi/4) -sin(pi/4) ;
                sin(pi/4)  cos(pi/4) ];
            
            % Instantiation of target class
            import msip.*            
            testCase.omgs = orthmtxgen();
            
            % Actual values
            coefActual = generate(testCase.omgs,pi/4,1);
            
            % Evaluation
            testCase.verifyEqual(coefExpctd,coefActual,'RelTol',1e-10);
        end
        
        % Test for default construction
        function testConstructorWithAnglesAndMus(testCase)
            
            % Expected values
            coefExpctd = [
                cos(pi/4) -sin(pi/4) ;
                -sin(pi/4) -cos(pi/4) ];
            
            % Instantiation of target class
            import msip.*            
            testCase.omgs = orthmtxgen();
            
            % Actual values
            coefActual = generate(testCase.omgs,pi/4,[ 1 -1 ]);            
            
            % Evaluation
            testCase.verifyEqual(coefExpctd,coefActual,'RelTol',1e-10);
            
        end

        % Test for set angle
        function testSetAngles(testCase)
            
            % Expected values
            coefExpctd = [
                1 0 ;
                0 1 ];
            
            % Instantiation of target class
            import msip.*            
            testCase.omgs = orthmtxgen();
            
            % Actual values
            coefActual = generate(testCase.omgs,0,1);
            
            % Evaluation
            testCase.verifyEqual(coefExpctd,coefActual,'RelTol',1e-10);
            
            % Expected values
            coefExpctd = [
                cos(pi/4) -sin(pi/4) ;
                sin(pi/4)  cos(pi/4) ];
            
            % Actual values
            coefActual = generate(testCase.omgs,pi/4,1);
            
            % Evaluation
            testCase.verifyEqual(coefExpctd,coefActual,'RelTol',1e-10);
        end

        % Test for set angle
        function test4x4(testCase)
            
            % Expected values
            normExpctd = 1;
            
            % Instantiation of target class
            ang = 2*pi*rand(6,1);
            import msip.*            
            testCase.omgs = orthmtxgen();
            
            % Actual values
            normActual = norm(generate(testCase.omgs,ang,1)*[1 0 0 0].');
            
            % Evaluation
            message = ...
                sprintf('normActual=%g differs from 1',normActual);
            testCase.verifyEqual(normActual,normExpctd,'RelTol',1e-15,message);
            
        end

        % Test for set angle
        function test8x8(testCase)
            
            % Expected values
            normExpctd = 1;
            
            % Instantiation of target class
            ang = 2*pi*rand(28,1);
            import msip.*            
            testCase.omgs = orthmtxgen();
            
            % Actual values
            normActual = norm(generate(testCase.omgs,ang,1)*[1 0 0 0 0 0 0 0].');
            
            % Evaluation
            message = ...
                sprintf('normActual=%g differs from 1',normActual);
            testCase.verifyEqual(normActual,normExpctd,'RelTol',1e-15,message);
        end
        
        % Test for set angle
        function test4x4red(testCase)
            
            % Expected values
            ltExpctd = 1;
            
            % Instantiation of target class
            ang = 2*pi*rand(6,1);
            nSize = 4;
            ang(1:nSize-1,1) = zeros(nSize-1,1);
            import msip.*            
            testCase.omgs = orthmtxgen();
            
            % Actual values
            matrix = generate(testCase.omgs,ang,1);
            ltActual = matrix(1,1);
            
            % Evaluation
            message = ...
                sprintf('ltActual=%g differs from 1',ltActual);
            testCase.verifyEqual(ltActual,ltExpctd,'RelTol',1e-15,message);
        end
        
        % Test for set angle
        function test8x8red(testCase)
            
            % Expected values
            ltExpctd = 1;
            
            % Instantiation of target class
            ang = 2*pi*rand(28,1);
            nSize = 8;
            ang(1:nSize-1,1) = zeros(nSize-1,1);
            import msip.*            
            testCase.omgs = orthmtxgen();
            
            % Actual values
            matrix = generate(testCase.omgs,ang,1);
            ltActual = matrix(1,1);
            
            % Evaluation
            message = ...
                sprintf('ltActual=%g differs from 1',ltActual);
            testCase.verifyEqual(ltActual,ltExpctd,'RelTol',1e-15,message);
        end
        
        % Test for set angle
        function testPartialDifference(testCase)
            
            % Expected values
            coefExpctd = [
                0 -1 ;
                1  0 ];
            
            % Instantiation of target class
            import msip.*
            testCase.omgs = orthmtxgen();
            
            % Actual values
            coefActual = generate(testCase.omgs,0,1,1);
            
            % Evaluation
            testCase.verifyEqual(coefExpctd,coefActual,'AbsTol',1e-10);
        end

        % Test for set angle
        function testPartialDifferenceAngs(testCase)
            
            % Expected values
            coefExpctd = [
                cos(pi/4+pi/2) -sin(pi/4+pi/2) ;
                sin(pi/4+pi/2)  cos(pi/4+pi/2) ];
            
            % Instantiation of target class
            import msip.*            
            testCase.omgs = orthmtxgen();
            
            % Actual values
            coefActual = generate(testCase.omgs,pi/4,1,1);
            
            % Evaluation
            testCase.verifyEqual(coefExpctd,coefActual,'AbsTol',1e-10);
        end

        % Test for default construction
        function testPartialDifferenceWithAnglesAndMus(testCase)
            
            % Expected values
            coefExpctd = [
                cos(pi/4+pi/2) -sin(pi/4+pi/2) ;
                -sin(pi/4+pi/2) -cos(pi/4+pi/2) ];
            
            % Instantiation of target class
            import msip.*            
            testCase.omgs = orthmtxgen();
            
            % Actual values
            coefActual = generate(testCase.omgs,pi/4,[ 1 -1 ],1);            
            
            % Evaluation
            testCase.verifyEqual(coefExpctd,coefActual,'AbsTol',1e-10);
            
        end

        % Test for set angle
        function testPartialDifferenceSetAngles(testCase)
            
            % Expected values
            coefExpctd = [
                0 -1 ;
                1  0 ];
            
            % Instantiation of target class
            import msip.*            
            testCase.omgs = orthmtxgen();
            
            % Actual values
            coefActual = generate(testCase.omgs,0,1,1);
            
            % Evaluation
            testCase.verifyEqual(coefExpctd,coefActual,'AbsTol',1e-10);
            
            % Expected values
            coefExpctd = [
                cos(pi/4+pi/2) -sin(pi/4+pi/2) ;
                sin(pi/4+pi/2)  cos(pi/4+pi/2) ];
            
            % Actual values
            coefActual = generate(testCase.omgs,pi/4,1,1);
            
            % Evaluation
            testCase.verifyEqual(coefExpctd,coefActual,'AbsTol',1e-10);
        end

        % Test for set angle
        function test4x4RandAngs(testCase)
            
            % Expected values
            mus = [ -1 1 -1 1 ];
            angs = 2*pi*rand(6,1);
            coefExpctd = ...
                diag(mus) * ...
               [ 1  0   0             0            ;
                 0  1   0             0            ;
                 0  0   cos(angs(6)) -sin(angs(6)) ;
                 0  0   sin(angs(6))  cos(angs(6)) ] *...                                                                            
               [ 1  0            0  0            ;
                 0  cos(angs(5)) 0 -sin(angs(5)) ;
                 0  0            1  0            ;
                 0  sin(angs(5)) 0 cos(angs(5))  ] *...                                                            
               [ 1  0             0            0 ;
                 0  cos(angs(4)) -sin(angs(4)) 0 ;
                 0  sin(angs(4))  cos(angs(4)) 0 ;
                 0  0             0            1 ] *...                                            
               [ cos(angs(3)) 0 0 -sin(angs(3))  ;
                 0            1 0  0             ;
                 0            0 1  0             ;        
                 sin(angs(3)) 0 0  cos(angs(3)) ] *...                            
               [ cos(angs(2)) 0 -sin(angs(2)) 0  ;
                 0            1  0            0  ; 
                 sin(angs(2)) 0  cos(angs(2)) 0  ;
                 0            0  0            1 ] *...            
               [ cos(angs(1)) -sin(angs(1)) 0 0  ;
                 sin(angs(1)) cos(angs(1))  0 0  ;
                 0            0             1 0  ;
                 0            0             0 1 ];
            
            % Instantiation of target class
            import msip.*            
            testCase.omgs = orthmtxgen();
            
            % Actual values
            coefActual = generate(testCase.omgs,angs,mus);            
            
            % Evaluation
            testCase.verifyEqual(coefExpctd,coefActual,'AbsTol',1e-10);

        end

        % Test for set angle
        function testPartialDifference4x4RandAngPdAng3(testCase)
            
            % Expected values
            mus = [ -1 1 -1 1 ];
            angs = 2*pi*rand(6,1);
            pdAng = 3;
            coefExpctd = ...
                diag(mus) * ...
               [ 1  0   0             0            ;
                 0  1   0             0            ;
                 0  0   cos(angs(6)) -sin(angs(6)) ;
                 0  0   sin(angs(6))  cos(angs(6)) ] *...                                                                            
               [ 1  0            0  0            ;
                 0  cos(angs(5)) 0 -sin(angs(5)) ;
                 0  0            1  0            ;
                 0  sin(angs(5)) 0 cos(angs(5))  ] *...                                                            
               [ 1  0             0            0 ;
                 0  cos(angs(4)) -sin(angs(4)) 0 ;
                 0  sin(angs(4))  cos(angs(4)) 0 ;
                 0  0             0            1 ] *...                                            
               [ cos(angs(3)+pi/2) 0 0 -sin(angs(3)+pi/2)  ; % Partial Diff.
                 0            0 0  0             ;
                 0            0 0  0             ;        
                 sin(angs(3)+pi/2) 0 0  cos(angs(3)+pi/2) ] *...                            
               [ cos(angs(2)) 0 -sin(angs(2)) 0  ;
                 0            1  0            0  ; 
                 sin(angs(2)) 0  cos(angs(2)) 0  ;
                 0            0  0            1 ] *...            
               [ cos(angs(1)) -sin(angs(1)) 0 0  ;
                 sin(angs(1)) cos(angs(1))  0 0  ;
                 0            0             1 0  ;
                 0            0             0 1 ];
            
            % Instantiation of target class
            import msip.*            
            testCase.omgs = orthmtxgen();
            
            % Actual values
            coefActual = generate(testCase.omgs,angs,mus,pdAng);            
            
            % Evaluation
            testCase.verifyEqual(coefExpctd,coefActual,'AbsTol',1e-10);

        end        

        % Test for set angle
        function testPartialDifference4x4RandAngPdAng6(testCase)
            
            % Expected values
            mus = [ 1 1 -1 -1 ];
            angs = 2*pi*rand(6,1);
            pdAng = 6;
            coefExpctd = ...
                diag(mus) * ...
               [ 0  0   0             0            ;
                 0  0   0             0            ;
                 0  0   cos(angs(6)+pi/2) -sin(angs(6)+pi/2) ; % Partial Diff.
                 0  0   sin(angs(6)+pi/2)  cos(angs(6)+pi/2) ] *...                                                                            
               [ 1  0            0  0            ;
                 0  cos(angs(5)) 0 -sin(angs(5)) ;
                 0  0            1  0            ;
                 0  sin(angs(5)) 0 cos(angs(5))  ] *...                                                            
               [ 1  0             0            0 ;
                 0  cos(angs(4)) -sin(angs(4)) 0 ;
                 0  sin(angs(4))  cos(angs(4)) 0 ;
                 0  0             0            1 ] *...                                            
               [ cos(angs(3)) 0 0 -sin(angs(3))  ; 
                 0            1 0  0             ;
                 0            0 1  0             ;        
                 sin(angs(3)) 0 0  cos(angs(3)) ] *...                            
               [ cos(angs(2)) 0 -sin(angs(2)) 0  ;
                 0            1  0            0  ; 
                 sin(angs(2)) 0  cos(angs(2)) 0  ;
                 0            0  0            1 ] *...            
               [ cos(angs(1)) -sin(angs(1)) 0 0  ;
                 sin(angs(1)) cos(angs(1))  0 0  ;
                 0            0             1 0  ;
                 0            0             0 1 ];
            
            % Instantiation of target class
            import msip.*            
            testCase.omgs = orthmtxgen();
            
            % Actual values
            coefActual = generate(testCase.omgs,angs,mus,pdAng);            
            
            % Evaluation
            testCase.verifyEqual(coefExpctd,coefActual,'AbsTol',1e-10);

        end        
        
         % Test for set angle
        function testPartialDifference4x4RandAngPdAng2(testCase)
            
            % Expected values
            mus = [ -1 -1 -1 -1 ];
            angs = 2*pi*rand(6,1);
            pdAng = 2;
            delta = 1e-10;
            coefExpctd = 1/delta * ...
                diag(mus) * ...
               [ 1  0   0             0            ;
                 0  1   0             0            ;
                 0  0   cos(angs(6)) -sin(angs(6)) ; 
                 0  0   sin(angs(6))  cos(angs(6)) ] *...                                                                            
               [ 1  0            0  0            ;
                 0  cos(angs(5)) 0 -sin(angs(5)) ;
                 0  0            1  0            ;
                 0  sin(angs(5)) 0 cos(angs(5))  ] *...                                                            
               [ 1  0             0            0 ;
                 0  cos(angs(4)) -sin(angs(4)) 0 ;
                 0  sin(angs(4))  cos(angs(4)) 0 ;
                 0  0             0            1 ] *...                                            
               [ cos(angs(3)) 0 0 -sin(angs(3))  ; 
                 0            1 0  0             ;
                 0            0 1  0             ;        
                 sin(angs(3)) 0 0  cos(angs(3)) ] * ...                           
            ( ...
               [ cos(angs(2)+delta) 0 -sin(angs(2)+delta) 0  ; 
                 0            1  0            0  ; 
                 sin(angs(2)+delta) 0  cos(angs(2)+delta) 0  ;
                 0            0  0            1 ] - ...
               [ cos(angs(2)) 0 -sin(angs(2)) 0  ; 
                 0            1  0            0  ; 
                 sin(angs(2)) 0  cos(angs(2)) 0  ;
                 0            0  0            1 ] ...                 
             ) *...            
               [ cos(angs(1)) -sin(angs(1)) 0 0  ;
                 sin(angs(1)) cos(angs(1))  0 0  ;
                 0            0             1 0  ;
                 0            0             0 1 ];
            
            % Instantiation of target class
            import msip.*            
            testCase.omgs = orthmtxgen();
            
            % Actual values
            coefActual = generate(testCase.omgs,angs,mus,pdAng);            
            
            % Evaluation
            testCase.verifyEqual(coefExpctd,coefActual,'AbsTol',1e-5);

        end
        
        % Test for set angle
        function testPartialDifference8x8RandAngPdAng2(testCase)
            
            % Expected values
            pdAng = 14;            
            delta = 1e-10;            
            angs0 = 2*pi*rand(28,1);
            angs1 = angs0;
            angs1(pdAng) = angs1(pdAng)+delta;
            
            % Instantiation of target class
            import msip.*            
            testCase.omgs = orthmtxgen();            
            coefExpctd = 1/delta * ...
                ( generate(testCase.omgs,angs1,1) ...
                - generate(testCase.omgs,angs0,1));
            
            % Instantiation of target class
            import msip.*            
            testCase.omgs = orthmtxgen();
            
            % Actual values
            coefActual = generate(testCase.omgs,angs0,1,pdAng);            
            
            % Evaluation
            testCase.verifyEqual(coefExpctd,coefActual,'AbsTol',1e-5);

        end        
        
    end
end
