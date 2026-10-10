%[text] # Sample 11-2: Transform of noise
%[text] Advanced Topics in Image Processing, Lecture 11 "Image Denoising"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Preparation
[datfolder,~] = atip.prjfolders();
atip.download_img(false)
%%
%[text] ## Parameter settings
%[text] - sgmuint8: standard deviation of the noise $\\sigma\_\\mathrm{w}$ (in the scale of 8-bit integers)
%[text] - nlevels: number of wavelet levels \
% Parameter settings
sgmuint8 = 30;  %[control:slider:2bd1]{"position":[12,14]}
sgm = sgmuint8/255;
nlevels = 3;  %[control:slider:730c]{"position":[11,12]}
%%
%[text] ## Read image
x = im2double(imread(fullfile(datfolder,"kodim23.png")));
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
    wname = "sym4"; %[control:dropdown:41ea]{"position":[13,19]}
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
%[text] Alignment of the coefficients
xc = aligncoefs(coefs,scales);
%%
%[text] ## Observation image
v = imnoise(x,'gaussian',0,sgm^2);
%[text] Analysis process
if iswtb
    [coefs,scales] = wavedec2(v,nlevels,h0,h1);
else
    [coefs,scales] = ezwavedec2(v,nlevels,H);
end
%[text] Alignment of the coefficients
vc = aligncoefs(coefs,scales);
%%
%[text] ## Image show
fig = figure;
tl = tiledlayout(fig,2,2,"TileSpacing","compact");
imshow(x,"Parent",nexttile(tl))
title("Original image $\mathbf{x}$","Interpreter","latex")
imshow(abs(xc),"Parent",nexttile(tl))
title("Transform coefficients of $\mathbf{x}$","Interpreter","latex")
imshow(v,"Parent",nexttile(tl))
title("Noisy image $\mathbf{v}$: PSNR = " + sprintf("%5.2f",psnr(v,x)) + " dB","Interpreter","latex")
imshow(abs(vc),"Parent",nexttile(tl))
title("Transform coefficients of $\mathbf{v}$","Interpreter","latex")
%%
%[text] ## Definition of the function
%[text] Alignment of the coefficients (octave-band arrangement)
function c00 = aligncoefs(coefs,scales)
nlevels = size(scales,1)-2;
dim = scales(1,:);
nel = prod(dim);
c00 = reshape(coefs(1:nel),dim)/(2^nlevels);
pos = nel;
for ilv = 1:nlevels
    dim = scales(ilv+1,:);
    nel = prod(dim);
    %
    c01 = abs(reshape(coefs(pos+1:pos+nel),dim));
    pos = pos + nel;
    %
    c10 = abs(reshape(coefs(pos+1:pos+nel),dim));
    pos = pos + nel;
    %
    c11 = abs(reshape(coefs(pos+1:pos+nel),dim));
    pos = pos + nel;
    %
    c00 = [ c00 c01; c10 c11 ];
end
end
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:2bd1]
%   data: {"defaultValue":30,"label":"sgmuint8","max":50,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":10}
%---
%[control:slider:730c]
%   data: {"defaultValue":3,"label":"nlevels","max":5,"min":1,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:dropdown:41ea]
%   data: {"defaultValue":"\"sym4\"","itemLabels":["haar","db2","sym4"],"items":["\"haar\"","\"db2\"","\"sym4\""],"label":"wname","run":"Section"}
%---
