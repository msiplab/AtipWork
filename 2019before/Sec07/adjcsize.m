function y = adjcsize(x,N)
% ADJCSIZE :	���͂̍s���𒲐�
%
%	Y = ADJCSIZE(X,N)
%
%	X  : ���͍s��
%
%	Y  : �o�͍s��
%
%	���� X �̗�T�C�Y���CN �ɂȂ�悤�ɁC
%	��l�t���C���邢�͐؎̂Ă��s�Ȃ��D
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
