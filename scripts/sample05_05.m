%[text] # Sample 5-5: Multivariate convolution
%[text] Advanced Topics in Image Processing, Lecture 5 "Fourier Analysis"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Preparation of a sample image $(x\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}$
x = im2double(imread('cameraman.tif'));
figure
imshow(x)
title('Original')
%%
%[text] ## Impulse response $(h\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}$ of a linear shift-invariant system
ftype = "gaussian"; %[control:dropdown:20ca]{"position":[9,19]}
h = rot90(fspecial(ftype),2);
%%
%[text] ## Output $(y\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}$ of the linear shift-invariant system
%[text] Convolution
%[text]{"align":"center"} $(y\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}=(h\[\\boldsymbol{n}\])\_{\\boldsymbol{n}} \\ast (x\[\\boldsymbol{n}\])\_{\\boldsymbol{n}} = \\sum\_{\\boldsymbol{m}\\in\\Omega}x\[\\boldsymbol{m}\](h\[\\boldsymbol{n}-\\boldsymbol{m}\])\_{\\boldsymbol{n}}$
y = imfilter(x,h,'conv','full');
%%
%[text] ## Spectrum of the input signal $(x\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}$
%[text]{"align":"center"} $X\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)= \\sum\_{\\boldsymbol{n}\\in\\mathbb{Z}^2}x\[\\boldsymbol{n}\]\\mathrm{e}^{-\\mathrm{j}\\boldsymbol{\\omega}^\\top \\boldsymbol{n}},\\ \\boldsymbol{\\omega}\\in\\mathbb{R}^2$
%[text] Frequency sampling of the DSFT by the DFT (FFT)
%[text]{"align":"center"} $X\[\\boldsymbol{k}\] = \\left.X\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)\\right|\_{\\boldsymbol{\\omega}=2\\pi \\boldsymbol{N}^{-\\top}\\boldsymbol{k}},\\ \\boldsymbol{k}\\in\\mathcal{N}(\\boldsymbol{N}^\\top)$
%[text] The function `fftn` is used.
% Number of frequency sample points in [0,2pi)^2:
% the least power of two that makes the circular convolution agree with the linear one
nPoints = pow2(nextpow2(size(x)+size(h)-1));

% Spectrum of x[n]
X = fftn(x,nPoints);
%%
%[text] ## Frequency response of the filter $(h\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}$
%[text]{"align":"center"} $H\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)= \\sum\_{\\boldsymbol{n}\\in\\mathbb{Z}^2}h\[\\boldsymbol{n}\]\\mathrm{e}^{-\\mathrm{j}\\boldsymbol{\\omega}^\\top \\boldsymbol{n}},\\ \\boldsymbol{\\omega}\\in\\mathbb{R}^2$
H = fftn(h,nPoints);
%%
%[text] ## Spectrum of the output signal $(y\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}$
%[text]{"align":"center"} $Y\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)= \\sum\_{\\boldsymbol{n}\\in\\mathbb{Z}^2}y\[\\boldsymbol{n}\]\\mathrm{e}^{-\\mathrm{j}\\boldsymbol{\\omega}^\\top \\boldsymbol{n}},\\ \\boldsymbol{\\omega}\\in\\mathbb{R}^2$
Y = fftn(y,nPoints);
%%
%[text] ## Display of the spectra and the frequency response
%[text]{"align":"center"} $Y\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)=H\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)X\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)$
% Frequency sample points
[w2,w1] = meshgrid(-pi:2*pi/nPoints(2):pi-2*pi/nPoints(2),-pi:2*pi/nPoints(1):pi-2*pi/nPoints(1));
spectra = {X, H, Y};
names = ["X" "H" "Y"];
for idx = 1:3
    figure
    mesh(w2,w1,10*log10(abs(fftshift(spectra{idx}))))
    ax = gca;
    xlabel('\omega_2 [rad]')
    ylabel('\omega_1 [rad]')
    zlabel("Magnitude 10log_{10} |" + names(idx) + "(e^{j\omega^T})| [dB]")
    axis ij
    ax.XLim = [-pi pi];
    ax.XTick = [-pi 0 pi];
    ax.XTickLabel = {'-\pi', '0', '\pi'};
    ax.YLim = [-pi pi];
    ax.YTick = [-pi 0 pi];
    ax.YTickLabel = {'-\pi', '0', '\pi'};
    colorbar(ax)
end
%%
%[text] ## Analysis of the linear shift-invariant system
%[text] Display of the frequency response
%[text]{"align":"center"} $H\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)= \\left.H(\\boldsymbol{z})\\right|\_{\\boldsymbol{z}=\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}},\\ \\boldsymbol{\\omega}\\in \\mathbb{R}^2$
%[text] - Magnitude response: $|H\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)|$
%[text] - Phase response: $\\angle H\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)$ \
%[text] The function `freqz2` displays the bivariate magnitude response.
figure
freqz2(h)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:dropdown:20ca]
%   data: {"defaultValue":"\"gaussian\"","itemLabels":["average","disk","gaussian","log","laplacian","unsharp","prewitt","sobel"],"items":["\"average\"","\"disk\"","\"gaussian\"","\"log\"","\"laplacian\"","\"unsharp\"","\"prewitt\"","\"sobel\""],"label":"Filter type","run":"SectionToEnd"}
%---
