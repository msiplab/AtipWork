%[text] # Sample 8-4
%[text] ## 離散コサイン変換
%[text] 基底画像
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Discrete cosine transform
%[text] Basis images
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ### DCT点数
%[text] (DCT points)
nPoints = 4; %[control:slider:353a]{"position":[11,12]}
%%
%[text] ### DCT基底ベクトルの抽出
%[text] (Extraction of DCT basis vectors)
%[text]  $\[\\mathbf{C}\_M\]\_{k,n}=\\sqrt{\\frac{2}{M}} \\alpha\_k\\cos\\frac{k(n+1∕2)\\pi}{M},\\ k,n=0,1,\\cdots,M-1$
%[text]  $\\alpha\_k=\\left\\{\\begin{array}{ll} \\frac{1}{\\sqrt{2}} & k=0 \\\\1 & k=1,2,\\cdots,M-1\\end{array}\\right.$
%[text] 基底ベクトル (Basis vector)
%[text]  $\\mathbf{b}\_k=\\mathbf{C}\_M^{-1}\\mathbf{e}\_k,\\ k=0,1,\\cdots,M-1$
%[text]  $\\mathbf{e}\_0= (1\\ 0\\ \\cdots\\ 0)^T$
%[text]  $\\mathbf{e}\_1= (0\\ 1\\ \\cdots\\ 0)^T$
%[text]  $\\vdots$
%[text]  $\\mathbf{e}\_{M-1}= (0\\ 0\\ \\cdots\\ 1)^T$
B = zeros(nPoints,nPoints);
for idx = 1:nPoints
    e = zeros(nPoints,1);
    e(idx) = 1;
    B(:,idx) = idct(e);
end
%%
%[text] ### 基底ベクトルの表示
%[text] (Display the basis vectors)
figure(1)
for idx = 1:nPoints
    subplot(ceil(nPoints/2),2,idx);
    stem(0:nPoints-1,B(:,idx),'filled');
    ax = gca;
    ax.YLim = 1.2*[min(B(:)) max(B(:))];
    xlabel('n')
end
%%
%[text] ### DCT基底画像の抽出
%[text] (Extraction of DCT basis images)
%[text]  $\\mathbf{B}\_{k,\\ell}=\\mathbf{C}\_M^{-1}\\mathbf{E}\_{k,\\ell}\\mathbf{C}\_M^{-T},\\ k,\\ell=0,1,\\cdots,M-1$
%[text]  $\\mathbf{E}\_{k,\\ell}= \\mathbf{e}\_k\\mathbf{e}\_\\ell^T$
B = zeros(nPoints,nPoints,nPoints^2);
iBasis = 1;
for iRow=1:nPoints
    for iCol=1:nPoints
        E = zeros(nPoints,nPoints);
        E(iRow,iCol) = 1;
        B(:,:,iBasis) = idct2(E,nPoints,nPoints);
        iBasis = iBasis + 1;
    end
end
%%
%[text] ### 基底画像の表示
%[text] (Display the basis images)
hfig2 = figure(2);
hfig2.Color = 0.9*[1 1 1];
iBasis = 1;
for iRow=1:nPoints
    for iCol=1:nPoints
        b = B(:,:,iBasis);
        subplot(nPoints,nPoints,nPoints*(iRow-1)+iCol);
        imshow(b+.5)
        iBasis = iBasis + 1;
    end
end
%%
%[text] ### 非線形近似
%[text] (Non-linear approximation)
%[text] 絶対値の大きな係数のみを残して再構成 (Reconst by leaving only the coefficients with large absolute values)
% Ratio of remaining coefficients
coefRatio = 5 ; %[control:slider:2366]{"position":[13,14]}

% Read image
X = im2double(imread('cameraman.tif'));

% Block DCT 
U = blockproc(X,nPoints*[1 1],@(x) dct2(x.data));

% Non-linear approximation (Shrinking small coefficients to zero)
nCoefs = round(coefRatio/100*numel(U));
[~,I] = mink(U(:),numel(U)-nCoefs,'ComparisonMethod','abs');
U(I) = 0;
disp(['Sparsity: ' num2str(nnz(U(:))) '/' num2str(numel(U(:))) ])
% Block IDCT
R = blockproc(U,nPoints*[1 1],@(x) idct2(x.data));
%%
%[text] ### 非線形近似の結果表示
%[text] (Display non-linear approximatiom result)
figure(3)
subplot(1,2,1)
imshow(X)
title('Original')
subplot(1,2,2)
imshow(R)
title(['NLA result w/ ' num2str(coefRatio) ' % Coefs. (PSNR: ' num2str(psnr(X,R)) ' dB)'])
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:353a]
%   data: {"defaultValue":4,"label":"nPoints","max":8,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:2366]
%   data: {"defaultValue":5,"label":"coefRatio","max":100,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
