% practice05_4.m
%
% $Id: practice05_4_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �}�X�N�̐ݒ�
alpha = 0.0;
unsharpMask = fspecial('unsharp',alpha);

%% ���摜�̓ǂݍ��݂ƕ\��
pictureRgb = imread('./data/firenzeRgb.jpg');
pictureGray = im2double(rgb2gray(pictureRgb));
figure(1)
imshow(pictureGray)
title('Original')

%% �t�B���^�����ƌ��ʂ̕\��
pictureUnsharped = ...
    imfilter(pictureGray,unsharpMask);
figure(2)
imshow(pictureUnsharped)
title('After filtering (unsharp)')

% end 
