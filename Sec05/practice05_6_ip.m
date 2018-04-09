% practice05_6.m
%
% $Id: practice05_6_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 一次元インパルス応答の設定
aveFilter1 = [ 1 1 1 ]/3;

%% 原画像の読み込みと表示
pictureNoisy = imread('./data/firenzeNoisy.jpg');
pictureNoisy = im2double(pictureNoisy);
figure(1)
imshow(pictureNoisy)
title('Original')

%% 垂直方向フィルタ処理と結果の表示
pictureVerFiltered = ...
    imfilter(pictureNoisy,aveFilter1(:),'conv');
figure(2)
imshow(pictureVerFiltered)
title('Intermediate result (vertical moving average)')

%% 水平方向フィルタ処理と結果の表示
pictureFiltered = ...
    imfilter(pictureVerFiltered,aveFilter1(:).','conv');
figure(3)
imshow(pictureFiltered)
title('After filtering (separate moving average)')

% end 
