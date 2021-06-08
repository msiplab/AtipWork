% practice04_3.m
%
% $Id: practice04_3_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �摜�t�@�C���̓Ǎ�
pictureRgb = imread('./data/firenzeRgb.jpg');

%% �J���[�摜(uint8)��TIFF�`���ł̏��o
imwrite(pictureRgb, './tmp/firenzeRgb.tif');

%% ���m�N���摜(double)�ւ̕ϊ�
pictureGrayDouble = im2double(rgb2gray(pictureRgb));

%% ���m�N���摜(double)��JPEG�`���ł̏��o
imwrite(pictureGrayDouble, ...
    './tmp/firenzeGray.jpg'); 

%% imshow �Ńt�@�C����\��
imshow('./tmp/firenzeGray.jpg')

% end
