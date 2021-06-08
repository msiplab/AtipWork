function [lmaxfft,lmaxpow] = circfiltgramlmax(p,sz)
%CIRCFILTGRAMLMAX λmax(P'P)
%   巡回畳み込みPのグラム行列P'Pの最大固有値
%
%   [lmaxfft,lmaxpow] = circfiltgramlmax(p,sz)   
%
%   入力
%       p : 多次元フィルタのインパルス応答
%       sz: 巡回畳み込みの周期(pと同じ次元）
%
%   出力
%       lmaxfft: FFTによる最大固有値の算出結果
%       lmaxpow: べき乗法による最大固有値の算出結果
%
%   補足
%       P の最大特異値σmax(P)=(λmax(P'P))^(1/2)は，
%       >> smax = sqrt(circfiltgramlmax(p,sz))
%
% Copyright (c) all rights reserved, Shogo MURAMATSU, 2019
%

%% FFT method
Fp = fftn(p,sz);      % 多次元FFT
Pp = conj(Fp).*Fp;    % 自己相関のFFT
lmaxfft = max(Pp(:)); % 最大固有値

%% Power method
d = ndims(p); % フィルタの次元
f = conj(p);  %（エルミート）転置フィルタ
for id=1:d
    f = flip(f,id);
end

eps  = 1e-3; % 許容更新誤差
err  = inf;  % 更新誤差
imax = 1000; % 最大繰り返し回数
iter = 1;    % 繰返し回数
xpre = randn(sz);            % 初期ベクトル
xpre = xpre/norm(xpre(:),2); % 正規化処理
while( err > eps && iter < imax )  
    xpst = imfilter(imfilter(xpre,p,'conv','circ'),f,'conv','circ'); % P'P
    lmaxpow = xpre(:)'*xpst(:);    % 最大固有値
    xpre = xpst/norm(xpst(:),2);   % 正規化処理
    err = norm(xpre(:)-xpst(:),2); % 更新誤差
    iter = iter + 1;
end