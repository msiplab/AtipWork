% practice06_7.m
%
% $Id: practice06_7.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% ��ԗ��̐ݒ�i2�ȏ�̐����j
factor = 2;

%% ���͐���̐ݒ�
w = pi/4; % �ϒ����g��
nInputSamples = 128; 
inputSeq = gausswin(nInputSamples);
inputSeq = inputSeq/sum(inputSeq);
inputSeq = inputSeq.*cos((0:(nInputSamples-1)).'*w);

%% �o�͐���̌v�Z
outputSeq = upsample(inputSeq,factor);
nOutputSamples = length(outputSeq);

%% ���͐���̕\��
subplot(2,1,1)
[H,W] = freqz(inputSeq);
plot(W/pi,20*log10(abs(H)))
title('Input sequence','FontSize',12)
xlabel('\omega [rad]/\pi','FontSize',12)
ylabel('|X(e^{j\omega})| [dB]','FontSize',12)
axis([ 0 1 -70 30 ])
grid on

% �o�͐���̕\��
subplot(2,1,2)
[H,W] = freqz(outputSeq);
plot(W/pi,20*log10(abs(H)))
title(sprintf('Output sequence (factor = %d)',factor),'FontSize',12)
xlabel('\omega [rad]/\pi','FontSize',12)
ylabel('|Y(e^{j\omega})| [dB]','FontSize',12)
axis([ 0 1 -70 30 ])
grid on

% end
