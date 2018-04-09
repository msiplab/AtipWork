% practice_a_2.m
%
% $Id:$
%
% Copyright (C) 2012-2015 Shogo MURAMATSU, All rights reserved
%

%% パラメータの設定
gamma = 10;
delta = 1 - gamma;

%% 数列の生成
N = 128;
rng('default'); % 乱数の初期化
w = 0.1*randn(N,1);
x = filter(1,[1 -0.95],w);
subplot(6,1,1), stem(0:N-1,x)
axis([0 N -1.5 1.5])
ylabel('x[n]')

%% 分析処理
% 分析フィルタ
h0 = [ gamma  delta ].';
h1 = [ gamma -delta ].';

% （巡回）畳み込み
y0 = cconv(h0,x,N);
subplot(6,1,2), stem(0:N-1,y0)
axis([0 N -1.5 1.5])
ylabel('y_0[n]')

y1 = cconv(h1,x,N);
subplot(6,1,3), stem(0:N-1,y1)
axis([0 N -1.5 1.5])
ylabel('y_1[n]')

%% 合成処理
% 合成フィルタ
f0 = [  1 1 ].'/2;
f1 = [ -1 1 ].'/2;

% （巡回）畳み込み
u0 = circshift(cconv(f0,y0,N),-1); % circshift は進み処理z^(+1)を実現
subplot(6,1,4), stem(0:N-1,u0)
axis([0 N -1.5 1.5])
ylabel('u_0[n]')

u1 = circshift(cconv(f1,y1,N),-1); % circshift は進み処理z^(+1)を実現
subplot(6,1,5), stem(0:N-1,u1)
axis([0 N -1.5 1.5])
ylabel('u_1[n]')

%% 評価
% 合成結果
hx = u0 + u1;
subplot(6,1,6), stem(0:N-1,hx)
axis([0 N -1.5 1.5])

mse = sum((x(:)-hx(:)).^2)/numel(x);
fprintf('mse = %f\n',mse);
ylabel('\^x[n]')