% �t���[�������X�N���v�g�̐��`
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
