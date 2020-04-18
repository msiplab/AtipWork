% practice04_7.m
%
% $Id: practice04_7.m,v 1.5 2008-06-17 10:34:24 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �摜�t�@�C���̓Ǎ�
pictureRgb = imread('./data/firenzeRgb.jpg');

%% YCbCr��ԁi�t�������W�j�ւ̕ϊ�
pictureYcbcr(:,:,1) = uint8( ...
    0.2990 * double(pictureRgb(:,:,1)) ...
    + 0.5870 * double(pictureRgb(:,:,2)) ...
    + 0.1140 * double(pictureRgb(:,:,3)) );
pictureYcbcr(:,:,2) = uint8( ...
    - 0.169 * double(pictureRgb(:,:,1)) ...
    - 0.331* double(pictureRgb(:,:,2)) ...
    + 0.5 *   double(pictureRgb(:,:,3)) ...
    + 128);
pictureYcbcr(:,:,3) = uint8( ...
      0.5 *   double(pictureRgb(:,:,1)) ...
    - 0.419 * double(pictureRgb(:,:,2)) ...
    - 0.081 * double(pictureRgb(:,:,3)) ...
    + 128);
nRows = size(pictureRgb,1);
nCols = size(pictureRgb,2);

%% ���摜�̕\��
subplot(2,2,1)
imshowcq(pictureRgb)
title('Original')

%% Y�����̕\��
subplot(2,2,2)
imshowcq(pictureYcbcr(:,:,1))
title('Y component')

%% Cb�����̕\��
subplot(2,2,3)
imshowcq(pictureYcbcr(:,:,2))
title('Cb component')

%% Cr�����̕\��
subplot(2,2,4)
imshowcq(pictureYcbcr(:,:,3))
title('Cr component')

% end
