function [y,f] = rowvecck(x)
% ROWVECCK :	���͂��s�x�N�g�����ǂ����̔���
%
%	[Y,F] = ROWVECCK(X)
%
%	X  : ����
%
%	Y  : �o��
%	F  : �t���O
%
%	���� X ���s�x�N�g���ł���Γ]�u�DF = 1 ���o�́D
%	����ȊO�́CX �����̂܂܁CF = 0 ���o�́D
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
