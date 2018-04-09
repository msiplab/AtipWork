% practice09_7.m
%
% $Id: practice09_7_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �p�����[�^�ݒ�
% �����̊Ԉ�����
verticalDecFactor = 2;
% �����̊Ԉ�����
horizontalDecFactor = 3;

% �z��̕W���΍�
sigma = 2;
% �z��̃T�C�Y
sizeX = 31;

%% 2�����K�E�X�֐��ɂ��z��̐���
arrayX = fspecial('gaussian',sizeX,sigma);

%% ���M���̎��g���U������
figure(1)
freqz2(arrayX)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('Before downsampling')

%% �_�E���T���v�����O
arrayY = ...
    downsample(...
        downsample(arrayX,...
            verticalDecFactor).',...
            horizontalDecFactor).';

%% ������̎��g���U������
figure(2)
freqz2(arrayY)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('After downsampling')
        
% end
