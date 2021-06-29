%
% $Id: exAviEdge.m,v 1.2 2006/05/29 12:08:53 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%
fileNameIn  = 'shuttle.avi';
fileNameOut = '../tmp/output.avi';

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
   pictureOut = double(edge(rgb2gray(pictureIn))); 
   
   %フレームの書込み
   writeVideo(vwObj,pictureOut);
end
close(vwObj);