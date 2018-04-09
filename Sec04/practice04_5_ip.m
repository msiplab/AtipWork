% practice04_5.m
%
% $Id: practice04_5_ip.m,v 1.3 2007/05/16 07:23:59 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%
parameterGamma = 0.25;

%% 画像ファイルの読込
pictureRgb = imread('./data/firenzeRgb.jpg');

%% モノクロ画像への変換
pictureGray = rgb2gray(pictureRgb);

%% 累乗則変換
pictureCorrected = imadjust(pictureGray,[],[],parameterGamma);

%% 原画像（モノクロ）の表示
figure(1)
imshow(pictureGray)
title('Before correction')

%% 処理画像の表示
figure(2)
imshow(pictureCorrected)
title('After correction')

% end
