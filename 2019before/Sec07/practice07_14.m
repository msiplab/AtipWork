% practice07_14.m
%
% $Id: practice07_14.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 画像の読込
pictureRgb = imread('./data/barbaraFaceRgb.tif');

%% モノクロ画像への変換
pictureGray = rgb2graycq(pictureRgb);

%% 順変換
% DB2 変換
[subLL,subHL,subLH,subHH] = imdb2trnscq(pictureGray);
alpha = 1/2;

% 5/3 変換
%[subLL,subHL,subLH,subHH] = im53trnscq(pictureGray);
%alpha = 1;

% 9/7 変換
%[subLL,subHL,subLH,subHH] = im97trnscq(pictureGray);
%alpha = 1;

%% サブバンド画像の表示（AC成分は見やすいようにスケーリング）
picturesSub = [ alpha*subLL        4*abs(subHL);
                4*abs(subLH) 4*abs(subHH) ];
figure(1)
imshowcq(uint8(picturesSub))
title('Subband pictures')

%% 逆変換
% DB2変換
pictureRec = imdb2itrnscq(subLL,subHL,subLH,subHH);
% 5/3変換
%pictureRec = im53itrnscq(subLL,subHL,subLH,subHH);
% 9/7変換
%pictureRec = im97itrnscq(subLL,subHL,subLH,subHH);

%% 復元画像の表示
figure(2)
imshowcq(uint8(pictureRec))
title('Reconstructed picture')

% end
