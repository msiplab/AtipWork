%
% $Id: exFrameAve.m,v 1.2 2006/05/29 12:08:53 sho Exp $
%
% Copyright (C) 2005-2006 Shogo MURAMATSU, All rights reserved
%


% 入出力ファイル名
fileNameIn  = 'shuttle.avi';
fileNameOut = 'output.avi';

%VideoReaderオブジェクトの生成
vrObj = VideoReader(fileNameIn);
frameRate = get(vrObj,'FrameRate');

%VideoWriterオブジェクトの生成
vwObj = VideoWriter(fileNameOut,'Uncompressed AVI');
set(vwObj,'FrameRate',frameRate);

%映像処理
open(vwObj)
while(hasFrame(vrObj))
   %フレームの読込み
   pictureIn = readFrame(vrObj);

   %フレーム処理
   pictureOut = pictureIn; % 処理を挿入！

   %フレームの書込み
   writeVideo(vwObj,pictureOut);
end
close(vwObj);

% フレーム間平均処理準備
framePre = aviread(fileNameIn,1);
picturePre = framePre.cdata;

% フレーム間平均処理
for iFrame = 1:nFrames
    % 現フレームの読出し
    frameCur = aviread(fileNameIn,iFrame);
    pictureCur = frameCur.cdata;
    % フィルタ処理
    pictureFiltered = uint8(...
        0.5*(double(picturePre)+double(pictureCur)));
    % 処理フレームの出力
    frameCur.cdata = pictureFiltered;
    aviObj = addframe(aviObj,frameCur);
    % 前フレームの更新
    picturePre = pictureCur;
end;
aviObj = close(aviObj);

% end 
