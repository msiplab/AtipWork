% practice10_1.m
%
% $Id: practice10_1.m,v 1.9 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 速度ベクトル（垂直、水平）
velocity = [0 0];

%% mobile.avi に対する処理の場合 true 
isMobileAvi = false;

if isMobileAvi
    vrObj = VideoReader('tmp/mobile.avi'); % mobile.avi は例題4.9で生成
    nFramesIn = [];
    frameRateIn = vrObj.FrameRate;
    height = vrObj.Height;
    width  = vrObj.Width;
    frameSize = [height width];
else
    % インタレース映像モデルの生成
    frameSeq = mkInterlacedMov(velocity);
    nFramesIn = length(frameSeq);
    frameRateIn = 30;
    frameSize = size(frame2im(frameSeq(1)));
end

%% VideoWriter オブジェクトの生成
outputFileName = 'tmp/tempip.avi';
frameRateOut = 2 * frameRateIn;
nFrameOut = 2 * nFramesIn;
vwObj = VideoWriter(outputFileName,'Uncompressed AVI');
vwObj.FrameRate = frameRateOut;
me.frameSize = frameSize;

%% 時間方向補間IP変換
deintPicture0 = 128*ones(frameSize,'uint8');
deintPicture1 = 128*ones(frameSize,'uint8');
previousField = 128*ones(frameSize./[2 1],'uint8');
iFrame = 1;
hasFrame_ = true;
open(vwObj)
while(hasFrame_)
    if isMobileAvi
        pictureI  = rgb2graycq(readFrame(vrObj));
        hasFrame_ = hasFrame(vrObj);
    else
        pictureI  = frame2im(frameSeq(iFrame));
        iFrame    = iFrame + 1;
        hasFrame_ = (iFrame < nFramesIn);
    end
    % Process for picture0
    deintPicture0(1:2:end,:) = previousField;
    deintPicture0(2:2:end,:) = pictureI(2:2:end,:);
    % Process for picture1
    deintPicture1 = pictureI;
    previousField = pictureI(1:2:end,:);
    %
    % Output to avi file
    writeVideo(vwObj, deintPicture0);
    writeVideo(vwObj, deintPicture1);
end
close(vwObj)

%
