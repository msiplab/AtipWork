% practice05_3.m
%
% $Id: practice05_3.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �}�X�N�̐ݒ�
laplacianMask = [0  1  0;
                 1 -4  1;
                 0  1  0];

%% ���摜�̓ǂݍ��݂ƕ\��
pictureRgb = imread('./data/firenzeRgb.jpg');
pictureGray = rgb2graycq(pictureRgb);
figure(1)
imshowcq(pictureGray)
title('Original')

%% �t�B���^�����ƌ��ʂ̕\��
pictureFiltered = ...
    uint8(filter2(laplacianMask,pictureGray)+128);
figure(2)
imshowcq(pictureFiltered)
title('After filtering (laplacian)')

% end 
