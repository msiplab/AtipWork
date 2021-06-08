function x = idcti(y,N)
% IDCTI    :  	�^�C�v I �� IDCT         (���K����)
%
%	X = IDCTI(Y [,N])
%
%	Y  : DCT-I �W��
%	N  : �ϊ��_��
%	
%	X  : �o�͍s��
%
%	N ���^����ꂽ�ꍇ�C�T�C�Y�������悤��
%	Y �ɑ΂����l�t���C���邢�͐؎̂Ă��s�Ȃ��D
%
%	See also: DCTI
%
% $Id: idcti.m,v 1.1 2006/04/19 17:34:37 sho Exp $
%
% Copyright (C) 1996-2015 Shogo MURAMATSU, All rights reserved
%
narginchk(1,2);	% �����̐��̃`�F�b�N

if nargin == 1
	x = dcti(y);
else
	x = dcti(y,N);
end
