% practice06_2.m
%
% $Id: practice06_2_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 間引き率
% 水平の間引き率
hDecFactor = 2;
% 垂直の間引き率
vDecFactor = 2;
% 全間引き率
decFactor = hDecFactor * vDecFactor;

%% 画像の読込と輝度値の抽出
pictureRgb = imread('./data/barbaraFaceRgb.tif');
pictureGray = rgb2gray(pictureRgb);
clear pictureRgb

%% 平均操作による縮小処理
clear pictureGrayDecimated
sizeNew = ceil(size(pictureGray) ./ [vDecFactor hDecFactor]);
pictureGrayDecimated = imresize(pictureGray,sizeNew,'box');

%% 原画像表示
figure(1)
imshow(pictureGray)
title('Original picture')

%% 縮小画像表示
figure(2)
imshow(pictureGrayDecimated)
title('Decimated picture')

% end
