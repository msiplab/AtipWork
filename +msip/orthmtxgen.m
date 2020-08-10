classdef orthmtxgen < handle
    %ORTHONORMALMATRIXGENERATIONSYSTEM Orthonormal matrix generator
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
    
    properties
        PartialDifference = 'off'
        NumberOfDimensions
    end
    
    properties (Hidden, Transient)
        PartialDifferenceSet = ...
            matlab.system.StringSet({'on','off'});
    end
    
    methods
        function obj = orthmtxgen(pdmode)
            % Support name-value pair arguments
            if nargin < 1
                obj.PartialDifferenceSet = 'off';
            else
                obj.PartialDifferenceSet = pdmode;
            end
        end
        
        function matrix = generate(obj,angles,mus,pdAng)
            
            if isempty(obj.NumberOfDimensions)
                obj.NumberOfDimensions = (1+sqrt(1+8*length(angles)))/2;
            end
            if ~isempty(mus) && any(abs(mus(:))~=1)
                error('All entries of mus must be 1 or -1.');
            end
            
            if nargin < 4
                pdAng = 0;
            end
            
            if isempty(angles)
                matrix = diag(mus);
            else
                nDim_ = obj.NumberOfDimensions;
                matrix = eye(nDim_);
                iAng = 1;
                for iTop=1:nDim_-1
                    vt = matrix(iTop,:);
                    for iBtm=iTop+1:nDim_
                        angle = angles(iAng);
                        if iAng == pdAng
                            angle = angle + pi/2;
                        end
                        c = cos(angle); %
                        s = sin(angle); %
                        vb = matrix(iBtm,:);
                        %
                        u  = s*(vt + vb);
                        vt = (c + s)*vt;
                        vb = (c - s)*vb;
                        vt = vt - u;
                        if iAng == pdAng
                            matrix = 0*matrix;
                        end
                        matrix(iBtm,:) = vb + u;
                        %
                        %{
                         u1 = c*vt - s*vb;
                         matrix(iBtm,:) = s*vt + c*vb;
                         vt = u1;
                        %}
                        iAng = iAng + 1;
                    end
                    matrix(iTop,:) = vt;
                end
                matrix = diag(mus)*matrix;
            end
            
        end
        
    end
    
    methods (Access = protected)
        
        function s = saveObjectImpl(obj)
            s = saveObjectImpl@matlab.System(obj);
            s.NumberOfDimensions = obj.NumberOfDimensions;
            s.PartialDifference = obj.PartialDifference;
        end
        
        function loadObjectImpl(obj,s,wasLocked)
            if isfield(s,'PartialDifference')
                obj.PartialDifference = s.PartialDifference;
            else
                obj.PartialDifference = 'off';
            end
            obj.NumberOfDimensions = s.NumberOfDimensions;
            loadObjectImpl@matlab.System(obj,s,wasLocked);
        end
        
        function N = getNumInputsImpl(obj)
            if strcmp(obj.PartialDifference,'on')
                N = 3;
            else
                N = 2;
            end
        end
        
        function N = getNumOutputsImpl(~)
            N = 1;
        end
    end
end
