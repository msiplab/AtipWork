%[text] # Sample 12-1: Wiener filter
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
%[text] - sgmuint8: standard deviation $\\sigma\_\\mathrm{w}$ of the noise in the 8-bit scale \
sgmuint8 = 10;  %[control:slider:14e2]{"position":[12,14]}
sgmw = sgmuint8/255;
%%
%[text] ## Read image
x = im2gray(im2double(imread(fullfile(datfolder,"kodim23.png"))));
sgmx = std(x(:));
%%
%[text] ## Observation image
%[text] Generate a blurred image that might result from camera motion.
%[text] - $\\mathbf{v}=\\mathbf{H}\\mathbf{x}+\\mathbf{w}$
%[text] - $\\mathbf{w}\\sim\\mathcal{N}\\left(\\mathbf{w};\\mathbf{0},\\sigma\_\\mathrm{w}^2\\mathbf{I}\\right)$ \
% Definition of the measurement process H (circular convolution with the PSF)
psf = fspecial("motion",31,21);
measureproc = @(u) imfilter(u,psf,"conv","circular");
% Simulation of AWGN
v = imnoise(measureproc(x),"gaussian",0,sgmw^2);
%%
%[text] ## Wiener filter
%[text] Assumption on the original image $\\mathbf{x}$ (white, zero mean)
%[text] - $\\mathbf{x}\\sim\\mathcal{N}\\left(\\mathbf{x};\\mathbf{0},\\sigma\_\\mathrm{x}^2\\mathbf{I}\\right)$ \
%[text] ### Problem setting
%[text] $\\hat{\\mathbf{x}}=\\arg\\min\_{\\mathbf{x}}\\frac{1}{2\\sigma\_\\mathrm{w}^2}\\|\\mathbf{v}-\\mathbf{H}\\mathbf{x}\\|\_2^2+\\frac{1}{2\\sigma\_\\mathrm{x}^2}\\|\\mathbf{x}\\|\_2^2$
%[text] ### Solution
%[text] $\\hat{\\mathbf{x}}=\\left(\\mathbf{H}^\\top\\mathbf{H}+\\frac{\\sigma\_\\mathrm{w}^2}{\\sigma\_\\mathrm{x}^2}\\mathbf{I}\\right)^{-1}\\mathbf{H}^\\top\\mathbf{v}\\stackrel{\\mathrm{DFT}}{\\longleftrightarrow}\\tilde{\\hat{x}}\[\\boldsymbol{k}\]=\\frac{\\overline{\\tilde{h}\[\\boldsymbol{k}\]}}{|\\tilde{h}\[\\boldsymbol{k}\]|^2+\\sigma\_\\mathrm{w}^2/\\sigma\_\\mathrm{x}^2}\\tilde{v}\[\\boldsymbol{k}\]$
%[text] where, for the circular convolution matrix $\\mathbf{H}$ with the impulse response $h\[\\boldsymbol{n}\]$,
%[text] - $\\mathbf{H}^\\top\\stackrel{\\mathrm{DFT}}{\\longleftrightarrow}\\overline{\\tilde{h}\[\\boldsymbol{k}\]}$
%[text] - $\\mathbf{H}^\\top\\mathbf{H}\\stackrel{\\mathrm{DFT}}{\\longleftrightarrow}\\overline{\\tilde{h}\[\\boldsymbol{k}\]}\\tilde{h}\[\\boldsymbol{k}\]=|\\tilde{h}\[\\boldsymbol{k}\]|^2$ \
% Number of DFT points
nPoints = size(x); % 2.^nextpow2(size(x))
% Ratio of the variances of the noise w and the signal x (ideal estimation)
nsr = sgmw^2/sgmx^2;
% DFT (OTF) of the PSF, where the phase response is adjusted to zero
Ht = psf2otf(psf,nPoints);
% DFT of the observation v
Vt = fftn(v,nPoints);
% DFT of the Wiener filter r
Rt = conj(Ht)./(abs(Ht).^2+nsr);
% IDFT of the filtered spectrum
y0 = real(ifftn(Rt.*Vt));
y0 = y0(1:size(x,1),1:size(x,2));
%%
%[text] ## Inverse filter
%[text] $\\check{\\mathbf{x}}=\\left(\\mathbf{H}^\\top\\mathbf{H}\\right)^{-1}\\mathbf{H}^\\top\\mathbf{v}=\\mathbf{H}^{-1}\\mathbf{v}\\stackrel{\\mathrm{DFT}}{\\longleftrightarrow}\\tilde{\\check{x}}\[\\boldsymbol{k}\]=\\frac{\\overline{\\tilde{h}\[\\boldsymbol{k}\]}}{|\\tilde{h}\[\\boldsymbol{k}\]|^2}\\tilde{v}\[\\boldsymbol{k}\]=\\frac{1}{\\tilde{h}\[\\boldsymbol{k}\]}\\tilde{v}\[\\boldsymbol{k}\]$
%[text] This is the Wiener filter with $\\sigma\_\\mathrm{w}^2=0$.
% IDFT of the filtered spectrum
y1 = real(ifftn(Vt./Ht));
y1 = y1(1:size(x,1),1:size(x,2));
%%
%[text] ## Image show
figure
imshow(x)
title("Original image x")
figure
imshow(v)
title("Blurred image v: PSNR = " + sprintf("%5.2f",psnr(v,x)) + " dB")
figure
imshow(y0)
title("Restored image y0 by the Wiener filter: PSNR = " + sprintf("%5.2f",psnr(y0,x)) + " dB")
figure
imshow(y1)
title("Restored image y1 by the inverse filter: PSNR = " + sprintf("%5.2f",psnr(y1,x)) + " dB")
%%
%[text] ## Wiener filter function
%[text] `deconvwnr` gives the same result.
y2 = deconvwnr(v,psf,nsr);
figure
imshow(y2)
title("Restored image y2 by deconvwnr: PSNR = " + sprintf("%5.2f",psnr(y2,x)) + " dB")
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:14e2]
%   data: {"defaultValue":10,"label":"sgmuint8","max":50,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":10}
%---
