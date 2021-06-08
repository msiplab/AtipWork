% practice05_1.m
%
% $Id: practice05_1_ip.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �}�X�N�̐ݒ�
sizeMask = [3 3];
movAveMask = fspecial('average',sizeMask);

sigma = 0.6;
gausMask = fspecial('gaussian',sizeMask,sigma);

%% ���摜�̓ǂݍ��݂ƕ\��
pictureRgb = imread('./data/firenzeRgb.jpg');
pictureGray = rgb2gray(pictureRgb);
figure(1)
imshow(pictureGray)
title('Original')

%% �m�C�Y����������摜�̐����ƕ\��
noiseDensity = 0.02;
pictureNoisy = imnoise(pictureGray,'salt & pepper', noiseDensity);
figure(2)
imshow(pictureNoisy)
title('Before filtering')

%% �t�B���^����
pictureFiltered = imfilter(pictureNoisy,movAveMask);
figure(3)
imshow(pictureFiltered)
title('After filtering (average)')

%% �t�B���^����
pictureFiltered = imfilter(pictureNoisy,gausMask);
figure(4)
imshow(pictureFiltered)
title('After filtering (gaussian)')

% end 
