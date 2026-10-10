%[text] # Sample 1-5: Image read and show
%[text] Advanced Topics in Image Processing, Lecture 1 "Digital Image Representation"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Image read
%[text] `imread` returns an RGB colour image as a 3-D array of size $N_1\\times N_2\\times 3$ (type `uint8`).
%[text] The element $x[n_\\mathrm{v},n_\\mathrm{h},n_\\mathrm{c}]$ of the reference text is `P(nv+1,nh+1,nc+1)`,
%[text] because MATLAB indices start from 1.
P = imread('peppers.png');
whos P
%%
%[text] ## Image show
figure
imshow(P)
title('peppers.png')
%%
%[text] ## Colour component images
%[text] $x[:,:,n_\\mathrm{c}]$ with $n_\\mathrm{c}\\in\\{0,1,2\\}$ are the R, G and B component images.
figure
tiledlayout(1,3,"TileSpacing","compact")
names = ["R","G","B"];
for nc = 0:2
    nexttile
    imshow(P(:,:,nc+1))
    title(names(nc+1) + " component")
end
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
