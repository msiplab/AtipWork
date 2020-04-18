% practice04_5.m
%
% $Id: practice04_5_ip.m,v 1.3 2007/05/16 07:23:59 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%
parameterGamma = 0.25;

%% �摜�t�@�C���̓Ǎ�
pictureRgb = imread('./data/firenzeRgb.jpg');

%% ���m�N���摜�ւ̕ϊ�
pictureGray = rgb2gray(pictureRgb);

%% �ݏ摥�ϊ�
pictureCorrected = imadjust(pictureGray,[],[],parameterGamma);

%% ���摜�i���m�N���j�̕\��
figure(1)
imshow(pictureGray)
title('Before correction')

%% �����摜�̕\��
figure(2)
imshow(pictureCorrected)
title('After correction')

% end
