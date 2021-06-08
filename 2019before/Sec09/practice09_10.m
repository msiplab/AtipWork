% practice09_10.m
%
% $Id: practice09_10.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% ��ԍs��i2x2)
upMtx = [ 1 1 ; -1 1 ];

%% �z��̋����U�s��
covMtx  = [2 0 ; 0 1];

%% �z��̃T�C�Y
sizeX = 31;

%% 2�����K�E�X�֐��ɂ��z��̐���
arrayX = gaussian2cq(sizeX,covMtx);

%% ���M���̎��g���U������
figure(1)
freqz2cq(arrayX)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('Before upsampling')

%% 2�����A�b�v�T���v�����O
arrayY = upsample2(arrayX,upMtx);

% ������̎��g���U������
figure(2)
freqz2cq(arrayY)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('After upsampling')
        
% end
