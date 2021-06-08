% practice07_10.m
%
% $Id: practice07_10.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 分析フィルタ
h0 = [  1  1 ]/2;
h1 = [  1 -1 ]/2;
%h0 = [  (1+sqrt(3)) (3+sqrt(3))  (3-sqrt(3)) (1-sqrt(3)) ]/8;
%h1 = [  (1-sqrt(3)) -(3-sqrt(3)) (3+sqrt(3)) -(1+sqrt(3)) ]/8;

%% 合成フィルタ
f0 = 2*fliplr(h0);
f1 = 2*fliplr(h1);

%% A(z)
h0m = h0 * diag( power(-1, 0:length(h0)-1) );
h1m = h1 * diag( power(-1, 0:length(h1)-1) );
A = ( conv(h0m,f0) + conv(h1m,f1) )/2;
disp('A(z)')
disp(A)

%% T(z)
T = ( conv(h0,f0) + conv(h1,f1) )/2;
disp('T(z)')
disp(T)

% 周波数振幅特性
fftPoints = 512;
[H,W] = freqz(h0,1,fftPoints);
plot(W/pi,20*log10(abs(H)),'b')
axis([0 1 -70 10])
xlabel('Normalized Frequency (x\pi rad/sample)')
ylabel('Magnitude (dB)')
grid on
hold on

H = freqz(h1,1,fftPoints);
plot(W/pi,20*log10(abs(H)),'r')
hold off

% end