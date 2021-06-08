function y = dcti(x,N)
% DCTI     : 	タイプ I の DCT	         (正規直交)
%
%	Y = DCTI(X [,N])
%
%	X  : 入力ベクトル，或は行列 
%	N  : 変換点数
%	
%	Y  : X の DCT-I 係数
%
%	X が行列のとき，各列ベクトルに対して変換
%	N が与えられた場合，サイズが合うように，
%	X に対する零値付加，あるいは切捨てを行なう．
%
%	See also: IDCTI
%
%	Ref.:	K. R. Rao and P. Yip, "Discrete Cosine Transform",
%		Academic Press, 1990.
%
%		Written by S. Muramatsu (5 Oct.,`96)
%
% $Id: dcti.m,v 1.1 2006/04/19 17:34:37 sho Exp $
%
% Copyright (C) 1996-2015 Shogo MURAMATSU, All rights reserved
%
narginchk(1,2);	% 引数の数のチェック

% 前処理

[x,flag] = rowvecck(x);		% 入力 x が行ベクトルのとき転置．
if nargin == 1	
	N = size(x,1);		% x の行数を変換点数 N とする．
else
	x = adjcsize(x,N);	% x のサイズを点数 N に合わせる． 
end;

% DCT-I 行列の生成

Scale = sqrt(2/(N-1));		% スケール
SQRT_H = 7.071067811865475e-01; % 2 の平方根の逆数

C = zeros(N,N);
for m=0:N-1
	for n=0:N-1
		C(m+1,n+1) = Scale*cos(n*m*pi/(N-1)); 
		if(m == 0 || m == (N-1))
			C(m+1,n+1) = C(m+1,n+1)*SQRT_H;
		end
		if(n == 0 || n == (N-1))
			C(m+1,n+1) = C(m+1,n+1)*SQRT_H;
		end
	end
end

% DCT-I

y = C*x;

% 後処理

if flag				% 入力 x が，行ベクトルのとき，
	y = y.';		% 出力 y も，行ベクトルとする．
end
