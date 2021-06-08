% practice06_1.m
%
% $Id: practice06_1.m,v 1.2 2007/05/07 11:09:47 sho Exp $
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
pictureGray = rgb2graycq(pictureRgb);
clear pictureRgb;

%% �Ԉ�������
pictureGrayDownsampled = pictureGray(...
            1:verticalDecFactor:end,...
            1:horizontalDecFactor:end);
% pictureGrayDownsampled = ...
%     downsample(downsample(pictureGray,...
%                           vDecFactor).',...
%                hDecFactor).';

%% ���摜�̕\��
figure(1)
imshowcq(pictureGray)
title('Original picture')

%% �Ԉ���������̉摜�̕\��
figure(2)
imshowcq(pictureGrayDownsampled)
title('Downsampled picture')

% end
