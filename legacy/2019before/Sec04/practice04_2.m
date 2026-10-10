% practice04_2.m
%
% $Id: practice04_2.m,v 1.5 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% RGBカラー画像の読込 
pictureRgb = imread('data/firenzeRgb.jpg');

%% RGBカラー画像(uint8)の表示
figure(1) 
image(pictureRgb) 
axis image 
axis off
title('pictureRgb')

%% モノクロ画像への変換
pictureGray = rgb2graycq(pictureRgb);

%% モノクロ画像(uint8)の表示
figure(2) 
image(pictureGray); colormap(gray(256)) 
axis image
axis off
title('pictureGray');

%% 倍精度(double)への変換
pictureRgbDouble = ...
    double(pictureRgb)/255.0; % 0.0～1.0 の間にスケーリング

%% カラー画像(double)の表示
figure(3) 
image(pictureRgbDouble) 
axis image
axis off
title('pictureRgbDouble')

% end
