% practice07_1.m
%
% $Id: practice07_1.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �M���_��
nSamples = 16;

%% ���M�� x[n] �̐���
clear x
n=0:nSamples-1;
x(n+1) = 2 * cos(pi/8 * n ) + cos(pi/4 * n );

%% ���M�� x[n] �̕\��
figure(1)
stem(n,x)
xlabel('n')
ylabel('x[n]')
title('Original sequence')

%% DFT �̌v�Z�ƌ��ʕ\��
clear ydft
ydft = fft(x);
figure(2)
stem(n,abs(ydft))
xlabel('k')
ylabel('Y_{DFT}[k]')
title('DFT (Magnitude)')

%% DCT �̌v�Z�ƌ��ʕ\��
clear ydct
ydct = dct(x);
figure(3)
stem(n,ydct)
xlabel('k')
ylabel('Y_{DCT}[k]')
title('DCT')

% end
