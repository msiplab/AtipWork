% practice04_6.m
%
% $Id: practice04_6.m,v 1.4 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 画像ファイルの読込
pictureRgb = imread('./data/firenzeRgb.jpg');

%% モノクロ画像への変換
pictureGray = rgb2graycq(pictureRgb);

%% 階調数の設定
nGrayLevels = 256; % 符号無し8bit整数

%% 処理前の画像の表示
subplot(2,2,1);
imshowcq(pictureGray);
title('Before histgram equalization');

%% 処理前のヒストグラムの解析
hx = histc(pictureGray(:),0:nGrayLevels-1);

%% 処理前のヒストグラムの表示
subplot(2,2,2);
stem(0:nGrayLevels-1,hx,'Marker','none');
axis([0 nGrayLevels 0 10000]);
title('Before histgram equalization');

%% 正規化ヒストグラムの計算
nPixels = numel(pictureGray);
px = hx/nPixels;

%% 変換表の作成
lut = double([]);
lut(1) = px(1);
for iGrayLevel = 1:nGrayLevels-1
    lut(iGrayLevel+1) = lut(iGrayLevel)+px(iGrayLevel+1);
end
lutUint8 = uint8((nGrayLevels-1)*lut);

%% ヒストグラム均等化
[nRows, nCols] = size(pictureGray);
pictureHistEqd = uint8([]);
for iCol = 1:nCols
    for iRow = 1:nRows
        pictureHistEqd(iRow,iCol) = ...
            uint8(lutUint8(pictureGray(iRow,iCol)+1));
    end
end

%% 処理後のヒストグラムの解析
hy = histc(pictureHistEqd(:),0:nGrayLevels-1);

%% 処理後の画像の表示
subplot(2,2,3);
imshowcq(pictureHistEqd);
title('After histgram equalization');

%% 処理後のヒストグラムの表示
subplot(2,2,4);
stem(0:nGrayLevels-1,hy,'Marker','none');
axis([0 nGrayLevels 0 10000]);
title('After histgram equalization');

% end
