% practice04_7.m
%
% $Id: practice04_7_ip.m,v 1.4 2008-06-17 10:34:24 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �摜�t�@�C���̓Ǎ�
pictureRgb = imread('./data/firenzeRgb.jpg');

%% YCbCr��ԁi�t�������W�j�ւ̕ϊ�
pictureYcbcr(:,:,1) = imlincomb(...
     0.2990, pictureRgb(:,:,1), ...
     0.5870, pictureRgb(:,:,2), ...
     0.1140, pictureRgb(:,:,3) );
pictureYcbcr(:,:,2) = imlincomb(...
    -0.169, pictureRgb(:,:,1), ...
    -0.331, pictureRgb(:,:,2), ...
     0.5,   pictureRgb(:,:,3), ...
     128);
pictureYcbcr(:,:,3) = imlincomb( ...
     0.5,   pictureRgb(:,:,1), ...
    -0.419, pictureRgb(:,:,2), ...
    -0.081, pictureRgb(:,:,3), ...
     128);

%% ���摜�̕\��
subplot(2,2,1)
imshow(pictureRgb)
title('Original')

%% Y�����̕\��
subplot(2,2,2)
imshow(pictureYcbcr(:,:,1))
title('Y component')

%% Cb�����̕\��
subplot(2,2,3)
imshow(pictureYcbcr(:,:,2))
title('Cb component')

%% Cr�����̕\��
subplot(2,2,4)
imshow(pictureYcbcr(:,:,3))
title('Cr component')

% end
