% practice05_2.m
%
% $Id: practice05_2_ip.m,v 1.4 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �}�X�N�T�C�Y
sizeMask = [3 3];

%% ���摜�̓ǂݍ��݂ƕ\��
pictureRgb = imread('./data/firenzeRgb.jpg');
pictureGray = rgb2gray(pictureRgb);
figure(1)
imshow(pictureGray)
title('Original')

%% �m�C�Y����������摜�̓ǂݍ��݂ƕ\��
pictureNoisy = imnoise(pictureGray,'salt & pepper',0.02);
figure(2);
imshow(pictureNoisy);
title('Before filtering');

%% �t�B���^�����ƌ��ʂ̕\��
pictureMedian = medfilt2(pictureNoisy,sizeMask);
figure(3)
imshow(pictureMedian)
title('After filtering (median)')

%% �t�B���^�����ƌ��ʂ̕\��
pictureMax = ordfilt2(pictureNoisy,prod(sizeMask),ones(sizeMask));
figure(4)
imshow(pictureMax)
title('After filtering (max)')

%% �t�B���^�����ƌ��ʂ̕\��
pictureMin = ordfilt2(pictureNoisy,1,ones(sizeMask));
figure(5)
imshow(pictureMin)
title('After filtering (min)')

% end 
