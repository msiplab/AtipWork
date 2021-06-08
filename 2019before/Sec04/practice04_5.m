% practice04_5.m
%
% $Id: practice04_5.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%
parameterGamma = 0.25;

%% 画像ファイルの読込
pictureRgb = imread('./data/firenzeRgb.jpg');

%% モノクロ画像への変換
pictureGray = rgb2graycq(pictureRgb);

%% double 型への変換
pictureGrayDouble = ...
    double(pictureGray)/255.0;

%% 累乗則変換
pictureCorrected = ...
    pictureGrayDouble.^parameterGamma;

%% 原画像（モノクロ）の表示
figure(1)
imshowcq(pictureGrayDouble)
title('Before correction')

%% 処理画像の表示
figure(2)
imshowcq(pictureCorrected)
title('After correction')

% end
