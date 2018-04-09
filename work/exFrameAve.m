%
% $Id: exFrameAve.m,v 1.2 2006/05/29 12:08:53 sho Exp $
%
% Copyright (C) 2005-2006 Shogo MURAMATSU, All rights reserved
%


% ���o�̓t�@�C����
fileNameIn  = 'shuttle.avi';
fileNameOut = 'output.avi';

%VideoReader�I�u�W�F�N�g�̐���
vrObj = VideoReader(fileNameIn);
frameRate = get(vrObj,'FrameRate');

%VideoWriter�I�u�W�F�N�g�̐���
vwObj = VideoWriter(fileNameOut,'Uncompressed AVI');
set(vwObj,'FrameRate',frameRate);

%�f������
open(vwObj)
while(hasFrame(vrObj))
   %�t���[���̓Ǎ���
   pictureIn = readFrame(vrObj);

   %�t���[������
   pictureOut = pictureIn; % ������}���I

   %�t���[���̏�����
   writeVideo(vwObj,pictureOut);
end
close(vwObj);

% �t���[���ԕ��Ϗ�������
framePre = aviread(fileNameIn,1);
picturePre = framePre.cdata;

% �t���[���ԕ��Ϗ���
for iFrame = 1:nFrames
    % ���t���[���̓Ǐo��
    frameCur = aviread(fileNameIn,iFrame);
    pictureCur = frameCur.cdata;
    % �t�B���^����
    pictureFiltered = uint8(...
        0.5*(double(picturePre)+double(pictureCur)));
    % �����t���[���̏o��
    frameCur.cdata = pictureFiltered;
    aviObj = addframe(aviObj,frameCur);
    % �O�t���[���̍X�V
    picturePre = pictureCur;
end;
aviObj = close(aviObj);

% end 
