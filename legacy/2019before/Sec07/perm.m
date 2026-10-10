function y = perm(x)
% PERM     :	置換操作 (IPERM の逆)
%
%	Y = PERM(X)
%
%	X  : 入力行列，あるいはベクトル
%
%	Y  : 出力行列，あるいはベクトル
%
%       PERM(X) は行列 X の偶数行を上半分，
%	奇数行を下半分に振り分ける．
%
%	See also: IPERM
%
% $Id: perm.m,v 1.1 2006/04/19 17:34:37 sho Exp $
%
% Copyright (C) 1996-2015 Shogo MURAMATSU, All rights reserved
%
[x,flag] = rowvecck(x);		% 入力 x が行ベクトルのとき転置．
ColSize  = size(x,1);
HcolSize = ColSize/2;

y(1:ceil(HcolSize),:)         = x(1:2:ColSize,:);
y(ceil(HcolSize)+1:ColSize,:) = x(2:2:ColSize,:);

if flag				% 入力 x が，行ベクトルのとき，
	y = y.';		% 出力 y も，行ベクトルとする．
end
