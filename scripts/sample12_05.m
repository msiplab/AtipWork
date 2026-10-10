%[text] # Sample 12-5: Primal-dual splitting (PDS)
%[text] Advanced Topics in Image Processing, Lecture 12 "Image Restoration"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Preparation
%[text] The Kodak images are downloaded to the data folder once.
datfolder = atip.prjfolders();
atip.download_img(false)
%%
%[text] ## Problem setting
%[text] $\\hat{\\mathbf{s}}=\\arg\\min\_{\\mathbf{s}}\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{H}\\mathbf{D}\\mathbf{s}\\|\_2^2+\\lambda\\|\\mathbf{s}\\|\_1,\\quad \\mathrm{s.t.}\\ \\mathbf{D}\\mathbf{s}\\in\\mathcal{C}$
%[text] Toy example with $\\mathbf{H}=1$ and $\\mathcal{C}=\[a,b\]$:
%[text] - $\\mathbf{D} = \\begin{pmatrix} \\frac{2}{3} & \\frac{1}{3}\\end{pmatrix}\\colon\\ \\mathbb{R}^2\\rightarrow\\mathbb{R}^1$
%[text] - $\\mathbf{v}=\\frac{1}{2}\\in\\mathbb{R}^1$
%[text] - $\\lambda\\in\[0,\\infty)$
%[text] - $\\mathbf{s}\\in\\mathbb{R}^2$
%[text] - $a,b\\in\\mathbb{R}$ \
D = [2 1]/3;
v = 0.5; %[control:slider:4281]{"position":[5,8]}
a =  -0.5;
b =   0.0;
%%
%[text] ### Function plot
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
%[text] ### Parameter settings
%[text] - lambda: regularization parameter $\\lambda$
%[text] - eta1: step size $\\eta\_1$ of the primal step
%[text] - niters: number of iterations \
lambda = 0.2; %[control:slider:555c]{"position":[10,13]}
eta1 = 0.4; %[control:slider:49ea]{"position":[8,11]}
niters = 20; %[control:slider:7d72]{"position":[10,12]}
%%
%[text] ## Approximation by the constrained $\\ell\_1$-norm regularized least squares method
%[text] $\\hat{\\mathbf{s}}=\\arg\\min\_{\\mathbf{s}}\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{D}\\mathbf{s}\\|\_2^2+\\lambda\\|\\mathbf{s}\\|\_1,\\quad \\mathbf{D}\\mathbf{s}\\in\[a,b\]$
%[text] It is reduced to the primal-dual splitting method for
%[text] $\\hat{\\mathbf{x}}=\\arg\\min\_{\\mathbf{x}} f(\\mathbf{x})+g(\\mathbf{x})+h(\\mathbf{L}\\mathbf{x})$
%[text] - $\\mathbf{L}\\in\\mathbb{R}^{M\\times N}$: linear operator
%[text] - $f(\\cdot)$: convex and differentiable, $\\nabla f$ is $\\kappa$-Lipschitz continuous
%[text] - $g(\\cdot)\\in\\Gamma\_0(\\mathbb{R}^N)$, $h(\\cdot)\\in\\Gamma\_0(\\mathbb{R}^M)$: proper, lower semicontinuous, convex functions \
%[text] Example
%[text] - $f(\\mathbf{s})=\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{D}\\mathbf{s}\\|\_2^2$
%[text] - $g(\\mathbf{s})=\\lambda\\|\\mathbf{s}\\|\_1$
%[text] - $h(\\mathbf{L}\\mathbf{s})=\\iota\_{\[a,b\]}(\\mathbf{D}\\mathbf{s})$ ($\\mathbf{L}=\\mathbf{D}$) \
%[text] Function plot
% Function setting
fg = @(s0,s1) 0.5*(v-(D(1)*s0+D(2)*s1)).^2 + lambda*(abs(s0)+abs(s1));
% Surfc plot of the cost function f+g
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
%[text] ### Primal-dual splitting method
%[text] 1. Initialization: $\\mathbf{x}^{(0)}$, $\\mathbf{y}^{(0)}$, $t\\leftarrow 0$
%[text] 2. Primal: $\\mathbf{x}^{(t+1)} \\leftarrow \\mathrm{prox}\_{\\eta\_{1} g}\\left(\\mathbf{x}^{(t)}-\\eta\_{1}\\left(\\nabla f\\left(\\mathbf{x}^{(t)}\\right)+\\mathbf{L}^\\top \\mathbf{y}^{(t)}\\right)\\right)$
%[text] 3. Dual: $\\mathbf{y}^{(t+1)}\\leftarrow \\mathrm{prox}\_{\\eta\_2h^\\ast}\\left(\\mathbf{y}^{(t)}+\\eta\_2\\mathbf{L}(2\\mathbf{x}^{(t+1)}-\\mathbf{x}^{(t)})\\right)$
%[text] 4. If a stopping criterion is satisfied then finish, otherwise $t\\leftarrow t+1$ and go to Step 2. \
%[text] Example
%[text] - $\\nabla f(\\mathbf{x})=\\mathbf{D}^\\top(\\mathbf{D}\\mathbf{x}-\\mathbf{v})$
%[text] - $\\mathrm{prox}\_{\\eta\\lambda\\|\\cdot\\|\_{1}}(\\mathbf{x})=\\phi\_\\mathrm{ST}(\\mathbf{x};\\eta\\lambda)=\\mathrm{sign}(\\mathbf{x})\\odot\\max(\\mathrm{abs}(\\mathbf{x})-\\eta\\lambda\\mathbf{1},\\mathbf{0})$
%[text] - $\\mathrm{prox}\_{\\eta\\iota\_{\\mathcal{C}}^\\ast}(\\mathbf{y})=\\mathbf{y}-\\eta\\,\\mathrm{proj}\_{\\mathcal{C}}(\\eta^{-1}\\mathbf{y})$ (Moreau identity) \
%[text] where $\\mathcal{C}=\[a,b\]^N$ and
%[text] $\\mathrm{proj}\_{\[a,b\]^N}(\\mathbf{x})=\\min(\\max(\\mathbf{x},a),b)$
%[text]
%[text] Soft thresholding
softthresh = @(u,t) sign(u).*max(abs(u)-t,0);
%[text] Initialization
sp = 2*rand(2,1)-1; % in [-1,1]^2
%[text] Setting of the step size $\\eta\_2$ from the condition $\\eta\_1^{-1}-\\eta\_2\\|\\mathbf{L}\\|\_\\mathrm{S}^2>\\kappa/2$
kappa = D*D';     % Lipschitz constant of the gradient of f
tau2 = D*D';      % squared spectral norm of L = D
eta2 = 1/(1.05*tau2)*(1/eta1-kappa/2);
assert((1/eta1 - eta2*tau2) > kappa/2,"Step size condition is violated.")
%[text] Primal-dual splitting method (the feasible set is shown on the bottom plane)
sf0 = -1:.01:1;
sf1 = -1:.01:1;
[Sf0,Sf1] = ndgrid(sf0,sf1);
ic = @(x1,x2) (D(1)*x1+D(2)*x2)>=a & (D(1)*x1+D(2)*x2)<=b;
C = repmat(ic(Sf0,Sf1),[1 1 3]);
hc = surf(sf0,sf1,zeros(size(C,1),size(C,2)),double(C));
hc.EdgeColor = 'interp';
hc.EdgeAlpha = 0.25;
hc.FaceAlpha = 0.25;
y = D*sp;
for idx = 0:niters-1
    % Previous state
    s(1,1) = sp(1); % s0
    s(2,1) = sp(2); % s1
    % Primal
    sg = sp-eta1*D'*((D*sp-v)+y);
    sc = softthresh(sg,eta1*lambda);
    % Dual
    u = y + eta2*D*(2*sc-sp);
    y = u - eta2*min(max(u/eta2,a),b);
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
%[text] ### Parameter settings
%[text] - lambda: regularization parameter $\\lambda$
%[text] - eta1: step size $\\eta\_1$ of the primal step
%[text] - sgmuint8: standard deviation $\\sigma\_\\mathrm{w}$ of the noise in the 8-bit scale
%[text] - niters: number of iterations \
lambda = 10^-2.4 %[control:slider:2e39]{"position":[13,17]}
eta1 = 10^-2.4 %[control:slider:18f4]{"position":[11,15]}
sgmuint8 = 10;  %[control:slider:629c]{"position":[12,14]}
sgm = sgmuint8/255;
niters = 80; %[control:slider:5c0b]{"position":[10,12]}
%%
%[text] ## Read image
x = im2gray(im2double(imread(fullfile(datfolder,"kodim23.png"))));
%%
%[text] ## Observation image
%[text] - $\\mathbf{v}=\\mathbf{H}\\mathbf{x}+\\mathbf{w}$
%[text] - $\\mathbf{w}\\sim\\mathcal{N}\\left(\\mathbf{w};\\mathbf{0},\\sigma\_\\mathrm{w}^2\\mathbf{I}\\right)$ \
% Definition of the measurement process H
psf = fspecial("motion",21,11);
measureproc = @(u) imfilter(u,psf,"conv","circular");
% Adjoint process H^T of the measurement process
measureadjp = @(u) imfilter(u,psf,"corr","circular");
% Simulation of AWGN
v = imnoise(measureproc(x),"gaussian",0,sgm^2);
%%
%[text] ## Total variation regularization
%[text] As an application of PDS, total variation (TV) regularization is applied to image restoration.
%[text] ### Problem setting
%[text] $\\hat{\\mathbf{x}}=\\arg\\min\_{\\mathbf{x}\\in\[0,1\]^{N}}\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{H}\\mathbf{x}\\|\_{2}^{2}+\\lambda\\|\\mathbf{x}\\|\_{\\mathrm{TV}}$
%[text] $\\Downarrow$
%[text] $\\hat{\\mathbf{x}}=\\arg\\min\_{\\mathbf{x}\\in\\mathbb{R}^{N}}\\frac{1}{2\\lambda}\\|\\mathbf{v}-\\mathbf{H}\\mathbf{x}\\|\_{2}^{2}+\\iota\_{\[0,1\]^{N}}(\\mathbf{x})+\\|\\mathbf{G}\\mathbf{x}\\|\_{1,2}$
%[text]
%[text] ### Algorithm
%[text] 1. Initialization: $\\mathbf{x}^{(0)}$, $\\mathbf{y}^{(0)}$, $t\\leftarrow 0$
%[text] 2. $\\mathbf{x}^{(t+1)}\\leftarrow\\mathrm{proj}\_{\[0,1\]^{N}}\\left(\\mathbf{x}^{(t)}-\\eta\_{1}\\left(\\lambda^{-1}\\mathbf{H}^\\top(\\mathbf{H}\\mathbf{x}^{(t)}-\\mathbf{v})+\\mathbf{G}^\\top\\mathbf{y}^{(t)}\\right)\\right)$
%[text] 3. $\\mathbf{y}^{(t+1)}\\leftarrow\\mathrm{prox}\_{\\eta\_{2}\\left(\\|\\cdot\\|\_{1,2}\\right)^{\*}}\\left(\\mathbf{y}^{(t)}+\\eta\_{2}\\mathbf{G}\\left(2\\mathbf{x}^{(t+1)}-\\mathbf{x}^{(t)}\\right)\\right)$
%[text] 4. If a stopping criterion is satisfied then finish, otherwise $t\\leftarrow t+1$ and go to Step 2. \
%[text] where
%[text] - $\\mathrm{prox}\_{\\eta\\|\\cdot\\|\_{1,2}^{\*}}(\\mathbf{u})=\\mathbf{u}-\\eta\\,\\mathrm{prox}\_{\\eta^{-1}\\|\\cdot\\|\_{1,2}}\\left(\\eta^{-1}\\mathbf{u}\\right)$
%[text] - $\\left\[\\eta\\,\\mathrm{prox}\_{\\eta^{-1}\\|\\cdot\\|\_{1,2}}\\left(\\eta^{-1}\\mathbf{u}\\right)\\right\]\_{\\mathcal{I}\_{\\boldsymbol{n}}}=\\left(1-1/\\|\\vec{u}\[\\boldsymbol{n}\]\\|\_{2}\\right)\_+\\vec{u}\[\\boldsymbol{n}\]$ (soft thresholding of the gradient magnitude $\\phi\_\\mathrm{MS}(\\cdot;1)$)
%[text] - $\\eta\_{1}^{-1}-\\eta\_{2}\\|\\mathbf{G}\\|\_\\mathrm{S}^{2}>\\|\\mathbf{H}\\|\_\\mathrm{S}^{2}/(2\\lambda)$ \
%[text] Gradient filters (backward differences)
g0 = [   0     1     0
         0    -1     0
         0     0     0 ]; % Vertical difference
g1 = rot90(g0);  % Horizontal difference
gradproc = @(u) cat(3,imfilter(u,g0,"conv","circ"),imfilter(u,g1,"conv","circ"));
gradadjp = @(u) imfilter(u(:,:,1),g0,"corr","circ") + imfilter(u(:,:,2),g1,"corr","circ");
%[text] Initialization
up = v;
yp = gradproc(v);
%[text] Setting of the step size $\\eta\_2$
nPoints = 2.^nextpow2(size(v));
kappa = max(abs(fftn(psf,nPoints)).^2,[],"all")/lambda;   % ||H||_S^2/lambda
tau2 = max(abs(fftn(g0,nPoints)).^2+abs(fftn(g1,nPoints)).^2,[],"all");  % ||G||_S^2
eta2 = 1/(1.05*tau2)*(1/eta1-kappa/2);
assert((1/eta1 - eta2*tau2) > kappa/2, ...
    "Step size condition is violated. eta1 must be less than " + num2str(2/kappa))
%[text] Primal-dual splitting method
for idx = 0:niters-1
    % Primal step
    ug = measureadjp(measureproc(up)-v);
    uc = min(max(up-eta1*(ug/lambda + gradadjp(yp)),0),1);
    % Dual step
    yt = yp + eta2*gradproc(2*uc - up);
    yc = yt - magshrink(yt); % MAGSHRINK is defined at the end of this script
    % Update
    up = uc;
    yp = yc;
end
%%
%[text] ## Restored image
y = uc;
%%
%[text] ## Image show
figure
imshow(x)
title("Original image x")
figure
imshow(v)
title("Blurred image v: PSNR = " + sprintf("%5.2f",psnr(v,x)) + " dB")
figure
imshow(y)
title("Restored image y by TV regularization: PSNR = " + sprintf("%5.2f",psnr(y,x)) + " dB")
%%
%[text] ## Magnitude soft thresholding
%[text] $\\phi\_\\mathrm{MS}(\\mathbf{u};1)$: soft thresholding of the gradient magnitude with threshold 1
function y = magshrink(x)
    Gv = x(:,:,1);
    Gh = x(:,:,2);
    Gmag = sqrt(Gv.^2+Gh.^2);
    map = max(1 - 1./Gmag,0);
    y = x.*map;
end
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:4281]
%   data: {"defaultValue":0.5,"label":"v","max":0.5,"min":-0.5,"run":"SectionToEnd","runOn":"ValueChanged","step":0.1}
%---
%[control:slider:555c]
%   data: {"defaultValue":0.2,"label":"lambda","max":2,"min":0,"run":"AllSections","runOn":"ValueChanged","step":0.1}
%---
%[control:slider:49ea]
%   data: {"defaultValue":0.4,"label":"eta1","max":1,"min":0.1,"run":"SectionToEnd","runOn":"ValueChanged","step":0.1}
%---
%[control:slider:7d72]
%   data: {"defaultValue":20,"label":"niters","max":100,"min":10,"run":"SectionToEnd","runOn":"ValueChanged","step":10}
%---
%[control:slider:2e39]
%   data: {"defaultValue":-2.4,"label":"log10(lambda)","max":2,"min":-4,"run":"AllSections","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:18f4]
%   data: {"defaultValue":-2.4,"label":"log10(eta1)","max":1,"min":-4,"run":"SectionToEnd","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:629c]
%   data: {"defaultValue":10,"label":"sgmuint8","max":50,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":10}
%---
%[control:slider:5c0b]
%   data: {"defaultValue":80,"label":"niters","max":100,"min":10,"run":"SectionToEnd","runOn":"ValueChanging","step":10}
%---
