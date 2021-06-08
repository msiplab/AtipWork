function x = idctii(y,N)
% IDCTII   :  	�^�C�v II �� IDCT        (���K����)
%
%	X = IDCTII(Y [,N])
%
%	Y  : DCT-II �W��
%	N  : �ϊ��_��
%	
%	X  : �o�͍s��
%
%	N ���^����ꂽ�ꍇ�C�T�C�Y�������悤��
%	Y �ɑ΂����l�t���C���邢�͐؎̂Ă��s�Ȃ��D
%
%	See also: DCTII
%
%		Written by S. Muramatsu (5 Oct.,`96)
%
% $Id: practice06_3_ip.m,v 1.4 2007/07/07 01:06:38 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%
narginchk(1,2);	% �����̐��̃`�F�b�N

if nargin == 1
	x = dctiii(y);
else
	x = dctiii(y,N);
end
