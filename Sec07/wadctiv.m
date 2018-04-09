function y = wadctiv(x,M)
% WADCTIV  :	Wang の高速 DCT-IV       (正規直交)
%
%	Y = WADCTIV(X [,M])
%
%	X  : 入力ベクトル，或は行列 
%	M  : 変換点数
%	
%	Y  : X の DCT-IV 係数
%
%	X が行列のとき，各列ベクトルに対して変換
%	M が与えられた場合，サイズが合うように，
%	X に対する零値付加，あるいは切捨てを行なう．
%
%	See also: WADCTI, WADCTII, WADCTIII
%
%	Ref.:	Z. Wang, "On Computing the Discrete Fourier and 
%		Cosine Transforms," IEEE Trans. ASSP, Vol.33, No.4,
%		pp.1341-1344, Oct. 1985. 
%
% $Id: wadctiv.m,v 1.1 2006/04/19 17:34:37 sho Exp $
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

% Wang の 高速 DCT-IV

SQRT_H = 7.071067811865475e-01;

if M == 2		% 2 点 DCT-IV

	COSPI_8 = cos(pi/8);
	SINPI_8 = sin(pi/8);
	y(1,:) = x(1,:)*COSPI_8 + x(2,:)*SINPI_8;
	y(2,:) = x(1,:)*SINPI_8 - x(2,:)*COSPI_8;

elseif rem(M,2) == 0	% M 点 高速 DCT-IV (M が 2 の倍数のとき)

	HM = M/2;
	DiagCos = diag( cos(pi*(1:2:M-1)/(4*M)) );
	DiagSin = diag( sin(pi*(1:2:M-1)/(4*M)) );

	% バタフライ，置換操作 
	ze(1,:) = x(1,:);
	zo(1,:) = x(M,:);
	for i=2:HM
		ze(i,     :) = ( x(2*(i-1),:) + x(2*(i-1)+1,:) )*SQRT_H;
		zo(HM+2-i,:) = ( x(2*(i-1),:) - x(2*(i-1)+1,:) )*SQRT_H;
	end;

	%  DCT-III による変換
	ue = wadctiii(ze);
	uo = diag( (-1).^(0:HM-1) )*wadctiii(zo);

	% 平面回転 (便宜上，3/3 アルゴリズムは使用しない)
	y(1:HM,  :) =         DiagCos*ue + DiagSin*uo;
	y(HM+1:M,:) = flipud( DiagSin*ue - DiagCos*uo );

else		% M 点 DCT-IV の行列演算 (M が 2 の倍数ではないとき)

	y = dctiv(x,M);

end;

% 後処理

if flag				% 入力 x が，行ベクトルのとき，
	y = y.';		% 出力 y も，行ベクトルとする．
end;

