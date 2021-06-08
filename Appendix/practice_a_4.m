% practice_a_3.m
%
% $Id:$
%
% Copyright (C) 2012-2015 Shogo MURAMATSU, All rights reserved
%

%% 入力点数の設定
N = 4;

%% 合成処理
% 合成フィルタ
f0 = [  1 1 ].'/2;
f1 = [ -1 1 ].'/2;

%% （巡回）畳込み行列
P = [zeros(1,N-1) 1; eye(N) ];      % 周期拡張行列
C = [zeros(N,1) eye(N) zeros(N,1)]; % 抜き出し行列
d0 = C*convmtx(f0,N+1)*P;
d1 = C*convmtx(f1,N+1)*P;

%% 辞書Dの構築
D = zeros(N,2*N);
D(:,1:2:end) = d0;
D(:,2:2:end) = d1;
fprintf('D = \n')
disp(D)

%% Moore-Penroseの一般化逆行列による分析処理
% 信号の生成
x = rand(N,1);
fprintf('数列 x\n')
disp(x)

% 一般化逆行列の計算
disp('ムーア・ペンローズの一般化逆行列')
fprintf('T = D^+ = \n')
T = pinv(D); % Moore-Penrose の一般化逆行列
disp(T)

% 分析処理
y = T*x;
fprintf('norm(y) = %f\n', norm(y));

% 合成処理
r = D*y;
mse = sum((x(:)-r(:)).^2)/numel(x);
fprintf('mse = %f\n\n',mse)

%% 他の一般化逆行列による分析処理
% 一般化逆行列の計算
gamma = 0.5;
delta = 1 - gamma;
disp('他の一般化逆行列')
fprintf('T = \n')
h0 = [ gamma  delta ].';
h1 = [ gamma -delta ].';
P = [eye(N) ; 1 zeros(1,N-1)];      % 周期拡張行列
C = [zeros(N,1) eye(N) zeros(N,1)]; % 抜き出し行列
t0 = C*convmtx(h0,N+1)*P;
t1 = C*convmtx(h1,N+1)*P;
T = zeros(2*N,N);
T(1:2:end,:) = t0;
T(2:2:end,:) = t1;
disp(T)

% 分析処理
y = T*x;
fprintf('norm(y) = %f\n', norm(y));

% 合成処理
r = D*y;
mse = sum((x(:)-r(:)).^2)/numel(x);
fprintf('mse = %f\n\n',mse);
