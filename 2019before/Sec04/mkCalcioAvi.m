%
% $Id:$
%
% Copyright (C) 2014-2015 Shogo MURAMATSU, All rights reserved
%
nFrames = 150;
frameRate = 30;

%% �o�̓t�@�C��
fileNameOut = './data/calcio.avi';
vwObj = VideoWriter(fileNameOut,'Uncompressed AVI');
set(vwObj,'FrameRate',frameRate);
open(vwObj)

%% �t���[�����̏���
for iFrame = 1:nFrames
    % �t���[���̓Ǐo��
    fileNameIn = sprintf('./data/calcio%03d.jpg', ...
        iFrame - 1);
    picture = imread(fileNameIn);
    % �t���[���̏o��
    writeVideo(vwObj,im2frame(picture));
end
close(vwObj)
