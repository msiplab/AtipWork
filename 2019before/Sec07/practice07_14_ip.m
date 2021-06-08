% practice07_14.m
%
% $Id: practice07_14_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 画像の読込
pictureRgb = imread('./data/barbaraFaceRgb.tif');

%% モノクロ画像への変換
pictureGray = rgb2gray(im2double(pictureRgb));

%% 順変換

% DB2変換
[subLL,subHL,subLH,subHH] = imdb2trnscq_ip(pictureGray);
alpha = 1/2;

% 5/3変換
%[subLL,subHL,subLH,subHH] = im53trnscq_ip(pictureGray);
%alpha = 1;

% 9/7変換
%[subLL,subHL,subLH,subHH] = im97trnscq_ip(pictureGray);
%alpha = 1;

%% サブバンド画像の表示（AC成分は見やすいようにスケーリング）
picturesSub = [ alpha*subLL        4*abs(subHL);
                4*abs(subLH) 4*abs(subHH) ];
figure(1)
imshow(picturesSub)
title('Subband pictures')

%% 逆変換

% DB2変換
pictureRec = imdb2itrnscq_ip(subLL,subHL,subLH,subHH);

% 5/3変換
%pictureRec = im53itrnscq_ip(subLL,subHL,subLH,subHH);

% 9/7変換
%pictureRec = im97itrnscq_ip(subLL,subHL,subLH,subHH);

%% 復元画像の表示
figure(2)
imshow(pictureRec)
title('Reconstructed picture')

% end
