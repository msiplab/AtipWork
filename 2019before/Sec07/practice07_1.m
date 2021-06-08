% practice07_1.m
%
% $Id: practice07_1.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 信号点数
nSamples = 16;

%% 原信号 x[n] の生成
clear x
n=0:nSamples-1;
x(n+1) = 2 * cos(pi/8 * n ) + cos(pi/4 * n );

%% 原信号 x[n] の表示
figure(1)
stem(n,x)
xlabel('n')
ylabel('x[n]')
title('Original sequence')

%% DFT の計算と結果表示
clear ydft
ydft = fft(x);
figure(2)
stem(n,abs(ydft))
xlabel('k')
ylabel('Y_{DFT}[k]')
title('DFT (Magnitude)')

%% DCT の計算と結果表示
clear ydct
ydct = dct(x);
figure(3)
stem(n,ydct)
xlabel('k')
ylabel('Y_{DCT}[k]')
title('DCT')

% end
