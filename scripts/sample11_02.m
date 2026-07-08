%[text] # Sample 11-2
%[text] ## 画像ノイズ除去
%[text] ノイズの変換
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Image denoising
%[text] Transform of noise
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
clear
close all
import msip.download_img
msip.download_img
%%
%[text] ### パラメータ設定
%[text] (Parameter settings)
%[text] - sgm: ノイズ標準偏差 $\\sigma\_w$ (Standard deviation of noise)
%[text] - nlevels: ウェーブレット段数 (Wavelet levels) \
% Parameter settings
sgmuint8 = 30;  %[control:slider:3ee0]{"position":[12,14]}
sgm = sgmuint8/255;
nlevels = 3;  %[control:slider:3b0b]{"position":[11,12]}
%%
%[text] ## 画像の読込
%[text] (Read image)
u = im2double(imread('./data/kodim23.png'));
if size(u,3) == 3
    u = rgb2gray(u);
end
%%
%[text] ## 分析処理
%[text] (Analysis process)
%[text] 直交ウェーブレット変換Symlet を利用．(Uses Symlet, which is an orthogonal wavelet transform.)
% Preperation of filters for wavelets
iswtb = license('checkout','wavelet_toolbox');
if iswtb % Functions in Wavelet Toolbox are used
    dwtmode('per')
    wname = "sym4"; %[control:dropdown:2bb3]{"position":[13,19]}
    [h0,h1,f0,f1] = wfilters(wname);
    %save(['./data/' char(wname) '.mat'],'h0','h1','f0','f1')
else
    import msip.ezwavedec2
    import msip.ezwaverec2
    S = load('./data/sym4.mat');
    h0 = S.h0;
    h1 = S.h1;
    f0 = S.f0;
    f1 = S.f1;
    clear H  F
    % Analysis bivariate filters
    H.h00 = h0(:)*h0(:).';
    H.h01 = h0(:)*h1(:).';
    H.h10 = h1(:)*h0(:).';
    H.h11 = h1(:)*h1(:).';
    % Synthesis bivariate filters
    F.f00 = f0(:)*f0(:).';
    F.f01 = f0(:)*f1(:).';
    F.f10 = f1(:)*f0(:).';
    F.f11 = f1(:)*f1(:).';
end
%[text] 分析処理 (Analysis process)
if iswtb
    [coefs,scales] = wavedec2(u,nlevels,h0,h1);
    % Reconstruction to check PR
    r = waverec2(coefs,scales,f0,f1);
else
    [coefs,scales] = ezwavedec2(u,nlevels,H);
    % Reconstruction to check PR%
    r = ezwaverec2(coefs,scales,F);
end
assert(norm(u-r,"fro")^2/numel(u)<1e-18,'Perfect reconstruction is violated.')
%[text] 変換係数の配列化 (Alighment of coefficients)
uc = aligncoefs(coefs,scales);
%%
%[text] ## 観測画像
%[text] (Observation image)
v = imnoise(u,'gaussian',0,sgm^2);
%[text] 分析処理 (Analysis process)
if iswtb
    [coefs,scales] = wavedec2(v,nlevels,h0,h1);
else
    [coefs,scales] = ezwavedec2(v,nlevels,H);
end

%% 変換係数の配列化
pos = 0;
dim = scales(1,:);
%[text] 変換係数の配列化 (Alighment of coefficients)
vc = aligncoefs(coefs,scales);
%%
%[text] ### 画像表示
%[text] (Image show)
figure
imshow(u);
title('Original image u')
figure
imshow(abs(uc))
title('Transform Coefs. of u')
figure
imshow(v)
title(sprintf('Noisy image v：PSNR = %5.2f [dB]',psnr(u,v)))
figure
imshow(abs(vc))
title('Transform Coefs. of v')
%%
%[text] ### 関数定義
%[text] (Definition of function)
%[text] 変換係数の配列化 (Alighment of coefficients)
function c00 = aligncoefs(coefs,scales)
nlevels = size(scales,1)-2;
pos = 0;
dim = scales(1,:);
nel = prod(dim);
c00 = reshape(coefs(pos+1:pos+nel),dim)/(2^nlevels);
pos = nel;
for ilv = 1:nlevels
    dim = scales(ilv+1,:);
    nel = prod(dim);
    %
    c01 = abs(reshape(coefs(pos+1:pos+nel),dim));
    pos = pos + nel;
    %
    c10 = abs(reshape(coefs(pos+1:pos+nel),dim));
    pos = pos + nel;
    %
    c11 = abs(reshape(coefs(pos+1:pos+nel),dim));
    pos = pos + nel;
    %
    c00 = [ c00 c01; c10 c11 ];
end
end
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:3ee0]
%   data: {"defaultValue":30,"label":"スライダー","max":50,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":10}
%---
%[control:slider:3b0b]
%   data: {"defaultValue":3,"label":"nlevels","max":5,"min":1,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:dropdown:2bb3]
%   data: {"defaultValue":"\"sym4\"","itemLabels":["haar","db2","sym4"],"items":["\"haar\"","\"db2\"","\"sym4\""],"label":"wname","run":"Section"}
%---
