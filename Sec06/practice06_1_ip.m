% practice06_1.m
%
% $Id: practice06_1_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% ŠÔˆø‚«—¦
% …•½‚ÌŠÔˆø‚«—¦
horizontalDecFactor = 2;
% ‚’¼‚ÌŠÔˆø‚«—¦
verticalDecFactor = 2;

%% ‰æ‘œ‚Ì“Ç
pictureRgb = imread('./data/barbaraFaceRgb.tif');
pictureGray = rgb2gray(pictureRgb);
clear pictureRgb;

%% ŠÔˆø‚«ˆ—
sizeNew = ceil(size(pictureGray) ./ ...
           [verticalDecFactor horizontalDecFactor]);
%pictureGrayDownsampled = imresize(pictureGray,sizeNew);
pictureGrayDownsampled = imresize_old(pictureGray,sizeNew);

% Œ´‰æ‘œ‚Ì•\¦
figure(1)
imshow(pictureGray)
title('Original picture')

% ŠÔˆø‚«ˆ—Œã‚Ì‰æ‘œ‚Ì•\¦
figure(2)
imshow(pictureGrayDownsampled)
title('Downsampled picture')

% end
