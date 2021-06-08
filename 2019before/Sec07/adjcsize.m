function y = adjcsize(x,N)
% ADJCSIZE :	入力の行数を調整
%
%	Y = ADJCSIZE(X,N)
%
%	X  : 入力行列
%
%	Y  : 出力行列
%
%	入力 X の列サイズが，N になるように，
%	零値付加，あるいは切捨てを行なう．
%
%		Written by S. Muramatsu (5 Oct.,`96)
%
% $Id: practice06_3_ip.m,v 1.4 2007/07/07 01:06:38 sho Exp $
%
% Copyright (C) 1996-2015 Shogo MURAMATSU, All rights reserved
%
if N > size(x,1)
	y = [x;zeros(N-size(x,1),size(x,2))];
elseif N < size(x,1)
	y = x(1:N,:);	
else
	y = x;
end
