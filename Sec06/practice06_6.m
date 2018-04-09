% practice06_6.m
%
% $Id: practice06_6.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%%�@��ԗ��̐ݒ�i2�ȏ�̐����j
uFactor = 2;

%% ���͐���̐ݒ�
startIndex = 256;
nInputSamples = 16;
load gong;
inputSeq = y(startIndex:startIndex+nInputSamples-1);
load chirp;
inputSeq = inputSeq + y(startIndex:startIndex+nInputSamples-1);

%% �o�͐���̌v�Z
outputSeq = upsample(inputSeq,uFactor);
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
plot(0:uFactor:uFactor*nInputSamples-uFactor+1,inputSeq,':')
axis([0 uFactor*nInputSamples -1 1])
title(sprintf('Output sequence (uFactor = %d)',uFactor),'FontSize',12)
xlabel('m','FontSize',12)
ylabel('y[m]','FontSize',12)
hold off

% end
