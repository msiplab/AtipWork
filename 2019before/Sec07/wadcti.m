function y = wadcti(x,N)
% WADCTI   :	Wang の高速 DCT- I       (正規直交)
%
%	Y = WADCTI(X [,N])
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
%	See also: WADCTII, WADCTIII, WADCTIV
%
%	Ref.:	Z. Wang, "Fast Algorithms for the Discrete W 
%		Transform and for the Discrete Fourier Transform,"
%		IEEE Trans. ASSP, Vol.32, No.4,	pp.803-816, Aug. 1984. 
%
% $Id: wadcti.m,v 1.1 2006/04/19 17:34:37 sho Exp $
%
% Copyright (C) 1996-2015 Shogo MURAMATSU, All rights reserved
%
narginchk(1,2);	% 引数の数のチェック

% 前処理

[x,flag] = rowvecck(x);		% 入力 x が行ベクトルのとき転置．
if nargin == 1	
	N = size(x,1);		% x の行数を変換点数 M とする．
else
	x = adjcsize(x,N);	% x のサイズを点数 M に合わせる． 
end;

% Wang の 高速 DCT-I

M = N-1;
SQRT_H = 7.071067811865475e-01;
SQRT_2 = 1.414213562373095e+00;

if M == 2		% 3 点 DCT-I
	
	x(2,:) = x(2,:)*SQRT_2;
	y(1,:) = (x(1,:) + x(2,:) + x(3,:))/2;
	y(2,:) = (x(1,:)          - x(3,:))*SQRT_H;
	y(3,:) = (x(1,:) - x(2,:) + x(3,:))/2;

elseif rem(M,2) == 0	% M+1 点 高速 DCT-I (M が 2 の倍数のとき)

	HM = M/2;

	% DCT-I, III による変換
	ye = wadcti([x(1:HM,:)+x(N:-1:HM+2,:);SQRT_2*x(HM+1,:)])*SQRT_H;
	yo = wadctiii(x(1:HM,:)-x(N:-1:HM+2,:))*SQRT_H;

	% 置換操作
	y = iperm([ye;yo]); 	

else		% M+1 点 DCT-I の行列演算 (M が 2 の倍数ではないとき)

	y = dcti(x,N);

end;

% 後処理

if flag				% 入力 x が，行ベクトルのとき，
	y = y.';		% 出力 y も，行ベクトルとする．
end;


