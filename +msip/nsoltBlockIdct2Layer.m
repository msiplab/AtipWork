classdef nsoltBlockIdct2Layer < nnet.layer.Layer

    properties
        % (Optional) Layer properties.
        DecimationFactor
        
        % Layer properties go here.
    end
    
    properties (Access = private)
        Cv 
        Ch 
    end
    
    methods
        function layer = nsoltBlockIdct2Layer(DecimationFactor,name)
            % (Optional) Create a myLayer.
            % This function must have the same name as the class.
            
            % Layer constructor function goes here.
            layer.DecimationFactor = DecimationFactor;
            layer.Name = name;
            layer.Description = "Block IDCT of size " ...
                + layer.DecimationFactor(1) + "x" + layer.DecimationFactor(2);
            layer.Type = '';
            
            Cv_ = dctmtx(layer.DecimationFactor(1));
            Ch_ = dctmtx(layer.DecimationFactor(2));
            layer.Cv = [ Cv_(1:2:end,:) ; Cv_(2:2:end,:) ];
            layer.Ch = [ Ch_(1:2:end,:) ; Ch_(2:2:end,:) ];
                
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
            DecimationFactor_ = layer.DecimationFactor;
            Cv_ = layer.Cv;
            Ch_ = layer.Ch;
            nRows = size(X,1)/DecimationFactor_(1);
            nCols = size(X,2)/DecimationFactor_(2);
            nComponents = size(X,3);
            nSamples = size(X,4);
            %
            Z = zeros(size(X),'like',X);
            for iSample = 1:nSamples
                for iComponent = 1:nComponents
                    %Z(:,:,iComponent,iSample) = ...
                    %    blockproc(X(:,:,iComponent,iSample),...
                    %    layer.DecimationFactor,@(x) Cv_.'*x.data*Ch_);
                    for iCol = 1:nCols
                        for iRow = 1:nRows
                            x = X((iRow-1)*DecimationFactor_(1)+1:iRow*DecimationFactor_(1),...
                                (iCol-1)*DecimationFactor_(2)+1:iCol*DecimationFactor_(2),...
                                iComponent,iSample);  
                            x = layer.permuteIdctCoefs_(x,DecimationFactor_);
                            z = Cv_.'*x*Ch_;
                            Z((iRow-1)*DecimationFactor_(1)+1:iRow*DecimationFactor_(1),...
                                (iCol-1)*DecimationFactor_(2)+1:iCol*DecimationFactor_(2),...
                                iComponent,iSample) = z;
                        end
                    end
                end
            end
        end        
        
        %{        
        function dLdX = backward(layer,~,~, dLdZ, ~)
            % (Optional) Backward propagate the derivative of the loss  
            % function through the layer.
            %
            % Inputs:
            %         layer             - Layer to backward propagate through          
            %         dLdZ              - Gradients propagated from the next layers
            % Outputs:
            %         dLdX              - Derivatives of the loss with respect to the
            %                             inputs
            %
            
            % Layer backward function goes here.
            DecimationFactor_ = layer.DecimationFactor;
            Cv_ = layer.Cv;
            Ch_ = layer.Ch;
            nRows = size(dLdZ,1)/DecimationFactor_(1);
            nCols = size(dLdZ,2)/DecimationFactor_(2);
            nComponents = size(dLdZ,3);
            nSamples = size(dLdZ,4);
            %
            dLdX = zeros(size(dLdZ),'like',dLdZ);
            for iSample = 1:nSamples
                for iComponent = 1:nComponents
                    %dLdX(:,:,iComponent,iSample) = ...
                    %    blockproc(dLdZ(:,:,iComponent,iSample),...
                    %    layer.DecimationFactor,@(x) Cv_*x.data*Ch_.');
                    for iCol = 1:nCols
                        for iRow = 1:nRows
                            dldz = dLdZ((iRow-1)*DecimationFactor_(1)+1:iRow*DecimationFactor_(1),...
                                (iCol-1)*DecimationFactor_(2)+1:iCol*DecimationFactor_(2),...
                                iComponent,iSample);                            
                            x = Cv_*dldz*Ch_.';
                            dLdX((iRow-1)*DecimationFactor_(1)+1:iRow*DecimationFactor_(1),...
                                (iCol-1)*DecimationFactor_(2)+1:iCol*DecimationFactor_(2),...
                                iComponent,iSample) = x;
                        end
                    end                    
                end
            end
            
        end
        %}
    end
    
    methods (Static, Access = private)
        
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
            value = [ 
                reshape(cee,ceil(decY_/2),ceil(decX_/2)) reshape(ceo,ceil(decY_/2),floor(decX_/2));
                reshape(coe,floor(decY_/2),ceil(decX_/2)) reshape(coo,floor(decY_/2),floor(decX_/2))
                ];
        end
    end
end

