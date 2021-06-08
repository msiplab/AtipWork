% practice05_6.m
%
% $Id: practice05_6.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 一次元インパルス応答の設定
aveFilter1 = [ 1 1 1 ]/3;

%% 原画像の読み込みと表示
pictureNoisy = imread('./data/firenzeNoisy.jpg');
pictureNoisy = double(pictureNoisy)./255;
figure(1)
imshowcq(pictureNoisy)
title('Original')

%% 垂直方向フィルタ処理と結果の表示
pictureVerFiltered = ...
    conv2(pictureNoisy,aveFilter1(:),'same');
figure(2)
imshowcq(pictureVerFiltered)
title('Intermediate result (vertical moving average)')

%% 水平方向フィルタ処理と結果の表示
pictureFiltered = ...
    conv2(pictureNoisy,aveFilter1(:).','same');
figure(3)
imshowcq(pictureFiltered)
title('After filtering (separate moving average)')

% end 
