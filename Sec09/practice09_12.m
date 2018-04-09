% practice09_12.m
%
% $Id: practice09_12.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �Ԉ����s��i2x2)
downMtx = [ 1 1 ; -1 1 ];

absDetD = abs(det(downMtx));

%% �v���g�^�C�v�ꎟ���t�B���^�݌v
nOrder = 20; % �v���g�^�C�v�t�B���^�̎���
passBandEdge = 1/absDetD * 0.8;
stopBandEdge = 1/absDetD * 1.2;
freqWeight = 0.5;
prtFilter = eigLpFir(nOrder,passBandEdge,stopBandEdge,freqWeight);

%% �Ԉ����t�B���^�݌v1
phase = [0 0]; % ���S���c��悤�Ԉ����̈ʑ��𒲐�����
filter4Dec1 = downsampleFilterDesign2(prtFilter, downMtx,phase);

%% �����̕\��
figure(1)
freqz2cq(filter4Dec1)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('filter 1')

%% �Ԉ����t�B���^�݌v2
unimodMtx = [ 1 0 ; 1 -1 ];
phase = [0 0]; % ���S���c��悤�Ԉ����̈ʑ��𒲐�����
filter4Dec2 = downsampleFilterDesign2(prtFilter, downMtx*unimodMtx, phase);

%% �����̕\��
figure(2)
freqz2cq(filter4Dec2)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('filter 2')

%% �f�V���[�V���������p�p�����[�^�ݒ�
% �M���̋����U�s��
covMtx  = [1 2 ; 2 8];
% �M���̃T�C�Y
sizeX = 63;

%% �񎟌��K�E�X�֐��ɂ��z��̐���
arrayX = gaussian2cq(sizeX,covMtx);

%% ���M���̎��g���U������
figure(3)
freqz2cq(arrayX)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('Before decimation')
axis([-1 1 -1 1 0 1.2])
    
%% �񎟌��f�V���[�V�����i�t�B���^1�j
arrayFiltd1 = filter2(filter4Dec1,arrayX);
arrayY1 = downsample2(arrayFiltd1,downMtx);

%% ������̎��g���U������
figure(4)
subplot(2,2,1)
freqz2cq(arrayFiltd1)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('After filtering with filter 1')
axis([-1 1 -1 1 0 1.2])

figure(4)
subplot(2,2,2)
freqz2cq(arrayY1)
xlabel('\omega_1/\pi')
ylabel('\omega_0/\pi')
title('After decimation with filter 1')
axis([-1 1 -1 1 0 1.2])

%% �񎟌��f�V���[�V�����i�t�B���^2�j
arrayFiltd2 = filter2(filter4Dec2,arrayX);
arrayY2 = downsample2(arrayFiltd2,downMtx);

%% ������̎��g���U������
figure(4)
subplot(2,2,3)
freqz2cq(arrayFiltd2)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('After filtering with filter 2')
axis([-1 1 -1 1 0 1.2])

figure(4)
subplot(2,2,4)
freqz2cq(arrayY2)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('After decimation with filter 2')
axis([-1 1 -1 1 0 1.2])

% end
