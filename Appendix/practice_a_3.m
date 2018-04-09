% practice_a_2.m
%
% $Id:$
%
% Copyright (C) 2012-2015 Shogo MURAMATSU, All rights reserved
%

%% �p�����[�^�̐ݒ�
gamma = 10;
delta = 1 - gamma;

%% ����̐���
N = 128;
rng('default'); % �����̏�����
w = 0.1*randn(N,1);
x = filter(1,[1 -0.95],w);
subplot(6,1,1), stem(0:N-1,x)
axis([0 N -1.5 1.5])
ylabel('x[n]')

%% ���͏���
% ���̓t�B���^
h0 = [ gamma  delta ].';
h1 = [ gamma -delta ].';

% �i����j��ݍ���
y0 = cconv(h0,x,N);
subplot(6,1,2), stem(0:N-1,y0)
axis([0 N -1.5 1.5])
ylabel('y_0[n]')

y1 = cconv(h1,x,N);
subplot(6,1,3), stem(0:N-1,y1)
axis([0 N -1.5 1.5])
ylabel('y_1[n]')

%% ��������
% �����t�B���^
f0 = [  1 1 ].'/2;
f1 = [ -1 1 ].'/2;

% �i����j��ݍ���
u0 = circshift(cconv(f0,y0,N),-1); % circshift �͐i�ݏ���z^(+1)������
subplot(6,1,4), stem(0:N-1,u0)
axis([0 N -1.5 1.5])
ylabel('u_0[n]')

u1 = circshift(cconv(f1,y1,N),-1); % circshift �͐i�ݏ���z^(+1)������
subplot(6,1,5), stem(0:N-1,u1)
axis([0 N -1.5 1.5])
ylabel('u_1[n]')

%% �]��
% ��������
hx = u0 + u1;
subplot(6,1,6), stem(0:N-1,hx)
axis([0 N -1.5 1.5])

mse = sum((x(:)-hx(:)).^2)/numel(x);
fprintf('mse = %f\n',mse);
ylabel('\^x[n]')