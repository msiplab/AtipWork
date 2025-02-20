% practice06_11.m
%
% $Id: practice06_11_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% パラメータ設定
% 補間率
uFactor = 5;
% 間引き率
dFactor = 6;

%% 入力ファイル
fileNameIn = './data/calcio.avi';
vrObj = VideoReader(fileNameIn);
frameRateIn = vrObj.FrameRate;
fprintf('入力フレームレート: %f [fps]\n',frameRateIn);

%% 出力ファイル
fileNameOut = './tmp/calcioFps25.avi';
frameRateOut = frameRateIn * uFactor / dFactor;
vwObj = VideoWriter(fileNameOut,'Uncompressed AVI');
vwObj.FrameRate = frameRateOut;

%% フレーム処理
open(vwObj)
while(hasFrame(vrObj)) %for iFrame = 1:dFactor:nFrames
    % フレームの読出し(Input phase 0)
    pictureCur = readFrame(vrObj);

    % フレームの出力(Output phase 0)
    pictureOut = pictureCur; % 重み 1
    writeVideo(vwObj,pictureOut);

    % フレームの読出し(Input phase 1)
    picturePre = readFrame(vrObj);

    % フレームの読出し(Input phase 2)
    pictureCur = readFrame(vrObj);

    % フレームの出力(Output phase 1)
    pictureOut = imlincomb(7/8, picturePre, 1/8, pictureCur);
    writeVideo(vwObj,pictureOut);

    % フレームの読出し(Input phase 3)
    picturePre = pictureCur;
    pictureCur = readFrame(vrObj);

    % フレームの出力(Output phase 2)
    pictureOut = imlincomb(5/8, picturePre, 3/8, pictureCur);
    writeVideo(vwObj,pictureOut);        
    
    % フレームの読出し(Input phase 4)
    picturePre = pictureCur;
    pictureCur = readFrame(vrObj);

    % フレームの出力(Output phase 3)
    pictureOut = imlincomb(3/8, picturePre, 5/8, pictureCur);
    writeVideo(vwObj,pictureOut);        
    
    % フレームの読出し(Input phase 5)
    picturePre = pictureCur;
    pictureCur = readFrame(vrObj);

    % フレームの出力(Output phase 4)
    pictureOut = imlincomb(1/8, picturePre, 7/8, pictureCur);
    writeVideo(vwObj,pictureOut);

end
close(vwObj)

fprintf('出力フレームレート: %f [fps]\n',vwObj.FrameRate);

% end 
