%
% $Id:$
%
% Copyright (C) 2014-2015 Shogo MURAMATSU, All rights reserved
%

%% ���̓t�@�C��
videoReader = VideoReader('./data/calcio.avi');
nFrames     = videoReader.CurrentTime;
frameRate   = videoReader.FrameRate;

%% �o�̓t�@�C��
videoWriter  = VideoWriter('./tmp/calcioOut.avi','Uncompressed AVI');
videoWriter.FrameRate = frameRate;
open(videoWriter)

% �t���[�����̏���
for iFrame = 1:nFrames
    % �t���[���̓Ǐo��
    pictureIn = readFrame(videoReader,iFrame);
    % �t���[������
    pictureOut = rgb2gray(pictureIn);
    % �t���[���̏o��
    writeVideo(videoWriter,pictureOut);
end
close(videoWriter);
