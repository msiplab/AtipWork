% practice06_12.m
%
% $Id: practice06_12.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �p�����[�^�ݒ�
%�@�Ԉ������̐ݒ�i�������j
dFactor = 2;

% �ʉ߈�[�̐ݒ�
pass = 1/dFactor * (1 - 0.2);
% �j�~��[�̐ݒ�
stop = 1/dFactor * (1 + 0.2);
% �d�݃p�����[�^
alpha = 0.5;
% �t�B���^����
nOrder = 30;

%% �t�B���^�݌v
h = eigLpFir(nOrder,pass,stop,alpha);

%% �C���p���X�����̕\��
subplot(2,1,1)
impz(h)

%% ���g���U�������̕\��
subplot(2,1,2)
[H,W] = freqz(h);
plot(W/pi,20*log10(abs(H)))
title(sprintf('Decimation Filter (dFactor = %d)',dFactor),'FontSize',12)
xlabel('\omega [rad]/\pi','FontSize',12)
ylabel('|H(e^{j\omega})| [dB]','FontSize',12)
axis([ 0 1 -80 20 ])
grid on
hold on
line([0 1/dFactor 1/dFactor],[0 0 -100],...
    'LineStyle',':','LineWidth',2,'Color','red')
hold off

% end
