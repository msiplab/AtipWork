%
% $Id: exAviEdge.m,v 1.2 2006/05/29 12:08:53 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%
fileNameIn  = 'shuttle.avi';
fileNameOut = '../tmp/output.avi';

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
   pictureOut = double(edge(rgb2gray(pictureIn))); 
   
   %�t���[���̏�����
   writeVideo(vwObj,pictureOut);
end
close(vwObj);