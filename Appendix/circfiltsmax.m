function smax = circfiltsmax(p,sz)
%CIRCFILTSMAX σmax(P)
%   巡回畳み込みPの最大特異値
%
%   smax = circfiltsmax(p,sz)   
%
%   入力
%       p : 多次元フィルタのインパルス応答
%       sz: 巡回畳み込みの周期(pと同じ次元）
%
%   出力
%       smax: 最大特異値
%
% Copyright (c) all rights reserved, Shogo MURAMATSU, 2019
%
Fp = fftn(p,sz);   % 多次元FFT
Pp = conj(Fp).*Fp; % 自己相関のFFT
lmax = max(Pp(:)); % グラム行列の最大固有値
smax = sqrt(lmax); % 最大特異値