% practice_a_6.m
%
% $Id:$
%
% Copyright (C) 2012-2015 Shogo MURAMATSU, All rights reserved
%

%% 係数の数の設定
K = 32;

%% 数列の生成
N = 128;
rng('default'); % 乱数の初期化
w = 0.1*randn(N,1);
x = filter(1,[1 -0.95],w);
subplot(3,1,1), stem(0:N-1,x)
axis([0 N -1.5 1.5])
ylabel('x[n]')
title('l_0ノルム最小化')

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

%% 直交マッチング追跡(OMP)法／マッチング追跡(MP)法
isOmp = true;
isGp = true;
% 初期化
M  = size(D,2);
e  = ones(M,1);
z  = zeros(M,1);
g  = zeros(M,1);
y  = zeros(M,1);
tx = zeros(N,1);
r  = x - tx;
sup = [];
% 近似結果
subplot(3,1,2), hsr = stem(0:N-1,tx);
axis([0 N -1.5 1.5])
ylabel('~{x}[n]')
% 近似誤差
subplot(3,1,3), hse = stem(0:N-1,r);
axis([0 N -1.5 1.5])
ylabel('r[n]')
for k=1:K
    % マッチング処理
    for m = 1:M %setdiff(1:M,sup)
        d = D(:,m);
        g(m) = d.'*r;
        z(m) = g(m)/(d'*d);
        e(m) = r.'*r - g(m)*z(m);
    end
    % 最小値探索（追跡）
    [~,mmin]= min(e);
    % サポート更新
    sup = union(sup,mmin);
    if isOmp % Orthogonal Matching Pursuit
        Ds = D(:,sup);
        if isGp % Gradient Pursuit
            % 暫定更新
            c = Ds*g(sup);
            a = (r.'*c)/(norm(c)^2);
            y(sup)  = y(sup) + a*g(sup);
        else
            % 暫定更新
            Ds = D(:,sup);
            y(sup)  = pinv(Ds) * x;
        end
    else % Matching Pursuit
        % 暫定更新
        y(mmin) = y(mmin) + z(mmin);
    end
    % 残差成分
    tx = D*y;
    r = x - tx;
    % グラフ更新
    set(hsr,'YData',tx);
    set(hse,'YData',r);
    drawnow
end

%% 評価
if isOmp 
    if isGp
        disp('l0ノルム最小化(GP)')
    else
        disp('l0ノルム最小化(OMP)')
    end
else
    disp('l0ノルム最小化(MP)')
end
mse = sum((x(:)-tx(:)).^2)/numel(x);
fprintf('mse = %f\n',mse);