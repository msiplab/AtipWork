% practice06_3.m
%
% $Id: practice06_3_ip.m,v 1.4 2007/07/07 01:06:38 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 補間率
% 水平の補間率
hIntFactor = 2;
% 垂直の補間率
vIntFactor = 2;
% 全間引き率
intFactor = hIntFactor * vIntFactor;

%% 画像の読込と輝度値の抽出
pictureRgb = imread('./data/boatsBackRgb.tif');
pictureGray = rgb2gray(pictureRgb);
clear pictureRgb;

%% 零次ホールドによる拡大処理
sizeNew = size(pictureGray).*[vIntFactor hIntFactor];
pictureGrayIntpd = imresize(pictureGray, sizeNew, 'nearest');

%% 原画像表示
figure(1)
imshow(pictureGray)
title('Original picture')

%% 拡大画像表示
figure(2)
imshow(pictureGrayIntpd)
title('Interpolated picture')

% end
