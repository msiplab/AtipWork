% practice06_4.m
%
% $Id: practice06_4.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%%�@�Ԉ������̐ݒ�i2�ȏ�̐����j
dFactor = 2;

%% ���͐���̐ݒ�
startIndex = 256;
nInputSamples = 32;
load gong;
inputSeq = y(startIndex:startIndex+nInputSamples-1);
load chirp;
inputSeq = inputSeq + y(startIndex:startIndex+nInputSamples-1);

%% �o�͐���̌v�Z
outputSeq = downsample(inputSeq,dFactor);
nOutputSamples = length(outputSeq);

%% ���͐���̕\��
subplot(2,1,1)
stem(0:nInputSamples-1,inputSeq)
hold on
plot(0:nInputSamples-1,inputSeq,':')
axis([0 nInputSamples -1 1])
title('Input sequence','FontSize',12)
xlabel('n','FontSize',12)
ylabel('x[n]','FontSize',12)
hold off

%% �o�͐���̕\��
subplot(2,1,2)
stem(0:nOutputSamples-1,outputSeq)
hold on
plot(0:1/dFactor:(nInputSamples-1)/dFactor,inputSeq,':')
axis([0 nInputSamples/dFactor -1 1])
title(sprintf('Output sequence (dFactor = %d)',dFactor),'FontSize',12)
xlabel('m','FontSize',12)
ylabel('y[m]','FontSize',12)
hold off

% end
