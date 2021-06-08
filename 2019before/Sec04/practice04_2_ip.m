% practice04_2.m
%
% $Id: practice04_2_ip.m,v 1.4 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% RGB�J���[�摜�̓Ǎ� 
pictureRgb = imread('data/firenzeRgb.jpg');

%% RGB�J���[�摜(uint8)�̕\��
figure(1) 
imshow(pictureRgb);
title('pictureRgb');

%% ���m�N���摜�ւ̕ϊ�
pictureGray = rgb2gray(pictureRgb);

%% ���m�N���摜(uint8)�̕\��
figure(2) 
imshow(pictureGray);
title('pictureGray');

% �{���x(double)�ւ̕ϊ�
pictureRgbDouble = ...
    double(pictureRgb)/255.0; % 0.0�`1.0 �̊ԂɃX�P�[�����O

%% �J���[�摜(double)�̕\��
figure(3) 
imshow(pictureRgbDouble);
title('pictureRgbDouble');

% end
