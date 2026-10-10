%[text] # Sample 12-4: Fast ISTA (FISTA)
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
%[text] $\\hat{\\mathbf{s}}=\\arg\\min\_{\\mathbf{s}}\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{H}\\mathbf{D}\\mathbf{s}\\|\_2^2+\\lambda\\|\\mathbf{s}\\|\_1$
%[text] Toy example with $\\mathbf{H}=1$:
%[text] - $\\mathbf{D} = \\begin{pmatrix} \\frac{2}{3} & \\frac{1}{3}\\end{pmatrix}\\colon\\ \\mathbb{R}^2\\rightarrow\\mathbb{R}^1$
%[text] - $\\mathbf{v}=\\frac{1}{2}\\in\\mathbb{R}^1$
%[text] - $\\lambda\\in\[0,\\infty)$
%[text] - $\\mathbf{s}\\in\\mathbb{R}^2$ \
D = [2 1]/3;
v = 0.5; %[control:slider:76ac]{"position":[5,8]}
%%
%[text] ### Function plot
% Function settings
f = @(s0,s1) 0.5*(v-(D(1)*s0+D(2)*s1)).^2;
g = @(s0,s1) (abs(s0)+abs(s1));
% Variable settings
s0 = linspace(-1,1,20);
s1 = linspace(-1,1,20);
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
%[text] - eta: step size $\\eta$
%[text] - niters: number of iterations \
lambda = 0.2; %[control:slider:7ece]{"position":[10,13]}
eta = 0.4; %[control:slider:388b]{"position":[7,10]}
niters = 20; %[control:slider:5b0d]{"position":[10,12]}
%%
%[text] ## Approximation by the $\\ell\_1$-norm regularized least squares method
%[text] $\\hat{\\mathbf{s}}=\\arg\\min\_{\\mathbf{s}}\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{D}\\mathbf{s}\\|\_2^2+\\lambda\\|\\mathbf{s}\\|\_1$
%[text] It is reduced to the proximal gradient method for
%[text] $\\hat{\\mathbf{x}}=\\arg\\min\_{\\mathbf{x}} f(\\mathbf{x})+g(\\mathbf{x})$
%[text] - $f(\\cdot)$: convex and differentiable, $\\nabla f$ is $\\kappa$-Lipschitz continuous
%[text] - $g(\\cdot)\\in\\Gamma\_0(\\mathbb{R}^L)$: proper, lower semicontinuous, convex function \
%[text] Example
%[text] - $f(\\mathbf{s})=\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{D}\\mathbf{s}\\|\_2^2$
%[text] - $g(\\mathbf{s})=\\lambda\\|\\mathbf{s}\\|\_1$ \
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
%[text] ### Nesterov's acceleration
%[text] 1. Initialization: $\\mathbf{y}^{(0)}=\\mathbf{x}^{(0)}$, $a^{(0)}=1$, $t\\leftarrow 0$
%[text] 2. Proximal gradient descent: $\\mathbf{x}^{(t+1)}\\leftarrow \\mathrm{prox}\_{\\eta g}\\left( \\mathbf{y}^{(t)}-\\eta\\nabla f(\\mathbf{y}^{(t)})\\right)$
%[text] 3. $a^{(t+1)}\\leftarrow\\frac{1+\\sqrt{1+4(a^{(t)})^2}}{2}$
%[text] 4. $\\mathbf{y}^{(t+1)}\\leftarrow\\mathbf{x}^{(t+1)}+\\frac{a^{(t)}-1}{a^{(t+1)}}(\\mathbf{x}^{(t+1)}-\\mathbf{x}^{(t)})$
%[text] 5. If a stopping criterion is satisfied then finish, otherwise $t\\leftarrow t+1$ and go to Step 2. \
%[text] Example
%[text] - $\\nabla f(\\mathbf{s})=\\mathbf{D}^\\top(\\mathbf{D}\\mathbf{s}-\\mathbf{v})$
%[text] - $\\mathrm{prox}\_{\\eta\\lambda\\|\\cdot\\|\_{1}}(\\mathbf{s})=\\phi\_\\mathrm{ST}(\\mathbf{s};\\eta\\lambda)=\\mathrm{sign}(\\mathbf{s})\\odot\\max(\\mathrm{abs}(\\mathbf{s})-\\eta\\lambda\\mathbf{1},\\mathbf{0})$ \
%[text] Soft thresholding
softthresh = @(u,t) sign(u).*max(abs(u)-t,0);
%[text] Initialization
sp0 = 2*rand(2,1)-1; % in [-1,1]^2
%[text] Proximal gradient descent without (red) and with (blue) the acceleration.
%[text] The step size of FISTA must satisfy $\\eta\\in(0,1/\\kappa\]$, where $\\kappa=\\|\\mathbf{D}\\|\_\\mathrm{S}^2$.
kappa = D*D';
assert(eta <= 1/kappa,"Step size condition is violated.")
for isaxel = [ false, true ]
    ac = 1;
    sp = sp0;
    z = sp0;
    for idx = 1:niters
        % Previous state
        s(1,1) = sp(1); % s0
        s(2,1) = sp(2); % s1
        % Proximal gradient descent
        sc = softthresh(z-eta*D'*(D*z-v),eta*lambda);
        %
        if isaxel
            an = (1+sqrt(1+4*ac^2))/2;
        else
            an = 1;
        end
        %
        z = sc + (ac-1)/an*(sc-sp);
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
        if isaxel
            hp.MarkerEdgeColor = 'b';
            hp.Color = 'b';
        else
            hp.MarkerEdgeColor = 'r';
            hp.Color = 'r';
        end
        hp.LineWidth = 2;
        % Update
        sp = sc;
        ac = an;
    end
end
hold off
%%
%[text] ### Parameter settings
%[text] - isaprxleft: the approximation (lowpass) coefficients are not thresholded
%[text] - lambda: regularization parameter $\\lambda$
%[text] - eta: step size $\\eta$ (FISTA: $\\eta\\leq 1/\\kappa=1$)
%[text] - sgmuint8: standard deviation $\\sigma\_\\mathrm{w}$ of the noise in the 8-bit scale
%[text] - nlevels: number of wavelet levels
%[text] - niters: number of iterations \
isaprxleft = true; %[control:checkbox:00b4]{"position":[14,18]}
lambda = 10^-1 %[control:slider:1dd9]{"position":[13,15]}
eta = 10^0 %[control:slider:43d3]{"position":[10,11]}
sgmuint8 = 10;  %[control:slider:7c42]{"position":[12,14]}
sgm = sgmuint8/255;
nlevels = 3;  %[control:slider:434d]{"position":[11,12]}
niters = 40; %[control:slider:0dbf]{"position":[10,12]}
%%
%[text] ## Read image
x = im2gray(im2double(imread(fullfile(datfolder,"kodim23.png"))));
%%
%[text] ## Observation image
%[text] - $\\mathbf{v}=\\mathbf{H}\\mathbf{x}+\\mathbf{w}$
%[text] - $\\mathbf{x}=\\mathbf{D}\\mathbf{s}$
%[text] - $\\mathbf{w}\\sim\\mathcal{N}\\left(\\mathbf{w};\\mathbf{0},\\sigma\_\\mathrm{w}^2\\mathbf{I}\\right)$ \
% Definition of the measurement process H
psf = fspecial("motion",21,11);
measureproc = @(u) imfilter(u,psf,"conv","circular");
% Adjoint process H^T of the measurement process
measureadjp = @(u) imfilter(u,psf,"corr","circular");
% Simulation of AWGN
v = imnoise(measureproc(x),"gaussian",0,sgm^2);
%%
%[text] ## Undecimated Haar DWT
import msip.udhaarwtdec2
import msip.udhaarwtrec2
%[text] ### Check of the perfect reconstruction
%[text] The undecimated Haar DWT satisfies the Parseval tight property
%[text] $\\mathbf{D}\\mathbf{D}^\\top=\\mathbf{I}$,
%[text] and thus its transposed system $\\mathbf{D}^\\top$ can be a perfect-reconstruction analysis system.
[coefs,scales] = udhaarwtdec2(v,nlevels);
r = udhaarwtrec2(coefs,scales);
assert(norm(v-r,"fro")^2/numel(v)<1e-18,"Perfect reconstruction is violated.")
%[text] Definition of the synthesis dictionary and its adjoint
adjdic = @(u) udhaarwtdec2(u,nlevels); % D^T
syndic = @(s) udhaarwtrec2(s,scales);  % D
%%
%[text] ## Fast ISTA
%[text] ### Problem setting
%[text] $\\hat{\\mathbf{s}}=\\arg\\min\_{\\mathbf{s}}\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{H}\\mathbf{D}\\mathbf{s}\\|\_2^2+\\lambda\\|\\mathbf{s}\\|\_1$
%[text] ### Algorithm
%[text] 1. Initialization: $\\mathbf{y}^{(0)}=\\mathbf{s}^{(0)}$, $a^{(0)}=1$, $t\\leftarrow 0$
%[text] 2. $\\mathbf{s}^{(t+1)}\\leftarrow \\mathrm{prox}\_{\\eta g}\\left( \\mathbf{y}^{(t)}-\\eta\\nabla f(\\mathbf{y}^{(t)})\\right)$
%[text] 3. $a^{(t+1)}\\leftarrow\\frac{1+\\sqrt{1+4(a^{(t)})^2}}{2}$
%[text] 4. $\\mathbf{y}^{(t+1)}\\leftarrow \\mathbf{s}^{(t+1)}+\\frac{a^{(t)}-1}{a^{(t+1)}}(\\mathbf{s}^{(t+1)}-\\mathbf{s}^{(t)})$
%[text] 5. If a stopping criterion is satisfied then finish, otherwise $t\\leftarrow t+1$ and go to Step 2. \
%[text] where
%[text] - $\\nabla f(\\mathbf{s})=\\mathbf{D}^\\top\\mathbf{H}^\\top(\\mathbf{H}\\mathbf{D}\\mathbf{s}-\\mathbf{v})$
%[text] - $\\mathrm{prox}\_{\\eta\\lambda\\|\\cdot\\|\_{1}}(\\mathbf{s})=\\phi\_\\mathrm{ST}(\\mathbf{s};\\eta\\lambda)=\\mathrm{sign}(\\mathbf{s})\\odot\\max(\\mathrm{abs}(\\mathbf{s})-\\eta\\lambda\\mathbf{1},\\mathbf{0})$ \
%[text] Soft thresholding
softthresh = @(u,t) sign(u).*max(abs(u)-t,0);
%[text] Initialization
[coefs,scales] = udhaarwtdec2(v,nlevels);
sp = coefs;
%[text] Proximal gradient descent with Nesterov's acceleration
%[text] - $\\eta\\leq1/\\kappa$: step size of FISTA
%[text] - $\\kappa$: Lipschitz constant of $\\nabla f$, $\\kappa=\\|\\mathbf{H}\\mathbf{D}\\|\_\\mathrm{S}^2=(\\sigma\_{\\max}(\\mathbf{H}\\mathbf{D}))^2=\\max\_{\\boldsymbol{k}}|\\tilde{h}\[\\boldsymbol{k}\]|^2$ \
kappa = max(abs(fftn(psf,2.^nextpow2(size(v)))).^2,[],"all");
assert(eta <= 1/kappa,"Step size condition is violated.")
if isaprxleft
    mask = ones(size(coefs));
    mask(1:prod(scales(1,:))) = 0;
    lambda = lambda * mask;
end
yc = sp;
ac = 1;
for idx = 1:niters
    % Proximal gradient descent
    sg = adjdic(measureadjp(measureproc(syndic(yc))-v));
    sc = softthresh(yc-eta*sg,eta*lambda);
    an = (1+sqrt(1+4*ac^2))/2;
    yc = sc + ((ac-1)/an)*(sc-sp);
    % Update
    sp = sc;
    ac = an;
end
%%
%[text] ## Restored image
y = syndic(sc);
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
title("Restored image y by FISTA: PSNR = " + sprintf("%5.2f",psnr(y,x)) + " dB")
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:76ac]
%   data: {"defaultValue":0.5,"label":"v","max":0.5,"min":-0.5,"run":"SectionToEnd","runOn":"ValueChanged","step":0.1}
%---
%[control:slider:7ece]
%   data: {"defaultValue":0.2,"label":"lambda","max":2,"min":0,"run":"AllSections","runOn":"ValueChanged","step":0.1}
%---
%[control:slider:388b]
%   data: {"defaultValue":0.4,"label":"eta","max":1,"min":0.1,"run":"SectionToEnd","runOn":"ValueChanged","step":0.1}
%---
%[control:slider:5b0d]
%   data: {"defaultValue":20,"label":"niters","max":100,"min":10,"run":"SectionToEnd","runOn":"ValueChanged","step":10}
%---
%[control:checkbox:00b4]
%   data: {"defaultValue":true,"label":"isaprxleft","run":"SectionToEnd"}
%---
%[control:slider:1dd9]
%   data: {"defaultValue":-1,"label":"log10(lambda)","max":2,"min":-4,"run":"SectionToEnd","runOn":"ValueChanged","step":0.1}
%---
%[control:slider:43d3]
%   data: {"defaultValue":0,"label":"log10(eta)","max":0,"min":-4,"run":"SectionToEnd","runOn":"ValueChanged","step":0.1}
%---
%[control:slider:7c42]
%   data: {"defaultValue":10,"label":"sgmuint8","max":50,"min":0,"run":"SectionToEnd","runOn":"ValueChanged","step":10}
%---
%[control:slider:434d]
%   data: {"defaultValue":3,"label":"nlevels","max":5,"min":1,"run":"SectionToEnd","runOn":"ValueChanged","step":1}
%---
%[control:slider:0dbf]
%   data: {"defaultValue":40,"label":"niters","max":100,"min":10,"run":"SectionToEnd","runOn":"ValueChanged","step":10}
%---
