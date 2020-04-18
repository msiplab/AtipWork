% practice09_3.m
%
% $Id: practice09_3_ip.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2006-2015 Shogo MURAMATSU, All rights reserved
%

%% �p�����[�^�ݒ�
% �ʉ߈�̎d�l
passEdge0 = 1/3-1/10; % ���� (�~�� rad)
passEdge1 = 1/3-1/10; % ���� (�~�� rad)

% �j�~��̎d�l
stopEdge0 = 1/3+1/10; % ���� (�~�� rad)
stopEdge1 = 1/3+1/10; % ���� (�~�� rad)

% ���e�덷�̎d�l
deltaPass = 0.01;
deltaStop = 0.01;

% �e�����̋��e�덷�̎d�l
deltaPass0 = sqrt(1+deltaPass)-1;
deltaStop0 = deltaStop/(1+deltaPass0);
deltaPass1 = sqrt(1+deltaPass)-1;
deltaStop1 = deltaStop/(1+deltaPass1);

%% �t�B���^ H_0 �̋ߎ��d�l
specFrq0 = [passEdge0 stopEdge0];
specAmp0 = [1 0];
specErr0 = [deltaPass0 deltaStop0];
spec0 = firpmord(specFrq0,specAmp0,specErr0,2,'cell');
if (mod(spec0{1},2)~=0)
    spec0{1}=spec0{1}+1; % �t�B���^�̃^�b�v������ƂȂ�悤�ɏC��
end
halfOrder0 = spec0{1}/2;

%% �t�B���^ H_1 �̋ߎ��d�l
specFrq1 = [passEdge1 stopEdge1];
specAmp1 = [1 0];
specErr1 = [deltaPass1 deltaStop1];
spec1 = firpmord(specFrq1,specAmp1,specErr1,2,'cell');
if (mod(spec1{1},2)~=0)
    spec1{1}=spec1{1}+1; % �t�B���^�̃^�b�v������ƂȂ�悤�ɏC��
end
halfOrder1 = spec1{1}/2;

%% �e�����̃t�B���^�݌v
oneDimensionalFilter0 = firpm(spec0{:});
oneDimensionalFilter1 = firpm(spec1{:});

%% �t�B���^�����̕\��
figure(1)
impz(oneDimensionalFilter0)
figure(2)
freqz(oneDimensionalFilter0)
figure(3)
impz(oneDimensionalFilter1)
figure(4)
freqz(oneDimensionalFilter1)

%% �����񎟌��t�B���^
twoDimensionalFilter = ...
    kron(oneDimensionalFilter1(:).',oneDimensionalFilter0(:));
figure(5)
mesh(-halfOrder1:halfOrder1,-halfOrder0:halfOrder0,...
    twoDimensionalFilter)
xlabel('n_1')
ylabel('n_0')

figure(6)
freqz2(twoDimensionalFilter)
xlabel('\omega_1 (\times \pi rad)')
ylabel('\omega_0 (\times \pi rad)')

% end of practice08_8.m
