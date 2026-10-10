%[text] # Sample 11-6: Proximal gradient ($\\ell\_1$ regularization)
%[text] Advanced Topics in Image Processing, Lecture 11 "Image Denoising"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Preparation
[datfolder,~] = atip.prjfolders();
atip.download_img(false)
%%
%[text] ## Problem setting
%[text] $\\hat{\\mathbf{s}}=\\arg\\min\_{\\mathbf{s}}\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{D}\\mathbf{s}\\|\_2^2+\\lambda\\|\\mathbf{s}\\|\_1$
%[text] - $\\mathbf{D} = \\left(\\begin{array}{cc} \\frac{2}{3} & \\frac{1}{3}\\end{array}\\right)\\colon\\quad \\mathbb{R}^2\\rightarrow\\mathbb{R}^1$
%[text] - $\\mathbf{v}=\\frac{1}{2}\\in\\mathbb{R}^1$
%[text] - $\\lambda\\in\[0,\\infty)$
%[text] - $\\mathbf{s}\\in\\mathbb{R}^2$ \
D = [2 1]/3;
v = 0.5; %[control:slider:3bb1]{"position":[5,8]}
%%
%[text] ## Function plot
%[text] Fidelity term (green) and regularizer (blue)
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
fig1 = figure;
ax = axes(fig1);
hf = surfc(ax,s0,s1,F);
hf(1).FaceAlpha = 0.125;
hf(1).FaceColor = 'green';
hf(1).EdgeAlpha = 0.25;
hf(2).LineWidth = 1;
ax.YDir = 'reverse';
hold(ax,"on")
% Surfc plot of the regularizer
hg = surfc(ax,s0,s1,G);
hg(1).FaceAlpha = 0.125;
hg(1).FaceColor = 'blue';
hg(1).EdgeAlpha = 0.25;
hg(2).LineWidth = 1;
xlabel(ax,"$s[1]$","Interpreter","latex")
ylabel(ax,"$s[0]$","Interpreter","latex")
hold(ax,"off")
%%
%[text] ## Parameter settings
%[text] Regularization parameter $\\lambda$, step size $\\eta$ and number of iterations
lambda = 0.2; %[control:slider:42e7]{"position":[10,13]}
eta = 0.4; %[control:slider:39a6]{"position":[7,10]}
niters = 20; %[control:slider:7c83]{"position":[10,12]}
%%
%[text] ## $\\ell\_1$-norm regularized least-squares method
%[text] $\\hat{\\mathbf{s}}=\\arg\\min\_{\\mathbf{s}}\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{D}\\mathbf{s}\\|\_2^2+\\lambda\\|\\mathbf{s}\\|\_1$
%[text] is solved by the proximal gradient method for
%[text] $\\hat{\\mathbf{x}}=\\arg\\min\_{\\mathbf{x}} f(\\mathbf{x})+g(\\mathbf{x})$
%[text] - $f(\\cdot)$: convex and differentiable ($\\nabla f$ is $\\kappa$-Lipschitz continuous)
%[text] - $g(\\cdot)\\in\\Gamma\_0(\\mathbb{R}^L)$: proper, convex and lower semicontinuous function \
%[text] **Example**
%[text] - $f(\\mathbf{s})=\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{D}\\mathbf{s}\\|\_2^2$
%[text] - $g(\\mathbf{s})=\\lambda\\|\\mathbf{s}\\|\_1$ \
%[text] Function plot
% Function setting
fg = @(s0,s1) 0.5*(v-(D(1)*s0+D(2)*s1)).^2 + lambda*(abs(s0)+abs(s1));
% Surfc plot of the cost function f+g
fig2 = figure;
ax = axes(fig2);
J = fg(S0,S1);
hf = surfc(ax,s0,s1,J);
hf(1).FaceAlpha = 0.25;
hf(1).EdgeAlpha = 0.25;
hf(1).EdgeColor = 'interp';
hf(2).LineWidth = 1;
ax.YDir = 'reverse';
ylabel(ax,"$s[0]$","Interpreter","latex")
xlabel(ax,"$s[1]$","Interpreter","latex")
zlabel(ax,"$f(\mathbf{s})+g(\mathbf{s})$","Interpreter","latex")
hold(ax,"on")
%%
%[text] ## Proximal gradient method
%[text] 1. Initialization: $\\mathbf{x}^{(0)}$, $t\\leftarrow 0$
%[text] 2. Proximal gradient descent: $\\mathbf{x}^{(t+1)}\\leftarrow \\mathrm{prox}\_{\\eta g}\\left( \\mathbf{x}^{(t)}-\\eta\\nabla f(\\mathbf{x}^{(t)})\\right)$
%[text] 3. If a stopping criterion is satisfied, finish; otherwise $t\\leftarrow t+1$ and go to step 2. \
%[text] **Example** (ISTA)
%[text] - $\\nabla f(\\mathbf{s})=\\mathbf{D}^\\top(\\mathbf{D}\\mathbf{s}-\\mathbf{v})$, $\\kappa=\\|\\mathbf{D}\\|\_\\mathrm{S}^2$
%[text] - $\\mathrm{prox}\_{\\eta\\lambda\\|\\cdot\\|\_{1}}(\\mathbf{s})=\\phi\_\\mathrm{ST}(\\mathbf{s};\\eta\\lambda)=\\mathrm{sign}(\\mathbf{s})\\odot\\max(\\mathrm{abs}(\\mathbf{s})-\\eta\\lambda\\mathbf{1},\\mathbf{0})$ \
%[text] Soft thresholding
softthresh = @(s,tau) sign(s).*max(abs(s)-tau,0);
%[text] Initialization
sp = 2*rand(2,1)-1; % in [-1,1]^2
%[text] Proximal gradient descent
kappa = norm(D)^2; % Lipschitz constant of the gradient of f
assert(eta < 2/kappa,'Step size condition is violated.')
for idx = 0:niters-1
    % Proximal gradient descent
    sc = softthresh(sp-eta*D.'*(D*sp-v),eta*lambda);
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
isaprxleft = true; %[control:checkbox:30c5]{"position":[14,18]}
lambda = 10^-1 %[control:slider:3121]{"position":[13,15]}
eta = 10^-0.1 %[control:slider:4db4]{"position":[10,14]}
sgmuint8 = 10;  %[control:slider:8b85]{"position":[12,14]}
sgm = sgmuint8/255;
nlevels = 3;  %[control:slider:49ef]{"position":[11,12]}
niters = 80; %[control:slider:35e4]{"position":[10,12]}
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
%[text] - $\\mathbf{s}\\sim\\prod\_k\\mathcal{L}(\[\\mathbf{s}\]\_k;0,b)$
%[text] - $\\mathbf{w}\\sim\\mathcal{N}\\left(\\mathbf{w};\\mathbf{0},\\sigma\_\\mathrm{w}^2\\mathbf{I}\\right)$ \
v = imnoise(x,'gaussian',0,sgm^2);
%%
%[text] ## Undecimated Haar DWT
import msip.udhaarwtdec2
import msip.udhaarwtrec2
%[text] ### Check of the perfect reconstruction
%[text] The undecimated Haar DWT satisfies the Parseval tight property $\\mathbf{D}\\mathbf{D}^\\top=\\mathbf{I}$
%[text] ($\\kappa=\\|\\mathbf{D}\\|\_\\mathrm{S}^2=1$), and thus its adjoint (transposed) system is a PR analysis system.
[coefs,scales] = udhaarwtdec2(v,nlevels);
xr = udhaarwtrec2(coefs,scales);
assert(norm(v-xr,"fro")^2/numel(v)<1e-18,'Perfect reconstruction is violated.')
%[text] Definition of the synthesis dictionary and its adjoint
adjdic = @(x) udhaarwtdec2(x,nlevels); % D.' (analysis FB)
syndic = @(s) udhaarwtrec2(s,scales);  % D   (synthesis FB)
%%
%[text] ## Proximal gradient method (ISTA)
%[text] $\\mathbf{s}^{(t+1)}\\leftarrow\\phi\_\\mathrm{ST}\\left(\\mathbf{s}^{(t)}-\\eta\\mathbf{D}^\\top(\\mathbf{D}\\mathbf{s}^{(t)}-\\mathbf{v});\\eta\\lambda\\right)$
%[text] Initialization
sp = coefs;
%[text] Proximal gradient descent
if isaprxleft
    mask = ones(size(coefs));
    mask(1:prod(scales(1,:))) = 0;
    lambda = lambda * mask;
end
for idx = 0:niters-1
    % Proximal gradient descent
    sc = softthresh(sp-eta*adjdic(syndic(sp)-v),eta*lambda);
    % Update
    sp = sc;
end
%%
%[text] ## Denoised image
xhat = syndic(sc);
%%
%[text] ## Image show
fig3 = figure;
tl = tiledlayout(fig3,1,3,"TileSpacing","compact");
imshow(x,"Parent",nexttile(tl))
title("Original image $\mathbf{x}$","Interpreter","latex")
imshow(v,"Parent",nexttile(tl))
title("Noisy image $\mathbf{v}$: PSNR = " + sprintf("%5.2f",psnr(v,x)) + " dB","Interpreter","latex")
imshow(xhat,"Parent",nexttile(tl))
title("Denoised image $\hat{\mathbf{x}}$: PSNR = " + sprintf("%5.2f",psnr(xhat,x)) + " dB","Interpreter","latex")
%%
%[text] ## Wavelet image denoising function
%[text] Reference
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
%[control:slider:3bb1]
%   data: {"defaultValue":0.5,"label":"v","max":0.5,"min":-0.5,"run":"SectionToEnd","runOn":"ValueChanged","step":0.1}
%---
%[control:slider:42e7]
%   data: {"defaultValue":0.2,"label":"lambda","max":2,"min":0,"run":"AllSections","runOn":"ValueChanged","step":0.1}
%---
%[control:slider:39a6]
%   data: {"defaultValue":0.4,"label":"eta","max":1,"min":0.1,"run":"SectionToEnd","runOn":"ValueChanged","step":0.1}
%---
%[control:slider:7c83]
%   data: {"defaultValue":20,"label":"niters","max":100,"min":10,"run":"SectionToEnd","runOn":"ValueChanged","step":10}
%---
%[control:checkbox:30c5]
%   data: {"defaultValue":true,"label":"isaprxleft","run":"SectionToEnd"}
%---
%[control:slider:3121]
%   data: {"defaultValue":-0.8,"label":"log10(lambda)","max":2,"min":-4,"run":"SectionToEnd","runOn":"ValueChanged","step":0.1}
%---
%[control:slider:4db4]
%   data: {"defaultValue":-0.1,"label":"log10(eta)","max":2,"min":-4,"run":"SectionToEnd","runOn":"ValueChanged","step":0.1}
%---
%[control:slider:8b85]
%   data: {"defaultValue":10,"label":"sgmuint8","max":50,"min":0,"run":"SectionToEnd","runOn":"ValueChanged","step":10}
%---
%[control:slider:49ef]
%   data: {"defaultValue":3,"label":"nlevels","max":5,"min":1,"run":"SectionToEnd","runOn":"ValueChanged","step":1}
%---
%[control:slider:35e4]
%   data: {"defaultValue":80,"label":"niters","max":100,"min":10,"run":"SectionToEnd","runOn":"ValueChanged","step":10}
%---
