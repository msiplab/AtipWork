function y = dctiv(x,N)
% DCTIV    : 	タイプ IV の DCT         (正規直交)
%
%	Y = DCTIV(X [,N])
%
%	X  : 入力ベクトル，或は行列
%	N  : 変換点数
%
%	Y  : X の DCT-IV 係数
%
%	X が行列のとき，各列ベクトルに対して変換
%	N が与えられた場合，サイズが合うように，
%	X に対する零値付加，あるいは切捨てを行なう．
%
%	See also: IDCTIV
%
%	Ref.:	K. R. Rao and P. Yip, "Discrete Cosine Transform",
%		Academic Press, 1990.
%
% $Id: dctiv.m,v 1.1 2006/04/19 17:34:37 sho Exp $
%
% Copyright (C) 1996-2006 Shogo MURAMATSU, All rights reserved
%
narginchk(1,2);	% 引数の数のチェック

% 前処理

[x,flag] = rowvecck(x);		% 入力 x が行ベクトルのとき転置．
if nargin == 1
    N = size(x,1);		% x の行数を変換点数 N とする．
else
    x = adjcsize(x,N);	% x のサイズを点数 N に合わせる．
end;

% DCT-IV 行列の生成

Scale = sqrt(2/N);		% スケール

C = zeros(N,N);
for m=0:N-1
    for n=0:N-1
        C(m+1,n+1) = Scale*cos((n+.5)*(m+.5)*pi/N);
    end
end

% DCT-IV

y = C*x;

% 後処理

if flag				% 入力 x が，行ベクトルのとき，
    y = y.';		% 出力 y も，行ベクトルとする．
end