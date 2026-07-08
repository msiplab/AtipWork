%[text] # Sample 12-3
%[text] ## 画像復元
%[text] 合成モデル
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Image restoration
%[text] Synthesis model
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
%[text] ### パラメータ設定
%[text] (Parameter settings)
%[text] - sgm: ノイズ標準偏差 $\\sigma\_w$ (Standard deviation of noise)
%[text] - nlevels: ウェーブレット段数 (Wavelet levels) \
% Parameter settings
isaprxleft = true; %[control:checkbox:040d]{"position":[14,18]}
lambda = 10^-0.1 %[control:slider:49f4]{"position":[13,17]}
gamma = 10^0.3 %[control:slider:09e3]{"position":[12,15]}
sgmuint8 = 10;  %[control:slider:19a6]{"position":[12,14]}
sgm = sgmuint8/255;
nlevels = 3;  %[control:slider:24b1]{"position":[11,12]}
niters = 80; %[control:slider:6a83]{"position":[10,12]}
%%
%[text] ## 画像の読込
%[text] (Read image)
u = rgb2gray(im2double(imread('./data/kodim23.png')));
%%
%[text] ## 観測画像
%[text] (Observation image)
%[text] - $\\mathbf{v}=\\mathbf{Pu}+\\mathbf{w}$
%[text] - $\\mathbf{u}=\\mathbf{Ds}$
%[text] - $\\mathbf{w}\\sim\\mathrm{Norm}\\left(\\mathbf{w}|\\mathbf{\\mu}\_w=\\mathbf{0},\\sigma\_w^2\\mathbf{I}\\right)$ \
% Definition of measurment process
psf = fspecial('motion',21,11);
measureproc = @(x) imfilter(x,psf,'conv','circular');
% Adjoint process of the measurment process
measureadjp = @(x) imfilter(x,psf,'corr','circular');
% Simulation of AWGN
v = imnoise(measureproc(u),'gaussian',0,sgm^2);
%%
%[text] ### 非間引きハールDWT
%[text] (Undecimated Haar DWT)
import msip.udhaarwtdec2
import msip.udhaarwtrec2
%[text] #### 完全再構成の確認 (Checki the perfect reconstruction)
%[text] 非間引きハールDWTはパーセバルタイト性 (The undecimated DWT satisfies the Parseval tight property,)
%[text]  $\\mathbf{DD}^T=\\mathbf{I}$
%[text] を満たすため， $\\mathbf{D}$ の転置システムは完全再構成分析システムとなり得る．(and thus Its transposition system can be a PR analysis system.)
[coefs,scales] = udhaarwtdec2(v,nlevels);
r = udhaarwtrec2(coefs,scales);
assert(norm(v-r,"fro")^2/numel(v)<1e-18,'Perfect reconstruction is violated.')
%[text] 合成辞書と転置辞書の定義 (Definition of synthesis dictionary  and its adjoint)
% Definiton of dictionay and its adjoint
adjdic = @(x) udhaarwtdec2(x,nlevels); % D
syndic = @(x) udhaarwtrec2(x,scales);  % D.'
%%
%[text] ### 近接勾配法
%[text] (Proximal gradient method)
%[text] #### 問題設定 (Problem setting)
%[text]  $\\hat{\\mathbf{s}}=\\arg\\min\_{\\mathbf{s}}\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{PDs}\\|\_2^2+\\lambda\\|\\mathbf{s}\\|\_1$
%[text] #### アルゴリズム (Algorithm)
%[text] 1. Initialization: $\\mathbf{s}^{(0)}$, $t\\leftarrow 0$
%[text] 2. Proximal gradient descent: $\\mathbf{s}^{(t+1)}\\leftarrow \\mathrm{prox}\_{\\gamma g}\\left( \\mathbf{s}^{(t)}-\\gamma\\nabla\_\\mathbf{s}f(\\mathbf{s}^{(t)})\\right)$
%[text] 3. If a stopping critera is satisfied then finish, otherwise $t\\rightarrow t+1$ and go to Step 2. \
%[text] ただし，(where)
%[text] - $\\nabla\_\\mathbf{s}f(\\mathbf{s})=\\mathbf{D}^T\\mathbf{P}^T(\\mathbf{PDs}-\\mathbf{v})$
%[text] - $\\mathrm{prox}\_{\\gamma\\lambda\\|\\cdot\\|\_{1}}(\\mathbf{s})=\\mathcal{T}\_{\\gamma\\lambda}(\\mathbf{s})=\\mathrm{sign}(\\mathbf{s})\\odot\\max(\\mathrm{abs}(\\mathbf{s})-\\gamma\\lambda\\mathbf{1},\\mathbf{0})$ \
%[text] ソフト閾値処理 (Soft-thresholding)
softthresh = @(x,t) sign(x).*max(abs(x)-t,0);
%[text] 初期化 (Initialization)
[coefs,scales] = udhaarwtdec2(v,nlevels);
sp = coefs;
%[text] 近接勾配降下 (Proximal gradient descent)
%[text] - $\\gamma\<2/\\beta$: Step size
%[text] - $\\beta$: Lipschitz constant of $\\nabla f$, where $\\beta = (\\sigma\_{\\mathrm{max}}(\\mathbf{PD}))^2$ \
beta = max(abs(fftn(psf,2.^nextpow2(size(v)))),[],'all');
assert(gamma < 2/beta,'Step size condition is violated.')
if isaprxleft
    mask = ones(size(coefs));
    mask(1:prod(scales(1,:))) = 0;
    lambda = lambda * mask;
end
for idx=0:niters-1
    % Proximal gradient descent
    sg = adjdic(measureadjp(measureproc(syndic(sp))-v));
    sc = softthresh(sp-gamma*sg,gamma*lambda);
    % Update
    sp = sc;
end
%%
%[text] ### 復元画像
%[text] (Restored image)
r = syndic(sc);
%%
%[text] ### 画像表示
%[text] (Image show)
figure(1)
imshow(u);
title('Original image u')
figure(2)
imshow(v)
title(sprintf('Blurred image v：PSNR = %5.2f [dB]',psnr(u,v)))
figure(3)
imshow(r)
title(sprintf('Restored image r w/ ISTA：PSNR = %5.2f [dB]',psnr(u,r)))
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:checkbox:040d]
%   data: {"defaultValue":true,"label":"isaprxleft","run":"SectionToEnd"}
%---
%[control:slider:49f4]
%   data: {"defaultValue":-0.1,"label":"lambda","max":2,"min":-4,"run":"SectionToEnd","runOn":"ValueChanged","step":0.1}
%---
%[control:slider:09e3]
%   data: {"defaultValue":0.3,"label":"gamma","max":2,"min":-4,"run":"SectionToEnd","runOn":"ValueChanged","step":0.1}
%---
%[control:slider:19a6]
%   data: {"defaultValue":10,"label":"スライダー","max":50,"min":0,"run":"SectionToEnd","runOn":"ValueChanged","step":10}
%---
%[control:slider:24b1]
%   data: {"defaultValue":3,"label":"nlevels","max":5,"min":1,"run":"SectionToEnd","runOn":"ValueChanged","step":1}
%---
%[control:slider:6a83]
%   data: {"defaultValue":80,"label":"niters","max":100,"min":10,"run":"SectionToEnd","runOn":"ValueChanged","step":10}
%---
