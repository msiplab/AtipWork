function x = idctiv(y,N)
% IDCTIV   :  	タイプ IV の IDCT        (正規直交)
%
%	X = IDCTIV(Y [,N])
%
%	Y  : DCT-IV 係数
%	N  : 変換点数
%	
%	X  : 出力行列
%
%	N が与えられた場合，サイズが合うように
%	Y に対する零値付加，あるいは切捨てを行なう．
%
%	See also: DCTIV
%
% $Id: idctiv.m,v 1.1 2006/04/19 17:34:37 sho Exp $
%
% Copyright (C) 1996-2015 Shogo MURAMATSU, All rights reserved
%
error(nargchk(1,2,nargin));	% 引数の数のチェック

if nargin == 1
	x = dctiv(y);
else
	x = dctiv(y,N);
end;
