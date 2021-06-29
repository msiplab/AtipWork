%
% $Id: exLinComb.m,v 1.2 2006/05/29 12:08:53 sho Exp $
%
% Copyright (C) 2005-2006 Shogo MURAMATSU, All rights reserved
%

x = [ 1 2 ].'; % ベクトルx の定義
A = [ 1 1 ; -1 1 ]; % 変換行列
y = A * x; % 変換係数の計算
invA = inv(A); % 変換行列の逆行列
b0 = invA(:,1); % 基底ベクトル b0
b1 = invA(:,2); % 基底ベクトル b1
y(1) * b0 + y(2) * b1 % 基底ベクトルの線形結合
