function h = downsampleFilterDesign2(prtFilter,slaMtx, phase)
%
% Inputs
%
%   prtFilter: 1-D prototype filter
%   slaMtx:    down-/up-sampling matrix of decimator/interpolator
%   phase:     phase of downsampling 
%
% Output
%
%   h:         inpulse response of designed filter
%
% $Id: downsampleFilterDesign2.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2007 Shogo MURAMATSU, All rights reserved
%
if nargin < 3
    phase = [0 0].';
else
    phase = phase(:);
end

% �Ԉ����s��̍s�񎮂̐�Βl
absDetMtx = abs(det(slaMtx));

% �񎟌������t�B���^�̍쐬
spFilter = kron(prtFilter(:).',prtFilter(:));

% �_�E���T���v�����O
adjMtx = absDetMtx*inv(slaMtx); %#ok
h = absDetMtx * downsample2(spFilter,adjMtx,phase);

% end of downsampleFilterDesign2
