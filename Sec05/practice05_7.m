% practice05_7.m
%
% $Id: practice05_7.m,v 1.3 2007/05/16 07:23:59 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% ���̓t�@�C��
fileNameIn = './data/calcio.avi';
vrObj = VideoReader(fileNameIn);
frameRate = vrObj.FrameRate;

%% �o�̓t�@�C��
fileNameOut = './tmp/calcioFiltered.avi';
vwObj = VideoWriter(fileNameOut,'Uncompressed AVI');
vwObj.FrameRate = frameRate;

% �t���[���ԍ�����Βl��������
framePre = readFrame(vrObj);
picturePre = rgb2graycq(framePre);

% �t���[���ԍ�����Βl����
open(vwObj)
while(hasFrame(vrObj))
    % ���t���[���̓Ǐo��
    frameCur = readFrame(vrObj);
    pictureCur = rgb2graycq(frameCur);
    % �t�B���^����
    pictureFiltered = uint8(...
        0.5*(double(pictureCur)+double(picturePre)));
    %pictureFiltered = uint8(...
    %    abs(double(pictureCur)-double(picturePre)));
    % �����t���[���̏o��
    writeVideo(vwObj,pictureFiltered);
    % �O�t���[���̍X�V
    picturePre = pictureCur;
end
close(vwObj)

% end 
