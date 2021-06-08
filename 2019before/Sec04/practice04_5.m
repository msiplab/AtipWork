% practice04_5.m
%
% $Id: practice04_5.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%
parameterGamma = 0.25;

%% �摜�t�@�C���̓Ǎ�
pictureRgb = imread('./data/firenzeRgb.jpg');

%% ���m�N���摜�ւ̕ϊ�
pictureGray = rgb2graycq(pictureRgb);

%% double �^�ւ̕ϊ�
pictureGrayDouble = ...
    double(pictureGray)/255.0;

%% �ݏ摥�ϊ�
pictureCorrected = ...
    pictureGrayDouble.^parameterGamma;

%% ���摜�i���m�N���j�̕\��
figure(1)
imshowcq(pictureGrayDouble)
title('Before correction')

%% �����摜�̕\��
figure(2)
imshowcq(pictureCorrected)
title('After correction')

% end
