% practice07_14.m
%
% $Id: practice07_14.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �摜�̓Ǎ�
pictureRgb = imread('./data/barbaraFaceRgb.tif');

%% ���m�N���摜�ւ̕ϊ�
pictureGray = rgb2graycq(pictureRgb);

%% ���ϊ�
% DB2 �ϊ�
[subLL,subHL,subLH,subHH] = imdb2trnscq(pictureGray);
alpha = 1/2;

% 5/3 �ϊ�
%[subLL,subHL,subLH,subHH] = im53trnscq(pictureGray);
%alpha = 1;

% 9/7 �ϊ�
%[subLL,subHL,subLH,subHH] = im97trnscq(pictureGray);
%alpha = 1;

%% �T�u�o���h�摜�̕\���iAC�����͌��₷���悤�ɃX�P�[�����O�j
picturesSub = [ alpha*subLL        4*abs(subHL);
                4*abs(subLH) 4*abs(subHH) ];
figure(1)
imshowcq(uint8(picturesSub))
title('Subband pictures')

%% �t�ϊ�
% DB2�ϊ�
pictureRec = imdb2itrnscq(subLL,subHL,subLH,subHH);
% 5/3�ϊ�
%pictureRec = im53itrnscq(subLL,subHL,subLH,subHH);
% 9/7�ϊ�
%pictureRec = im97itrnscq(subLL,subHL,subLH,subHH);

%% �����摜�̕\��
figure(2)
imshowcq(uint8(pictureRec))
title('Reconstructed picture')

% end
