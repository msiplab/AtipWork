%[text] # Sample 8-3
%[text] ## 離散コサイン変換
%[text] 画像符号化
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Discrete cosine transform
%[text] Image codec
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ### 単変量変換行列の定義
%[text] (Definition of univariate transform)
%[text] - 回転行列(rotation matrix) \
%[text]  $\\mathbf{A}\_{\\theta} = \\left(\\begin{array}{cc} \\cos\\theta & -\\sin\\theta \\\\ \\sin\\theta & \\cos\\theta \\end{array}\\right)$
Atheta = @(theta) [cos(theta) -sin(theta) ; sin(theta) cos(theta)];
%%
%[text] ### ブロック毎の処理の定義
%[text] (Definition of patch processing)
%[text] 順変換　→　量子化　→　逆量子化　→　逆変換
%[text] (Forward transform → Quantization → Inverse quantization → Inverse transform)
%[text]  $T(\\mathbf{X})=\\mathbf{A}^{-1}\\left(\\mathbf{Q}\\odot\\mathrm{round}( (\\mathbf{AXA}^T)\\oslash\\mathbf{Q})\\right)\\mathbf{A}^{-T}$
%[text] - $\\odot$: 要素毎の掛け算 (Entry-wise multiplication)
%[text] - $\\oslash$: 要素毎の割り算 (Entry-wise division) \
mycodec = @(X,A,Q) inv(A)*(Q.*(round((A*double(X.data)*A.')./Q)))*inv(A).';
%[text] ブロックサイズ (Patch size)
blkSz = [2 2];
%%
%[text] ### 配列に対するブロック処理
%[text] 品質制御パラメータ (Quality factor)
%[text] - 量子化ステップを制御 (Controls the quantization step) \
Qfactor = 1; %[control:slider:8c6a]{"position":[11,12]}
%%
%[text] ### 入力配列の定義
%[text]  (Definition of input array)
U = [
    2 2 3 1 ;
    2 2 3 1 ;
    3 3 2 0 ;
    1 1 0 2 ];
%%
%[text] ### 単位行列の場合
%[text]  (For the indentity matrix case)
A0 = eye(blkSz) % or Atheta(0)
%[text] 量子化テーブル (Quantization table) $\\mathbf{Q}$
Q0 = Qfactor*[ % Flat
    2 2 ; 
    2 2 ];
%[text] 符号化および復号(Coding and decoding)
% Definition of block processing
mycodec0 = @(x) mycodec(x,A0,Q0);

% Run codec
V0 = blockproc(U,blkSz,mycodec0)
% Error
U-V0
%%
%[text] ### ハール変換の場合
%[text]  (For the Haar case)
Ah = Atheta(-pi/4)
%[text] 量子化テーブル (Quantization table) $\\mathbf{Q}$
Qh = Qfactor*[ % Manually weighted
    3 4 ;
    4 5 ]/2;
%[text] 符号化および復号(Coding and decoding)
% Definition of block processing
mycodech = @(x) mycodec(x,Ah,Qh);
% Run codec
Vh = blockproc(U,blkSz,mycodech)
% Error
U-Vh
%%
%[text] ### 品質評価 
%[text] (Quality assesment) 
%[text]  $\\mathrm{PSNR}(\\mathbf{U},\\mathbf{V}) = 10\\log\_{10}\\frac{\\mathrm{peak}^2}{\\mathrm{MSE}(\\mathbf{U},\\mathbf{V})}$ \[dB\]
%[text] - PSNRが大きいほど誤差が小さい (Larger PSNR means smaller error.) \
Qfactor
fprintf('PSNR (theta=0): %6.2f [dB]',psnr(U,V0,max(U(:))))
fprintf('PSNR (theta=-π/4): %6.2f [dB]',psnr(U,Vh,max(U(:))))
%%
%[text] ### 原画像の読込
%[text] (Read an image)
U = rgb2gray(imread('data/barbaraFaceRgb.tif'));
%%
%[text] ### 符号化および復号
%[text] (Coding and decoding)
%[text] 単位行列の場合 (For the indentity matrix case)
% Run codec w/ θ = 0
V0 = cast(blockproc(U,blkSz,mycodec0),'like',U);
%[text] ハール変換の場合 (For the Haar case)
% Run codec w/ θ=-π/4
Vh = cast(blockproc(U,blkSz,mycodech),'like',U);
%%
%[text] ### 品質評価 
%[text] (Quality assesment) 
Qfactor

fprintf('PSNR (theta=-π/4): %6.2f [dB]',psnr(U,Vh))
%%
%[text] ### 画像表示
%[text] (Image show)
figure(1)
imshow(U)
title('Original picture')
figure(2)
imshow(V0)
title(['Decoded picture w/ \theta=0 (PSNR: ' num2str(psnr(U,V0)) ' dB)'])
figure(3)
imshow(Vh)
title(['Decoded picture w/ \theta=-\pi/4 (PSNR: ' num2str(psnr(U,Vh)) ' dB)'])
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:8c6a]
%   data: {"defaultValue":1,"label":"Qfactor","max":8,"min":0.5,"run":"SectionToEnd","runOn":"ValueChanging","step":0.5}
%---
