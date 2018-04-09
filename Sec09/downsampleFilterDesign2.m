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

% 間引き行列の行列式の絶対値
absDetMtx = abs(det(slaMtx));

% 二次元可分離フィルタの作成
spFilter = kron(prtFilter(:).',prtFilter(:));

% ダウンサンプリング
adjMtx = absDetMtx*inv(slaMtx); %#ok
h = absDetMtx * downsample2(spFilter,adjMtx,phase);

% end of downsampleFilterDesign2
