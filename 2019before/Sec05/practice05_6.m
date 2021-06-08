% practice05_6.m
%
% $Id: practice05_6.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �ꎟ���C���p���X�����̐ݒ�
aveFilter1 = [ 1 1 1 ]/3;

%% ���摜�̓ǂݍ��݂ƕ\��
pictureNoisy = imread('./data/firenzeNoisy.jpg');
pictureNoisy = double(pictureNoisy)./255;
figure(1)
imshowcq(pictureNoisy)
title('Original')

%% ���������t�B���^�����ƌ��ʂ̕\��
pictureVerFiltered = ...
    conv2(pictureNoisy,aveFilter1(:),'same');
figure(2)
imshowcq(pictureVerFiltered)
title('Intermediate result (vertical moving average)')

%% ���������t�B���^�����ƌ��ʂ̕\��
pictureFiltered = ...
    conv2(pictureNoisy,aveFilter1(:).','same');
figure(3)
imshowcq(pictureFiltered)
title('After filtering (separate moving average)')

% end 
