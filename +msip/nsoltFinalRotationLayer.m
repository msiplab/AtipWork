classdef nsoltFinalRotationLayer < nnet.layer.Layer
    
    properties
        % (Optional) Layer properties.
        nChannels
        Stride
        
        % Layer properties go here.
    end
    
    properties (Learnable)
    end
    
    properties (Access = private)

    end
    
    methods
        function layer = nsoltFinalRotationLayer(nchs,stride,name)
            % (Optional) Create a myLayer.
            % This function must have the same name as the class.
            
            % Layer constructor function goes here.
            layer.nChannels = nchs;
            layer.Stride = stride;
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
            %         X1, ..., Xn - Input data
            % Outputs:
            %         Z1, ..., Zm - Outputs of layer forward function
            
            % Layer forward function for prediction goes here.
            nrows = size(X,1);
            ncols = size(X,2);
            height = layer.Stride(1)*nrows;
            width = layer.Stride(2)*ncols;
            ps = layer.nChannels(1);
            pa = layer.nChannels(2);
            nSamples = size(X,4);
            stride = layer.Stride;
            nDecs = prod(stride);
            %
            W0T = eye(ps,'like',X);
            U0T = eye(pa,'like',X);
            Y = permute(X,[3 1 2 4]);
            Ys = reshape(Y(1:ps,:,:,:),ps,nrows*ncols*nSamples);
            Ya = reshape(Y(ps+1:ps+pa,:,:,:),pa,nrows*ncols*nSamples);
            Zsa = [ W0T(1:nDecs/2,:)*Ys; U0T(1:nDecs/2,:)*Ya ];
            Z = zeros(height,width,1,nSamples,'like',X);
            nBlks = nrows*ncols;
            for iSample=1:nSamples
                Zi = Zsa(:,(iSample-1)*nBlks+1:iSample*nBlks);
                Z(:,:,1,iSample) = ...
                    col2im(Zi,stride,[height width],'distinct');    
            end
        end
        
        function [dLdX, dLdW] = backward(layer,X, Z, dLdZ, memory)
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
            
            % Layer backward function goes here.
            dLdX = [];
            dLdW = [];
        end
    end
end

