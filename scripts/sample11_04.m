%[text] # Sample 11-4
%[text] ## 画像ノイズ除去
%[text] 勾配降下法
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Image denoising
%[text] Gradient descent
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
%[text]  $\\hat{\\mathbf{s}}=\\arg\\min\_{\\mathbf{s}}\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{Ds}\\|\_2^2+\\frac{\\lambda}{2}\\|\\mathbf{s}\\|\_2^2$
%[text] - $\\mathbf{D} = \\left(\\begin{array}{cc} \\frac{2}{3} & \\frac{1}{3}\\end{array}\\right)\\colon\\quad \\mathbb{R}^2\\rightarrow\\mathbb{R}^1$
%[text] - $\\mathbf{v}=\\frac{1}{2}\\in\\mathbb{R}^1$
%[text] - $\\lambda\\in\[0,\\infty)$
%[text] - $\\mathbf{s}\\in\\mathbb{R}^2$ \
D = [2 1]/3;
v = 0.5; %[control:slider:8928]{"position":[5,8]}
%%
%[text] ### パラメータ設定
%[text] (Parameter settings)
lambda = 0.2; %[control:slider:54f9]{"position":[10,13]}
gamma = 0.4; %[control:slider:0043]{"position":[9,12]}
niters = 20; %[control:slider:4552]{"position":[10,12]}
%%
%[text] ### 関数プロット
%[text] (Function plot)
% Function setting
f = @(x0,x1) 0.5*(v-(D(1)*x0+D(2)*x1)).^2 + lambda*0.5*(x0.^2+x1.^2);
% Variable settings
s0 = linspace(-1,1,21);
s1 = linspace(-1,1,21);
% Surfc plot of cost function f()
figure
[S0,S1] = ndgrid(s0,s1);
J = f(S0,S1);
hf = surfc(s0,s1,J);
hf(1).FaceAlpha = 0.25;
hf(1).EdgeAlpha = 0.25;
hf(1).EdgeColor = 'interp';
hf(2).LineWidth = 1;
set(gca,'YDir','reverse')
ylabel('s_0')
xlabel('s_1')
zlabel('f(s)')
hold on
%%
%[text] ### 勾配降下法
%[text] (Gradient descent)
%[text] 1. Initialization: $\\mathbf{x}^{(0)}$, $t\\leftarrow 0$
%[text] 2. Gradient descent: $\\mathbf{x}^{(t+1)}\\leftarrow \\mathbf{x}^{(t)}-\\gamma\\nabla\_\\mathbf{x}f(\\mathbf{x}^{(t)})$
%[text] 3. If a stopping critera is satisfied then finish, otherwise $t\\rightarrow t+1$ and go to Step 2. \
%[text] 【Example】
%[text] - $f(\\mathbf{s})=\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{Ds}\\|\_2^2+\\frac{\\lambda}{2}\\|\\mathbf{s}\\|\_2^2$
%[text] - $\\nabla\_\\mathbf{s}f(\\mathbf{s})=\\mathbf{D}^T(\\mathbf{Ds}-\\mathbf{v})+\\lambda\\mathbf{s}$ \
%[text] 初期化 (Initialization)
sp = 2*rand(2,1)-1; % in [-1,1]^2
%[text] 勾配降下 (Gradient descent)
for idx=0:niters-1
    % Preious state
    s(1,1) = sp(1); % s0
    s(2,1) = sp(2); % s1
    % Gradient descent
    sc = sp-gamma*(D'*(D*sp-v)+lambda*sp);
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
isaprxleft = true; %[control:checkbox:842d]{"position":[14,18]}
lambda = 10^1 %[control:slider:7287]{"position":[13,14]}
gamma = 10^-1 %[control:slider:63ad]{"position":[12,14]}
sgmuint8 = 30;  %[control:slider:4563]{"position":[12,14]}
sgm = sgmuint8/255;
nlevels = 3;  %[control:slider:08bd]{"position":[11,12]}
niters = 80; %[control:slider:7a77]{"position":[10,12]}
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
%[text] - $\\mathbf{s}\\sim\\mathrm{Norm}\\left(\\mathbf{s}|\\mathbf{\\mu}=\\mathbf{0},\\sigma\_s^2\\mathbf{I}\\right)$
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
%[text] ### 勾配降下法
%[text] (Gradient descent method)
%[text] 1. Initialization: $\\mathbf{x}^{(0)}$, $t\\leftarrow 0$
%[text] 2. Gradient descent: $\\mathbf{x}^{(t+1)}\\leftarrow \\mathbf{x}^{(t)}-\\gamma\\nabla\_\\mathbf{x}f(\\mathbf{x}^{(t)})$
%[text] 3. If a stopping critera is satisfied then finish, otherwise $t\\rightarrow t+1$ and go to Step 2. \
%[text] 【Example】
%[text] - $f(\\mathbf{s})=\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{Ds}\\|\_2^2+\\frac{\\lambda}{2}\\|\\mathbf{s}\\|\_2^2$
%[text] - $\\nabla\_\\mathbf{s}f(\\mathbf{s})=\\mathbf{D}^T(\\mathbf{Ds}-\\mathbf{v})+\\lambda\\mathbf{s}$ \
%[text] 初期化 (Initialization)
sp = coefs;
%[text] 勾配降下 (Gradient descent)
if isaprxleft
    mask = ones(size(coefs));
    mask(1:prod(scales(1,:))) = 0;
    lambda = lambda * mask;
end
for idx=0:niters-1
    % Gradient descent
    sc = sp-gamma*(adjdic(syndic(sp)-v)+lambda.*sp);
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
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:8928]
%   data: {"defaultValue":0.5,"label":"v","max":0.5,"min":-0.5,"run":"SectionToEnd","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:54f9]
%   data: {"defaultValue":0.2,"label":"lambda","max":2,"min":0,"run":"AllSections","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:0043]
%   data: {"defaultValue":0.4,"label":"gamma","max":1,"min":0.1,"run":"SectionToEnd","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:4552]
%   data: {"defaultValue":20,"label":"niters","max":100,"min":10,"run":"SectionToEnd","runOn":"ValueChanging","step":10}
%---
%[control:checkbox:842d]
%   data: {"defaultValue":true,"label":"isaprxleft","run":"SectionToEnd"}
%---
%[control:slider:7287]
%   data: {"defaultValue":1,"label":"lambda","max":2,"min":-4,"run":"AllSections","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:63ad]
%   data: {"defaultValue":-1,"label":"gamma","max":1,"min":-2,"run":"SectionToEnd","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:4563]
%   data: {"defaultValue":20,"label":"スライダー","max":50,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":10}
%---
%[control:slider:08bd]
%   data: {"defaultValue":3,"label":"nlevels","max":5,"min":1,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:7a77]
%   data: {"defaultValue":80,"label":"niters","max":100,"min":10,"run":"SectionToEnd","runOn":"ValueChanging","step":10}
%---
