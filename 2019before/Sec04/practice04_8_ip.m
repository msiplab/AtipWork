% practice04_8.m
%
% $Id: practice04_8_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �ݏ摥�ϊ��̃p�����[�^��
parameterGamma = 0.4;

%% �摜�t�@�C���̓Ǎ�
pictureRgb = imread('./data/firenzeRgb.jpg');

%% RGB��Ԃł̗ݏ摥�ϊ�
pictureRgbA = imadjust(pictureRgb,[],[],parameterGamma);

%% V�����ɑ΂���ݏ摥�ϊ�
pictureHsv = rgb2hsv(pictureRgb);
pictureHsv(:,:,3) = ...
   imadjust(pictureHsv(:,:,3),[],[],parameterGamma);
pictureRgbV = hsv2rgb(pictureHsv);

%% �摜�̕\��
figure(1);
imshow(pictureRgb);
title('���摜');

figure(2);
imshow(pictureRgbA);
title('RGB�S�����ɑ΂���ݏ摥�ϊ�');

figure(3);
imshow(pictureRgbV);
title('V�����݂̂ɑ΂���ݏ摥�ϊ�');

% end
