classdef nsoltFinalRotationLayer < nnet.layer.Layer
    %
    %   コンポーネント別に入力(nComponents):
    %      nRows x nCols x nChs x nSamples
    %
    %   コンポーネント別に出力(nComponents):
    %      nRows x nCols x nDecs x nSamples
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
        function layer = nsoltFinalRotationLayer(nchs,stride,name)
            % (Optional) Create a myLayer.
            % This function must have the same name as the class.
            
            % Layer constructor function goes here.
            layer.NumberOfChannels = nchs;
            layer.DecimationFactor = stride;
            layer.Name = name;
            layer.Description = "NSOLT final rotation ( " ...
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
            height = layer.DecimationFactor(1)*nrows;
            width = layer.DecimationFactor(2)*ncols;
            ps = layer.NumberOfChannels(1);
            pa = layer.NumberOfChannels(2);
            nSamples = size(X,4);
            stride = layer.DecimationFactor;
            nDecs = prod(stride);
            %
            if isempty(layer.Angles)
                W0T = eye(ps);
                U0T = eye(pa);
            else
                anglesW = layer.Angles(1:length(layer.Angles)/2);
                anglesU = layer.Angles(length(layer.Angles)/2+1:end);
                W0T = transpose(layer.orthmtxgen_(anglesW,1));
                U0T = transpose(layer.orthmtxgen_(anglesU,1));
            end
            Y = permute(X,[3 1 2 4]);
            Ys = reshape(Y(1:ps,:,:,:),ps,nrows*ncols*nSamples);
            Ya = reshape(Y(ps+1:ps+pa,:,:,:),pa,nrows*ncols*nSamples);
            Zsa = [ W0T(1:nDecs/2,:)*Ys; U0T(1:nDecs/2,:)*Ya ];
            Z = permute(reshape(Zsa,nDecs,nrows,ncols,nSamples),[2 3 1 4]);
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
        function value = permuteIdctCoefs_(x,blockSize)
            coefs = x;
            decY_ = blockSize(1);
            decX_ = blockSize(2);
            nQDecsee = ceil(decY_/2)*ceil(decX_/2);
            nQDecsoo = floor(decY_/2)*floor(decX_/2);
            nQDecsoe = floor(decY_/2)*ceil(decX_/2);
            cee = coefs(         1:  nQDecsee);
            coo = coefs(nQDecsee+1:nQDecsee+nQDecsoo);
            coe = coefs(nQDecsee+nQDecsoo+1:nQDecsee+nQDecsoo+nQDecsoe);
            ceo = coefs(nQDecsee+nQDecsoo+nQDecsoe+1:end);
            value = zeros(decY_,decX_,'like',x);
            value(1:2:decY_,1:2:decX_) = reshape(cee,ceil(decY_/2),ceil(decX_/2));
            value(2:2:decY_,2:2:decX_) = reshape(coo,floor(decY_/2),floor(decX_/2));
            value(2:2:decY_,1:2:decX_) = reshape(coe,floor(decY_/2),ceil(decX_/2));
            value(1:2:decY_,2:2:decX_) = reshape(ceo,ceil(decY_/2),floor(decX_/2));
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

