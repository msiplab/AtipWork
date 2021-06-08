% practice06_2.m
%
% $Id: practice06_2.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 間引き率
% 水平の間引き率
hDecFactor = 2;
% 垂直の間引き率
vDecFactor = 2;
% 全間引き率
decFactor = hDecFactor * vDecFactor;

%% 画像の読込と輝度値の抽出
pictureRgb = imread('./data/barbaraFaceRgb.tif');
pictureGray = rgb2graycq(pictureRgb);
clear pictureRgb

%% 画像サイズの抽出
nRows = size(pictureGray,1);
nCols = size(pictureGray,2);

%% 平均操作による縮小処理
sizeExt = ceil(size(pictureGray) ./ [vDecFactor hDecFactor]) ...
    .* [vDecFactor hDecFactor];
pictureGrayExt = zeros(sizeExt);
pictureGrayExt(1:nRows,1:nCols) = pictureGray;
pictureGrayAcc = 0;
for iSubRow = 1:vDecFactor
   for iSubCol = 1:hDecFactor
      pictureGrayAcc = pictureGrayAcc + ...
          double(pictureGrayExt(iSubRow:vDecFactor:end,...
                                iSubCol:hDecFactor:end));
   end  
end
pictureGrayDecimated = uint8( pictureGrayAcc / decFactor );

%% 原画像表示
figure(1)
imshowcq(pictureGray)
title('Original picture')

%% 縮小画像表示
figure(2)
imshowcq(pictureGrayDecimated)
title('Decimated picture')

% end
