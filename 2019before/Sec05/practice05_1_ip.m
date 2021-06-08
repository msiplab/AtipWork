% practice05_1.m
%
% $Id: practice05_1_ip.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% マスクの設定
sizeMask = [3 3];
movAveMask = fspecial('average',sizeMask);

sigma = 0.6;
gausMask = fspecial('gaussian',sizeMask,sigma);

%% 原画像の読み込みと表示
pictureRgb = imread('./data/firenzeRgb.jpg');
pictureGray = rgb2gray(pictureRgb);
figure(1)
imshow(pictureGray)
title('Original')

%% ノイズが加わった画像の生成と表示
noiseDensity = 0.02;
pictureNoisy = imnoise(pictureGray,'salt & pepper', noiseDensity);
figure(2)
imshow(pictureNoisy)
title('Before filtering')

%% フィルタ処理
pictureFiltered = imfilter(pictureNoisy,movAveMask);
figure(3)
imshow(pictureFiltered)
title('After filtering (average)')

%% フィルタ処理
pictureFiltered = imfilter(pictureNoisy,gausMask);
figure(4)
imshow(pictureFiltered)
title('After filtering (gaussian)')

% end 
