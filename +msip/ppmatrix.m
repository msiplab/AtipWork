classdef ppmatrix < handle
    %PPMATRIX Univariate polyphase matrix
    %
    % Exported and modified from SaivDr package
    %
    %    https://github.com/msiplab/SaivDr
    %
    % Requirements: MATLAB R2015b
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
    
    properties (GetAccess = public, SetAccess = private)
        Coefficients = [];
    end
    
    methods
        function obj = ppmatrix(input)
            if nargin == 1
                if isa(input,'msip.ppmatrix')
                    obj.Coefficients = input.Coefficients;
                else
                    obj.Coefficients = input;
                end
            end
        end
        
        function value = double(obj)
            value = double(obj.Coefficients);
        end
        
        function value = char(obj)
            nRowsPhs = size(obj.Coefficients,1);
            nColsPhs = size(obj.Coefficients,2);
            value = ['[' 10]; % 10 -> \n
            if all(obj.Coefficients(:) == 0)
                value = '0';
            else
                for iRowPhs = 1:nRowsPhs
                    strrow = 9; % 9 -> \t
                    for iColPhs = 1:nColsPhs
                        coefMatrix = permute(...
                            obj.Coefficients(iRowPhs,iColPhs,:),[3 1 2]);
                        nOrds = size(coefMatrix,1) - 1;
                        strelm = '0';
                        for iOrd = 0:nOrds
                            elm = coefMatrix(iOrd+1);
                            if elm ~= 0
                                if strelm == '0'
                                    strelm = [];
                                end
                                if ~isempty(strelm)
                                    if elm > 0
                                        strelm = [strelm ' + ' ];
                                    else
                                        strelm = [strelm ' - ' ];
                                        elm = -elm;
                                    end
                                end
                                if elm ~= 1 || iOrd == 0
                                    strelm = [strelm num2str(elm)];
                                    if iOrd > 0
                                        strelm = [strelm '*'];
                                    end
                                end
                                if iOrd >=1
                                    strelm = [strelm 'z^(-' int2str(iOrd) ')'];
                                end
                            end % for strelm ~= 0
                        end % for iOrd
                        strrow = [strrow strelm];
                        if iColPhs ~= nColsPhs
                            strrow = [strrow ',' 9]; % 9 -> \t
                        end
                    end % for iColPhs
                    if iRowPhs == nRowsPhs
                        value = [value strrow 10 ']']; % 10 -> \n
                    else
                        value = [value strrow ';' 10]; % 10 -> \n
                    end
                end % for iRowPhs
            end
        end
        
        function disp(obj)
            disp([char(obj) 10]);
        end
        
        function value = subsref(obj,sub)
            % Implement a special subscripted assignment
            switch sub.type
                case '()'
                    r = sub.subs{1};
                    c = sub.subs{2};
                    value = permute(obj.Coefficients(r,c,:),[3 1 2]).';
                case '.'       
                    value = eval(sprintf('obj.%s',sub.subs));                    
                otherwise
                    error('Specify polyphase index for r,c as obj(r,c)')
            end
        end % subsref
        
        function value = plus(obj,another)
            import msip.ppmatrix                                                           
            % Plus Implement obj1 + obj2 for PolyPhaseMatrix2d
            coef1 = double(obj);
            coef2 = double(another);
            if (ndims(coef1) == ndims(coef2) && ...
                    all(size(coef1) == size(coef2))) || ...
                    (isscalar(coef1) || isscalar(coef2))
                value = ppmatrix(coef1+coef2);
            else
                [s1m1,s1m2,s1o1,s1o2] = size(coef1);
                [s2m1,s2m2,s2o1,s2o2] = size(coef2);
                s3 = max( [s1m1,s1m2,s1o1,s1o2],[s2m1,s2m2,s2o1,s2o2]);
                coef3 = zeros( s3 );
                n0 = size(coef1,3);
                coef3(:,:,1:n0) = coef1(:,:,1:n0);
                n0 = size(coef2,3);
                coef3(:,:,1:n0) = ...
                    coef3(:,:,1:n0) + coef2(:,:,1:n0);
                value = ppmatrix(coef3);
            end
        end % plus
        
        function value = minus(obj,another)
            value = plus(obj,-double(another));
        end % minus
        
        function value = mtimes(obj,another)
            import msip.ppmatrix                                                           
            %import msip.Direction
            coef1 = double(obj);
            coef2 = double(another);
            if size(coef1,2) ~= size(coef2,1)
                if ( isscalar(coef1) || isscalar(coef2) )
                    coef3 = coef1 * coef2;
                else
                    error('Inner dimensions must be the same as each other.');
                end
            else
                nDims = size(coef1,2);
                nRows = size(coef1,1);
                nCols = size(coef2,2);
                nCoef = size(coef1,3)+size(coef2,3)-1;
                pcoef1 = permute(coef1,[3 1 2]);
                pcoef2 = permute(coef2,[3 1 2]);
                pcoef3 = zeros(nCoef,nRows,nCols);
                for iCol = 1:nCols
                    for iRow = 1:nRows
                        array1 = pcoef1(:,iRow,1);
                        array2 = pcoef2(:,1,iCol);
                        array3 = conv(array1,array2);                        
                        for iDim = 2:nDims
                            array1 = pcoef1(:,iRow,iDim);
                            array2 = pcoef2(:,iDim,iCol);                            
                            array3 = array3 + conv(array1,array2);
                        end
                        pcoef3(:,iRow,iCol) = array3;
                    end
                end
                coef3 = ipermute(pcoef3,[3 1 2]);
            end
            value = ppmatrix(coef3);
        end
        
        function value = ctranspose(obj)
            import msip.ppmatrix            
            coefTmp = double(obj);
            coefTmp = permute(coefTmp,[2 1 3]);
            coefTmp = flip(coefTmp,3);
            coefTmp = conj(coefTmp);
            value = ppmatrix(coefTmp);
        end
        
        function value = transpose(obj)
            import msip.ppmatrix                                                           
            coefTmp = double(obj);
            coefTmp = permute(coefTmp,[2 1 3 4]);
            coefTmp = flip(coefTmp,3);
            coefTmp = flip(coefTmp,4);
            value = ppmatrix(coefTmp);
        end
        
        function value = upsample(obj,ufactor)
            import msip.ppmatrix
            value = obj;
            ucoef = obj.Coefficients;
            coefTmp = double(value);
            if size(obj.Coefficients,3) ~= 1
                uLength = size(coefTmp,3);
                uLength = ufactor*(uLength - 1) + 1;
                usize = size(coefTmp);
                usize(3) = uLength;
                ucoef = zeros(usize);
                ucoef(:,:,1:ufactor:end) = coefTmp;
            end
            value = ppmatrix(ucoef);
        end
                        
        function value = downsample(obj,dfactor)
            import msip.ppmatrix
            value = obj;
            ucoef = obj.Coefficients;
            coefTmp = double(value);
            if size(obj.Coefficients,3) ~= 1
                uLength = size(coefTmp,3);
                uLength = dfactor*(uLength - 1) + 1;
                usize = size(coefTmp);
                usize(3) = uLength;
                ucoef = ucoef(:,:,1:dfactor:end);
            end
            value = ppmatrix(ucoef);
        end
        
        
    end
end