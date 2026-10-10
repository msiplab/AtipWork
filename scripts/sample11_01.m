%[text] # Sample 11-1: Additive white Gaussian noise
%[text] Advanced Topics in Image Processing, Lecture 11 "Image Denoising"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Preparation
[datfolder,~] = atip.prjfolders();
atip.download_img(false)
%%
%[text] ## Image generation
%[text] - $\\mathbf{x}\\in\\mathbb{R}^N$: original image \
% Original image x
x = 0.75*ones(128);
x(24:128-24,24:128-24) = 0.5;
x(48:128-48,48:128-48) = 0.25;

fig1 = figure;
imshow(x,"Parent",axes(fig1))
title("Original")
fig2 = figure;
ax = axes(fig2);
imhist(x)
title(ax,"Histogram of the original")
ax.YLim = [0 12000];
%%
%[text] ## White Gaussian noise
%[text] The noise is assumed to be random numbers drawn from a Gaussian (normal) distribution.
%[text] - $\\mathbf{w}\\sim\\mathcal{N}(\\mathbf{w};\\boldsymbol{\\mu}\_\\mathrm{w},\\boldsymbol{\\Sigma}\_\\mathrm{w})$: noise
%[text] - $\\mathcal{N}(\\mathbf{w};\\boldsymbol{\\mu},\\boldsymbol{\\Sigma})=\\frac{1}{\\sqrt{(2\\pi)^N|\\boldsymbol{\\Sigma}|}} \\exp \\left(-\\frac{1}{2}(\\mathbf{w}-\\boldsymbol{\\mu})^\\top\\boldsymbol{\\Sigma}^{-1}(\\mathbf{w}-\\boldsymbol{\\mu})\\right), \\quad \\mathbf{w} \\in \\mathbb{R}^{N}$ \
%[text] "White" means zero mean and independent and identically distributed (i.i.d.) components:
%[text] - $\\boldsymbol{\\mu}\_\\mathrm{w}=\\mathbf{0}$
%[text] - $\\boldsymbol{\\Sigma}\_\\mathrm{w} = \\sigma\_\\mathrm{w}^2\\mathbf{I}$ \
%[text] Change the exponent of $\\sigma\_\\mathrm{w}^2$ with the slider.
% Gaussian parameters
muw = 0;
sgmw2 = 10^-3; %[control:slider:559c]{"position":[12,14]}
sgmw  = sqrt(sgmw2);

% Gaussian distribution
wgrid = linspace(-4*sgmw,4*sgmw,1001);
wpdf = normpdf(wgrid,muw,sgmw);
fig3 = figure;
ax = axes(fig3);
plot(ax,wgrid,wpdf)
xlabel(ax,"$w$","Interpreter","latex")
title(ax,"Gaussian distribution")
grid(ax,"on")
%[text] Pseudo-random number generation
% Additive white Gaussian noise
w = sgmw*randn(size(x));
fig4 = figure;
ax = axes(fig4);
histogram(ax,w(:))
title(ax,"Histogram of the Gaussian noise")
ax.XLim = [-4*sgmw 4*sgmw];
%%
%[text] ## Observed image
%[text] Simulation of the degradation by additive white Gaussian noise
%[text] - $\\mathbf{v}=\\mathbf{x}+\\mathbf{w}\\in\\mathbb{R}^N$: observed image \
% Noisy observation
v = x + w;
fig5 = figure;
imshow(v,"Parent",axes(fig5))
title("Observation")
fig6 = figure;
ax = axes(fig6);
imhist(v)
title(ax,"Histogram of the observation")
ax.YLim = [0 600];
%%
%[text] ## Generation of a noisy image
%[text] The function `imnoise` can be used.  Example of adding additive white Gaussian noise (AWGN):
X = rgb2gray(imread(fullfile(datfolder,"kodim23.png")));
V = imnoise(X,"gaussian",muw,sgmw2);
fig7 = figure;
tl = tiledlayout(fig7,2,2,"TileSpacing","compact");
imshow(X,"Parent",nexttile(tl))
title("Original")
imshow(V,"Parent",nexttile(tl))
title("Noisy")
[cnt,bins] = imhist(X);
ax = nexttile(tl);
bar(ax,bins,cnt,1,"EdgeColor","none")
xlim(ax,[0 255])
title(ax,"Histogram of the original")
[cnt,bins] = imhist(V);
ax = nexttile(tl);
bar(ax,bins,cnt,1,"EdgeColor","none")
xlim(ax,[0 255])
title(ax,"Histogram of the noisy image")
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:559c]
%   data: {"defaultValue":-3,"label":"log10(sgmw2)","max":0,"min":-4,"run":"SectionToEnd","runOn":"ValueChanging","step":0.1}
%---
