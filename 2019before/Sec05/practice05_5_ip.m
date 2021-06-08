% practice05_5.m
%
% $Id: practice05_5_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% マスクの設定
prewittMask = fspecial('prewitt');
             
%% 原画像の読み込みと表示
pictureRgb = imread('./data/firenzeRgb.jpg');
pictureGray = im2double(rgb2gray(pictureRgb));
figure(1)
imshow(pictureGray)
title('Original')

%% フィルタ処理と結果の表示
pictureVerFiltered = ...
    imfilter(pictureGray,prewittMask);
pictureHorFiltered = ...
    imfilter(pictureGray, prewittMask.');
pictureFiltered = abs(pictureVerFiltered) + abs(pictureHorFiltered);
figure(2)
imshow(pictureFiltered)
title('After filtering (prewitt)')

%% 二値化処理と結果の表示
pictureBinary = im2bw(pictureFiltered);
figure(3)
imshow(pictureBinary)
title('After filtering (binary)')

%% 二値化処理と結果の表示
pictureEdge = edge(pictureGray,'prewitt');
figure(4)
imshow(pictureEdge)
title('After edge detection')

% end 
