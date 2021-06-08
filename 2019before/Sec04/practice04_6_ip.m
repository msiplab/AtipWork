% practice04_6.m
%
% $Id: practice04_6_ip.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �摜�t�@�C���̓Ǎ�
pictureRgb = imread('./data/firenzeRgb.jpg');

%% ���m�N���摜�ւ̕ϊ�
pictureGray = rgb2gray(pictureRgb);

%% �����O�̉摜�̕\��
subplot(2,2,1)
imshow(pictureGray)
title('Before histgram equalization')

%% �����O�̃q�X�g�O�����̕\��
subplot(2,2,2)
imhist(pictureGray)
title('Before histgram equalization')

%% �q�X�g�O�����ϓ���
pictureHistEqd = histeq(pictureGray);

%% ������̉摜�̕\��
subplot(2,2,3)
imshow(pictureHistEqd)
title('After histgram equalization')

%% ������̃q�X�g�O�����̕\��
subplot(2,2,4)
imhist(pictureHistEqd)
title('After histgram equalization')

% end
