%
% $Id: exAviFile.m,v 1.4 2006/05/29 12:08:53 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%
frameSizeY = [288 352];
frameSizeC = [144 176];
frameRate = 30; 
nFrames = 300;
nPixelsY = prod(frameSizeY);
nPixelsC = prod(frameSizeC);
precision = 'uint8=>uint8';
fileId = fopen('../data/mobile.cif','r');
clear pictureYCbCr;
% VidwoWriter オブジェクトの生成
vwObj = VideoWriter('../tmp/mobile.avi');
set(vwObj,'FrameRate',frameRate);

%AVIファイル生成
open(vwObj);
for iFrame = 1:nFrames
   % 輝度(Y)成分を列ベクトルとして読込
   pictureTpd= ...
      fread(fileId, nPixelsY, precision);
   % 転置に注意して配列化
   pictureYCbCr(:,:,1) = ...
      reshape(pictureTpd,...
              frameSizeY(2), frameSizeY(1)).';
   for iCmp = 2:3
      % 色差（Cb,Cr）成分を列ベクトルとして読込
      pictureTpd = ...
         fread(fileId, nPixelsC, precision);
      % 転置に注意して配列化
      pictureC = reshape(pictureTpd, ...
         frameSizeC(2), frameSizeC(1)).'; 
      % 縦横それぞれ2倍に拡大(Image Proc. TB)
      pictureYCbCr(:,:,iCmp) = imresize(pictureC,2);
   end
   % YCbCrをRGBへ変換
   pictureRgb = ycbcr2rgb(pictureYCbCr);
   % フレームの追加
   writeVideo(vwObj, pictureRgb);
end
close(vwObj);
fclose(fileId);