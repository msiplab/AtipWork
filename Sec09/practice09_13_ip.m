% practice14_10.m
%
% $Id: practice09_13_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% ��ԍs��i2x2)
upMtx = [ 1 1 ; -1 1 ];
absDetU = abs(det(upMtx));

%% �v���g�^�C�v�ꎟ���t�B���^�݌v
nOrder = 20; % �v���g�^�C�v�t�B���^�̎���
passBandEdge = 1/absDetU * 0.8;
stopBandEdge = 1/absDetU * 1.2;
freqWeight = 0.5;
prtFilter = eigLpNqFir(...
    nOrder,passBandEdge,stopBandEdge,freqWeight,absDetU);

%% �Ԉ����t�B���^�݌v1
phase = [0 0]; % ���S���c��悤�Ԉ����̈ʑ��𒲐�����
filter4Inp1 = absDetU * ...
   downsampleFilterDesign2(prtFilter, upMtx, phase);

%% �����̕\��
figure(1)
freqz2(filter4Inp1)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('filter 1')

%% �Ԉ����t�B���^�݌v2
unimodMtx = [ 1 0 ; 1 -1 ];
phase = [0 0]; % ���S���c��悤�Ԉ����̈ʑ��𒲐�����
filter4Inp2 = absDetU * ... 
    downsampleFilterDesign2(prtFilter, upMtx*unimodMtx, phase);

%% �����̕\��
figure(2)
freqz2(filter4Inp2)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('filter 2')

%% �C���^�|���[�V���������p�����[�^�ݒ�
% �M���̋����U�s��
covMtx  = [8 0 ; 0 1 ]; %[1 2 ; 2 8];
% �M���̃T�C�Y
sizeX = 31;

%% �񎟌��K�E�X�֐��ƊԈ����ɂ��z��̐���
arrayX = downsample2(gaussian2cq(sizeX,covMtx),upMtx);

%% ���M���̎��g���U������
figure(3)
subplot(2,2,1)
freqz2(arrayX)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('Before upsampling')
axis([-1 1 -1 1 0 1.2])

%% �񎟌��A�b�v�T���v�����O
arrayUpSpd = upsample2(arrayX,upMtx);

%% �A�b�v�T���v����̎��g���U������
figure(3)
subplot(2,2,2)
freqz2(arrayUpSpd)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('After upsampling')
axis([-1 1 -1 1 0 1.2])

%% �񎟌��C���^�|���[�V����(�t�B���^1�j
arrayY1 = filter2(filter4Inp1,arrayUpSpd);

%% ������̎��g���U������
figure(3)
subplot(2,2,3)
freqz2(arrayY1)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('After interpolation with filter 1')
axis([-1 1 -1 1 0 1.2])

%% �񎟌��C���^�|���[�V�����i�t�B���^2�j
arrayY2 = filter2(filter4Inp2,arrayUpSpd);

%% ������̎��g���U������
figure(3)
subplot(2,2,4)
freqz2(arrayY2)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('After interpolation with filter 2')
axis([-1 1 -1 1 0 1.2])

% end
