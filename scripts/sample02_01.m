%[text] # Sample 2-1: RGB to grayscale
%[text] Advanced Topics in Image Processing, Lecture 2 "Input and Output of Images"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Preparation
%[text] The data folder holds the images used in this sample; outputs go to the results folder.
[datfolder,resfolder] = atip.prjfolders();
%%
%[text] ## RGB to grayscale
%[text] Grayscale conversion is the inner product of an RGB pixel $\\vec{x}=(x\_\\mathrm{R}\\ x\_\\mathrm{G}\\ x\_\\mathrm{B})^\\top$
%[text] with a weight vector (\[M\] Example "Grayscale conversion", Section 2.3.1):
%[text]{"align":"center"} $y=\\phi(\\vec{x})=0.2989x\_\\mathrm{R}+0.5870x\_\\mathrm{G}+0.1140x\_\\mathrm{B}$
% Read a colour image
pictureRgb = imread(fullfile(datfolder,'firenzeRgb.jpg'));
% Conversion to grayscale
pictureGray = uint8( ...
    0.2989 * double(pictureRgb(:,:,1)) + ... % R
    0.5870 * double(pictureRgb(:,:,2)) + ... % G
    0.1140 * double(pictureRgb(:,:,3)) ...   % B
    );
whos pictureRgb pictureGray
%%
%[text] ## Image show in uint8
%[text] - RGB colour image
%[text] - Grayscale image \
figure
imshow(pictureRgb)
title('RGB colour image (uint8)')
figure
imshow(pictureGray)
title('Grayscale image (uint8)')
%%
%[text] ## RGB2GRAY function
%[text] `rgb2gray` keeps the data type of the input: a `double` input gives a `double` output.
pictureRgbDouble = im2double(pictureRgb);
pictureGrayDouble = rgb2gray(pictureRgbDouble);
whos pictureRgbDouble pictureGrayDouble
%%
%[text] ## Image show in double
%[text] - RGB colour image
%[text] - Grayscale image \
figure
imshow(pictureRgbDouble)
title('RGB colour image (double)')
figure
imshow(pictureGrayDouble)
title('Grayscale image (double)')
%%
%[text] ## Image write
%[text] `imwrite` decides the format from the file extension.  The files are saved in the results folder.
imwrite(pictureRgb, fullfile(resfolder,'firenzeRgb.tif'))
imwrite(pictureGray, fullfile(resfolder,'firenzeGray.jpg'))
dir(fullfile(resfolder,'firenze*'))
%[text] JPEG is lossy.  The quality factor (0 to 100, default 75) controls the trade-off between
%[text] the file size and the image quality.
imwrite(pictureGray, fullfile(resfolder,'q50.jpg'), 'Quality', 50)
dir(fullfile(resfolder,'q50.jpg'))
%%
%[text] ## Image viewer app
%[text] `imageViewer` shows the pixel values and allows zooming (desktop only).
%[text] - RGB colour image
%[text] - Grayscale image \
if usejava('desktop')
    imageViewer(pictureRgbDouble)
    imageViewer(pictureGrayDouble)
end
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
