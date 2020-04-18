function y = wadcti(x,N)
% WADCTI   :	Wang �̍��� DCT- I       (���K����)
%
%	Y = WADCTI(X [,N])
%
%	X  : ���̓x�N�g���C���͍s�� 
%	N  : �ϊ��_��
%	
%	Y  : X �� DCT-I �W��
%
%	X ���s��̂Ƃ��C�e��x�N�g���ɑ΂��ĕϊ�
%	N ���^����ꂽ�ꍇ�C�T�C�Y�������悤�ɁC
%	X �ɑ΂����l�t���C���邢�͐؎̂Ă��s�Ȃ��D
%
%	See also: WADCTII, WADCTIII, WADCTIV
%
%	Ref.:	Z. Wang, "Fast Algorithms for the Discrete W 
%		Transform and for the Discrete Fourier Transform,"
%		IEEE Trans. ASSP, Vol.32, No.4,	pp.803-816, Aug. 1984. 
%
% $Id: wadcti.m,v 1.1 2006/04/19 17:34:37 sho Exp $
%
% Copyright (C) 1996-2015 Shogo MURAMATSU, All rights reserved
%
narginchk(1,2);	% �����̐��̃`�F�b�N

% �O����

[x,flag] = rowvecck(x);		% ���� x ���s�x�N�g���̂Ƃ��]�u�D
if nargin == 1	
	N = size(x,1);		% x �̍s����ϊ��_�� M �Ƃ���D
else
	x = adjcsize(x,N);	% x �̃T�C�Y��_�� M �ɍ��킹��D 
end;

% Wang �� ���� DCT-I

M = N-1;
SQRT_H = 7.071067811865475e-01;
SQRT_2 = 1.414213562373095e+00;

if M == 2		% 3 �_ DCT-I
	
	x(2,:) = x(2,:)*SQRT_2;
	y(1,:) = (x(1,:) + x(2,:) + x(3,:))/2;
	y(2,:) = (x(1,:)          - x(3,:))*SQRT_H;
	y(3,:) = (x(1,:) - x(2,:) + x(3,:))/2;

elseif rem(M,2) == 0	% M+1 �_ ���� DCT-I (M �� 2 �̔{���̂Ƃ�)

	HM = M/2;

	% DCT-I, III �ɂ��ϊ�
	ye = wadcti([x(1:HM,:)+x(N:-1:HM+2,:);SQRT_2*x(HM+1,:)])*SQRT_H;
	yo = wadctiii(x(1:HM,:)-x(N:-1:HM+2,:))*SQRT_H;

	% �u������
	y = iperm([ye;yo]); 	

else		% M+1 �_ DCT-I �̍s�񉉎Z (M �� 2 �̔{���ł͂Ȃ��Ƃ�)

	y = dcti(x,N);

end;

% �㏈��

if flag				% ���� x ���C�s�x�N�g���̂Ƃ��C
	y = y.';		% �o�� y ���C�s�x�N�g���Ƃ���D
end;


