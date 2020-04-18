% practice07_8.m
%
% $Id: practice07_8.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% ベクトルの次元
nPoints = 4;

%% 相関係数 |ρ|<1
rho = 0.99995; 

%% 共分散行列
Rxx = toeplitz(power(rho,0:nPoints-1)); 

%% 固有ベクトルと固有値の計算
[V,D] = eig(Rxx);	

%% 固有値のソート
[Y,I] = sort(diag(D));  

%% KLT 行列
Phi = V(:,nPoints-I+1).';
disp('Phi')
disp(Phi)

% DCT 行列
C = dct(eye(nPoints));
disp('C')
disp(C)
