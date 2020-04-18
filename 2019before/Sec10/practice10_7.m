% practice10_7.m
%
% $Id: practice10_7.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 速度ベクトル（垂直、水平）
velocity = [2 2]; 

%% 探索パラメータ（構造体に保持）
me.mbSize = [16 16]; % ブロックサイズ
me.searchRegion = ...
    [ -7 7 ... % 探索範囲（垂直）
    -7 7 ];  % 探索範囲（水平）

%% フレーム画像の準備
pictureObj = imread('./data/squareandgauss.tif');
pictureBg = imread('./data/background.tif');

%% 参照フレームの設定
referenceFrame = pictureObj + ...
    uint8(not(pictureObj)) .* pictureBg; 

%% 現フレームの設定
pictureObj = circshift(pictureObj, velocity); 
currentFrame = pictureObj + ...
    uint8(not(pictureObj)) .* pictureBg;
me.frameSize = size(currentFrame); % フレームサイズ

%% 動きベクトル場の推定
mvField = fullSearchBlockMatchingMe(...
    referenceFrame, currentFrame, me);

%% 動き補償予測
predictedFrame = mcPrediction(...
    referenceFrame, mvField, me);

%% 現フレームの表示
figure(1)
imshowcq(currentFrame)
title('Current frame')

%% 動き補償予測フレームの表示
figure(2)
imshowcq(predictedFrame)
title('Predicted frame')

%% 差分の表示
figure(3)
imshowcq(16*abs(currentFrame-predictedFrame))
title('Difference')
