%[text] # Sample 11-4: Gradient descent ($\\ell\_2$ regularization)
%[text] Advanced Topics in Image Processing, Lecture 11 "Image Denoising"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Preparation
[datfolder,~] = atip.prjfolders();
atip.download_img(false)
%%
%[text] ## Problem setting
%[text] $\\hat{\\mathbf{s}}=\\arg\\min\_{\\mathbf{s}}\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{D}\\mathbf{s}\\|\_2^2+\\frac{\\lambda}{2}\\|\\mathbf{s}\\|\_2^2$
%[text] - $\\mathbf{D} = \\left(\\begin{array}{cc} \\frac{2}{3} & \\frac{1}{3}\\end{array}\\right)\\colon\\quad \\mathbb{R}^2\\rightarrow\\mathbb{R}^1$
%[text] - $\\mathbf{v}=\\frac{1}{2}\\in\\mathbb{R}^1$
%[text] - $\\lambda\\in\[0,\\infty)$
%[text] - $\\mathbf{s}\\in\\mathbb{R}^2$ \
D = [2 1]/3;
v = 0.5; %[control:slider:775c]{"position":[5,8]}
%%
%[text] ## Parameter settings
%[text] Regularization parameter $\\lambda$, step size $\\eta$ and number of iterations
lambda = 0.2; %[control:slider:55d1]{"position":[10,13]}
eta = 0.4; %[control:slider:7a6e]{"position":[7,10]}
niters = 20; %[control:slider:8f01]{"position":[10,12]}
%%
%[text] ## Function plot
% Function setting
f = @(s0,s1) 0.5*(v-(D(1)*s0+D(2)*s1)).^2 + lambda*0.5*(s0.^2+s1.^2);
% Variable settings
s0 = linspace(-1,1,21);
s1 = linspace(-1,1,21);
% Surfc plot of the cost function f(s)
fig1 = figure;
ax = axes(fig1);
[S0,S1] = ndgrid(s0,s1);
J = f(S0,S1);
hf = surfc(ax,s0,s1,J);
hf(1).FaceAlpha = 0.25;
hf(1).EdgeAlpha = 0.25;
hf(1).EdgeColor = 'interp';
hf(2).LineWidth = 1;
ax.YDir = 'reverse';
ylabel(ax,"$s[0]$","Interpreter","latex")
xlabel(ax,"$s[1]$","Interpreter","latex")
zlabel(ax,"$f(\mathbf{s})$","Interpreter","latex")
hold(ax,"on")
%%
%[text] ## Gradient descent
%[text] 1. Initialization: $\\mathbf{x}^{(0)}$, $t\\leftarrow 0$
%[text] 2. Gradient descent: $\\mathbf{x}^{(t+1)}\\leftarrow \\mathbf{x}^{(t)}-\\eta\\nabla f(\\mathbf{x}^{(t)})$
%[text] 3. If a stopping criterion is satisfied, finish; otherwise $t\\leftarrow t+1$ and go to step 2. \
%[text] The step size must satisfy $\\eta\\in(0,2/\\kappa)$, where $\\kappa$ is the Lipschitz constant of $\\nabla f$.
%[text] **Example**
%[text] - $f(\\mathbf{s})=\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{D}\\mathbf{s}\\|\_2^2+\\frac{\\lambda}{2}\\|\\mathbf{s}\\|\_2^2$
%[text] - $\\nabla f(\\mathbf{s})=\\mathbf{D}^\\top(\\mathbf{D}\\mathbf{s}-\\mathbf{v})+\\lambda\\mathbf{s}$, $\\kappa=\\|\\mathbf{D}\\|\_\\mathrm{S}^2+\\lambda$ \
%[text] Initialization
sp = 2*rand(2,1)-1; % in [-1,1]^2
%[text] Gradient descent
for idx = 0:niters-1
    % Gradient descent
    sc = sp - eta*(D.'*(D*sp-v)+lambda*sp);
    % Quiver plot from the previous state to the current state (s[1] horizontal, s[0] vertical)
    hp = quiver(ax,sp(2),sp(1),sc(2)-sp(2),sc(1)-sp(1));
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
hold(ax,"off")
%%
%[text] ## Parameter settings for image denoising
%[text] - isaprxleft: the low-pass (approximation) coefficients are not regularized if true
%[text] - lambda, eta: regularization parameter $\\lambda$ and step size $\\eta$ (exponents with the sliders)
%[text] - sgmuint8: standard deviation of the noise $\\sigma\_\\mathrm{w}$ (in the scale of 8-bit integers)
%[text] - nlevels: number of wavelet levels
%[text] - niters: number of iterations \
% Parameter settings
isaprxleft = true; %[control:checkbox:3a95]{"position":[14,18]}
lambda = 10^1 %[control:slider:5c91]{"position":[13,14]}
eta = 10^-1 %[control:slider:120b]{"position":[10,12]}
sgmuint8 = 30;  %[control:slider:721e]{"position":[12,14]}
sgm = sgmuint8/255;
nlevels = 3;  %[control:slider:477a]{"position":[11,12]}
niters = 80; %[control:slider:6412]{"position":[10,12]}
%%
%[text] ## Read image
x = im2double(imread(fullfile(datfolder,"kodim23.png")));
if size(x,3) == 3
    x = rgb2gray(x);
end
%%
%[text] ## Observation image
%[text] - $\\mathbf{v}=\\mathbf{x}+\\mathbf{w}$
%[text] - $\\mathbf{x}=\\mathbf{D}\\mathbf{s}$
%[text] - $\\mathbf{s}\\sim\\mathcal{N}\\left(\\mathbf{s};\\mathbf{0},\\sigma\_\\mathrm{s}^2\\mathbf{I}\\right)$
%[text] - $\\mathbf{w}\\sim\\mathcal{N}\\left(\\mathbf{w};\\mathbf{0},\\sigma\_\\mathrm{w}^2\\mathbf{I}\\right)$ \
v = imnoise(x,'gaussian',0,sgm^2);
%%
%[text] ## Undecimated Haar DWT
import msip.udhaarwtdec2
import msip.udhaarwtrec2
%[text] ### Check of the perfect reconstruction
%[text] The undecimated Haar DWT satisfies the Parseval tight property $\\mathbf{D}\\mathbf{D}^\\top=\\mathbf{I}$,
%[text] and thus its adjoint (transposed) system is a PR analysis system.
[coefs,scales] = udhaarwtdec2(v,nlevels);
xr = udhaarwtrec2(coefs,scales);
assert(norm(v-xr,"fro")^2/numel(v)<1e-18,'Perfect reconstruction is violated.')
%[text] Definition of the synthesis dictionary and its adjoint
adjdic = @(x) udhaarwtdec2(x,nlevels); % D.' (analysis FB)
syndic = @(s) udhaarwtrec2(s,scales);  % D   (synthesis FB)
%%
%[text] ## Gradient descent
%[text] $\\mathbf{s}^{(t+1)}\\leftarrow\\mathbf{s}^{(t)}-\\eta\\left(\\mathbf{D}^\\top(\\mathbf{D}\\mathbf{s}^{(t)}-\\mathbf{v})+\\lambda\\mathbf{s}^{(t)}\\right)$
%[text] Initialization
sp = coefs;
%[text] Gradient descent
if isaprxleft
    mask = ones(size(coefs));
    mask(1:prod(scales(1,:))) = 0;
    lambda = lambda * mask;
end
for idx = 0:niters-1
    % Gradient descent
    sc = sp - eta*(adjdic(syndic(sp)-v)+lambda.*sp);
    % Update
    sp = sc;
end
%%
%[text] ## Denoised image
xhat = syndic(sc);
%%
%[text] ## Image show
fig2 = figure;
tl = tiledlayout(fig2,1,3,"TileSpacing","compact");
imshow(x,"Parent",nexttile(tl))
title("Original image $\mathbf{x}$","Interpreter","latex")
imshow(v,"Parent",nexttile(tl))
title("Noisy image $\mathbf{v}$: PSNR = " + sprintf("%5.2f",psnr(v,x)) + " dB","Interpreter","latex")
imshow(xhat,"Parent",nexttile(tl))
title("Denoised image $\hat{\mathbf{x}}$: PSNR = " + sprintf("%5.2f",psnr(xhat,x)) + " dB","Interpreter","latex")
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:775c]
%   data: {"defaultValue":0.5,"label":"v","max":0.5,"min":-0.5,"run":"SectionToEnd","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:55d1]
%   data: {"defaultValue":0.2,"label":"lambda","max":2,"min":0,"run":"AllSections","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:7a6e]
%   data: {"defaultValue":0.4,"label":"eta","max":1,"min":0.1,"run":"SectionToEnd","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:8f01]
%   data: {"defaultValue":20,"label":"niters","max":100,"min":10,"run":"SectionToEnd","runOn":"ValueChanging","step":10}
%---
%[control:checkbox:3a95]
%   data: {"defaultValue":true,"label":"isaprxleft","run":"SectionToEnd"}
%---
%[control:slider:5c91]
%   data: {"defaultValue":1,"label":"log10(lambda)","max":2,"min":-4,"run":"AllSections","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:120b]
%   data: {"defaultValue":-1,"label":"log10(eta)","max":1,"min":-2,"run":"SectionToEnd","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:721e]
%   data: {"defaultValue":30,"label":"sgmuint8","max":50,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":10}
%---
%[control:slider:477a]
%   data: {"defaultValue":3,"label":"nlevels","max":5,"min":1,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:6412]
%   data: {"defaultValue":80,"label":"niters","max":100,"min":10,"run":"SectionToEnd","runOn":"ValueChanging","step":10}
%---
