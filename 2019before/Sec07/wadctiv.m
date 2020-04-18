function y = wadctiv(x,M)
% WADCTIV  :	Wang �̍��� DCT-IV       (���K����)
%
%	Y = WADCTIV(X [,M])
%
%	X  : ���̓x�N�g���C���͍s�� 
%	M  : �ϊ��_��
%	
%	Y  : X �� DCT-IV �W��
%
%	X ���s��̂Ƃ��C�e��x�N�g���ɑ΂��ĕϊ�
%	M ���^����ꂽ�ꍇ�C�T�C�Y�������悤�ɁC
%	X �ɑ΂����l�t���C���邢�͐؎̂Ă��s�Ȃ��D
%
%	See also: WADCTI, WADCTII, WADCTIII
%
%	Ref.:	Z. Wang, "On Computing the Discrete Fourier and 
%		Cosine Transforms," IEEE Trans. ASSP, Vol.33, No.4,
%		pp.1341-1344, Oct. 1985. 
%
% $Id: wadctiv.m,v 1.1 2006/04/19 17:34:37 sho Exp $
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

% Wang �� ���� DCT-IV

SQRT_H = 7.071067811865475e-01;

if M == 2		% 2 �_ DCT-IV

	COSPI_8 = cos(pi/8);
	SINPI_8 = sin(pi/8);
	y(1,:) = x(1,:)*COSPI_8 + x(2,:)*SINPI_8;
	y(2,:) = x(1,:)*SINPI_8 - x(2,:)*COSPI_8;

elseif rem(M,2) == 0	% M �_ ���� DCT-IV (M �� 2 �̔{���̂Ƃ�)

	HM = M/2;
	DiagCos = diag( cos(pi*(1:2:M-1)/(4*M)) );
	DiagSin = diag( sin(pi*(1:2:M-1)/(4*M)) );

	% �o�^�t���C�C�u������ 
	ze(1,:) = x(1,:);
	zo(1,:) = x(M,:);
	for i=2:HM
		ze(i,     :) = ( x(2*(i-1),:) + x(2*(i-1)+1,:) )*SQRT_H;
		zo(HM+2-i,:) = ( x(2*(i-1),:) - x(2*(i-1)+1,:) )*SQRT_H;
	end;

	%  DCT-III �ɂ��ϊ�
	ue = wadctiii(ze);
	uo = diag( (-1).^(0:HM-1) )*wadctiii(zo);

	% ���ʉ�] (�֋X��C3/3 �A���S���Y���͎g�p���Ȃ�)
	y(1:HM,  :) =         DiagCos*ue + DiagSin*uo;
	y(HM+1:M,:) = flipud( DiagSin*ue - DiagCos*uo );

else		% M �_ DCT-IV �̍s�񉉎Z (M �� 2 �̔{���ł͂Ȃ��Ƃ�)

	y = dctiv(x,M);

end;

% �㏈��

if flag				% ���� x ���C�s�x�N�g���̂Ƃ��C
	y = y.';		% �o�� y ���C�s�x�N�g���Ƃ���D
end;

