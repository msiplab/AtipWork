%[text] # Sample 3-3: Gradient filter
%[text] Advanced Topics in Image Processing, Lecture 3 "Image Smoothing and Sharpening"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Preparation of sample image
% Read the original image
I = im2double(imread('cameraman.tif'));
figure
imshow(I)
title('Original')
%%
%[text] ## Selecting the filter kernel
%[text] - Sobel
%[text] - Prewitt \
ftype = 'Sobel'; %[control:dropdown:2fb0]{"position":[9,16]}
%%
%[text] ## Gradient filter
%[text] The vertical and horizontal first-order differences give the gradient vector
%[text] (\[M\] Section 3.2.2)
%[text]{"align":"center"} $\\vec{y}\[\\boldsymbol{n}\]=\\begin{pmatrix}x\_\\mathrm{v}\[\\boldsymbol{n}\] \\\\ x\_\\mathrm{h}\[\\boldsymbol{n}\]\\end{pmatrix}$
%[text] `imgradientxy` returns the horizontal difference `Gh` ($x\_\\mathrm{h}$) and the vertical difference `Gv`
%[text] ($x\_\\mathrm{v}$, positive downward).
% Gradient filter
[Gh,Gv] = imgradientxy(I,ftype);

% Show the results with the bias 1/2
figure
tiledlayout(1,2)
nexttile
imshow(Gh+.5)
title(ftype + " horizontal filter")
nexttile
imshow(Gv+.5)
title(ftype + " vertical filter")
%%
%[text] ## Visualization of the gradient
figure
quiver(Gh,Gv)
title('Gradient')
axis equal off ij
%%
%[text] ## Magnitude and direction of the gradient
%[text]{"align":"center"} $y\_\\mathrm{mag}\[\\boldsymbol{n}\]=\\sqrt{x\_\\mathrm{v}^2\[\\boldsymbol{n}\]+x\_\\mathrm{h}^2\[\\boldsymbol{n}\]}$
%[text]{"align":"center"} $y\_\\mathrm{ang}\[\\boldsymbol{n}\]=\\mathrm{atan2}\\left(x\_\\mathrm{v}\[\\boldsymbol{n}\],x\_\\mathrm{h}\[\\boldsymbol{n}\]\\right)$
%[text] `imgradient` returns the direction `Gd` in degrees, measured counterclockwise from the horizontal axis,
%[text] i.e. $\\mathrm{atan2}(-x\_\\mathrm{v},x\_\\mathrm{h})$ in $\[-180,180\]$.
% Magnitude and direction of the gradient
[Gm,Gd] = imgradient(Gh,Gv);

% Show the magnitude
figure
imshow(Gm)
title('Magnitude of gradient')
%%
% Show the direction (unit vectors; the y-axis of the image points downward)
figure
quiver(cosd(Gd),-sind(Gd))
title('Direction of gradient')
axis equal off ij
%%
%[text] ## Edge detection
% Edge detection
E = edge(I,ftype);

% Show the result
figure
imshow(E)
title("Edge detection with " + ftype)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:dropdown:2fb0]
%   data: {"defaultValue":"'Sobel'","itemLabels":["Sobel","Prewitt"],"items":["'Sobel'","'Prewitt'"],"label":"Kernel","run":"SectionToEnd"}
%---
