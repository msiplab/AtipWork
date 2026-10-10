% practice05_4.m
%
% $Id: practice05_4.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% マスクの設定
unsharpMask = [ 0  -1  0;
               -1   5  -1;
                0  -1  0];

             
%% 原画像の読み込みと表示
pictureRgb = imread('./data/firenzeRgb.jpg');
pictureGray = rgb2graycq(pictureRgb);
figure(1)
imshowcq(pictureGray)
title('Original')

%% フィルタ処理と結果の表示
pictureFiltered = ...
    uint8(filter2(unsharpMask,pictureGray));
figure(2)
imshowcq(pictureFiltered)
title('After filtering (unsharp)')

% end 
