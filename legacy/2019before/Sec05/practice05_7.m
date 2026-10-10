% practice05_7.m
%
% $Id: practice05_7.m,v 1.3 2007/05/16 07:23:59 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 入力ファイル
fileNameIn = './data/calcio.avi';
vrObj = VideoReader(fileNameIn);
frameRate = vrObj.FrameRate;

%% 出力ファイル
fileNameOut = './tmp/calcioFiltered.avi';
vwObj = VideoWriter(fileNameOut,'Uncompressed AVI');
vwObj.FrameRate = frameRate;

% フレーム間差分絶対値処理準備
framePre = readFrame(vrObj);
picturePre = rgb2graycq(framePre);

% フレーム間差分絶対値処理
open(vwObj)
while(hasFrame(vrObj))
    % 現フレームの読出し
    frameCur = readFrame(vrObj);
    pictureCur = rgb2graycq(frameCur);
    % フィルタ処理
    pictureFiltered = uint8(...
        0.5*(double(pictureCur)+double(picturePre)));
    %pictureFiltered = uint8(...
    %    abs(double(pictureCur)-double(picturePre)));
    % 処理フレームの出力
    writeVideo(vwObj,pictureFiltered);
    % 前フレームの更新
    picturePre = pictureCur;
end
close(vwObj)

% end 
