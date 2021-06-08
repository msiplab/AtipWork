function [y,f] = rowvecck(x)
% ROWVECCK :	入力が行ベクトルかどうかの判定
%
%	[Y,F] = ROWVECCK(X)
%
%	X  : 入力
%
%	Y  : 出力
%	F  : フラグ
%
%	入力 X が行ベクトルであれば転置．F = 1 を出力．
%	それ以外は，X をそのまま，F = 0 を出力．
%
%		Written by S. Muramatsu (5 Oct.,`96)
%
% $Id: predictionStep_ip.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 1996-2015 Shogo MURAMATSU, All rights reserved
%
if size(x,1) == 1
	f = 1;
	y = x(:);
else
	f = 0;
	y = x;
end;
