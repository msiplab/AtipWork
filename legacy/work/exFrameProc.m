% フレーム処理スクリプトの雛形
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
