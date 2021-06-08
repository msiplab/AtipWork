function y = wadctiii(x,M)
% WADCTIII :	Wang �̍��� DCT-III      (���K����)
%
%	Y = WADCTIII(X [,M])
%
%	X  : ���̓x�N�g���C���͍s�� 
%	M  : �ϊ��_��
%	
%	Y  : X �� DCT-III �W��
%
%	X ���s��̂Ƃ��C�e��x�N�g���ɑ΂��ĕϊ�
%	M ���^����ꂽ�ꍇ�C�T�C�Y�������悤�ɁC
%	X �ɑ΂����l�t���C���邢�͐؎̂Ă��s�Ȃ��D
%
%	See also: WADCTI, WADCTII, WADCTIV
%
%	Ref.:	Z. Wang, "Fast Algorithms for the Discrete W 
%		Transform and for the Discrete Fourier Transform,"
%		IEEE Trans. ASSP, Vol.32, No.4,	pp.803-816, Aug. 1984. 
%
% $Id: wadctiii.m,v 1.1 2006/04/19 17:34:37 sho Exp $
%
% Copyright (C) 1996-2015 Shogo MURAMATSU, All rights reserved
%
narginchk(1,2);	% �����̐��̃`�F�b�N

% �O����

[x,flag] = rowvecck(x);		% ���� x ���s�x�N�g���̂Ƃ��]�u�D
if nargin == 1	
	M = size(x,1);		% x �̍s����ϊ��_�� M �Ƃ���D
else
	x = adjcsize(x,M);	% x �̃T�C�Y��_�� M �ɍ��킹��D 
end;

% Wang �� ���� DCT-III

SQRT_H = 7.071067811865475e-01;

if M == 2		% 2 �_ DCT-III

	y(1,:) = ( x(1,:) + x(2,:) )*SQRT_H;
	y(2,:) = ( x(1,:) - x(2,:) )*SQRT_H;

elseif rem(M,2) == 0	% M �_ ���� DCT-iII (M �� 2 �̔{���̂Ƃ�)

	HM = M/2;

	% �u������
	u = perm(x);

	% DCT-III, IV �ɂ��ϊ�
	ye = wadctiii(u(1:HM,:));
	yo =  wadctiv(u(HM+1:M,:));
	y(1:HM,:)   =       ( ye + yo )*SQRT_H;
	y(HM+1:M,:) = flipud( ye - yo )*SQRT_H;

else			% M �_ DCT-III �̍s�񉉎Z (M �� 2 �̔{���ł͂Ȃ��Ƃ�)

	y = dctiii(x,M);

end;

% �㏈��

if flag				% ���� x ���C�s�x�N�g���̂Ƃ��C
	y = y.';		% �o�� y ���C�s�x�N�g���Ƃ���D
end;

