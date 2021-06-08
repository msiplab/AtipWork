% practice_a_1.m
%
% $Id:$
%
% Copyright (C) 2012-2015 Shogo MURAMATSU, All rights reserved
%
close all; clc

mse  = @(s,r) sum((s(:)-r(:)).^2)/numel(s);
psnr = @(s,r) -10*log10(mse(s,r));

%% パラメータ設定
psfSigma = 2; % 点広がり関数の標準偏差 
nseSigma = 5; % 加法性白色ガウスノイズの標準偏差
nlevels  = 3; % ウェーブレット段数
eps      = 1e-4; % ISTA の許容誤差（収束条件）
lambda   = 0.001; % 制御パラメータλ

%% 原画像の読み込み
src = im2double(imread('./data/org.tif'));
%src = im2double(imread('cameraman.tif'));
subplot(2,2,1), imshow(src);
title('原画像')

%% 観測画像の生成
psfSize = 2*round(4*psfSigma)+1;
psf = fspecial('gaussian',psfSize,psfSigma);
linrprocess = @(x) imfilter(x,psf,'conv','circ');
obs = imnoise(linrprocess(src),'gaussian',0,(nseSigma/255)^2);
subplot(2,2,2), imshow(obs);
title(sprintf('観測画像：PSNR = %5.2f [dB]',psnr(src,obs)))

%% ウィーナーフィルタ
noise_var = (nseSigma/255)^2;
estimated_nsr = noise_var / var(src(:));
resWnr = deconvwnr(obs, psf, estimated_nsr);
subplot(2,2,3), imshow(resWnr);
title(sprintf('復元画像(Wiener)：PSNR = %5.2f [dB]',psnr(src,resWnr)))

%% 繰返し縮退／閾値アルゴリズム(ISTA)
% 前処理：P.'Pの最大固有値（べき乗法）
dualprocess = @(x) imfilter(x,psf,'corr','circ');
upst = 0*obs;
upst(1,1) = 1;
eps_ = 1e-6;
err_ = Inf;
while ( err_ > eps_ ) 
    upre = upst;
    v    = linrprocess(upre); % P
    upst = dualprocess(v);    % P.'
    err_ = norm(upst(:)-upre(:))^2/norm(upst(:));
end
n  = sum(upst(:).'*upst(:));
d  = sum(upst(:).'*upre(:));
lc = n/d;
fprintf('リプシッツ定数： %f\n',lc);

% 繰り返し処理
softshrink  = @(y,lmd) sign(y).*max(abs(y)-lmd,0);
[y,s] = nshaarwtdec2(obs,nlevels);
err = Inf;
subplot(2,2,4), hi = imshow(obs);
ht = title(sprintf('復元画像(ISTA)：PSNR = %5.2f [dB]',psnr(src,obs)));
while ( err > eps ) 
    ypre = y;
    v = linrprocess(nshaarwtrec2(ypre,s));
    e = nshaarwtdec2(dualprocess(v-obs),nlevels)/lc;
    y = softshrink(ypre - e,lambda/lc);
    err = norm(y(:)-ypre(:))^2/norm(y(:));
    resIsta = nshaarwtrec2(y,s);
    set(hi,'CData',resIsta)
    set(ht,'String',sprintf('復元画像(ISTA)：PSNR = %5.2f [dB]',psnr(src,resIsta)))
    drawnow    
end