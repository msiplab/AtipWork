%
% $Id: exFread.m,v 1.2 2006/05/29 12:08:53 sho Exp $
%
% Copyright (C) 2005-2006 Shogo MURAMATSU, All rights reserved
%

% �摜�T�C�Y �����~��
frameSize = [612 816];
nPixels = prod(frameSize);
% �Ǎ����x�� uint8 ��
precision = 'uint8=>uint8';
% �Ǎ����[�h'r'�ɂăt�@�C�����I�[�v��
fileId = fopen('firenze.yyy', 'r');
% �摜�f�[�^���x�N�g���Ƃ��ēǍ���
pictureGray = fread(fileId, nPixels, precision);
fclose(fileId);
% ��x�N�g����z��ɕϊ�
pictureGray = reshape(pictureGray, frameSize);
%
imshow(pictureGray);
%
% end
