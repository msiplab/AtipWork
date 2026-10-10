%[text] # Sample 3-4: Order statistic filters
%[text] Advanced Topics in Image Processing, Lecture 3 "Image Smoothing and Sharpening"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Preparation of sample image
%[text] An order statistic filter outputs the $K$-th smallest value in the neighbourhood (\[M\] Section 3.3)
%[text]{"align":"center"} $y\[\\boldsymbol{n}\]=\\mathrm{ord}\\left(\\left(x\[\\boldsymbol{n}+\\boldsymbol{m}\]\\right)\_{\\boldsymbol{m}\\in\\mathcal{N}\_\\mathrm{f}},K\\right)$
% Read the original image
I = im2double(imread('cameraman.tif'));
figure
imshow(I)
title('Original')
%%
%[text] ## Image contaminated with salt & pepper noise
% Noise density
d = 0.05; %[control:slider:2397]{"position":[5,9]}
% Add noise
J = imnoise(I,'salt & pepper',d);

% Show the result
figure
imshow(J)
title('Contaminated image')
%%
%[text] ## Median filter
%[text] $K=(|\\mathcal{N}\_\\mathrm{f}|+1)/2$: robust to impulsive noise.
% Neighbourhood size
hsize = 3 %[control:slider:2003]{"position":[9,10]}
% Median filtering
K = medfilt2(J,[hsize hsize]);

% Show the result
figure
imshow(K)
title('Median filter')
%%
%[text] ## Maximum filter
%[text] $K=|\\mathcal{N}\_\\mathrm{f}|$: bright regions spread.
% Neighbourhood setting
hsize = 3; %[control:slider:681f]{"position":[9,10]}
domain = ones(hsize);

% Maximum filtering
L = ordfilt2(J,nnz(domain),domain);

% Show the result
figure
imshow(L)
title('Maximum filter')
%%
%[text] ## Minimum filter
%[text] $K=1$: dark regions spread.
% Neighbourhood setting
hsize = 3; %[control:slider:8984]{"position":[9,10]}
domain = ones(hsize);

% Minimum filtering
M = ordfilt2(J,1,domain);

% Show the result
figure
imshow(M)
title('Minimum filter')
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:2397]
%   data: {"defaultValue":0.05,"label":"d","max":1,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":0.05}
%---
%[control:slider:2003]
%   data: {"defaultValue":3,"label":"hsize","max":31,"min":1,"run":"Section","runOn":"ValueChanging","step":2}
%---
%[control:slider:681f]
%   data: {"defaultValue":3,"label":"hsize","max":31,"min":1,"run":"Section","runOn":"ValueChanging","step":2}
%---
%[control:slider:8984]
%   data: {"defaultValue":3,"label":"hsize","max":31,"min":1,"run":"Section","runOn":"ValueChanging","step":2}
%---
