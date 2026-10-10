% practice05_7.m
%
% $Id: practice05_7_ip.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 入力ファイル
fileNameIn = './tmp/mobile.avi';
vrObj = VideoReader(fileNameIn);
frameRate = vrObj.FrameRate;

%% 出力ファイル
fileNameOut = './tmp/mobileFiltered.avi';
vwObj = VideoWriter(fileNameOut,'Uncompressed AVI');
vwObj.FrameRate = frameRate;

%% フレーム間差分絶対値処理準備
picturePre = rgb2gray(readFrame(vrObj));

%% フレーム間差分絶対値処理
open(vwObj)
while(hasFrame(vrObj))
    % 現フレームの読出し
    pictureCur = rgb2gray(readFrame(vrObj));
    % フィルタ処理
    pictureFiltered = imabsdiff(pictureCur,picturePre);
    % 処理フレームの出力
    writeVideo(vwObj,pictureFiltered);
    % 前フレームの更新
    picturePre = pictureCur;
end
close(vwObj)

% end 
