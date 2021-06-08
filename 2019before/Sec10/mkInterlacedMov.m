function frameSeq = mkInterlacedMov(velocity)
%
% $Id: mkInterlacedMov.m,v 1.4 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

% 静止画像の読込
pictureObj = imread('./data/squareandgauss.tif');
pictureBg = imread('./data/background.tif');

% インタレース映像の生成
nFrames = 16;
pictureI = zeros(size(pictureObj),'uint8');
for iFrame = 1:nFrames
    pictureObj = circshift(pictureObj, velocity);
    picture = pictureObj + ...
        uint8(not(pictureObj)) .* pictureBg;
    pictureI(2:2:end,:) = picture(2:2:end,:);
    pictureObj = circshift(pictureObj, velocity);
    picture = pictureObj + ...
        uint8(not(pictureObj)) .* pictureBg;    
    pictureI(1:2:end,:) = picture(1:2:end,:);
    frameSeq(iFrame) = im2frame(pictureI,gray(256));  
end