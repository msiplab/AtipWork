classdef nsoltIntermediateRotation2dLayer < nnet.layer.Layer
    %NSOLTINTERMEDIATEROTATION2DLAYER
    %
    %
    %   コンポーネント別に入力(nComponents):
    %      nRows x nCols x nChsTotal x nSamples
    %
    %   コンポーネント別に出力(nComponents):
    %      nRows x nCols x nChsTotal x nSamples
    %
    % Exported and modified from SaivDr package
    %
    %    https://github.com/msiplab/SaivDr
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
    
    
    properties
        % (Optional) Layer properties.
        NumberOfChannels
        Mus
        Mode
        
        % Layer properties go here.
    end
    
    properties (Learnable)
        Angles
    end
    
    methods
        function layer = nsoltIntermediateRotation2dLayer(varargin)
            % (Optional) Create a myLayer.
            % This function must have the same name as the class.
            p = inputParser;
            addParameter(p,'NumberOfChannels',[])
            addParameter(p,'Angles',[])
            addParameter(p,'Mus',[])
            addParameter(p,'Mode','Synthesis')
            addParameter(p,'Name','')
            parse(p,varargin{:})
            
            % Layer constructor function goes here.
            layer.NumberOfChannels = p.Results.NumberOfChannels;
            layer.Name = p.Results.Name;
            layer.Mode = p.Results.Mode;
            layer.Angles = p.Results.Angles;
            layer.Mus = p.Results.Mus;
            layer.Description = layer.Mode ...
                + " NSOLT intermediate rotation " ...
                + "(ps,pa) = (" ...
                + layer.NumberOfChannels(1) + "," ...
                + layer.NumberOfChannels(2) + ")";
            layer.Type = '';
            
            if isempty(layer.Angles)
                nChsTotal = sum(layer.NumberOfChannels);
                nAngles = (nChsTotal-2)*nChsTotal/8;
                layer.Angles = zeros(nAngles,1);
            end
            
        end
        
        function Z = predict(layer, X)
            % Forward input data through the layer at prediction time and
            % output the result.
            %
            % Inputs:
            %         layer       - Layer to forward propagate through
            %         X1, ..., Xn - Input data (n: # of components)
            % Outputs:
            %         Z           - Outputs of layer forward function
            %
            import msip.*
            
            % Layer forward function for prediction goes here.
            nrows = size(X,1);
            ncols = size(X,2);
            ps = layer.NumberOfChannels(1);
            pa = layer.NumberOfChannels(2);
            nSamples = size(X,4);
            %
            if isempty(layer.Mus)
                musU = 1;
            else
                musU = layer.Mus;
            end
            anglesU = layer.Angles;
            Un = layer.fcn_orthmtxgen_(anglesU,musU);
            %
            Y = permute(X,[3 1 2 4]);
            Ya = reshape(Y(ps+1:ps+pa,:,:,:),pa,nrows*ncols*nSamples);
            if strcmp(layer.Mode,'Analysis')
                Za = Un*Ya;
            elseif strcmp(layer.Mode,'Synthesis')
                Za = Un.'*Ya;
            else
                throw(MException('NsoltLayer:InvalidMode',...
                    '%s : Mode should be either of Synthesis or Analysis',...
                    layer.Mode))
            end
            Y(ps+1:ps+pa,:,:,:) = reshape(Za,pa,nrows,ncols,nSamples);
            Z = ipermute(Y,[3 1 2 4]);
        end
        
        function [dLdX, dLdW] = ...
                backward(layer, X, ~, dLdZ, ~)
            % (Optional) Backward propagate the derivative of the loss
            % function through the layer.
            %
            % Inputs:
            %         layer             - Layer to backward propagate through
            %         X1, ..., Xn       - Input data
            %         Z1, ..., Zm       - Outputs of layer forward function
            %         dLdZ1, ..., dLdZm - Gradients propagated from the next layers
            %         memory            - Memory value from forward function
            % Outputs:
            %         dLdX1, ..., dLdXn - Derivatives of the loss with respect to the
            %                             inputs
            %         dLdW1, ..., dLdWk - Derivatives of the loss with respect to each
            %                             learnable parameter
            import msip.*
            nrows = size(dLdZ,1);
            ncols = size(dLdZ,2);
            nSamples = size(dLdZ,4);
            anglesU = layer.Angles;
            musU = layer.Mus;
            ps = layer.NumberOfChannels(1);
            pa = layer.NumberOfChannels(2);
            
            % Layer backward function goes here.
            % dLdX = dZdX x dLdZ
            Un = layer.fcn_orthmtxgen_(anglesU,musU,0);
            adLd_ = permute(dLdZ,[3 1 2 4]);
            cdLd_low = reshape(adLd_(ps+1:ps+pa,:,:,:),...
                pa,nrows*ncols*nSamples);
            if strcmp(layer.Mode,'Analysis')
                cdLd_low = Un.'*cdLd_low;
            else
                cdLd_low = Un*cdLd_low;
            end
            adLd_(ps+1:ps+pa,:,:,:) = reshape(cdLd_low,...
                pa,nrows,ncols,nSamples);
            dLdX = ipermute(adLd_,[3 1 2 4]);
            
            % dLdWi = <dLdZ,(dVdWi)X>
            nAngles = length(anglesU);
            dLdW = zeros(nAngles,1,'like',dLdZ);
            for iAngle = 1:nAngles
                dUn = layer.fcn_orthmtxgen_(anglesU,musU,iAngle);
                a_ = permute(X,[3 1 2 4]);
                c_low = reshape(a_(ps+1:ps+pa,:,:,:),pa,nrows*ncols*nSamples);
                if strcmp(layer.Mode,'Analysis')
                    c_low = dUn*c_low;
                else
                    c_low = dUn.'*c_low;
                end
                a_ = zeros(size(a_),'like',dLdZ);
                a_(ps+1:ps+pa,:,:,:) = reshape(c_low,pa,nrows,ncols,nSamples);
                dVdW_X = ipermute(a_,[3 1 2 4]);
                %
                dLdW(iAngle) = sum(dLdZ.*dVdW_X,'all');
            end
        end
        
        
    end
    
    methods (Static, Access = private)
        
        function matrix = fcn_orthmtxgen_(angles,mus,pdAng)
            %FCN_ORTHONORMALMATRIXGENERATE
            %
            % Function realization of
            % saivdr.dictionary.utility.OrthonormalMatrixGenerationSystem
            % for supporting dlarray (Deep learning array for custom training
            % loops)
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
            
            if nargin < 3
                pdAng = 0;
            end
            
            nDim_ = (1+sqrt(1+8*length(angles)))/2;
            if isempty(angles)
                matrix = zeros(nDim_);
            else
                matrix = zeros(nDim_,'like',angles);
            end
            for idx = 1:nDim_
                matrix(idx,idx) = 1;
            end
            if ~isempty(angles)
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
                        iAng = iAng + 1;
                    end
                    matrix(iTop,:) = vt;
                end
            end
            if isscalar(mus)
                matrix = mus*matrix;
            elseif ~isempty(mus)
                for idx = 1:nDim_
                    matrix(idx,:) = mus(idx)*matrix(idx,:);
                end
            end
        end
        
    end
end

