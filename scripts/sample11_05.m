%[text] # Sample 11-5: Prior distribution and wavelet shrinkage
%[text] Advanced Topics in Image Processing, Lecture 11 "Image Denoising"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Preparation
[datfolder,~] = atip.prjfolders();
atip.download_img(false)
%%
%[text] ## Parameter settings
%[text] - nlevels: number of wavelet levels \
% Parameter settings
nlevels = 3;  %[control:slider:55e2]{"position":[11,12]}
%%
%[text] ## Read image
%[text] Change the image (kodim01, ..., kodim24) and check the histograms of the coefficients.
img = "kodim23";
x = im2double(imread(fullfile(datfolder,img + ".png")));
if size(x,3) == 3
    x = rgb2gray(x);
end
%%
%[text] ## Analysis process
%[text] An orthonormal wavelet transform (Symlet) is used.  Without the Wavelet Toolbox, the filters
%[text] stored in the data folder and `msip.ezwavedec2`/`msip.ezwaverec2` are used instead.
% Preparation of the wavelet filters
iswtb = license('checkout','wavelet_toolbox');
if iswtb % Functions in Wavelet Toolbox are used
    dwtmode('per','nodisp')
    wname = "sym4"; %[control:dropdown:102a]{"position":[13,19]}
    [h0,h1,f0,f1] = wfilters(wname);
else
    import msip.ezwavedec2
    import msip.ezwaverec2
    S = load(fullfile(datfolder,"sym4.mat"));
    h0 = S.h0;
    h1 = S.h1;
    f0 = S.f0;
    f1 = S.f1;
    % Analysis bivariate filters
    H.h00 = h0(:)*h0(:).';
    H.h01 = h0(:)*h1(:).';
    H.h10 = h1(:)*h0(:).';
    H.h11 = h1(:)*h1(:).';
    % Synthesis bivariate filters
    F.f00 = f0(:)*f0(:).';
    F.f01 = f0(:)*f1(:).';
    F.f10 = f1(:)*f0(:).';
    F.f11 = f1(:)*f1(:).';
end
%[text] Analysis process
if iswtb
    [coefs,scales] = wavedec2(x,nlevels,h0,h1);
    % Reconstruction to check PR
    xr = waverec2(coefs,scales,f0,f1);
else
    [coefs,scales] = ezwavedec2(x,nlevels,H);
    % Reconstruction to check PR
    xr = ezwaverec2(coefs,scales,F);
end
assert(norm(x-xr,"fro")^2/numel(x)<1e-18,'Perfect reconstruction is violated.')
%[text] Extraction of the coefficients
s = extractcoefs(coefs,scales);
%%
%[text] ## Distribution of the coefficients
%[text] Each channel $\\mathbf{s}\_p$ and its histogram.  The high-pass channels concentrate at zero (sparse).
nchs = length(s);
for ich = 1:nchs
    fig = figure;
    tl = tiledlayout(fig,1,2,"TileSpacing","compact");
    if ich == 1
        imshow(s{ich}*pow2(-nlevels),"Parent",nexttile(tl))
    else
        imshow(s{ich}+.5,"Parent",nexttile(tl))
    end
    title("$\mathbf{s}_{" + (ich-1) + "}$","Interpreter","latex")
    ax = nexttile(tl);
    histogram(ax,s{ich}(:))
    axis(ax,"square")
    drawnow
end
%%
%[text] ## Laplace distribution
%[text] The coefficients are assumed to be random numbers drawn from a Laplace distribution.
%[text] - $\\mathbf{s}\\sim\\prod\_k\\mathcal{L}(\[\\mathbf{s}\]\_k;0,b)$
%[text] - $\\mathcal{L}(s;\\mu,b)=\\frac{1}{2b}\\exp\\left(-\\frac{|s-\\mu|}{b}\\right)$ (variance $2b^2$) \
% Laplace parameters
mu = 0;
sgm2 = 0.001;
b = sqrt(sgm2/2);
% Laplace distribution
spdf = @(s) 1/(2*b)*exp(-abs(s-mu)/b);
fig = figure;
ax = axes(fig);
fplot(ax,spdf)
xlabel(ax,"$s$","Interpreter","latex")
ylabel(ax,"$\mathcal{L}(s;0,b)$, $b=" + sprintf("%.4f",b) + "$","Interpreter","latex")
title(ax,"Laplace distribution")
grid(ax,"on")
axis(ax,[-1 1 0 30])
%%
%[text] ## Observation image
%[text] Parameter settings
sgmuint8 = 30;  %[control:slider:84b3]{"position":[12,14]}
sgm = sgmuint8/255;
%[text] Add noise
v = imnoise(x,'gaussian',0,sgm^2);
%[text] Analysis process
if iswtb
    [coefs,scales] = wavedec2(v,nlevels,h0,h1);
else
    [coefs,scales] = ezwavedec2(v,nlevels,H);
end
%%
%[text] ## Wavelet shrinkage
%[text] Problem setting
%[text] - $\\hat{\\mathbf{s}}=\\arg\\min\_{\\mathbf{s}}\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{D}\\mathbf{s}\\|\_2^2+\\lambda\\|\\mathbf{s}\\|\_1$
%[text] - $\\mathbf{D}\\mathbf{D}^\\top=\\mathbf{D}^\\top\\mathbf{D}=\\mathbf{I}$ (orthonormal) \
%[text] Parameter settings (BayesShrink selects a threshold for each sub-band adaptively)
isbayesshrink = false; %[control:checkbox:26d7]{"position":[17,22]}
if ~isbayesshrink
    isaprxleft = true; %[control:checkbox:6d7b]{"position":[18,22]}
    lambda = 10^-0.6 %[control:slider:16aa]{"position":[17,21]}
end
%[text] Soft thresholding
%[text] $\\hat{\\mathbf{s}} = \\phi\_\\mathrm{ST}(\\mathbf{c};\\lambda)=\\mathrm{sign}(\\mathbf{c})\\odot\\max(\\mathrm{abs}(\\mathbf{c})-\\lambda\\mathbf{1},\\mathbf{0})$, $\\mathbf{c}=\\mathbf{D}^\\top\\mathbf{v}$
% Sub-band adaptive soft shrinkage
if isbayesshrink
    import msip.bayesshrink
    coefs = bayesshrink(coefs,scales);
else
    if isaprxleft
        mask = ones(size(coefs));
        mask(1:prod(scales(1,:))) = 0;
        lambda = lambda * mask;
    end
    softshrink = @(c) sign(c).*max(abs(c)-lambda,0);
    coefs = softshrink(coefs);
end
%[text] Synthesis process
if iswtb
    xhat = waverec2(coefs,scales,f0,f1);
else
    xhat = ezwaverec2(coefs,scales,F);
end
%%
%[text] ## Image show
fig = figure;
tl = tiledlayout(fig,1,3,"TileSpacing","compact");
imshow(x,"Parent",nexttile(tl))
title("Original image $\mathbf{x}$","Interpreter","latex")
imshow(v,"Parent",nexttile(tl))
title("Noisy image $\mathbf{v}$: PSNR = " + sprintf("%5.2f",psnr(v,x)) + " dB","Interpreter","latex")
imshow(xhat,"Parent",nexttile(tl))
title("Denoised image $\hat{\mathbf{x}}$: PSNR = " + sprintf("%5.2f",psnr(xhat,x)) + " dB","Interpreter","latex")
%%
%[text] ## Wavelet image denoising functions
%[text] Reference
if iswtb
    help wthcoef2
    help wdenoise2
end
%%
%[text] ## Extraction of the coefficients
function s = extractcoefs(coefs,scales)
nscales = size(scales,1)-1;
s = cell(3*(nscales-1)+1,1);
sidx = 1;
subSize = scales(1,:);
eidx = sidx + prod(subSize) - 1;
s{1} = reshape(coefs(sidx:eidx),subSize);
sidx = eidx + 1;
ich = 2;
for iscale = 2:nscales
    subSize = scales(iscale,:);
    for iband = 1:3
        eidx = sidx + prod(subSize) - 1;
        s{ich} = reshape(coefs(sidx:eidx),subSize);
        sidx = eidx + 1;
        ich = ich + 1;
    end
end
end
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:55e2]
%   data: {"defaultValue":3,"label":"nlevels","max":5,"min":1,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:dropdown:102a]
%   data: {"defaultValue":"\"sym4\"","itemLabels":["haar","db2","sym4"],"items":["\"haar\"","\"db2\"","\"sym4\""],"label":"wname","run":"SectionToEnd"}
%---
%[control:slider:84b3]
%   data: {"defaultValue":30,"label":"sgmuint8","max":50,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":10}
%---
%[control:checkbox:26d7]
%   data: {"defaultValue":false,"label":"isbayesshrink","run":"SectionToEnd"}
%---
%[control:checkbox:6d7b]
%   data: {"defaultValue":true,"label":"isaprxleft","run":"SectionToEnd"}
%---
%[control:slider:16aa]
%   data: {"defaultValue":-0.8,"label":"log10(lambda)","max":2,"min":-4,"run":"AllSections","runOn":"ValueChanging","step":0.1}
%---
