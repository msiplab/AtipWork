%
% $Id: practice03_8.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 入力 x[n]
x = [1 2 3 ];

%% インパルス応答 h[n]
h = [1 1 1]/3;

%% 出力 y[n]
y = conv(h,x);

%% X(z) の周波数特性
X=freqz(x,1,512);

%% H(z) の周波数応答
H=freqz(h,1,512);

%% Y(z) の周波数特性
[Y,w]=freqz(y,1,512);

%% 周波数特性（応答）表示
plot(w/pi,abs(X),'b');
hold on;
plot(w/pi,abs(H),'k:');
hold on;
plot(w/pi,abs(Y),'r-.');
legend('X(e^{j\omega})','H(e^{j\omega})',...
    'Y(e^{j\omega})');
grid on;
xlabel('Normalized frequency (\times\pi rad/sample)');
ylabel('Magnitude (-)');
hold off;

% end
