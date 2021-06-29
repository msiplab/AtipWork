% practice_a_14.m
%
% $Id:$
%
% Copyright (C) 2012-2015 Shogo MURAMATSU, All rights reserved
%

%% ウェーブレット段数
nlevels = 3;

%% 原画像の読み込み
%xs = im2double(imread('./data/org.tif'));
xs = im2double(imread('cameraman.tif'));
subplot(1,3,1), imshow(xs)
title('原画像')

%% 分析処理（対称直交ウェーブレット変換）
[valueC,valueS] = sowtdec2(xs,nlevels);

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
subplot(1,3,2), imshow(c0)
title('変換係数')

%% 合成処理（対称直交ウェーブレット変換）
xr = sowtrec2(valueC,valueS);

%% パーセバルの等式の確認
fprintf('||x||^2 = %f\n', norm(xs(:))^2);
fprintf('||y||^2 = %f\n', norm(valueC(:))^2);

%% PSNR
psnr = -10*log10(sum((xs(:)-xr(:)).^2));
fprintf('PSNR: %6.2f[dB]\n',psnr);
subplot(1,3,3), imshow(xr)
title('再構成画像')