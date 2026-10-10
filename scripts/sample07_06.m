%[text] # Sample 7-6: Image registration (phase-only correlation)
%[text] Advanced Topics in Image Processing, Lecture 7 "Geometric Image Processing"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Image input
% Reading an image
fixed = imread('westconcordorthophoto.png');
%[text] Generation of a shifted image
% Setting the amount of movement
mx = -8; %[control:slider:24e3]{"position":[6,8]}
my = 8; %[control:slider:57f1]{"position":[6,7]}

% (Circularly) shifting the image
moving = circshift(fixed,[my mx]);

% Show the images
fig1 = figure;
tl1 = tiledlayout(fig1, 1, 2, 'TileSpacing', 'compact');
ax = nexttile(tl1);
imshow(fixed, 'Parent', ax)
title(ax, 'Fixed')
ax = nexttile(tl1);
imshow(moving, 'Parent', ax)
title(ax, 'Moving')

% Show the difference of the images
fig2 = figure;
imshowpair(moving, fixed, 'Parent', axes(fig2))
%%
%[text] ## Phase-only correlation
%[text] Detects the displacement between two images from their phase characteristics.
%[text]{"align":"center"} $\\mathrm{POC}(\\mathsf{x},\\mathsf{y})=\\mathrm{IDFT}\\left(\\frac{X\[\\boldsymbol{k}\]\\overline{Y\[\\boldsymbol{k}\]}}{|X\[\\boldsymbol{k}\]\\overline{Y\[\\boldsymbol{k}\]}|}\\right)=\\mathrm{IDFT}\\left(\\mathrm{e}^{\\mathrm{j}(\\angle X\[\\boldsymbol{k}\]-\\angle Y\[\\boldsymbol{k}\])}\\right)$
%[text] Reference
%[text] - [http://www.aoki.ecei.tohoku.ac.jp/~ito/vol1\_030.pdf](http://www.aoki.ecei.tohoku.ac.jp/~ito/vol1_030.pdf) \
% Definition of POC in the frequency domain
nPoints = pow2(nextpow2(size(fixed)));
frqPoc = @(x,y) exp(1j*(angle(fftn(x,nPoints))-angle(fftn(y,nPoints))));

% POC evaluation between two images
poc = abs(ifftn(frqPoc(moving,fixed)));

% POC result
[n1,n2] = ndgrid(0:nPoints(1)-1,0:nPoints(2)-1);
fig3 = figure;
ax = axes(fig3);
mesh(ax, n2, n1, poc)
xlabel(ax, 'n_2')
ylabel(ax, 'n_1')
axis(ax, 'ij')
ax.XLim = [0 nPoints(2)-1];
ax.YLim = [0 nPoints(1)-1];
%[text] POC with a band limitation for denoising
szRect = nPoints/4;
frqMask = zeros(nPoints);
frqMask(1:szRect(1),1:szRect(2)) = 1;
frqMask = circshift(frqMask,-ceil(szRect/2));

% POC evaluation between two images with the band limitation
poc = abs(ifftn(frqMask.*frqPoc(moving,fixed)));

% POC result with the band limitation
fig4 = figure;
ax = axes(fig4);
mesh(ax, n2, n1, poc)
xlabel(ax, 'n_2')
ylabel(ax, 'n_1')
axis(ax, 'ij')
ax.XLim = [0 nPoints(2)-1];
ax.YLim = [0 nPoints(1)-1];
%%
%[text] ## Peak detection
% Find the peak (zero-based indices)
[~,loc] = max(poc(:));
[py,px] = ind2sub(nPoints,loc);
py = py - 1;
px = px - 1;

% Take the negative shifts into account
py = mod(py+nPoints(1)/2,nPoints(1))-nPoints(1)/2;
px = mod(px+nPoints(2)/2,nPoints(2))-nPoints(2)/2;
disp("The peak location is [px, py] = [" + px + " " + py + "]")
%%
%[text] ## Image registration
%[text] Registration of two misaligned images.
% Actual moving image
moving = rgb2gray(imread('westconcordaerial.png'));

% Show the images
fig5 = figure;
tl5 = tiledlayout(fig5, 1, 2, 'TileSpacing', 'compact');
ax = nexttile(tl5);
imshow(fixed, 'Parent', ax)
title(ax, 'Fixed')
ax = nexttile(tl5);
imshow(moving, 'Parent', ax)
title(ax, 'Moving')

% Show the difference of the images
fig6 = figure;
imshowpair(moving, fixed, 'Parent', axes(fig6))
%[text] Estimation of the geometric transformation with phase correlation
tformEstimate = imregcorr(moving,fixed)
%[text] Spatial referencing of the fixed image
Rfixed = imref2d(size(fixed));
%[text] Registration
movingReg = imwarp(moving,tformEstimate,'OutputView',Rfixed);
%[text] Display of the result
fig7 = figure;
imshowpair(fixed, movingReg, 'Parent', axes(fig7))
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:24e3]
%   data: {"defaultValue":-8,"label":"mx","max":16,"min":-16,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:57f1]
%   data: {"defaultValue":8,"label":"my","max":16,"min":-16,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
