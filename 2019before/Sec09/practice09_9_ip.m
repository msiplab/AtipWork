% practice14_6.m
%
% $Id: practice09_9_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �p�����[�^�ݒ�
% �����̕�ԗ�
verticalInpFactor = 3;
% �����̕�ԗ�
horizontalInpFactor = 2;

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
title('Before upsampling')

%% �A�b�v�T���v�����O
arrayY = ...
    upsample(...
        upsample(arrayX,...
            verticalInpFactor).',...
               horizontalInpFactor).';

%% ������̎��g���U������
figure(2)
freqz2(arrayY)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('After upsampling')
        
% end
