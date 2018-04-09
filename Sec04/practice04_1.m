% practice04_1.m
%
% $Id: practice04_1.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 画像の高さと幅
nRows = 612;
nCols = 816;

%% logical バイナリ画像
pictureBinary = false(nRows,nCols);

%% uint8 モノクロ画像
pictureGray = zeros(nRows,nCols,'uint8');

%% double モノクロ画像
pictureGrayDouble = zeros(nRows,nCols,'double');

%% uint8 カラー画像
pictureRgb = zeros(nRows,nCols,3,'uint8');

%% double カラー画像
pictureRgbDouble = zeros(nRows,nCols,3,'double');

%% 容量の比較
clear nRows nCols
whos pictureBinary pictureGray pictureGrayDouble ...
    pictureRgb pictureRgbDouble

% end 
