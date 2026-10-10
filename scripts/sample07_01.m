%[text] # Sample 7-1: Image resizing
%[text] Advanced Topics in Image Processing, Lecture 7 "Geometric Image Processing"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Setting the resizing factors
%[text]{"align":"center"} $\\boldsymbol{M}=\\begin{bmatrix} M\_1 & 0 \\\\ 0 & M\_2 \\end{bmatrix}$
%[text] - $M\_1$: vertical factor
%[text] - $M\_2$: horizontal factor \
% Vertical factor M1
verticalFactor = 2; %[control:slider:12a5]{"position":[18,19]}
% Horizontal factor M2
horizontalFactor = 2; %[control:slider:6e18]{"position":[20,21]}
%%
%[text] ## Input image
%[text] - $\\mathsf{x}=\\left(x\[\\boldsymbol{m}\]\\right)\_{\\boldsymbol{m}}$: input image \
% Reading an image
datfolder = atip.prjfolders();
x = rgb2gray(imread(fullfile(datfolder,'barbaraFaceRgb.tif')));
%%
%[text] ## Decreasing the resolution
%[text] Decreasing the resolution with downsampling (\[M\] Definition "Downsampling", Sec. 5.1.1)
%[text]{"align":"center"} $y\[\\boldsymbol{n}\]=x\[\\boldsymbol{M}\\boldsymbol{n}\]$
%[text] - $\\mathsf{y}=\\left(y\[\\boldsymbol{n}\]\\right)\_{\\boldsymbol{n}}$: output image of downsampling \
% Bivariate downsampling function
downsample2 = @(x,n) ...
    shiftdim(downsample(...
    shiftdim(downsample(x,...
    n(1)),1),...
    n(2)),1);

% Downsampling
y = downsample2(x,[verticalFactor horizontalFactor]);
%[text] Decreasing the resolution with box averaging (\[M\] Example "Block average", Sec. 5.1.1)
%[text]{"align":"center"} $v\[\\boldsymbol{n}\]=\\frac{1}{|\\det(\\boldsymbol{M})|}\\sum\_{\\boldsymbol{m}\\in\\mathcal{N}(\\boldsymbol{M})}x\[\\boldsymbol{M}\\boldsymbol{n}+\\boldsymbol{m}\]$
%[text] - $\\mathsf{v}=\\left(v\[\\boldsymbol{n}\]\\right)\_{\\boldsymbol{n}}$: output image of box averaging \
% Box averaging
sizeNew = ceil(size(x)./[verticalFactor horizontalFactor]);
v = imresize(x,sizeNew,'box');
%%
%[text] ## Display of the images
%[text] Original $\\mathsf{x}$
fig1 = figure;
imshow(x, 'Parent', axes(fig1))
title('Original')
%[text] Downsampled $\\mathsf{y}$ and box-averaged $\\mathsf{v}$: the downsampled image shows aliasing.
fig2 = figure;
tl2 = tiledlayout(fig2, 1, 2, 'TileSpacing', 'compact');
ax = nexttile(tl2);
imshow(y, 'Parent', ax)
title(ax, 'Downsampled')
ax = nexttile(tl2);
imshow(v, 'Parent', ax)
title(ax, 'Box-averaged')
%%
%[text] ## Increasing the resolution
%[text] Increasing the resolution with zero insertion (\[M\] Definition "Upsampling", Sec. 5.1.2)
%[text]{"align":"center"} $y\[\\boldsymbol{n}\] = \\left\\{\\begin{array}{ll}  x\[\\boldsymbol{M}^{-1}\\boldsymbol{n}\] & \\boldsymbol{n}\\in\\mathcal{L}(\\boldsymbol{M}) \\\\ 0 &\\mathrm{otherwise} \\end{array}\\right.$
%[text]{"align":"center"} $\\mathcal{L}(\\boldsymbol{M})\\coloneqq \\{\\boldsymbol{M}\\boldsymbol{k} \\mid \\boldsymbol{k}\\in\\mathbb{Z}^2\\}$
%[text] - $\\mathsf{y}=\\left(y\[\\boldsymbol{n}\]\\right)\_{\\boldsymbol{n}}$: output image of zero insertion \
% Bivariate upsampling function
upsample2 = @(x,n) ...
    shiftdim(upsample(...
    shiftdim(upsample(x,...
    n(1)),1),...
    n(2)),1);

% Upsampling
y = upsample2(x,[verticalFactor horizontalFactor]);
%%
%[text] Increasing the resolution with nearest-neighbour interpolation (\[M\] Example "Nearest-neighbour interpolation", Sec. 5.1.2)
%[text]{"align":"center"} $v\[\\boldsymbol{n}\] = x\\left\[\\lfloor\\boldsymbol{M}^{-1}\\boldsymbol{n}\\rfloor\\right\]$
%[text] - $\\mathsf{v}=\\left(v\[\\boldsymbol{n}\]\\right)\_{\\boldsymbol{n}}$: output image of nearest-neighbour interpolation \
% Nearest-neighbour interpolation
sizeNew = size(x).*[verticalFactor horizontalFactor];
v = imresize(x,sizeNew,'nearest');
%%
%[text] ## Display of the images
%[text] Zero-inserted $\\mathsf{y}$
fig3 = figure;
imshow(y, 'Parent', axes(fig3))
title('Upsampled')
%[text] Nearest-neighbour interpolated $\\mathsf{v}$
fig4 = figure;
imshow(v, 'Parent', axes(fig4))
title('Nearest-neighbour')
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:12a5]
%   data: {"defaultValue":2,"label":"verticalFactor","max":8,"min":1,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:6e18]
%   data: {"defaultValue":2,"label":"horizontalFactor","max":8,"min":1,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
