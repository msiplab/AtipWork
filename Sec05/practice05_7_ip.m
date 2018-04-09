% practice05_7.m
%
% $Id: practice05_7_ip.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% ���̓t�@�C��
fileNameIn = './tmp/mobile.avi';
vrObj = VideoReader(fileNameIn);
frameRate = vrObj.FrameRate;

%% �o�̓t�@�C��
fileNameOut = './tmp/mobileFiltered.avi';
vwObj = VideoWriter(fileNameOut,'Uncompressed AVI');
vwObj.FrameRate = frameRate;

%% �t���[���ԍ�����Βl��������
picturePre = rgb2gray(readFrame(vrObj));

%% �t���[���ԍ�����Βl����
open(vwObj)
while(hasFrame(vrObj))
    % ���t���[���̓Ǐo��
    pictureCur = rgb2gray(readFrame(vrObj));
    % �t�B���^����
    pictureFiltered = imabsdiff(pictureCur,picturePre);
    % �����t���[���̏o��
    writeVideo(vwObj,pictureFiltered);
    % �O�t���[���̍X�V
    picturePre = pictureCur;
end
close(vwObj)

% end 
