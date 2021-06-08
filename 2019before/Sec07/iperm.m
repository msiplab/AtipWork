function x = iperm(y)
% IPER     :	置換操作 (PERM の逆)
%
%	X = IPERM(Y)
%
%	Y  : 入力行列，あるいはベクトル
%
%	X  : 出力行列，あるいはベクトル
%
%	See also: PERM
%
% $Id: iperm.m,v 1.1 2006/04/19 17:34:37 sho Exp $
%
% Copyright (C) 1996-2015 Shogo MURAMATSU, All rights reserved
%

[y,flag] = rowvecck(y);		% 入力 y が行ベクトルのとき転置．

ColSize = size(y,1);
HcolSize = ColSize/2;

x(1:2:ColSize,:) = y(1:ceil(HcolSize),:);
x(2:2:ColSize,:) = y(ceil(HcolSize)+1:ColSize,:); 

if flag				% 入力 y が，行ベクトルのとき，
	x = x.';		% 出力 x も，行ベクトルとする．
end
