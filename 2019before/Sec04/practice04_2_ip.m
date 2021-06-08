% practice04_2.m
%
% $Id: practice04_2_ip.m,v 1.4 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% RGBカラー画像の読込 
pictureRgb = imread('data/firenzeRgb.jpg');

%% RGBカラー画像(uint8)の表示
figure(1) 
imshow(pictureRgb);
title('pictureRgb');

%% モノクロ画像への変換
pictureGray = rgb2gray(pictureRgb);

%% モノクロ画像(uint8)の表示
figure(2) 
imshow(pictureGray);
title('pictureGray');

% 倍精度(double)への変換
pictureRgbDouble = ...
    double(pictureRgb)/255.0; % 0.0～1.0 の間にスケーリング

%% カラー画像(double)の表示
figure(3) 
imshow(pictureRgbDouble);
title('pictureRgbDouble');

% end
