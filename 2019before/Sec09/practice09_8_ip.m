% practice14_5.m
%
% $Id: practice09_8_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �p�����[�^�ݒ�
% �Ԉ����s��i2x2)
downMtx = [ 1 1 ; -1 1 ];

% �z��̋����U�s��
covMtx  = [2 0 ; 0 1];
% �z��̃T�C�Y
sizeX = 31;

%% 2�����K�E�X�֐��ɂ��z��̐���
arrayX = gaussian2cq(sizeX,covMtx);

%% ���M���̎��g���U������
figure(1)
freqz2(arrayX)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('Before downsampling')

%% 2�����_�E���T���v�����O
arrayY = downsample2(arrayX,downMtx);

%% ������̎��g���U������
figure(2)
freqz2(arrayY)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('After downsampling')
        
% end
