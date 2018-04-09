% practice06_3.m
%
% $Id: practice06_3_ip.m,v 1.4 2007/07/07 01:06:38 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% ��ԗ�
% �����̕�ԗ�
hIntFactor = 2;
% �����̕�ԗ�
vIntFactor = 2;
% �S�Ԉ�����
intFactor = hIntFactor * vIntFactor;

%% �摜�̓Ǎ��ƋP�x�l�̒��o
pictureRgb = imread('./data/boatsBackRgb.tif');
pictureGray = rgb2gray(pictureRgb);
clear pictureRgb;

%% �뎟�z�[���h�ɂ��g�又��
sizeNew = size(pictureGray).*[vIntFactor hIntFactor];
pictureGrayIntpd = imresize(pictureGray, sizeNew, 'nearest');

%% ���摜�\��
figure(1)
imshow(pictureGray)
title('Original picture')

%% �g��摜�\��
figure(2)
imshow(pictureGrayIntpd)
title('Interpolated picture')

% end
