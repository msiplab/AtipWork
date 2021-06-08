% practice05_2.m
%
% $Id: practice05_2_ip.m,v 1.4 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% マスクサイズ
sizeMask = [3 3];

%% 原画像の読み込みと表示
pictureRgb = imread('./data/firenzeRgb.jpg');
pictureGray = rgb2gray(pictureRgb);
figure(1)
imshow(pictureGray)
title('Original')

%% ノイズが加わった画像の読み込みと表示
pictureNoisy = imnoise(pictureGray,'salt & pepper',0.02);
figure(2);
imshow(pictureNoisy);
title('Before filtering');

%% フィルタ処理と結果の表示
pictureMedian = medfilt2(pictureNoisy,sizeMask);
figure(3)
imshow(pictureMedian)
title('After filtering (median)')

%% フィルタ処理と結果の表示
pictureMax = ordfilt2(pictureNoisy,prod(sizeMask),ones(sizeMask));
figure(4)
imshow(pictureMax)
title('After filtering (max)')

%% フィルタ処理と結果の表示
pictureMin = ordfilt2(pictureNoisy,1,ones(sizeMask));
figure(5)
imshow(pictureMin)
title('After filtering (min)')

% end 
