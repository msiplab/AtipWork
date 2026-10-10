%[text] # Sample 9-6: Bivariate DWT
%[text] Advanced Topics in Image Processing, Lecture 9 "Discrete Wavelet Transforms"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Preparation
%[text] The Kodak images are downloaded to the data folder once.  The compressed files are written to the results folder.
[datfolder,resfolder] = atip.prjfolders();
atip.download_img(false)
%%
%[text] ## Read an image
x = im2double(imread(fullfile(datfolder,"kodim23.png")));
figure
imshow(x)
title("Original")
%%
%[text] ## The 9/7-transform and its inverse of an image
% Forward 9/7-transform
[subLL,subHL,subLH,subHH] = imtrans97(x);

% Show the subband images
picturesSub = [ subLL    subHL+.5;
                subLH+.5 subHH+.5 ];
figure
imshow(picturesSub)
title("Subband images")
% Inverse 9/7-transform
xhat = imitrans97(subLL,subHL,subLH,subHH);

% Show the reconstructed picture
figure
imshow(xhat)
title("Reconstruction")
%%
%[text] ## The 9/7-DWT and its inverse of an image
% 3-level 9/7-DWT (tree structure on the LL subband)
[subLL2,subHL2,subLH2,subHH2] = imtrans97(x);
[subLL1,subHL1,subLH1,subHH1] = imtrans97(subLL2);
[subLL0,subHL0,subLH0,subHH0] = imtrans97(subLL1);

% Arrangement of the subbands
subband0 = [subLL0 subHL0+.5 ;
    subLH0+.5 subHH0+.5];
subband1 = [subband0 subHL1+.5 ;
    subLH1+.5 subHH1+.5];
subband2 = [ subband1 subHL2+.5;
    subLH2+.5 subHH2+.5 ];
figure
imshow(subband2)
title("Subband images w/ 3-level DWT")

% 3-level 9/7-IDWT
subLL1 = imitrans97(subLL0,subHL0,subLH0,subHH0);
subLL2 = imitrans97(subLL1,subHL1,subLH1,subHH1);
w = imitrans97(subLL2,subHL2,subLH2,subHH2);

% Reconstruction
figure
imshow(w)
title("Reconstruction w/ 3-level IDWT")
% PSNR evaluation
psnr(im2uint8(x),im2uint8(w))
%%
%[text] ## Image approximation
%[text] Approximation by the 3-level 9/7-DWT (only the lowest subband is kept)
% 3-level 9/7-IDWT
subLL1 = imitrans97(subLL0 ,0*subHL0, 0*subLH0, 0*subHH0);
subLL2 = imitrans97(subLL1, 0*subHL1, 0*subLH1, 0*subHH1);
r = imitrans97(subLL2, 0*subHL2, 0*subLH2, 0*subHH2);

%[text] Approximation by the $8\\times 8$ DCT (only the DC coefficients are kept)
mask = zeros(8);
mask(1) = 1;
[c1,c2,c3] = imsplit(x);
fun = @(blk) idct2(mask.*dct2(blk.data));
y1 = blockproc(c1,[8 8],fun);
y2 = blockproc(c2,[8 8],fun);
y3 = blockproc(c3,[8 8],fun);
y = cat(3,y1,y2,y3);

% Reconstruction
figure
imshow(r)
title("Approximation w/ 3-level DWT (PSNR: " + psnr(im2uint8(x),im2uint8(r)) + " dB)")
figure
imshow(y)
title("Approximation w/ 8\times 8 DCT (PSNR: " + psnr(im2uint8(x),im2uint8(y)) + " dB)")
%%
%[text] ## Image compression
% JPEG w/ DCT
jpgfile = fullfile(resfolder,"kodim23.jpg");
imwrite(x,jpgfile,"Quality",10)
jpginfo = imfinfo(jpgfile)

% JPEG 2000 w/ 9/7-DWT
jp2file = fullfile(resfolder,"kodim23.jp2");
imwrite(x,jp2file,"CompressionRatio",80.7)
jp2info = imfinfo(jp2file)
% Comparison
figure
g = imread(jpgfile);
imshow(g)
title(sprintf("JPEG Size: %d, PSNR: %6.2f dB",jpginfo.FileSize,psnr(im2uint8(x),g)))
figure
t = imread(jp2file);
imshow(t)
title(sprintf("JPEG 2000 Size: %d, PSNR: %6.2f dB",jp2info.FileSize,psnr(im2uint8(x),t)))
%%
%[text] ## Function definitions
%[text] Forward 9/7-transform with in-place implementation
function [subLL,subHL,subLH,subHH] = imtrans97(img)
%
% Copyright (C) 2005-2020 Shogo MURAMATSU, All rights reserved
%
alpha = -1.586134342059924;
beta  = -0.052980118572961;
gamma =  0.882911075530934;
delta =  0.443506852043971;
K =  1.230174104914001;

img = double(img);

% Vertical transform
img = inplaceprediction2(img,alpha);
img = inplaceupdate2(img,beta);
img = inplaceprediction2(img,gamma);
img = inplaceupdate2(img,delta);
img(1:2:end,:,:) = img(1:2:end,:,:)/K;
img(2:2:end,:,:) = img(2:2:end,:,:)*K;

% Horizontal transform
img = inplaceprediction2(permute(img,[2 1 3]),alpha);
img = inplaceupdate2(img,beta);
img = inplaceprediction2(img,gamma);
img = ipermute(inplaceupdate2(img,delta),[2 1 3]);
img(:,1:2:end,:) = img(:,1:2:end,:)/K;
img(:,2:2:end,:) = img(:,2:2:end,:)*K;

% Arrange coefficients
subLL = img(1:2:end,1:2:end,:);
subHL = img(1:2:end,2:2:end,:);
subLH = img(2:2:end,1:2:end,:);
subHH = img(2:2:end,2:2:end,:);

end
%[text] Inverse 9/7-transform with in-place implementation
function img = imitrans97(subLL,subHL,subLH,subHH)
%
% Copyright (C) 2005-2020 Shogo MURAMATSU, All rights reserved
%
alpha = -1.586134342059924;
beta  = -0.052980118572961;
gamma =  0.882911075530934;
delta =  0.443506852043971;
K =  1.230174104914001;

% Preparation of the array
fullSize = (size(subLL) + size(subHH))./[1 1 2];
img = zeros(fullSize);

% Merge coefficients
img(1:2:end,1:2:end,:) = subLL;
img(1:2:end,2:2:end,:) = subHL;
img(2:2:end,1:2:end,:) = subLH;
img(2:2:end,2:2:end,:) = subHH;

% Horizontal transform
img(:,1:2:end,:) = img(:,1:2:end,:)*K;
img(:,2:2:end,:) = img(:,2:2:end,:)/K;
img = inplaceupdate2(permute(img,[2 1 3]),-delta);
img = inplaceprediction2(img,-gamma);
img = inplaceupdate2(img,-beta);
img = ipermute(inplaceprediction2(img,-alpha),[2 1 3]);

% Vertical transform
img(1:2:end,:,:) = img(1:2:end,:,:)*K;
img(2:2:end,:,:) = img(2:2:end,:,:)/K;
img = inplaceupdate2(img,-delta);
img = inplaceprediction2(img,-gamma);
img = inplaceupdate2(img,-beta);
img = inplaceprediction2(img,-alpha);

end
%[text] Prediction lifting step with in-place implementation
function picture = inplaceprediction2(picture,p)
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%
if (mod(size(picture,1),2)==0)
    picture(2:2:end,:,:) = imlincomb(...
        p, picture(1:2:end,:,:), ...
        1, picture(2:2:end,:,:), ...
        p, [picture(3:2:end,:,:); picture(end-1,:,:)] ...
        );
else
    picture(2:2:end,:,:) = imlincomb(...
        p, picture(1:2:end-2,:,:), ...
        1, picture(2:2:end,:,:), ...
        p, picture(3:2:end,:,:) ...
        );
end
end
%[text] Update lifting step with in-place implementation
function picture = inplaceupdate2(picture,u)
%
% Copyright (C) 2005-2020 Shogo MURAMATSU, All rights reserved
%
if (mod(size(picture,1),2)==0)
    picture(1:2:end,:,:) = imlincomb(...
        u, [picture(2,:,:); picture(2:2:end-1,:,:)], ...
        1, picture(1:2:end,:,:), ...
        u, picture(2:2:end,:,:) ...
        );
else
    picture(1:2:end,:,:) = imlincomb(...
        u, [picture(2,:,:); picture(2:2:end-1,:,:)], ...
        1, picture(1:2:end,:,:), ...
        u, [picture(2:2:end,:,:); picture(end-1,:,:)] ...
        );
end
end
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
