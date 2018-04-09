% practice05_8.m
%
% $Id: practice05_8_ip.m,v 1.3 2007/05/14 21:39:03 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �}�X�N�̐ݒ�
sizeMask = 3;
aveMask = fspecial('average',sizeMask);

%% ���摜�̓ǂݍ��݂ƕ\��
pictureRgb = imread('./data/barbaraFaceRgb.tif');
figure(1)
imshow(pictureRgb)
title('Original')

%% �t�B���^�����i��l�g���j�ƌ��ʂ̕\��
pictureFilteredZp = imfilter(pictureRgb,aveMask);
figure(2)
imshow(pictureFilteredZp)
title('After filtering (zero padding)')

%% �t�B���^�����i�����g���j�ƌ��ʂ̕\��
pictureFilteredPe = imfilter(pictureRgb,aveMask,'circular');
figure(3)
imshow(pictureFilteredPe)
title('After filtering (periodic extension)')

%% �t�B���^�����i�Ώ̊g���j�ƌ��ʂ̕\��
pictureFilteredSe = imfilter(pictureRgb,aveMask,'symmetric');
figure(4)
imshow(pictureFilteredSe)
title('After filtering (symmetric extension)')

% end 
