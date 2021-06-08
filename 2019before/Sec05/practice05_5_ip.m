% practice05_5.m
%
% $Id: practice05_5_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �}�X�N�̐ݒ�
prewittMask = fspecial('prewitt');
             
%% ���摜�̓ǂݍ��݂ƕ\��
pictureRgb = imread('./data/firenzeRgb.jpg');
pictureGray = im2double(rgb2gray(pictureRgb));
figure(1)
imshow(pictureGray)
title('Original')

%% �t�B���^�����ƌ��ʂ̕\��
pictureVerFiltered = ...
    imfilter(pictureGray,prewittMask);
pictureHorFiltered = ...
    imfilter(pictureGray, prewittMask.');
pictureFiltered = abs(pictureVerFiltered) + abs(pictureHorFiltered);
figure(2)
imshow(pictureFiltered)
title('After filtering (prewitt)')

%% ��l�������ƌ��ʂ̕\��
pictureBinary = im2bw(pictureFiltered);
figure(3)
imshow(pictureBinary)
title('After filtering (binary)')

%% ��l�������ƌ��ʂ̕\��
pictureEdge = edge(pictureGray,'prewitt');
figure(4)
imshow(pictureEdge)
title('After edge detection')

% end 
