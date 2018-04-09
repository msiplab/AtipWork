function x = idctiii(y,N)
% IDCTIII  :  	�^�C�v III �� IDCT       (���K����)
%
%	X = IDCTIII(Y [,N])
%
%	Y  : DCT-III �W��
%	N  : �ϊ��_��
%	
%	X  : �o�͍s��
%
%	N ���^����ꂽ�ꍇ�C�T�C�Y�������悤��
%	Y �ɑ΂����l�t���C���邢�͐؎̂Ă��s�Ȃ��D
%
%	See also: DCTIII
%
%		Written by S. Muramatsu (5 Oct.,`96)
%
% $Id: practice06_3_ip.m,v 1.4 2007/07/07 01:06:38 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%
narginchk(1,2);	% �����̐��̃`�F�b�N

if nargin == 1
	x = dctii(y);
else
	x = dctii(y,N);
end
