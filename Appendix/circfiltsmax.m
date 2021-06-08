function smax = circfiltsmax(p,sz)
%CIRCFILTSMAX ��max(P)
%   �����ݍ���P�̍ő���ْl
%
%   smax = circfiltsmax(p,sz)   
%
%   ����
%       p : �������t�B���^�̃C���p���X����
%       sz: �����ݍ��݂̎���(p�Ɠ��������j
%
%   �o��
%       smax: �ő���ْl
%
% Copyright (c) all rights reserved, Shogo MURAMATSU, 2019
%
Fp = fftn(p,sz);   % ������FFT
Pp = conj(Fp).*Fp; % ���ȑ��ւ�FFT
lmax = max(Pp(:)); % �O�����s��̍ő�ŗL�l
smax = sqrt(lmax); % �ő���ْl