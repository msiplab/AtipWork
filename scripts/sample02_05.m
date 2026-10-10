%[text] # Sample 2-5: Colour space conversion
%[text] Advanced Topics in Image Processing, Lecture 2 "Input and Output of Images"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Preparation of sample image
%[text] Each pixel of an RGB image is a vector $\\vec{x}=(x\_\\mathrm{R}\\ x\_\\mathrm{G}\\ x\_\\mathrm{B})^\\top\\in\[0,1\]^3$
%[text] and is mapped by a vector function $\\vec{y}=\\boldsymbol{\\phi}(\\vec{x})$ (\[M\] Section 2.3.3).
datfolder = atip.prjfolders();
% Read the original image
X = im2double(imread(fullfile(datfolder,'firenzeRgb.jpg')));
figure
imshow(X)
title('Original')
%%
%[text] ## Negative transform
%[text]{"align":"center"} $\\begin{pmatrix}y\_\\mathrm{R} \\\\ y\_\\mathrm{G} \\\\ y\_\\mathrm{B}\\end{pmatrix}=\\boldsymbol{\\phi}\\begin{pmatrix}x\_\\mathrm{R} \\\\ x\_\\mathrm{G} \\\\ x\_\\mathrm{B}\\end{pmatrix}=\\begin{pmatrix}1 \\\\ 1 \\\\ 1\\end{pmatrix}-\\begin{pmatrix}x\_\\mathrm{R} \\\\ x\_\\mathrm{G} \\\\ x\_\\mathrm{B}\\end{pmatrix}$
% Definition of the negative transform
Tn = @(x) 1.0-x;
% Negative transform of image X
Y = Tn(X);
figure
imshow(Y)
title('Negative')
%%
%[text] ## Power-law transform in RGB space
%[text]{"align":"center"} $\\begin{pmatrix}y\_\\mathrm{R} \\\\ y\_\\mathrm{G} \\\\ y\_\\mathrm{B}\\end{pmatrix}=\\boldsymbol{\\phi}\\begin{pmatrix}x\_\\mathrm{R} \\\\ x\_\\mathrm{G} \\\\ x\_\\mathrm{B}\\end{pmatrix}=\\begin{pmatrix}x\_\\mathrm{R}^\\gamma \\\\ x\_\\mathrm{G}^\\gamma \\\\ x\_\\mathrm{B}^\\gamma\\end{pmatrix}$
% Parameter of the power-law transform
gamma = 0.5 %[control:slider:2917]{"position":[9,12]}
% Power-law transform in RGB space
Y = imadjust(X,[],[],gamma);
figure
imshow(Y)
title('Power-law transform in RGB space')
%%
%[text] ## Power-law transform of the V component in HSV space
%[text]{"align":"center"} $\\begin{pmatrix}u\_\\mathrm{H} \\\\ u\_\\mathrm{S} \\\\ u\_\\mathrm{V}\\end{pmatrix}=\\mathrm{rgb2hsv}\\begin{pmatrix}x\_\\mathrm{R} \\\\ x\_\\mathrm{G} \\\\ x\_\\mathrm{B}\\end{pmatrix}$
%[text]{"align":"center"} $\\begin{pmatrix}y\_\\mathrm{R} \\\\ y\_\\mathrm{G} \\\\ y\_\\mathrm{B}\\end{pmatrix}=\\mathrm{hsv2rgb}\\begin{pmatrix}u\_\\mathrm{H} \\\\ u\_\\mathrm{S} \\\\ u\_\\mathrm{V}^\\gamma\\end{pmatrix}$
% Parameter of the power-law transform
gamma = 0.5 %[control:slider:5c42]{"position":[9,12]}
% Power-law transform of the V component in HSV space
U = rgb2hsv(X);
[H,S,V] = imsplit(U);
V = imadjust(V,[],[],gamma);
U = cat(3,H,S,V);
Y = hsv2rgb(U);
figure
imshow(Y)
title('Power-law transform of V in HSV space')
%%
%[text] ## Histogram equalization in RGB space
%[text]{"align":"center"} $\\begin{pmatrix}y\_\\mathrm{R} \\\\ y\_\\mathrm{G} \\\\ y\_\\mathrm{B}\\end{pmatrix}=\\boldsymbol{\\phi}\\begin{pmatrix}x\_\\mathrm{R} \\\\ x\_\\mathrm{G} \\\\ x\_\\mathrm{B}\\end{pmatrix}=\\begin{pmatrix}\\mathrm{histeq}(x\_\\mathrm{R}) \\\\ \\mathrm{histeq}(x\_\\mathrm{G}) \\\\ \\mathrm{histeq}(x\_\\mathrm{B})\\end{pmatrix}$
% Histogram equalization in RGB space
[R,G,B] = imsplit(X);
R = histeq(R);
G = histeq(G);
B = histeq(B);
Y = cat(3,R,G,B);
figure
imshow(Y)
title('Histogram equalization in RGB space')
%%
%[text] ## Histogram equalization of the V component in HSV space
%[text] Equalizing only the V component keeps the hue and the saturation.
%[text]{"align":"center"} $\\begin{pmatrix}u\_\\mathrm{H} \\\\ u\_\\mathrm{S} \\\\ u\_\\mathrm{V}\\end{pmatrix}=\\mathrm{rgb2hsv}\\begin{pmatrix}x\_\\mathrm{R} \\\\ x\_\\mathrm{G} \\\\ x\_\\mathrm{B}\\end{pmatrix}$
%[text]{"align":"center"} $\\begin{pmatrix}y\_\\mathrm{R} \\\\ y\_\\mathrm{G} \\\\ y\_\\mathrm{B}\\end{pmatrix}=\\mathrm{hsv2rgb}\\begin{pmatrix}u\_\\mathrm{H} \\\\ u\_\\mathrm{S} \\\\ \\mathrm{histeq}(u\_\\mathrm{V})\\end{pmatrix}$
% Histogram equalization of the V component in HSV space
U = rgb2hsv(X);
[H,S,V] = imsplit(U);
V = histeq(V);
U = cat(3,H,S,V);
Y = hsv2rgb(U);
figure
imshow(Y)
title('Histogram equalization of V in HSV space')
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:2917]
%   data: {"defaultValue":0.5,"label":"gamma","max":4,"min":0,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:5c42]
%   data: {"defaultValue":0.5,"label":"gamma","max":4,"min":0,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
