% practice04_3.m
%
% $Id: practice04_3_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 画像ファイルの読込
pictureRgb = imread('./data/firenzeRgb.jpg');

%% カラー画像(uint8)のTIFF形式での書出
imwrite(pictureRgb, './tmp/firenzeRgb.tif');

%% モノクロ画像(double)への変換
pictureGrayDouble = im2double(rgb2gray(pictureRgb));

%% モノクロ画像(double)のJPEG形式での書出
imwrite(pictureGrayDouble, ...
    './tmp/firenzeGray.jpg'); 

%% imshow でファイルを表示
imshow('./tmp/firenzeGray.jpg')

% end
