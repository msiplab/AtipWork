% practice04_3.m
%
% $Id: practice04_3.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �摜�t�@�C���̓Ǎ�
pictureRgb = imread('data/firenzeRgb.jpg');

%% �J���[�摜(uint8)��TIFF�`���ł̏��o
imwrite(pictureRgb, './tmp/firenzeRgb.tif');

%% ���m�N���摜(double)�ւ̕ϊ�
pictureGrayDouble = ...
    double(rgb2graycq(pictureRgb))/255.0; % 0.0�`1.0 �̊ԂɃX�P�[�����O

%% ���m�N���摜(double)��JPEG�`���ł̏��o
imwrite(pictureGrayDouble, ...
    './tmp/firenzeGray.jpg'); 

% end
