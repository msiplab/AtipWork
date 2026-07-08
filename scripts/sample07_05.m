%[text] # Sample 7-5
%[text] ## 幾何学処理
%[text] 畳み込みの随伴作用素
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Geometric image processing
%[text] Adjoint of convolution
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ### インパルス応答の生成
%[text] (Generation of impulse response)
ftype = "prewitt"; %[control:dropdown:56b7]{"position":[9,18]}
h = rot90(fspecial(ftype),2)
figure(1)
stem3(h,'filled')
axis ij
title('Impulse response of h[n]')
%%
%[text] ### 二変量循環畳み込みの行列表現
%[text] (Matrix representation of bivariate circular convolution)
%[text] 周期 $\\mathbf{Q}$ の循環畳み込み演算 (Circular convolution with period $\\mathbf{Q}$)
%[text]  $\\{v\[\\mathbf{n}\]\\}\_\\mathbf{n}=\\{h\[\\mathbf{n}\]\\}\_\\mathbf{n} \\bigcirc  \\{u\[\\mathbf{n}\]\\}\_\\mathbf{n} = \\sum\_{\\mathbf{k}\\in\\Omega\\subset\\mathbb{Z}^2}h\[\\mathbf{k}\]\\{u\[(\\!(\\mathbf{n}-\\mathbf{k})\\!)\_\\mathbf{Q}\]\\}\_\\mathbf{n}\n$
% Input array size
N1 =6; %[control:slider:25d1]{"position":[5,6]}
N2 =4; %[control:slider:87fc]{"position":[5,6]}

% Find the matrix representation of the bivariate downsampling
N  = N1*N2;
T = [];
for idx = 1:N
    % Generating a standard basis vector
    e = zeros(N1,N2);
    e(idx) = 1;
    % Response to the standard basis vector
    t = imfilter(e,h,'conv','circ'); 
    T(:,idx) = t(:);
end
%[text] 行列表現 (Matrix represntation)
%[text] - $\\mathbf{T}$ \
% Matrix representation of the bivariate downsampling
T
%%
%[text] ### 二変量循環畳み込みの随伴作用素
%[text] (Adjoint operator of bivariate circular convolution)
%[text] エルミート転置 (Herimitian transposition)
%[text] - $\\mathbf{T}^H$ \
% Adjoint matrix of the bivariate circular convolution
T'
%[text] 随伴作用素(Adjoint operator)
%[text]  $T^\\ast(\\{v\[\\mathbf{m}\]\\}\_\\mathbf{m})=\\mathrm{vec}\_{\\Omega\_\\mathrm{u}}^{-1} \\circ \\mathbf{T}^H\\mathrm{vec}\_{\\Omega\_\\mathrm{v}}(\\{v\[\\mathbf{m}\]\\}\_\\mathbf{m})$
% Adjoint operator T*
adjOp = @(x) reshape(T'*x(:),[N1 N2]);
%%
%[text] ### 内積の保存の確認
%[text] (Confirmation of the preservation of the inner product)
%[text] 入力配列の生成 (Generation of an input array) 
%[text] -  $\\{u\[\\mathbf{n}\]\\}\_\\mathbf{n}$ \
% Generation of an input array u 
arrayU = randn(N1,N2);
%[text]   循環畳み込みの出力 (Output of the circular convolution)
%[text] - $\\{v\[\\mathbf{m}\]\\}\_\\mathbf{m}=T(\\{u\[\\mathbf{n}\]\\}\_\\mathbf{n})$ \
% Circular convolution (v=Tu)
arrayV = imfilter(arrayU,h,'conv','circ');
%[text] 任意の出力領域配列生成(Generation of an arbitrary array in output range)
% Array generation in the same domain with arrayV
arrayY = randn(size(arrayV),'like',arrayV);
%[text] 内積 (Inner product)          
%[text]  $\\alpha=\\langle \\mathbf{y},\\mathbf{v}\\rangle=\\langle\\mathbf{y},\\mathbf{Tu}\\rangle$
% Inner product <y,v>=<y,Tu>
innprodA = dot(arrayY(:),arrayV(:))
%[text] 循環畳み込みの随伴作用素 (The adjoint operator of circular convolution)
%[text]  $\\mathbf{r}=\\mathbf{T}^H\\mathbf{v}$
% Adjoint operation of circular convolution (r=T'v)
arrayR = adjOp(arrayY)
%[text]  $\\beta=\\langle \\mathbf{r},\\mathbf{u}\\rangle=\\langle\\mathbf{T}^H\\mathbf{y},\\mathbf{u}\\rangle$
% Inner product <r,u>=<T'v,u>
innprodB = dot(arrayR(:),arrayU(:));

% Verify the preservation of the inner product
err = abs(innprodA - innprodB);
disp(['|<y,Tu> - <T''y,u>| = ' num2str(err)])
%%
%[text] ### 反転インパルス応答による循環畳み込み
%[text] (Circular convolution with the reversal impulse response)
%[text]  $\\{r\[\\mathbf{n}\]\\}\_\\mathbf{n}=\\{\\bar{h}\[-\\mathbf{n}\]\\}\_\\mathbf{n} \\bigcirc  \\{y\[\\mathbf{n}\]\\}\_\\mathbf{n} = \\sum\_{\\mathbf{k}\\in\\Omega\\subset\\mathbb{Z}^2}\\bar{h}\[-\\mathbf{k}\]\\{y\[(\\!(\\mathbf{n}-\\mathbf{k})\\!)\_\\mathbf{Q}\]\\}\_\\mathbf{n}\n$
% Revaersal impulse response
f = conj(rot90(h,2))
figure(2)
stem3(f,'filled')
axis ij
title('Impulse response of f[n]')

% Circular convolution with impulse response f
arrayS = imfilter(arrayY,f,'conv','circ')
%[text] 行列演算とIMFILTERの比較
% Definition of MSE
mymse = @(x,y) sum((x-y).^2,'all')/numel(x);

% Evaluation
disp(['MSE between matrix operation and IMFILTER: ' num2str(mymse(arrayR,arrayS))])
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:dropdown:56b7]
%   data: {"defaultValue":"\"prewitt\"","itemLabels":["prewitt","sobel"],"items":["\"prewitt\"","\"sobel\""],"label":"ドロップ ダウン","run":"SectionToEnd"}
%---
%[control:slider:25d1]
%   data: {"defaultValue":6,"label":"N1","max":8,"min":4,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:87fc]
%   data: {"defaultValue":4,"label":"N2","max":8,"min":4,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
