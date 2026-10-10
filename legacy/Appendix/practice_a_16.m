% practice_a_16.m
%
% $Id:$
%
% Copyright (C) 2012-2015 Shogo MURAMATSU, All rights reserved
%
 close all; clc

mse  = @(s,r) sum((s(:)-r(:)).^2)/numel(s);
psnr = @(s,r) -10*log10(mse(s,r));

%% パラメータ設定
nseSigma = 20; % 加法性白色ガウスノイズの標準偏差
nlevels  = 3; % ウェーブレット段数

%% 原画像の読み込み
src = im2double(imread('./data/org.tif'));
%src = im2double(imread('cameraman.tif'));
subplot(2,2,1), imshow(src);
title('原画像')

%% 観測画像の生成
obs = imnoise(src,'gaussian',0,(nseSigma/255)^2);
subplot(2,2,2), imshow(obs);
title(sprintf('ノイズ画像：PSNR = %5.2f [dB]',psnr(src,obs)))

%% ウィーナーフィルタ
resWnr = wiener2(obs, [5 5]);
subplot(2,2,3), imshow(resWnr);
title(sprintf('復元画像(Wiener)：PSNR = %5.2f [dB]',psnr(src,resWnr)))

%% ソフト縮退処理
% ウェーブレット順変換（対称直交）
[v,s] = sowtdec2(obs,nlevels);
% サブバンド適応ソフト縮退処理
y   = bayesshrink(v,s); 
% ウェーブレット逆変換（対称直交）
res = sowtrec2(y,s);
subplot(2,2,4), imshow(res)
title(sprintf('復元画像(ソフト縮退)：PSNR = %5.2f [dB]',psnr(src,res)))
