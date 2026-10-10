% practice05_2.m
%
% $Id: practice05_2.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 原画像の読み込みと表示
pictureRgb = imread('./data/firenzeRgb.jpg');
pictureGray = rgb2graycq(pictureRgb);
figure(1)
imshowcq(pictureGray)
title('Original')

%% ノイズが加わった画像の読み込みと表示
pictureNoisy = imread('./data/firenzeNoisy.jpg');
figure(2)
imshowcq(pictureNoisy)
title('Before filtering')

%% フィルタ処理と結果の表示
[nRows, nCols] = size(pictureNoisy);
% 境界部に零値を挿入
pictureNoisy = [zeros(nRows,1) pictureNoisy zeros(nRows,1)];
pictureNoisy = [zeros(1,nCols+2) ; pictureNoisy ; zeros(1,nCols+2)];
% フィルタ処理
pictureMedian = zeros(nRows,nCols,'like',pictureNoisy);
pictureMax = zeros(nRows,nCols,'like',pictureNoisy);
pictureMin = zeros(nRows,nCols,'like',pictureNoisy);
for iCol = 1:nCols
    for iRow = 1:nRows
        % 3x3 領域の切り出し(水平垂直の１画素のずれに注意）
        subDomain = pictureNoisy(iRow:iRow+2, iCol:iCol+2);
        % 中央値, 最大値, 最小値）の出力
        pictureMedian(iRow,iCol) = median(subDomain(:));
        pictureMax(iRow,iCol) = max(subDomain(:));
        pictureMin(iRow,iCol) = min(subDomain(:));
    end
end
figure(3)
imshowcq(pictureMedian)
title('After filtering (median)')

figure(4)
imshowcq(pictureMax)
title('After filtering (max)')

figure(5)
imshowcq(pictureMin)
title('After filtering (min)')

% end 
