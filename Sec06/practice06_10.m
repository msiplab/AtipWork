% practice06_10.m
%
% $Id: practice06_10.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �p�����[�^�ݒ�
%�@��ԗ��̐ݒ�i�������j
uFactor = 2;
%�@�Ԉ������̐ݒ�i�������j
dFactor = 3;

rFactor = max(uFactor,dFactor);

%% ������ԃt�B���^�̃C���p���X�����̐ݒ�
lineInterpolationFilter = [1:uFactor-1 uFactor uFactor-1:-1:1]/uFactor;

%% ���σt�B���^�̃C���p���X�����̐ݒ�
averageFilter = ones(dFactor,1)/dFactor;

%% �����t�B���^�����̐ݒ�
jointFilter = conv(lineInterpolationFilter,averageFilter);

%% �C���p���X�����̕\��
subplot(2,1,1)
impz(jointFilter);
set(gca,'XLim',[-1 length(jointFilter)])

%% ���g���U�������̕\��
subplot(2,1,2)
[H,W] = freqz(jointFilter);
plot(W/pi,20*log10(abs(H)))
title(sprintf('Sampling Rate Conversion Filter (factor = %d/%d)',...
    uFactor, dFactor), 'FontSize',12)
xlabel('\omega [rad]/\pi','FontSize',12)
ylabel('|G(e^{j\omega})| [dB]','FontSize',12)
gain = 20*log10(uFactor);
axis([ 0 1 -80+gain 20+gain])
grid on
hold on
line([0 1/rFactor 1/rFactor],[gain gain -100],...
    'LineStyle',':','LineWidth',2,'Color','red')
hold off

% end
