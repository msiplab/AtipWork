classdef nsoltInitialRotationLayer < nnet.layer.Layer
    %
    %   コンポーネント別に入力(nComponents):
    %      nRows x nCols x nDecs x nSamples
    %
    %   コンポーネント別に出力(nComponents):
    %      nRows x nCols x nChs x nSamples
    %
    
    properties
        % (Optional) Layer properties.
        NumberOfChannels
        DecimationFactor
        %Mus
        
        % Layer properties go here.
    end
    
    properties (Learnable)
        Angles
    end
    
    
    methods
        function layer = nsoltInitialRotationLayer(nchs,stride,name)
            % (Optional) Create a myLayer.
            % This function must have the same name as the class.
            
            % Layer constructor function goes here.
            layer.NumberOfChannels = nchs;
            layer.DecimationFactor = stride;
            layer.Name = name;
            layer.Description = "NSOLT initial rotation ( " ...
                + "(ps,pa) = (" ...
                + nchs(1) + "," + nchs(2) + "), "  ...
                + "(mv,mh) = (" ...
                + stride(1) + "," + stride(2) + ")" ...
                + " )";
            layer.Type = '';
            
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
            
            % Layer forward function for prediction goes here.
            nrows = size(X,1);
            ncols = size(X,2);
            ps = layer.NumberOfChannels(1);
            pa = layer.NumberOfChannels(2);
            nSamples = size(X,4);
            stride = layer.DecimationFactor;
            nDecs = prod(stride);
            nChsTotal = ps + pa;
            %
            if isempty(layer.Angles)
                W0 = eye(ps);
                U0 = eye(pa);
            else
                anglesW = layer.Angles(1:length(layer.Angles)/2);
                anglesU = layer.Angles(length(layer.Angles)/2+1:end);
                W0 = layer.orthmtxgen_(anglesW,1);
                U0 = layer.orthmtxgen_(anglesU,1);
            end
            Y = reshape(permute(X,[3 1 2 4]),nDecs,nrows*ncols*nSamples);
            Zs = W0(:,1:nDecs/2)*Y(1:nDecs/2,:);
            Za = U0(:,1:nDecs/2)*Y(nDecs/2+1:end,:);
            Z = ipermute(reshape([Zs;Za],nChsTotal,nrows,ncols,nSamples),...
                [3 1 2 4]);

        end
        
        %{        
        function [Z, memory] = forward(layer, X)
            % (Optional) Forward input data through the layer at training
            % time and output the result and a memory value.
            %
            % Inputs:
            %         layer       - Layer to forward propagate through
            %         X1, ..., Xn - Input data (n: # of components)
            % Outputs:
            %         Z           - Outputs of layer forward function
            %         memory      - Memory value for custom backward propagation

            % Layer forward function for training goes here.
            Z = layer.predict(X);
            memory = X;
        end
        
        function [dLdX, dLdW] = backward(layer,~, ~, dLdZ, memory)
            % (Optional) Backward propagate the derivative of the loss
            % function through the layer.
            %
            % Inputs:
            %         layer             - Layer to backward propagate through
            %         X1, ..., Xn       - Input data (n: # of components)
            %         Z                 - Outputs of layer forward function
            %         dLdZ              - Gradients propagated from the next layers
            %         memory            - Memory value from forward function
            % Outputs:
            %         dLdX1, ..., dLdXn - Derivatives of the loss with respect to the
            %                             inputs (n: # of components)
            %         dLdW              - Derivatives of the loss with respect to each
            %                             learnable parameter
            
            % Layer backward function goes here.
            dLdX = [];
            dLdW = [];
        end
        %}
    end
    
    methods (Static, Access = private)
        %{
        function value = permuteDctCoefs_(x,blockSize)
            coefs = x;
            decY_ = blockSize(1);
            decX_ = blockSize(2);
            cee = coefs(1:2:end,1:2:end);
            coo = coefs(2:2:end,2:2:end);
            coe = coefs(2:2:end,1:2:end);
            ceo = coefs(1:2:end,2:2:end);
            value = [ cee(:) ; coo(:) ; coe(:) ; ceo(:) ];
            value = reshape(value,decY_,decX_);
        end
        %}
        function matrix = orthmtxgen_(angles,mus,pdAng)
            
            if nargin < 3
                pdAng = 0;
            end
            
            if isempty(angles)
                matrix = diag(mus);
            else
                nDim_ = (1+sqrt(1+8*length(angles)))/2;
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
                        iAng = iAng + 1;
                    end
                    matrix(iTop,:) = vt;
                end
                matrix = diag(mus)*matrix;
            end
        end

    end
end

