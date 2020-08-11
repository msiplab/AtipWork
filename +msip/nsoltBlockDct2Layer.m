classdef nsoltBlockDct2Layer < nnet.layer.Layer
    %
    %   ベクトル配列をブロック配列を入力:
    %      (Stride(1)xnRows) x (Stride(2)xnCols) x nComponents x nSamples
    %
    %   コンポーネント別に出力(nComponents):
    %      nRows x nCols x nDecs x nSamples
    %    
    
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
        function layer = nsoltBlockDct2Layer(DecimationFactor,name)
            % (Optional) Create a myLayer.
            % This function must have the same name as the class.
            
            % Layer constructor function goes here.
            layer.DecimationFactor = DecimationFactor;
            layer.Name = name;
            layer.Description = "Block DCT of size " ...
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
            decFactor = layer.DecimationFactor;
            Cv_ = layer.Cv;
            Ch_T = layer.Ch.';
            decV = decFactor(1);
            decH = decFactor(2);
            nRows = size(X,1)/decV;
            nCols = size(X,2)/decH;
            nDecs = prod(decFactor);
            nComponents = size(X,3);
            nSamples = size(X,4);
            %
            A = zeros(nDecs,nRows,nCols,nSamples,'like',X);
            for iSample = 1:nSamples
                for iComponent = 1:nComponents
                    for iCol = 1:nCols
                        for iRow = 1:nRows
                            x = X((iRow-1)*decV+1:iRow*decV,...
                                (iCol-1)*decH+1:iCol*decH,...
                                iComponent,iSample);
                            coefs = Cv_*x*Ch_T;
                            %z = layer.permuteDctCoefs_(coefs,decFactor);
                            cee = coefs(1:ceil(decV/2),    1:ceil(decH/2));
                            coo = coefs(ceil(decV/2)+1:end,ceil(decH/2)+1:end);
                            coe = coefs(ceil(decV/2)+1:end,1:ceil(decH/2));
                            ceo = coefs(1:ceil(decV/2),    ceil(decH/2)+1:end);
                            z = [ cee coo coe ceo ];
                            %
                            A(:,iRow,iCol,iSample) = z(:);
                        end
                    end
                end
            end
            Z = permute(A,[2 3 1 4]);
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
                            x = Cv_.'*dldz*Ch_;
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
    
    %{
    methods (Static, Access = private)
        function value = permuteDctCoefs_(x,blockSize)
            coefs = x;
            decY_ = blockSize(1);
            decX_ = blockSize(2);
            cee = coefs(1:ceil(decY_/2),    1:ceil(decX_/2));
            coo = coefs(ceil(decY_/2)+1:end,ceil(decX_/2)+1:end);
            coe = coefs(ceil(decY_/2)+1:end,1:ceil(decX_/2));
            ceo = coefs(1:ceil(decY_/2),    ceil(decX_/2)+1:end);
            value = [ cee(:) ; coo(:) ; coe(:) ; ceo(:) ];
        end
    end
    %}
end

