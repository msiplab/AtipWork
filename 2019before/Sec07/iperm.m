function x = iperm(y)
% IPER     :	�u������ (PERM �̋t)
%
%	X = IPERM(Y)
%
%	Y  : ���͍s��C���邢�̓x�N�g��
%
%	X  : �o�͍s��C���邢�̓x�N�g��
%
%	See also: PERM
%
% $Id: iperm.m,v 1.1 2006/04/19 17:34:37 sho Exp $
%
% Copyright (C) 1996-2015 Shogo MURAMATSU, All rights reserved
%

[y,flag] = rowvecck(y);		% ���� y ���s�x�N�g���̂Ƃ��]�u�D

ColSize = size(y,1);
HcolSize = ColSize/2;

x(1:2:ColSize,:) = y(1:ceil(HcolSize),:);
x(2:2:ColSize,:) = y(ceil(HcolSize)+1:ColSize,:); 

if flag				% ���� y ���C�s�x�N�g���̂Ƃ��C
	x = x.';		% �o�� x ���C�s�x�N�g���Ƃ���D
end
