% practice06_1.m
%
% $Id: practice06_1_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �Ԉ�����
% �����̊Ԉ�����
horizontalDecFactor = 2;
% �����̊Ԉ�����
verticalDecFactor = 2;

%% �摜�̓Ǎ�
pictureRgb = imread('./data/barbaraFaceRgb.tif');
pictureGray = rgb2gray(pictureRgb);
clear pictureRgb;

%% �Ԉ�������
sizeNew = ceil(size(pictureGray) ./ ...
           [verticalDecFactor horizontalDecFactor]);
%pictureGrayDownsampled = imresize(pictureGray,sizeNew);
pictureGrayDownsampled = imresize_old(pictureGray,sizeNew);

% ���摜�̕\��
figure(1)
imshow(pictureGray)
title('Original picture')

% �Ԉ���������̉摜�̕\��
figure(2)
imshow(pictureGrayDownsampled)
title('Downsampled picture')

% end
