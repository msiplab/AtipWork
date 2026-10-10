%[text] # Sample 3-2: Moving average and Laplacian
%[text] Advanced Topics in Image Processing, Lecture 3 "Image Smoothing and Sharpening"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Preparation of sample image
%[text] A linear filter repeats the local inner product (\[M\] Section 3.1)
%[text]{"align":"center"} $y\[\\boldsymbol{n}\]=\\sum\_{\\boldsymbol{m}\\in\\mathcal{N}\_\\mathrm{f}}f\[\\boldsymbol{m}\]x\[\\boldsymbol{n}+\\boldsymbol{m}\]$
%[text] which is `imfilter(X,f)` in MATLAB (zero padding by default).
% Read the original image
I = im2double(imread('cameraman.tif'));
figure
imshow(I)
title('Original')
%%
%[text] ## Moving average filter
%[text] The averaging (box) kernel of size $3\\times 3$ is
%[text]{"align":"center"} $\\left(f\[\\boldsymbol{m}\]\\right)\_{\\boldsymbol{m}}=\\frac{1}{9}\\begin{pmatrix}1 & 1 & 1 \\\\ 1 & 1 & 1 \\\\ 1 & 1 & 1\\end{pmatrix}$
% Kernel size
hsize = 3; %[control:slider:95e7]{"position":[9,10]}

% Generate the filter kernel
f = fspecial('average',hsize)
% Moving average filter
J = imfilter(I,f);

% Show the result
figure
imshow(J)
title("Moving average filter of size " + hsize + "\times" + hsize)
%%
%[text] ## Gaussian filter
%[text] The Gaussian kernel of size $3\\times 3$ is given by (\[M\] Example "Gaussian filter", Section 3.1.1)
%[text]{"align":"center"} $f\[\\boldsymbol{m}\]=\\frac{g\[\\boldsymbol{m}\]}{\\sum\_{\\boldsymbol{\\ell}\\in\\mathcal{N}\_\\mathrm{f}}g\[\\boldsymbol{\\ell}\]},\\quad g\[\\boldsymbol{m}\]=\\exp\\left(-\\frac{m\_1^2+m\_2^2}{2\\sigma\_\\mathrm{g}^2}\\right),\\quad \\boldsymbol{m}\\in\\{-1,0,1\\}^2$
%[text] where $\\sigma\_\\mathrm{g}$ is the standard deviation.
% Kernel size and standard deviation
hsize = 3; %[control:slider:4aa0]{"position":[9,10]}
sigma = 0.5; %[control:slider:4101]{"position":[9,12]}

% Generate the filter kernel
f = fspecial('gaussian',hsize,sigma)
% Mesh plot of the Gaussian kernel
[m2,m1] = meshgrid(-ceil(hsize/2-1):floor(hsize/2),-ceil(hsize/2-1):floor(hsize/2));
figure
mesh(m2,m1,f)
title('Gaussian kernel')
xlabel('m_2')
ylabel('m_1')
% Gaussian filtering with IMFILTER
J = imfilter(I,f);

% Show the result
figure
imshow(J)
title("Gaussian filter (IMFILTER) of size " + hsize + "\times" + hsize + ", \sigma = " + sigma)
% Gaussian filtering with IMGAUSSFILT
K = imgaussfilt(I,sigma);

% Kernel size used by IMGAUSSFILT
hsize = 2*ceil(2*sigma)+1;

% Show the result
figure
imshow(K)
title("Gaussian filter (IMGAUSSFILT) of size " + hsize + "\times" + hsize + ", \sigma = " + sigma)
%%
%[text] ## Laplacian filter
%[text] The 4-neighbour Laplacian kernel ($\\alpha=0$) is (\[M\] Example "4-neighbour Laplacian", Section 3.1.2)
%[text]{"align":"center"} $\\left(f\[\\boldsymbol{m}\]\\right)\_{\\boldsymbol{m}}=\\begin{pmatrix}0 & 1 & 0 \\\\ 1 & -4 & 1 \\\\ 0 & 1 & 0\\end{pmatrix}$
% Shape parameter
alpha = 0; %[control:slider:1991]{"position":[9,10]}

% Generate the filter kernel
f = fspecial('laplacian',alpha)
% Laplacian filtering
J = imfilter(I,f);

% Show the result with the bias 1/2
figure
imshow(J+.5)
title("Laplacian filter, \alpha = " + alpha)
%%
%[text] ## Unsharp mask filter
%[text] The 4-neighbour unsharp mask kernel ($\\alpha=0$) is the identity minus the Laplacian,
%[text] $\\mathsf{y}=(\\mathsf{I}-\\nabla^2)\\mathsf{x}$ (\[M\] Example "4-neighbour unsharp mask", Section 3.1.2):
%[text]{"align":"center"} $\\left(f\[\\boldsymbol{m}\]\\right)\_{\\boldsymbol{m}}=\\begin{pmatrix}0 & -1 & 0 \\\\ -1 & 5 & -1 \\\\ 0 & -1 & 0\\end{pmatrix}$
% Shape parameter
alpha = 0; %[control:slider:537e]{"position":[9,10]}

% Generate the filter kernel
f = fspecial('unsharp',alpha)
% Unsharp mask filtering
J = imfilter(I,f);

% Show the result
figure
imshow(J)
title("Unsharp mask filter, \alpha = " + alpha)
%%
%[text] ## Sobel filter
%[text] Horizontal Sobel kernel (\[M\] Example "Sobel filter", Section 3.2.1)
%[text]{"align":"center"} $\\left(f\_\\mathrm{h}\[\\boldsymbol{m}\]\\right)\_{\\boldsymbol{m}}=\\begin{pmatrix}-1 & 0 & 1 \\\\ -2 & 0 & 2 \\\\ -1 & 0 & 1\\end{pmatrix}$
% Generate the filter kernel (FSPECIAL gives the vertical kernel with the opposite sign)
f = fspecial('sobel');
f = rot90(f,-1)
% Horizontal Sobel filtering
H = imfilter(I,f);

% Show the result with the bias 1/2
figure
imshow(H+.5)
title('Sobel horizontal filter')
%[text] Vertical Sobel kernel
%[text]{"align":"center"} $\\left(f\_\\mathrm{v}\[\\boldsymbol{m}\]\\right)\_{\\boldsymbol{m}}=\\begin{pmatrix}-1 & -2 & -1 \\\\ 0 & 0 & 0 \\\\ 1 & 2 & 1\\end{pmatrix}$
% Generate the filter kernel
f = fspecial('sobel');
f = flipud(f)
% Vertical Sobel filtering
V = imfilter(I,f);

% Show the result with the bias 1/2
figure
imshow(V+.5)
title('Sobel vertical filter')
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:95e7]
%   data: {"defaultValue":3,"label":"hsize","max":16,"min":1,"run":"Section","runOn":"ValueChanging","step":1}
%---
%[control:slider:4aa0]
%   data: {"defaultValue":3,"label":"hsize","max":16,"min":1,"run":"Section","runOn":"ValueChanging","step":1}
%---
%[control:slider:4101]
%   data: {"defaultValue":0.5,"label":"sigma","max":16,"min":0.1,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:1991]
%   data: {"defaultValue":0,"label":"alpha","max":1,"min":0,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:537e]
%   data: {"defaultValue":0,"label":"alpha","max":1,"min":0,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
