% practice04_8.m
%
% $Id: practice04_8.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 累乗則変換のパラメータγ
parameterGamma = 0.4;

%% 画像ファイルの読込
pictureRgb = imread('./data/firenzeRgb.jpg');

%% RGB空間での累乗則変換
pictureRgbDouble = double(pictureRgb)./255.0;
pictureRgbA = pictureRgbDouble.^parameterGamma;

%% V成分に対する累乗則変換
pictureHsv = rgb2hsv(pictureRgb);
pictureHsv(:,:,3) = pictureHsv(:,:,3).^parameterGamma;
pictureRgbV = hsv2rgb(pictureHsv);

%% 画像の表示
figure(1)
imshowcq(pictureRgb)
title('原画像')

figure(2)
imshowcq(pictureRgbA)
title('RGB全成分に対する累乗則変換')

figure(3)
imshowcq(pictureRgbV)
title('V成分のみに対する累乗則変換')

% end
