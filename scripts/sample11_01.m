%[text] # Sample 11-1
%[text] ## 画像ノイズ除去
%[text] 加法性白色ガウスノイズ
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Image denoising
%[text] Additive whitel Gaussian noise
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
clear 
close all
import msip.download_img
msip.download_img
%%
%[text] ## 画像生成
%[text] (Image generation)
%[text] - $\\mathbf{u}\\in\\mathbb{R}^N$: 原画像 (Original image) \
% Original image u
u = 0.75*ones(128);
u(24:128-24,24:128-24) = 0.5;
u(48:128-48,48:128-48) = 0.25;

figure
imshow(u)
title('Original')
figure
imhist(u)
title('Histogram of original')
set(gca,'YLim',[0 12000])
%%
%[text] ### 白色ガウスノイズ
%[text] (White Gaussian noise)
%[text] ノイズはガウス分布(正規分布)に従う乱数と仮定．(Noise is assumed to be a random number drawn from a Gaussian distribution (normal distribution).)
%[text] - $\\mathbf{w}\\sim\\mathrm{Norm}(\\mathbf{w}|\\mathbf{\\mu}\_w,\\mathbf{\\Sigma}\_w)$: ノイズ (Noise)
%[text] - $\\mathrm{Norm}(\\mathbf{x}|\\mathbf{\\mu},\\mathbf{\\Sigma})=\\frac{1}{\\sqrt{2 \\pi |\\mathbf{\\Sigma}|}} \\exp \\left(-\\frac{1}{2 }(\\mathbf{x}-\\mathbf{\\mu})^T\\mathbf{\\Sigma}^{-1}(\\mathbf{x}-\\mathbf{\\mu})\\right), \\quad \\mathbf{x} \\in \\mathbb{R}^{N}$ \
%[text] 白色とは零平均 (zero mean) かつ 独立同一分布 i.i.d. (independently and identical distribution)を意味する．(White means zero mean and i.i.d. (independent and identical distribution)).
%[text] - $\\mathbf{\\mu}\_w=\\mathbf{0}$
%[text] - $\\mathbf{\\Sigma}\_w = \\sigma\_w^2\\mathbf{I}$ \
% Gaussain parameters
muw = 0;
sgmw2 = 10^-3; %[control:slider:1812]{"position":[12,14]}
sgmw  = sqrt(sgmw2);

% Gaussian distribution
x = linspace(-4*sgmw,4*sgmw,1001);
wpdf = normpdf(x,muw,sgmw);
figure
h = plot(x,wpdf);
xlabel('w')
title('Gaussian distribution') 
grid on
%[text] 擬似乱数生成 (Pseudo-random number generation)
% Additive white Gaussian noise
w = sqrt(sgmw2)*randn(size(u));
figure
histogram(w(:))
title('Histogram of Gaussian noise')
set(gca,'XLim',[-4*sgmw 4*sgmw])
%%
%[text] ### 観測画像
%[text] (Observed image)
%[text] 加法性白色ガウスノイズによる劣化のシミュレーション (Simulation of degradation by additive White Gaussian noise)
%[text] - $\\mathbf{v}=\\mathbf{u}+\\mathbf{w}\\in\\mathbb{R}^N$: 観測画像 (Observed image) \
% Noisy observation
v = u + w;
figure
imshow(v)
title('Observation')
figure
imhist(v)
title('Histogram of observation')
set(gca,'YLim',[0 600])
%%
%[text] ### ノイズ画像生成
%[text] (Generation of noisy image)
%[text] IMNOISE関数を利用できる．(IMNOISE function can be used.)
%[text] 加法性白色ガウスノイズ(AWGN)を与える例．(Example of giving additive white Gaussian noise(AWGN).)
I = rgb2gray(imread('./data/kodim23.png'));
J = imnoise(I,'gaussian',muw,sgmw2);
figure
imshow(I)
figure
imhist(I)
figure
imshow(J)
figure
imhist(J)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:1812]
%   data: {"defaultValue":-3,"label":"スライダー","max":0,"min":-4,"run":"SectionToEnd","runOn":"ValueChanging","step":0.1}
%---
