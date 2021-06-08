% practice06_2.m
%
% $Id: practice06_2_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �Ԉ�����
% �����̊Ԉ�����
hDecFactor = 2;
% �����̊Ԉ�����
vDecFactor = 2;
% �S�Ԉ�����
decFactor = hDecFactor * vDecFactor;

%% �摜�̓Ǎ��ƋP�x�l�̒��o
pictureRgb = imread('./data/barbaraFaceRgb.tif');
pictureGray = rgb2gray(pictureRgb);
clear pictureRgb

%% ���ϑ���ɂ��k������
clear pictureGrayDecimated
sizeNew = ceil(size(pictureGray) ./ [vDecFactor hDecFactor]);
pictureGrayDecimated = imresize(pictureGray,sizeNew,'box');

%% ���摜�\��
figure(1)
imshow(pictureGray)
title('Original picture')

%% �k���摜�\��
figure(2)
imshow(pictureGrayDecimated)
title('Decimated picture')

% end
