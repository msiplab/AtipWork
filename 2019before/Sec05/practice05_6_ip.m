% practice05_6.m
%
% $Id: practice05_6_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �ꎟ���C���p���X�����̐ݒ�
aveFilter1 = [ 1 1 1 ]/3;

%% ���摜�̓ǂݍ��݂ƕ\��
pictureNoisy = imread('./data/firenzeNoisy.jpg');
pictureNoisy = im2double(pictureNoisy);
figure(1)
imshow(pictureNoisy)
title('Original')

%% ���������t�B���^�����ƌ��ʂ̕\��
pictureVerFiltered = ...
    imfilter(pictureNoisy,aveFilter1(:),'conv');
figure(2)
imshow(pictureVerFiltered)
title('Intermediate result (vertical moving average)')

%% ���������t�B���^�����ƌ��ʂ̕\��
pictureFiltered = ...
    imfilter(pictureVerFiltered,aveFilter1(:).','conv');
figure(3)
imshow(pictureFiltered)
title('After filtering (separate moving average)')

% end 
