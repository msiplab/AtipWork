% practice06_8.m
%
% $Id: practice06_8.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%%�@�Ԉ������̐ݒ�i2�ȏ�̐����j
dFactor = 2;

%% �t�B���^�̃C���p���X�����̐ݒ�
averageFilter = ones(dFactor,1)/dFactor;

%% �C���p���X�����̕\��
subplot(2,1,1)
impz(averageFilter)
set(gca,'XLim',[-1 length(averageFilter)])

%% ���g���U�������̕\��
subplot(2,1,2)
[H,W] = freqz(averageFilter);
plot(W/pi,20*log10(abs(H)))
title(sprintf('Average Filter (dFactor = %d)',dFactor),'FontSize',12)
xlabel('\omega [rad]/\pi','FontSize',12)
ylabel('|H(e^{j\omega})| [dB]','FontSize',12)
axis([ 0 1 -80 20 ])
grid on
hold on
line([0 1/dFactor 1/dFactor],[0 0 -100],...
    'LineStyle',':','LineWidth',2,'Color','red')
hold off

% end
