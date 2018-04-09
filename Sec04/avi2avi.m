%
% $Id:$
%
% Copyright (C) 2014-2015 Shogo MURAMATSU, All rights reserved
%

%% 入力ファイル
videoReader = VideoReader('./data/calcio.avi');
nFrames     = videoReader.CurrentTime;
frameRate   = videoReader.FrameRate;

%% 出力ファイル
videoWriter  = VideoWriter('./tmp/calcioOut.avi','Uncompressed AVI');
videoWriter.FrameRate = frameRate;
open(videoWriter)

% フレーム毎の処理
for iFrame = 1:nFrames
    % フレームの読出し
    pictureIn = readFrame(videoReader,iFrame);
    % フレーム処理
    pictureOut = rgb2gray(pictureIn);
    % フレームの出力
    writeVideo(videoWriter,pictureOut);
end
close(videoWriter);
