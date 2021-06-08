% practice_a_8.m
%
% $Id:$
%
% Copyright (C) 2012-2015 Shogo MURAMATSU, All rights reserved
%

%% 係数の数，λ，収束条件の設定
K      = 32;     % 係数の数       
lambda = 0.0306; % λ
eps    = 1e-4;   % ISTA の許容誤差（収束条件）

%% 数列の生成
N = 128;
rng('default'); % 乱数の初期化
w = 0.1*randn(N,1);
x = filter(1,[1 -0.95],w);
subplot(3,1,1), stem(0:N-1,x)
axis([0 N -1.5 1.5])
ylabel('x[n]')
title('基底追跡ノイズ除去')

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

%% 基底追跡(BPDN)法
% 繰返し縮退／閾値アルゴリズム(ISTA)
softshrink  = @(y,lmd) sign(y).*max(abs(y)-lmd,0);
tx = x;
y = D.'*tx;
err = Inf;
while ( err > eps ) 
    ypre = y;
    v = D*ypre;
    e = D.'*(v-x);
    y = softshrink(ypre-e,lambda);
    err = norm(y(:)-ypre(:))^2/norm(y(:));
end

%% 非線形近似
y = y(:);
[~,ix] = sort(abs(y),'descend');
y(ix(K+1:end)) = 0;

%% 評価
% 近似結果
tx = D*y;
subplot(3,1,2), stem(0:N-1,tx)
axis([0 N -1.5 1.5])
ylabel('~x[n]')

% 近似誤差
r = x - tx;
subplot(3,1,3), stem(0:N-1,r)
axis([0 N -1.5 1.5])
ylabel('r[n]')

disp('基底追跡ノイズ除去(BPDN)')
mse = sum((x(:)-tx(:)).^2)/numel(x);
fprintf('mse = %f\n',mse);