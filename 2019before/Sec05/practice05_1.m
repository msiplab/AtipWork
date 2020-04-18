% practice05_1.m
%
% $Id: practice05_1.m,v 1.4 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% マスクの設定
sizeMask = [3 3];
movAveMask = ones(sizeMask,'double');
movAveMask = movAveMask/sum(movAveMask(:));

sigma = 0.6;
halfSizeMask = (sizeMask - 1)/2;
[k0,k1] = meshgrid(...
    -halfSizeMask(1):halfSizeMask(1),...
    -halfSizeMask(2):halfSizeMask(2));
gausMask = exp(-(k0.^2+k1.^2)/(2*sigma^2));
gausMask = gausMask/sum(gausMask(:));

%% 原画像の読み込みと表示
pictureRgb = imread('./data/firenzeRgb.jpg');
pictureGray = rgb2graycq(pictureRgb);
figure(1)
imshowcq(pictureGray)
title('Original')

%% ノイズが加わった画像の読み込みと表示
pictureNoisy = imread('./data/firenzeNoisy.jpg');
figure(2)
imshowcq(pictureNoisy)
title('Before filtering')

%% フィルタ処理と結果の表示
pictureFiltered = ...
    uint8(filter2(movAveMask,pictureNoisy));
figure(3)
imshowcq(pictureFiltered)
title('After filtering (average)')

%% フィルタ処理と結果の表示
pictureFiltered = ...
    uint8(filter2(gausMask,pictureNoisy));
figure(4)
imshowcq(pictureFiltered)
title('After filtering (gaussian)')

% end 
