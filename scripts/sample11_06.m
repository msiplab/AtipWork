%[text] # Sample 11-6
%[text] ## 画像ノイズ除去
%[text] 近接勾配法
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Image denoising
%[text] Proximal gradient
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
%[text] ## 問題設定
%[text] (Problem settings)
%[text]  $\\hat{\\mathbf{s}}=\\arg\\min\_{\\mathbf{s}}\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{Ds}\\|\_2^2+\\lambda\\|\\mathbf{s}\\|\_1$
%[text] - $\\mathbf{D} = \\left(\\begin{array}{cc} \\frac{2}{3} & \\frac{1}{3}\\end{array}\\right)\\colon\\quad \\mathbb{R}^2\\rightarrow\\mathbb{R}^1$
%[text] - $\\mathbf{v}=\\frac{1}{2}\\in\\mathbb{R}^1$
%[text] - $\\lambda\\in\[0,\\infty)$
%[text] - $\\mathbf{s}\\in\\mathbb{R}^2$ \
D = [2 1]/3;
v = 0.5; %[control:slider:0f61]{"position":[5,8]}
%%
%[text] ### 関数プロット
%[text] (Function plot)
% Function settings
f = @(s0,s1) 0.5*(v-(D(1)*s0+D(2)*s1)).^2;
g = @(s0,s1) (abs(s0)+abs(s1));
% Variable settings
s0 = linspace(-1,1,21);
s1 = linspace(-1,1,21);
[S0,S1] = ndgrid(s0,s1);
F = f(S0,S1);
G = g(S0,S1);
% Surfc plot of the fidelity
figure
hf = surfc(s0,s1,F);
hf(1).FaceAlpha = 0.125;
hf(1).FaceColor = 'green';
hf(1).EdgeAlpha = 0.25;
hf(2).LineWidth = 1;
set(gca,'YDir','reverse');
hold on
% Surfc plot of the regularizer
hg = surfc(s0,s1,G);
hg(1).FaceAlpha = 0.125;
hg(1).FaceColor = 'blue';
hg(1).EdgeAlpha = 0.25;
hg(2).LineWidth = 1;
xlabel('s_1')
ylabel('s_0')
hold off
%%
%[text] ### パラメータ設定
%[text] (Parameter settings)
lambda = 0.2; %[control:slider:9d84]{"position":[10,13]}
gamma = 0.4; %[control:slider:2279]{"position":[9,12]}
niters = 20; %[control:slider:7ce5]{"position":[10,12]}
%%
%[text] ## $\\ell\_1$ -ノルム正則化最小自乗法による近似
%[text] ($\\ell\_1$ -norm-regularized least square method)
%[text]  $\\hat{\\mathbf{s}}=\\arg\\min\_{\\mathbf{s}}\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{Ds}\\|\_2^2+\\lambda\\|\\mathbf{s}\\|\_1$
%[text] 近接勾配法に帰着させる．(Reduced to a proximal gradient method)
%[text]  $\\hat{\\mathbf{x}}=\\arg\\min\_{\\mathbf{x} \\in V} f(\\mathbf{x})+g(\\mathbf{x})$
%[text] - $f(\\cdot),g(\\cdot)\\in\\Gamma\_0(\\mathbb{R}^L)$: Convex functions
%[text] - $f(\\cdot)$ is differentiable ( $\\beta$-Lipschitz continuous)
%[text] - $\\Gamma\_0(\\mathbb{R}^L)$ : Set of proper semi-lower-continuous convex functions \
%[text] ### 
%[text] 【Example】
%[text] - $f(\\mathbf{s})=\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{Ds}\\|\_2^2$
%[text] - $g(\\mathbf{s})=\\lambda\\|\\mathbf{s}\\|\_1$ \
%[text] 関数プロット (Function plot)
% Function setting
fg = @(s0,s1) 0.5*(v-(D(1)*s0+D(2)*s1)).^2 + lambda*(abs(s0)+abs(s1));
% Surfc plot of cost function f+g
figure
J = fg(S0,S1);
hf = surfc(s0,s1,J);
hf(1).FaceAlpha = 0.25;
hf(1).EdgeAlpha = 0.25;
hf(1).EdgeColor = 'interp';
hf(2).LineWidth = 1;
set(gca,'YDir','reverse')
ylabel('s_0')
xlabel('s_1')
zlabel('f(s)+g(s)')
hold on
%%
%[text] ### 近接勾配法
%[text] (Proximal gradient method)
%[text] 1. Initialization: $\\mathbf{x}^{(0)}$, $t\\leftarrow 0$
%[text] 2. Proximal gradient descent: $\\mathbf{x}^{(t+1)}\\leftarrow \\mathrm{prox}\_{\\gamma g}\\left( \\mathbf{x}^{(t)}-\\gamma\\nabla\_\\mathbf{x}f(\\mathbf{x}^{(t)})\\right)$
%[text] 3. If a stopping critera is satisfied then finish, otherwise $t\\rightarrow t+1$ and go to Step 2. \
%[text] 【Example】
%[text] - $\\nabla\_\\mathbf{s}f(\\mathbf{s})=\\mathbf{D}^T(\\mathbf{Ds}-\\mathbf{v})$
%[text] - $\\mathrm{prox}\_{\\gamma\\lambda\\|\\cdot\\|\_{1}}(\\mathbf{s})=\\mathcal{T}\_{\\gamma\\lambda}(\\mathbf{s})=\\mathrm{sign}(\\mathbf{s})\\odot\\max(\\mathrm{abs}(\\mathbf{s})-\\gamma\\lambda\\mathbf{1},\\mathbf{0})$ \
%[text] ソフト閾値処理 (Soft-thresholding)
softthresh = @(x,t) sign(x).*max(abs(x)-t,0);
%[text] 初期化 (Initialization)
sp = 2*rand(2,1)-1; % in [-1,1]^2
%[text] 近接勾配降下 (Proximal gradient descent)
beta = D*D';
assert(gamma < 2/beta,'Step size condition is violated.')
for idx=0:niters-1
    % Preious state
    s(1,1) = sp(1); % s0
    s(2,1) = sp(2); % s1
    % Proximal gradient descent
    sc = softthresh(sp-gamma*D'*(D*sp-v),gamma*lambda);
    % sc = sign(c).*max(abs(c)-gamma*lambda,0);
    % Current state
    s(1,2) = sc(1); % s0
    s(2,2) = sc(2); % s1
    % Quiver plot
    xp = s(2,1);
    yp = s(1,1);
    xn = s(2,2);
    yn = s(1,2);
    hp = quiver(xp,yp,xn-xp,yn-yp);
    hp.Marker = 'o';
    hp.ShowArrowHead = 'on';
    hp.MaxHeadSize = 120;
    hp.MarkerSize = 6;
    hp.MarkerEdgeColor = 'r';
    hp.Color = 'r';
    hp.LineWidth = 2;
    % Update
    sp = sc;
end
hold off
%%
%[text] ### パラメータ設定
%[text] (Parameter settings)
%[text] - sgm: ノイズ標準偏差 $\\sigma\_w$ (Standard deviation of noise)
%[text] - nlevels: ウェーブレット段数 (Wavelet levels) \
% Parameter settings
isaprxleft = true; %[control:checkbox:508d]{"position":[14,18]}
lambda = 10^-1 %[control:slider:2257]{"position":[13,15]}
gamma = 10^-0.1 %[control:slider:9a91]{"position":[12,16]}
sgmuint8 = 10;  %[control:slider:6daa]{"position":[12,14]}
sgm = sgmuint8/255;
nlevels = 3;  %[control:slider:10b6]{"position":[11,12]}
niters = 80; %[control:slider:13a5]{"position":[10,12]}
%%
%[text] ## 画像の読込
%[text] (Read image)
u = im2double(imread('./data/kodim23.png'));
if size(u,3) == 3
    u = rgb2gray(u);
end
%%
%[text] ## 観測画像
%[text] (Observation image)
%[text] - $\\mathbf{v}=\\mathbf{u}+\\mathbf{w}$
%[text] - $\\mathbf{u}=\\mathbf{Ds}$
%[text] - $\\mathbf{s}\\sim\\mathrm{Lap}\\left(\\mathbf{s}|\\mathbf{\\mu}=\\mathbf{0},b\\right)$
%[text] - $\\mathbf{w}\\sim\\mathrm{Norm}\\left(\\mathbf{w}|\\mathbf{\\mu}\_w=\\mathbf{0},\\sigma\_w^2\\mathbf{I}\\right)$ \
v = imnoise(u,'gaussian',0,sgm^2);
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
%[text] 初期化 (Initialization)
[coefs,scales] = udhaarwtdec2(v,nlevels);
sp = coefs;
%[text] 近接勾配降下 (Proximal gradient descent)
if isaprxleft
    mask = ones(size(coefs));
    mask(1:prod(scales(1,:))) = 0;
    lambda = lambda * mask;
end
for idx=0:niters-1
    % Proximal gradient descent
    sc = softthresh(sp-gamma*adjdic(syndic(sp)-v),gamma*lambda);
    % Update
    sp = sc;
end
%%
%[text] ### ノイズ除去画像
%[text] (Denoised image)
r = syndic(sc);
%%
%[text] ### 画像表示
%[text] (Image show)
figure
imshow(u);
title('Original image u')
figure
imshow(v)
title(sprintf('Noisy image v：PSNR = %5.2f [dB]',psnr(u,v)))
figure
imshow(r)
title(sprintf('Denoised image r：PSNR = %5.2f [dB]',psnr(u,r)))
%%
%[text] ### ウェーブレット画像ノイズ除去関数
%[text] (Wavelet image denoising function)
%[text] 参考資料 (Reference)
iswtb = license('checkout','wavelet_toolbox');
if iswtb
    help wdenoise2
end
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:0f61]
%   data: {"defaultValue":0.5,"label":"v","max":0.5,"min":-0.5,"run":"SectionToEnd","runOn":"ValueChanged","step":0.1}
%---
%[control:slider:9d84]
%   data: {"defaultValue":0.2,"label":"lambda","max":2,"min":0,"run":"AllSections","runOn":"ValueChanged","step":0.1}
%---
%[control:slider:2279]
%   data: {"defaultValue":0.4,"label":"gamma","max":1,"min":0.1,"run":"SectionToEnd","runOn":"ValueChanged","step":0.1}
%---
%[control:slider:7ce5]
%   data: {"defaultValue":20,"label":"niters","max":100,"min":10,"run":"SectionToEnd","runOn":"ValueChanged","step":10}
%---
%[control:checkbox:508d]
%   data: {"defaultValue":true,"label":"isaprxleft","run":"SectionToEnd"}
%---
%[control:slider:2257]
%   data: {"defaultValue":-0.8,"label":"lambda","max":2,"min":-4,"run":"SectionToEnd","runOn":"ValueChanged","step":0.1}
%---
%[control:slider:9a91]
%   data: {"defaultValue":-0.1,"label":"gamma","max":2,"min":-4,"run":"SectionToEnd","runOn":"ValueChanged","step":0.1}
%---
%[control:slider:6daa]
%   data: {"defaultValue":10,"label":"スライダー","max":50,"min":0,"run":"SectionToEnd","runOn":"ValueChanged","step":10}
%---
%[control:slider:10b6]
%   data: {"defaultValue":3,"label":"nlevels","max":5,"min":1,"run":"SectionToEnd","runOn":"ValueChanged","step":1}
%---
%[control:slider:13a5]
%   data: {"defaultValue":80,"label":"niters","max":100,"min":10,"run":"SectionToEnd","runOn":"ValueChanged","step":10}
%---
