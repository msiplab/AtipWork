function y = perm(x)
% PERM     :	�u������ (IPERM �̋t)
%
%	Y = PERM(X)
%
%	X  : ���͍s��C���邢�̓x�N�g��
%
%	Y  : �o�͍s��C���邢�̓x�N�g��
%
%       PERM(X) �͍s�� X �̋����s���㔼���C
%	��s���������ɐU�蕪����D
%
%	See also: IPERM
%
% $Id: perm.m,v 1.1 2006/04/19 17:34:37 sho Exp $
%
% Copyright (C) 1996-2015 Shogo MURAMATSU, All rights reserved
%
[x,flag] = rowvecck(x);		% ���� x ���s�x�N�g���̂Ƃ��]�u�D
ColSize  = size(x,1);
HcolSize = ColSize/2;

y(1:ceil(HcolSize),:)         = x(1:2:ColSize,:);
y(ceil(HcolSize)+1:ColSize,:) = x(2:2:ColSize,:);

if flag				% ���� x ���C�s�x�N�g���̂Ƃ��C
	y = y.';		% �o�� y ���C�s�x�N�g���Ƃ���D
end
