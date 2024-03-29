% practice06_1.m
%
% $Id: practice06_1.m,v 1.2 2007/05/07 11:09:47 sho Exp $
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
pictureGray = rgb2graycq(pictureRgb);
clear pictureRgb;

%% 間引き処理
pictureGrayDownsampled = pictureGray(...
            1:verticalDecFactor:end,...
            1:horizontalDecFactor:end);
% pictureGrayDownsampled = ...
%     downsample(downsample(pictureGray,...
%                           vDecFactor).',...
%                hDecFactor).';

%% 原画像の表示
figure(1)
imshowcq(pictureGray)
title('Original picture')

%% 間引き処理後の画像の表示
figure(2)
imshowcq(pictureGrayDownsampled)
title('Downsampled picture')

% end
