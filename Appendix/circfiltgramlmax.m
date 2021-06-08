function [lmaxfft,lmaxpow] = circfiltgramlmax(p,sz)
%CIRCFILTGRAMLMAX ��max(P'P)
%   �����ݍ���P�̃O�����s��P'P�̍ő�ŗL�l
%
%   [lmaxfft,lmaxpow] = circfiltgramlmax(p,sz)   
%
%   ����
%       p : �������t�B���^�̃C���p���X����
%       sz: �����ݍ��݂̎���(p�Ɠ��������j
%
%   �o��
%       lmaxfft: FFT�ɂ��ő�ŗL�l�̎Z�o����
%       lmaxpow: �ׂ���@�ɂ��ő�ŗL�l�̎Z�o����
%
%   �⑫
%       P �̍ő���ْl��max(P)=(��max(P'P))^(1/2)�́C
%       >> smax = sqrt(circfiltgramlmax(p,sz))
%
% Copyright (c) all rights reserved, Shogo MURAMATSU, 2019
%

%% FFT method
Fp = fftn(p,sz);      % ������FFT
Pp = conj(Fp).*Fp;    % ���ȑ��ւ�FFT
lmaxfft = max(Pp(:)); % �ő�ŗL�l

%% Power method
d = ndims(p); % �t�B���^�̎���
f = conj(p);  %�i�G���~�[�g�j�]�u�t�B���^
for id=1:d
    f = flip(f,id);
end

eps  = 1e-3; % ���e�X�V�덷
err  = inf;  % �X�V�덷
imax = 1000; % �ő�J��Ԃ���
iter = 1;    % �J�Ԃ���
xpre = randn(sz);            % �����x�N�g��
xpre = xpre/norm(xpre(:),2); % ���K������
while( err > eps && iter < imax )  
    xpst = imfilter(imfilter(xpre,p,'conv','circ'),f,'conv','circ'); % P'P
    lmaxpow = xpre(:)'*xpst(:);    % �ő�ŗL�l
    xpre = xpst/norm(xpst(:),2);   % ���K������
    err = norm(xpre(:)-xpst(:),2); % �X�V�덷
    iter = iter + 1;
end