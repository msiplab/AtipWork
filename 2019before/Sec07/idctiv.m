function x = idctiv(y,N)
% IDCTIV   :  	�^�C�v IV �� IDCT        (���K����)
%
%	X = IDCTIV(Y [,N])
%
%	Y  : DCT-IV �W��
%	N  : �ϊ��_��
%	
%	X  : �o�͍s��
%
%	N ���^����ꂽ�ꍇ�C�T�C�Y�������悤��
%	Y �ɑ΂����l�t���C���邢�͐؎̂Ă��s�Ȃ��D
%
%	See also: DCTIV
%
% $Id: idctiv.m,v 1.1 2006/04/19 17:34:37 sho Exp $
%
% Copyright (C) 1996-2015 Shogo MURAMATSU, All rights reserved
%
error(nargchk(1,2,nargin));	% �����̐��̃`�F�b�N

if nargin == 1
	x = dctiv(y);
else
	x = dctiv(y,N);
end;
