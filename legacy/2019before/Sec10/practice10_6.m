% practice10_6.m
%
% $Id: practice10_6.m,v 1.3 2007/05/07 11:09:47 sho Exp $
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

%% 現フレームの表示
%（動きベクトル場が見やすいよう加工）
imshowcq((double(currentFrame)/510+.5).^.25)
hold on

%% 動きベクトル場の表示
[n0,n1] = ndgrid(...
    me.mbSize(1)/2:me.mbSize(1):me.frameSize(1),...
    me.mbSize(2)/2:me.mbSize(2):me.frameSize(2));
d0 = mvField(:,:,1);
d1 = mvField(:,:,2);
quiver(n1,n0,-d1,-d0,...
   'LineWidth',2) % 対応ベクトルを反転表示
hold off



