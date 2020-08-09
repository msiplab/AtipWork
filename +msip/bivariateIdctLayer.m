classdef bivariateIdctLayer < nnet.layer.Layer

    properties
        % (Optional) Layer properties.
        Stride
        
        % Layer properties go here.
    end
    
    properties (Access = private)
        %Cv 
        %Ch 
    end
    
    methods
        function layer = bivariateIdctLayer(stride,name)
            % (Optional) Create a myLayer.
            % This function must have the same name as the class.
            
            % Layer constructor function goes here.
            layer.Stride = stride;
            layer.Name = name;
            layer.Description = "Bivariate IDCT of size " ...
                + layer.Stride(1) + "x" + layer.Stride(2);
            layer.Type = '';
            
            %layer.Cv = dctmtx(layer.Stride(1));
            %layer.Ch = dctmtx(layer.Stride(2));
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
            nComponents = size(X,3);
            nSamples = size(X,4);
            %Cv_ = layer.Cv;
            %Ch_ = layer.Ch;
            %
            Z = zeros(size(X),'like',X);
            for iSample = 1:nSamples
                for iComponent = 1:nComponents
                    Z(:,:,iComponent,iSample) = ...
                        blockproc(X(:,:,iComponent,iSample),...
                        layer.Stride,@(x) idct2(x.data)); % Cv_.'*x.data*Ch_);
                end
            end
        end
       
        
        function dLdX = backward(layer,X, Z, dLdZ, memory)
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
            nComponents = size(dLdZ,3);
            nSamples = size(dLdZ,4);
            %Cv_ = layer.Cv;
            %Ch_ = layer.Ch;
            %
            dLdX = zeros(size(dLdZ),'like',dLdZ);
            for iSample = 1:nSamples
                for iComponent = 1:nComponents
                    dLdX(:,:,iComponent,iSample) = ...
                        blockproc(dLdZ(:,:,iComponent,iSample),...
                        layer.Stride,@(x) dct2(x.data)); %Cv_*x.data*Ch_.');
                end
            end
        end

    end
end

