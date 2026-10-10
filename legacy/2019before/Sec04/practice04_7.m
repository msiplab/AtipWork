% practice04_7.m
%
% $Id: practice04_7.m,v 1.5 2008-06-17 10:34:24 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 画像ファイルの読込
pictureRgb = imread('./data/firenzeRgb.jpg');

%% YCbCr空間（フルレンジ）への変換
pictureYcbcr(:,:,1) = uint8( ...
    0.2990 * double(pictureRgb(:,:,1)) ...
    + 0.5870 * double(pictureRgb(:,:,2)) ...
    + 0.1140 * double(pictureRgb(:,:,3)) );
pictureYcbcr(:,:,2) = uint8( ...
    - 0.169 * double(pictureRgb(:,:,1)) ...
    - 0.331* double(pictureRgb(:,:,2)) ...
    + 0.5 *   double(pictureRgb(:,:,3)) ...
    + 128);
pictureYcbcr(:,:,3) = uint8( ...
      0.5 *   double(pictureRgb(:,:,1)) ...
    - 0.419 * double(pictureRgb(:,:,2)) ...
    - 0.081 * double(pictureRgb(:,:,3)) ...
    + 128);
nRows = size(pictureRgb,1);
nCols = size(pictureRgb,2);

%% 原画像の表示
subplot(2,2,1)
imshowcq(pictureRgb)
title('Original')

%% Y成分の表示
subplot(2,2,2)
imshowcq(pictureYcbcr(:,:,1))
title('Y component')

%% Cb成分の表示
subplot(2,2,3)
imshowcq(pictureYcbcr(:,:,2))
title('Cb component')

%% Cr成分の表示
subplot(2,2,4)
imshowcq(pictureYcbcr(:,:,3))
title('Cr component')

% end
