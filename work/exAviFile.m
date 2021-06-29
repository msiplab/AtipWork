%
% $Id: exAviFile.m,v 1.4 2006/05/29 12:08:53 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%
frameSizeY = [288 352];
frameSizeC = [144 176];
frameRate = 30; 
nFrames = 300;
nPixelsY = prod(frameSizeY);
nPixelsC = prod(frameSizeC);
precision = 'uint8=>uint8';
fileId = fopen('../data/mobile.cif','r');
clear pictureYCbCr;
% VidwoWriter �I�u�W�F�N�g�̐���
vwObj = VideoWriter('../tmp/mobile.avi');
set(vwObj,'FrameRate',frameRate);

%AVI�t�@�C������
open(vwObj);
for iFrame = 1:nFrames
   % �P�x(Y)�������x�N�g���Ƃ��ēǍ�
   pictureTpd= ...
      fread(fileId, nPixelsY, precision);
   % �]�u�ɒ��ӂ��Ĕz��
   pictureYCbCr(:,:,1) = ...
      reshape(pictureTpd,...
              frameSizeY(2), frameSizeY(1)).';
   for iCmp = 2:3
      % �F���iCb,Cr�j�������x�N�g���Ƃ��ēǍ�
      pictureTpd = ...
         fread(fileId, nPixelsC, precision);
      % �]�u�ɒ��ӂ��Ĕz��
      pictureC = reshape(pictureTpd, ...
         frameSizeC(2), frameSizeC(1)).'; 
      % �c�����ꂼ��2�{�Ɋg��(Image Proc. TB)
      pictureYCbCr(:,:,iCmp) = imresize(pictureC,2);
   end
   % YCbCr��RGB�֕ϊ�
   pictureRgb = ycbcr2rgb(pictureYCbCr);
   % �t���[���̒ǉ�
   writeVideo(vwObj, pictureRgb);
end
close(vwObj);
fclose(fileId);