function y = wadctiii(x,M)
% WADCTIII :	Wang の高速 DCT-III      (正規直交)
%
%	Y = WADCTIII(X [,M])
%
%	X  : 入力ベクトル，或は行列 
%	M  : 変換点数
%	
%	Y  : X の DCT-III 係数
%
%	X が行列のとき，各列ベクトルに対して変換
%	M が与えられた場合，サイズが合うように，
%	X に対する零値付加，あるいは切捨てを行なう．
%
%	See also: WADCTI, WADCTII, WADCTIV
%
%	Ref.:	Z. Wang, "Fast Algorithms for the Discrete W 
%		Transform and for the Discrete Fourier Transform,"
%		IEEE Trans. ASSP, Vol.32, No.4,	pp.803-816, Aug. 1984. 
%
% $Id: wadctiii.m,v 1.1 2006/04/19 17:34:37 sho Exp $
%
% Copyright (C) 1996-2015 Shogo MURAMATSU, All rights reserved
%
narginchk(1,2);	% 引数の数のチェック

% 前処理

[x,flag] = rowvecck(x);		% 入力 x が行ベクトルのとき転置．
if nargin == 1	
	M = size(x,1);		% x の行数を変換点数 M とする．
else
	x = adjcsize(x,M);	% x のサイズを点数 M に合わせる． 
end;

% Wang の 高速 DCT-III

SQRT_H = 7.071067811865475e-01;

if M == 2		% 2 点 DCT-III

	y(1,:) = ( x(1,:) + x(2,:) )*SQRT_H;
	y(2,:) = ( x(1,:) - x(2,:) )*SQRT_H;

elseif rem(M,2) == 0	% M 点 高速 DCT-iII (M が 2 の倍数のとき)

	HM = M/2;

	% 置換操作
	u = perm(x);

	% DCT-III, IV による変換
	ye = wadctiii(u(1:HM,:));
	yo =  wadctiv(u(HM+1:M,:));
	y(1:HM,:)   =       ( ye + yo )*SQRT_H;
	y(HM+1:M,:) = flipud( ye - yo )*SQRT_H;

else			% M 点 DCT-III の行列演算 (M が 2 の倍数ではないとき)

	y = dctiii(x,M);

end;

% 後処理

if flag				% 入力 x が，行ベクトルのとき，
	y = y.';		% 出力 y も，行ベクトルとする．
end;

