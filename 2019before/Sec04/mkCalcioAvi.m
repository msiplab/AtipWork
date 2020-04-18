%
% $Id:$
%
% Copyright (C) 2014-2015 Shogo MURAMATSU, All rights reserved
%
nFrames = 150;
frameRate = 30;

%% 出力ファイル
fileNameOut = './data/calcio.avi';
vwObj = VideoWriter(fileNameOut,'Uncompressed AVI');
set(vwObj,'FrameRate',frameRate);
open(vwObj)

%% フレーム毎の処理
for iFrame = 1:nFrames
    % フレームの読出し
    fileNameIn = sprintf('./data/calcio%03d.jpg', ...
        iFrame - 1);
    picture = imread(fileNameIn);
    % フレームの出力
    writeVideo(vwObj,im2frame(picture));
end
close(vwObj)
