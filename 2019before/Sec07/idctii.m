function x = idctii(y,N)
% IDCTII   :  	タイプ II の IDCT        (正規直交)
%
%	X = IDCTII(Y [,N])
%
%	Y  : DCT-II 係数
%	N  : 変換点数
%	
%	X  : 出力行列
%
%	N が与えられた場合，サイズが合うように
%	Y に対する零値付加，あるいは切捨てを行なう．
%
%	See also: DCTII
%
%		Written by S. Muramatsu (5 Oct.,`96)
%
% $Id: practice06_3_ip.m,v 1.4 2007/07/07 01:06:38 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%
narginchk(1,2);	% 引数の数のチェック

if nargin == 1
	x = dctiii(y);
else
	x = dctiii(y,N);
end
