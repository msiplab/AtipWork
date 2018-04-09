% practice05_3.m
%
% $Id: practice05_3_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% マスクの設定
alpha = 0.0;
laplacianMask = fspecial('laplacian',alpha);

%% 原画像の読み込みと表示
pictureRgb = imread('./data/firenzeRgb.jpg');
pictureGray = im2double(rgb2gray(pictureRgb));
figure(1)
imshow(pictureGray)
title('Original')

%% フィルタ処理と結果の表示
pictureFiltered = ...
    imfilter(pictureGray,laplacianMask) + 0.5;
figure(2)
imshow(pictureFiltered)
title('After filtering (laplacian)')

% end 
