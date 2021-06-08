% practice05_5.m
%
% $Id: practice05_5.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% マスクの設定
prewittMask = [ 1  1  1;
                0  0  0;
               -1 -1 -1 ];
             
%% 原画像の読み込みと表示
pictureRgb = imread('./data/firenzeRgb.jpg');
pictureGray = rgb2graycq(pictureRgb);
figure(1)
imshowcq(pictureGray)
title('Original')

%% フィルタ処理と結果の表示
pictureVerFiltered = ...
    filter2(prewittMask, pictureGray);
pictureHorFiltered = ...
    filter2(prewittMask.', pictureGray);
pictureFiltered = uint8(...
    abs(pictureVerFiltered) ...
    + abs(pictureHorFiltered) );
figure(2)
imshowcq(pictureFiltered)
title('After filtering (prewitt)')

%% 二値化処理と結果の表示
level = 128;
pictureBinary = zeros(size(pictureFiltered),'uint8');
pictureBinary(pictureFiltered>=level) = uint8(255); 
pictureBinary = reshape(pictureBinary,size(pictureFiltered));
figure(3)
imshowcq(pictureBinary)
title('After filtering (binary)')

% end 
