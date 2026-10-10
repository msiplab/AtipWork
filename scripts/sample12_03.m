%[text] # Sample 12-3: Synthesis model (ISTA)
%[text] Advanced Topics in Image Processing, Lecture 12 "Image Restoration"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Preparation
%[text] The Kodak images are downloaded to the data folder once.
datfolder = atip.prjfolders();
atip.download_img(false)
%%
%[text] ## Parameter settings
%[text] - isaprxleft: the approximation (lowpass) coefficients are not thresholded
%[text] - lambda: regularization parameter $\\lambda$
%[text] - eta: step size $\\eta$
%[text] - sgmuint8: standard deviation $\\sigma\_\\mathrm{w}$ of the noise in the 8-bit scale
%[text] - nlevels: number of wavelet levels
%[text] - niters: number of iterations \
isaprxleft = true; %[control:checkbox:35e5]{"position":[14,18]}
lambda = 10^-0.1 %[control:slider:2d8d]{"position":[13,17]}
eta = 10^0.3 %[control:slider:975f]{"position":[10,13]}
sgmuint8 = 10;  %[control:slider:1f84]{"position":[12,14]}
sgm = sgmuint8/255;
nlevels = 3;  %[control:slider:9b0c]{"position":[11,12]}
niters = 80; %[control:slider:35e8]{"position":[10,12]}
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
%[text] ## Proximal gradient method (ISTA)
%[text] ### Problem setting
%[text] $\\hat{\\mathbf{s}}=\\arg\\min\_{\\mathbf{s}}\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{H}\\mathbf{D}\\mathbf{s}\\|\_2^2+\\lambda\\|\\mathbf{s}\\|\_1$
%[text] ### Algorithm
%[text] 1. Initialization: $\\mathbf{s}^{(0)}$, $t\\leftarrow 0$
%[text] 2. Proximal gradient descent: $\\mathbf{s}^{(t+1)}\\leftarrow \\mathrm{prox}\_{\\eta g}\\left( \\mathbf{s}^{(t)}-\\eta\\nabla f(\\mathbf{s}^{(t)})\\right)$
%[text] 3. If a stopping criterion is satisfied then finish, otherwise $t\\leftarrow t+1$ and go to Step 2. \
%[text] where
%[text] - $f(\\mathbf{s})=\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{H}\\mathbf{D}\\mathbf{s}\\|\_2^2$, $g(\\mathbf{s})=\\lambda\\|\\mathbf{s}\\|\_1$
%[text] - $\\nabla f(\\mathbf{s})=\\mathbf{D}^\\top\\mathbf{H}^\\top(\\mathbf{H}\\mathbf{D}\\mathbf{s}-\\mathbf{v})$
%[text] - $\\mathrm{prox}\_{\\eta\\lambda\\|\\cdot\\|\_{1}}(\\mathbf{s})=\\phi\_\\mathrm{ST}(\\mathbf{s};\\eta\\lambda)=\\mathrm{sign}(\\mathbf{s})\\odot\\max(\\mathrm{abs}(\\mathbf{s})-\\eta\\lambda\\mathbf{1},\\mathbf{0})$ \
%[text] Soft thresholding
softthresh = @(u,t) sign(u).*max(abs(u)-t,0);
%[text] Initialization
[coefs,scales] = udhaarwtdec2(v,nlevels);
sp = coefs;
%[text] Proximal gradient descent
%[text] - $\\eta\<2/\\kappa$: step size
%[text] - $\\kappa$: Lipschitz constant of $\\nabla f$, $\\kappa=\\|\\mathbf{H}\\mathbf{D}\\|\_\\mathrm{S}^2=(\\sigma\_{\\max}(\\mathbf{H}\\mathbf{D}))^2=\\|\\mathbf{H}\\|\_\\mathrm{S}^2=\\max\_{\\boldsymbol{k}}|\\tilde{h}\[\\boldsymbol{k}\]|^2$ \
kappa = max(abs(fftn(psf,2.^nextpow2(size(v)))).^2,[],"all");
assert(eta < 2/kappa,"Step size condition is violated.")
if isaprxleft
    mask = ones(size(coefs));
    mask(1:prod(scales(1,:))) = 0;
    lambda = lambda * mask;
end
for idx = 0:niters-1
    % Proximal gradient descent
    sg = adjdic(measureadjp(measureproc(syndic(sp))-v));
    sc = softthresh(sp-eta*sg,eta*lambda);
    % Update
    sp = sc;
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
title("Restored image y by ISTA: PSNR = " + sprintf("%5.2f",psnr(y,x)) + " dB")
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:checkbox:35e5]
%   data: {"defaultValue":true,"label":"isaprxleft","run":"SectionToEnd"}
%---
%[control:slider:2d8d]
%   data: {"defaultValue":-0.1,"label":"log10(lambda)","max":2,"min":-4,"run":"SectionToEnd","runOn":"ValueChanged","step":0.1}
%---
%[control:slider:975f]
%   data: {"defaultValue":0.3,"label":"log10(eta)","max":2,"min":-4,"run":"SectionToEnd","runOn":"ValueChanged","step":0.1}
%---
%[control:slider:1f84]
%   data: {"defaultValue":10,"label":"sgmuint8","max":50,"min":0,"run":"SectionToEnd","runOn":"ValueChanged","step":10}
%---
%[control:slider:9b0c]
%   data: {"defaultValue":3,"label":"nlevels","max":5,"min":1,"run":"SectionToEnd","runOn":"ValueChanged","step":1}
%---
%[control:slider:35e8]
%   data: {"defaultValue":80,"label":"niters","max":100,"min":10,"run":"SectionToEnd","runOn":"ValueChanged","step":10}
%---
