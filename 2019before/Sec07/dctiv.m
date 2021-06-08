function y = dctiv(x,N)
% DCTIV    : 	�^�C�v IV �� DCT         (���K����)
%
%	Y = DCTIV(X [,N])
%
%	X  : ���̓x�N�g���C���͍s��
%	N  : �ϊ��_��
%
%	Y  : X �� DCT-IV �W��
%
%	X ���s��̂Ƃ��C�e��x�N�g���ɑ΂��ĕϊ�
%	N ���^����ꂽ�ꍇ�C�T�C�Y�������悤�ɁC
%	X �ɑ΂����l�t���C���邢�͐؎̂Ă��s�Ȃ��D
%
%	See also: IDCTIV
%
%	Ref.:	K. R. Rao and P. Yip, "Discrete Cosine Transform",
%		Academic Press, 1990.
%
% $Id: dctiv.m,v 1.1 2006/04/19 17:34:37 sho Exp $
%
% Copyright (C) 1996-2006 Shogo MURAMATSU, All rights reserved
%
narginchk(1,2);	% �����̐��̃`�F�b�N

% �O����

[x,flag] = rowvecck(x);		% ���� x ���s�x�N�g���̂Ƃ��]�u�D
if nargin == 1
    N = size(x,1);		% x �̍s����ϊ��_�� N �Ƃ���D
else
    x = adjcsize(x,N);	% x �̃T�C�Y��_�� N �ɍ��킹��D
end;

% DCT-IV �s��̐���

Scale = sqrt(2/N);		% �X�P�[��

C = zeros(N,N);
for m=0:N-1
    for n=0:N-1
        C(m+1,n+1) = Scale*cos((n+.5)*(m+.5)*pi/N);
    end
end

% DCT-IV

y = C*x;

% �㏈��

if flag				% ���� x ���C�s�x�N�g���̂Ƃ��C
    y = y.';		% �o�� y ���C�s�x�N�g���Ƃ���D
end