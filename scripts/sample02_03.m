%[text] # Sample 2-3: Intensity transforms
%[text] Advanced Topics in Image Processing, Lecture 2 "Input and Output of Images"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Preparation of sample image
%[text] Each pixel value $x$ is mapped to $y=\\phi(x)$ by the same scalar function (pixel-wise processing,
%[text] \[M\] Section 2.1).  The grayscale image is normalized to $\[0,1\]$.
datfolder = atip.prjfolders();
% Read the original image
I = im2double(rgb2gray(imread(fullfile(datfolder,'firenzeRgb.jpg'))));
figure
imshow(I)
title('Original')
figure
imhist(I)
%%
%[text] ## Negative transform
%[text]{"align":"center"} $y=\\phi(x) = 1-x$
% Definition of the negative transform
Tn = @(x) 1.0-x;
figure
fplot(Tn,[0,1])
axis square
grid on
% Negative transform of image I
J = Tn(I);
figure
imshow(J)
title('Negative')
figure
imhist(J)
%%
%[text] ## Contrast stretching
%[text] \[M\] Section 2.1.4 with $\\gamma=10^{-\\alpha}$:
%[text]{"align":"center"} $y=\\phi(x) = \\frac{1}{2}\\left(\\mathrm{sign}(2x-1)|2x-1|^{10^{-\\alpha}}+1\\right)$
% Definition of contrast stretching
alpha = 1 %[control:slider:27ad]{"position":[9,10]}
Tc = @(x) 0.5*(sign(2.0*x-1.0).*abs(2*x-1.0).^(10^(-alpha))+1.0);
figure
fplot(Tc,[0,1])
axis square
grid on
% Contrast stretching of image I
K = Tc(I);
figure
imshow(K)
title('Contrast stretching')
figure
imhist(K)
%%
%[text] ## Power-law transform
%[text] \[M\] Section 2.1.4 with $c=1$: $\\gamma<1$ brightens and $\\gamma>1$ darkens the image.
%[text]{"align":"center"} $y=\\phi(x) = x^\\gamma$
% Definition of the power-law transform
gamma = 0.5 %[control:slider:0ccc]{"position":[9,12]}
Tp = @(x) x.^gamma;
figure
fplot(Tp,[0,1])
axis square
grid on
% Power-law transform of image I
L = Tp(I);
figure
imshow(L)
title('Power-law transform')
figure
imhist(L)
%%
%[text] ## Image adjustment function
%[text] `imadjust` is a sophisticated intensity adjustment function that allows fine tuning of images,
%[text] including the power-law transform of `uint8` images.
% Parameter of the power-law transform
gamma = 0.5 %[control:slider:8f9c]{"position":[9,12]}
% Conversion to uint8
U = im2uint8(I);
% Power-law transform with IMADJUST
M = imadjust(U,[],[],gamma);
figure
imshow(M)
title('Power-law transform with IMADJUST')
figure
imhist(M)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:27ad]
%   data: {"defaultValue":1,"label":"alpha","max":3,"min":0,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:0ccc]
%   data: {"defaultValue":0.5,"label":"gamma","max":4,"min":0,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:8f9c]
%   data: {"defaultValue":0.5,"label":"gamma","max":4,"min":0,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
