%
% $Id: practice03_8.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% ���� x[n]
x = [1 2 3 ];

%% �C���p���X���� h[n]
h = [1 1 1]/3;

%% �o�� y[n]
y = conv(h,x);

%% X(z) �̎��g������
X=freqz(x,1,512);

%% H(z) �̎��g������
H=freqz(h,1,512);

%% Y(z) �̎��g������
[Y,w]=freqz(y,1,512);

%% ���g�������i�����j�\��
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
