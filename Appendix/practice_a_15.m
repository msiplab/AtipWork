% practice_a_15.m
%
% $Id:$
%
% Copyright (C) 2012-2015 Shogo MURAMATSU, All rights reserved
%
mse  = @(s,r) sum((s(:)-r(:)).^2)/numel(s);
psnr = @(s,r) -10*log10(mse(s,r));

%% パラメータ設定
nseSigma = 20; % 加法性白色ガウスノイズの標準偏差
nlevels  = 3; % ウェーブレット段数

%% 原画像の読み込み
%src = im2double(imread('./data/org.tif'));
src = im2double(imread('cameraman.tif'));
subplot(2,2,1), imshow(src);
title('原画像')

%% 分析処理（対称直交ウェーブレット変換）
[valueC,valueS] = sowtdec2(src,nlevels);

%% 変換係数の配列化
pos = 0;
dim = valueS(1,:);
nel = prod(dim);
c0 = reshape(valueC(pos+1:pos+nel),dim)/(2^nlevels);
pos = nel;
for ilv = 1:nlevels
    dim = valueS(ilv+1,:);
    nel = prod(dim);
    %
    c1 = abs(reshape(valueC(pos+1:pos+nel),dim));
    pos = pos + nel;
    %
    c2 = abs(reshape(valueC(pos+1:pos+nel),dim));
    pos = pos + nel;    
    %
    c3 = abs(reshape(valueC(pos+1:pos+nel),dim));
    pos = pos + nel;        
    %
    c0 = [ c0 c1; c2 c3 ];
end
subplot(2,2,2), imshow(abs(c0).^0.25)
title('原画像の変換係数')

%% 観測画像の生成

obs = imnoise(src,'gaussian',0,(nseSigma/255)^2);
subplot(2,2,3), imshow(obs);
title(sprintf('ノイズ画像：PSNR = %5.2f [dB]',psnr(src,obs)))

%% 分析処理（対称直交ウェーブレット変換）
[valueC,valueS] = sowtdec2(obs,nlevels);

%% 変換係数の配列化
pos = 0;
dim = valueS(1,:);
nel = prod(dim);
c0 = reshape(valueC(pos+1:pos+nel),dim)/(2^nlevels);
pos = nel;
for ilv = 1:nlevels
    dim = valueS(ilv+1,:);
    nel = prod(dim);
    %
    c1 = abs(reshape(valueC(pos+1:pos+nel),dim));
    pos = pos + nel;
    %
    c2 = abs(reshape(valueC(pos+1:pos+nel),dim));
    pos = pos + nel;    
    %
    c3 = abs(reshape(valueC(pos+1:pos+nel),dim));
    pos = pos + nel;        
    %
    c0 = [ c0 c1; c2 c3 ];
end
subplot(2,2,4), imshow(abs(c0).^0.25)
title('ノイズ画像の変換係数')