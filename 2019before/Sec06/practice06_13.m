% practice06_13.m
%
% $Id: practice06_13.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �p�����[�^�ݒ�
%�@��ԗ��̐ݒ�i�������j
uFactor = 2;

% �ʉ߈�[�̐ݒ�
pass = 1/uFactor * (1 - 0.2);
% �j�~��[�̐ݒ�
stop = 1/uFactor * (1 + 0.2);
% �d�݃p�����[�^
alpha = 0.5;
% �t�B���^����
nOrder = 30;

%% �t�B���^�݌v
h = uFactor * eigLpNqFir(nOrder,pass,stop,alpha,uFactor);

%% �C���p���X�����̕\��
subplot(2,1,1)
impz(h)

%% ���g���U�������̕\��
subplot(2,1,2)
[H,W] = freqz(h);
plot(W/pi,20*log10(abs(H)))
title(sprintf('Interpolation Filter (uFactor = %d)',uFactor),...
    'FontSize',12)
xlabel('\omega [rad]/\pi','FontSize',12)
ylabel('|F(e^{j\omega})| [dB]','FontSize',12)
gain = 20*log10(uFactor);
axis([ 0 1 -80+gain 20+gain])
grid on
hold on
line([0 1/uFactor 1/uFactor],[gain gain -100],...
    'LineStyle',':','LineWidth',2,'Color','red')
hold off

% end
