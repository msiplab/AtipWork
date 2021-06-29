% practice05_3.m
%
% $Id: practice05_3_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �}�X�N�̐ݒ�
alpha = 0.0;
laplacianMask = fspecial('laplacian',alpha);

%% ���摜�̓ǂݍ��݂ƕ\��
pictureRgb = imread('./data/firenzeRgb.jpg');
pictureGray = im2double(rgb2gray(pictureRgb));
figure(1)
imshow(pictureGray)
title('Original')

%% �t�B���^�����ƌ��ʂ̕\��
pictureFiltered = ...
    imfilter(pictureGray,laplacianMask) + 0.5;
figure(2)
imshow(pictureFiltered)
title('After filtering (laplacian)')

% end 
