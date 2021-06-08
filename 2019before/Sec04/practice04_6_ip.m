% practice04_6.m
%
% $Id: practice04_6_ip.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 画像ファイルの読込
pictureRgb = imread('./data/firenzeRgb.jpg');

%% モノクロ画像への変換
pictureGray = rgb2gray(pictureRgb);

%% 処理前の画像の表示
subplot(2,2,1)
imshow(pictureGray)
title('Before histgram equalization')

%% 処理前のヒストグラムの表示
subplot(2,2,2)
imhist(pictureGray)
title('Before histgram equalization')

%% ヒストグラム均等化
pictureHistEqd = histeq(pictureGray);

%% 処理後の画像の表示
subplot(2,2,3)
imshow(pictureHistEqd)
title('After histgram equalization')

%% 処理後のヒストグラムの表示
subplot(2,2,4)
imhist(pictureHistEqd)
title('After histgram equalization')

% end
