% practice06_3.m
%
% $Id: practice06_3.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 補間率
% 水平の補間率
hIntFactor = 2;
% 垂直の補間率
vIntFactor = 2;
% 全間引き率
intFactor = hIntFactor * vIntFactor;

%% 画像の読込と輝度値の抽出
pictureRgb = imread('./data/boatsBackRgb.tif');
pictureGray = rgb2graycq(pictureRgb);
clear pictureRgb;

%% 零次ホールドによる拡大処理
pictureGrayIntpd = ...
    zeros(size(pictureGray).*[vIntFactor hIntFactor],'uint8');
for iSubRow = 1:vIntFactor
    for iSubCol = 1:hIntFactor
        pictureGrayIntpd(...
            iSubRow:vIntFactor:end,...
            iSubCol:hIntFactor:end) = pictureGray;
    end    
end

%% 原画像表示
figure(1)
imshowcq(pictureGray)
title('Original picture')

%% 拡大画像表示
figure(2)
imshowcq(pictureGrayIntpd)
title('Interpolated picture')

% end
