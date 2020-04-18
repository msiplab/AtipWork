% practice05_8.m
%
% $Id: practice05_8_ip.m,v 1.3 2007/05/14 21:39:03 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% マスクの設定
sizeMask = 3;
aveMask = fspecial('average',sizeMask);

%% 原画像の読み込みと表示
pictureRgb = imread('./data/barbaraFaceRgb.tif');
figure(1)
imshow(pictureRgb)
title('Original')

%% フィルタ処理（零値拡張）と結果の表示
pictureFilteredZp = imfilter(pictureRgb,aveMask);
figure(2)
imshow(pictureFilteredZp)
title('After filtering (zero padding)')

%% フィルタ処理（周期拡張）と結果の表示
pictureFilteredPe = imfilter(pictureRgb,aveMask,'circular');
figure(3)
imshow(pictureFilteredPe)
title('After filtering (periodic extension)')

%% フィルタ処理（対称拡張）と結果の表示
pictureFilteredSe = imfilter(pictureRgb,aveMask,'symmetric');
figure(4)
imshow(pictureFilteredSe)
title('After filtering (symmetric extension)')

% end 
