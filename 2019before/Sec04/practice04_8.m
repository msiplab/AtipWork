% practice04_8.m
%
% $Id: practice04_8.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �ݏ摥�ϊ��̃p�����[�^��
parameterGamma = 0.4;

%% �摜�t�@�C���̓Ǎ�
pictureRgb = imread('./data/firenzeRgb.jpg');

%% RGB��Ԃł̗ݏ摥�ϊ�
pictureRgbDouble = double(pictureRgb)./255.0;
pictureRgbA = pictureRgbDouble.^parameterGamma;

%% V�����ɑ΂���ݏ摥�ϊ�
pictureHsv = rgb2hsv(pictureRgb);
pictureHsv(:,:,3) = pictureHsv(:,:,3).^parameterGamma;
pictureRgbV = hsv2rgb(pictureHsv);

%% �摜�̕\��
figure(1)
imshowcq(pictureRgb)
title('���摜')

figure(2)
imshowcq(pictureRgbA)
title('RGB�S�����ɑ΂���ݏ摥�ϊ�')

figure(3)
imshowcq(pictureRgbV)
title('V�����݂̂ɑ΂���ݏ摥�ϊ�')

% end
