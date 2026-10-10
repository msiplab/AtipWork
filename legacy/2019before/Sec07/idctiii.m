function x = idctiii(y,N)
% IDCTIII  :  	タイプ III の IDCT       (正規直交)
%
%	X = IDCTIII(Y [,N])
%
%	Y  : DCT-III 係数
%	N  : 変換点数
%	
%	X  : 出力行列
%
%	N が与えられた場合，サイズが合うように
%	Y に対する零値付加，あるいは切捨てを行なう．
%
%	See also: DCTIII
%
%		Written by S. Muramatsu (5 Oct.,`96)
%
% $Id: practice06_3_ip.m,v 1.4 2007/07/07 01:06:38 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%
narginchk(1,2);	% 引数の数のチェック

if nargin == 1
	x = dctii(y);
else
	x = dctii(y,N);
end
