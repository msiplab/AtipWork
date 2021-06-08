% practice07_14.m
%
% $Id: practice07_14_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �摜�̓Ǎ�
pictureRgb = imread('./data/barbaraFaceRgb.tif');

%% ���m�N���摜�ւ̕ϊ�
pictureGray = rgb2gray(im2double(pictureRgb));

%% ���ϊ�

% DB2�ϊ�
[subLL,subHL,subLH,subHH] = imdb2trnscq_ip(pictureGray);
alpha = 1/2;

% 5/3�ϊ�
%[subLL,subHL,subLH,subHH] = im53trnscq_ip(pictureGray);
%alpha = 1;

% 9/7�ϊ�
%[subLL,subHL,subLH,subHH] = im97trnscq_ip(pictureGray);
%alpha = 1;

%% �T�u�o���h�摜�̕\���iAC�����͌��₷���悤�ɃX�P�[�����O�j
picturesSub = [ alpha*subLL        4*abs(subHL);
                4*abs(subLH) 4*abs(subHH) ];
figure(1)
imshow(picturesSub)
title('Subband pictures')

%% �t�ϊ�

% DB2�ϊ�
pictureRec = imdb2itrnscq_ip(subLL,subHL,subLH,subHH);

% 5/3�ϊ�
%pictureRec = im53itrnscq_ip(subLL,subHL,subLH,subHH);

% 9/7�ϊ�
%pictureRec = im97itrnscq_ip(subLL,subHL,subLH,subHH);

%% �����摜�̕\��
figure(2)
imshow(pictureRec)
title('Reconstructed picture')

% end
