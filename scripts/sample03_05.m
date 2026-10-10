%[text] # Sample 3-5: Boundary processing
%[text] Advanced Topics in Image Processing, Lecture 3 "Image Smoothing and Sharpening"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Pad array
%[text] Extension of an array beyond its support (\[M\] Section 3.1.3)
%[text] - Zero padding
%[text] - Circular padding
%[text] - Replica padding
%[text] - Symmetric padding (half-sample symmetry) \
% Pad size
padsize = 2; %[control:slider:213c]{"position":[11,12]}
%
A = randi(8,4)
% Zero padding
B = padarray(A,[padsize padsize],0,'both')
% Circular padding
C = padarray(A,[padsize padsize],'circular','both')
% Replica padding
R = padarray(A,[padsize padsize],'replicate','both')
% Symmetric padding
D = padarray(A,[padsize padsize],'symmetric','both')
%%
%[text] ## Preparation of sample image
%[text] The image is read from the data folder of the AtipWork project.
datfolder = atip.prjfolders();
% Read the original image
I = im2double(imread(fullfile(datfolder,'barbaraFaceRgb.tif')));
figure
imshow(I)
title('Original')
%%
%[text] ## Filter setting
% Filter setting
hsize = 3; %[control:slider:4f44]{"position":[9,10]}
f = fspecial('average',hsize);
%%
%[text] ## Zero padding
% Zero padding (default of IMFILTER)
Jz = imfilter(I,f);

% Show the result
figure
imshow(Jz)
title('After filtering (zero padding)')
%%
%[text] ## Circular padding
% Circular padding
Jp = imfilter(I,f,'circular');

% Show the result
figure
imshow(Jp)
title('After filtering (circular padding)')
%%
%[text] ## Replica padding
% Replica padding
Jr = imfilter(I,f,'replicate');

% Show the result
figure
imshow(Jr)
title('After filtering (replica padding)')
%%
%[text] ## Symmetric padding
% Symmetric padding
Js = imfilter(I,f,'symmetric');

% Show the result
figure
imshow(Js)
title('After filtering (symmetric padding)')
%%
%[text] ## Comparison
%[text] Lower-right corner of the results (\[M\] Fig. 3.4).  Zero padding gives black blurring and circular
%[text] padding wrap-around; replica and symmetric padding suppress both.  Increase `hsize` to see the
%[text] difference clearly.
% Patch size
psize = 32;

figure
tiledlayout(1,4,"TileSpacing","compact")
titles = ["Zero padding","Circular padding","Replica padding","Symmetric padding"];
results = {Jz,Jp,Jr,Js};
for k = 1:4
    nexttile
    imshow(imresize(results{k}(end-psize+1:end,end-psize+1:end,:),4,'nearest'))
    title(titles(k))
end
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:213c]
%   data: {"defaultValue":2,"label":"padsize","max":5,"min":0,"run":"Section","runOn":"ValueChanging","step":1}
%---
%[control:slider:4f44]
%   data: {"defaultValue":3,"label":"hsize","max":17,"min":1,"run":"SectionToEnd","runOn":"ValueChanging","step":2}
%---
