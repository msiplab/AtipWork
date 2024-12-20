% practice06_1.m
%
% $Id: practice06_1_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 間引き率
% 水平の間引き率
horizontalDecFactor = 2;
% 垂直の間引き率
verticalDecFactor = 2;

%% 画像の読込
pictureRgb = imread('./data/barbaraFaceRgb.tif');
pictureGray = rgb2gray(pictureRgb);
clear pictureRgb;

%% 間引き処理
sizeNew = ceil(size(pictureGray) ./ ...
           [verticalDecFactor horizontalDecFactor]);
%pictureGrayDownsampled = imresize(pictureGray,sizeNew);
pictureGrayDownsampled = imresize_old(pictureGray,sizeNew);

% 原画像の表示
figure(1)
imshow(pictureGray)
title('Original picture')

% 間引き処理後の画像の表示
figure(2)
imshow(pictureGrayDownsampled)
title('Downsampled picture')

% end
