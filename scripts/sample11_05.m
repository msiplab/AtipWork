%[text] # Sample 11-5
%[text] ## 画像ノイズ除去
%[text] 事前分布
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Image denoising
%[text] Prior distribution
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
nlevels = 3;  %[control:slider:4ba3]{"position":[11,12]}
%%
%[text] ## 画像の読込
%[text] (Read image)
img = "kodim23";
u = im2double(imread("./data/" + img + ".png"));
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
    wname = "sym4"; %[control:dropdown:1f55]{"position":[13,19]}
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
%[text] 変換係数の抽出 (Extraction  of coefficients)
s = extractcoefs(coefs,scales);
%%
%[text] ### 変換係数の分布
%[text] (Distribution of Coefs.)
nchs = length(s);
for ich = 1:nchs
    figure
    subplot(1,2,1)
    if ich == 1
        imshow(s{ich}*pow2(-nlevels))
    else
        imshow(s{ich}+.5)
    end 
    subplot(1,2,2)
    histogram(s{ich}(:))
    axis square
    drawnow
end
%%
%[text] ### ラプラス分布
%[text] (Laplace distribution)
%[text] 変換係数はラプラス分布に従う乱数と仮定．(Coefs. are assumed to be random numbers drawn from a Laplace distribution.)
%[text] - $\\mathbf{s}\\sim\\mathrm{Lap}\\left(\\mathbf{s}|\\mathbf{\\mu}=\\mathbf{0},b\\right)$
%[text] - $\\mathrm{Lap}\\left(\\mathbf{s}|\\mathbf{\\mu}=\\mathbf{0},b\\right)=\\frac{1}{2b}\\exp\\left(-\\frac{\\|\\mathbf{s}-\\mathbf{\\mu}\\|\_1}{b}\\right)$ \
% Laplacian parameters
mu = 0;
sgm2 = 0.001;
b = sqrt(sgm2/2);
% Laplacian distribution
spdf = @(x) 1/(2*b)*exp(-abs(x-mu)/b);
figure
h = fplot(spdf);
xlabel('s')
ylabel(['L(s|\mu=0,b=' num2str(b) ')'])
title('Laplacian distribution')
grid on
axis([-1 1 0 30])
%%
%[text] ## 観測画像
%[text] (Observation image)
%[text] パラメータ設定 (Parameter settings)
sgmuint8 = 30;  %[control:slider:3723]{"position":[12,14]}
sgm = sgmuint8/255;
%[text] ノイズ付加 (Add noise)
v = imnoise(u,'gaussian',0,sgm^2);
%[text] 分析処理 (Analysis process)
if iswtb
    [coefs,scales] = wavedec2(v,nlevels,h0,h1);
else
    [coefs,scales] = ezwavedec2(v,nlevels,H);
end
%%
%[text] ### ウェーブレット縮退処理
%[text] (Wavelet shrinkage)
%[text] 問題設定 (Problem settings)
%[text] - $\\hat{\\mathbf{s}}=\\arg\\min\_{\\mathbf{s}}\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{Ds}\\|\_2^2+\\lambda\\|\\mathbf{s}\\|\_1$
%[text] - $\\mathbf{DD}^T=\\mathbf{D}^T\\mathbf{D}=\\mathbf{I}$ (Orthonormal) \
%[text] パラメータ設定 (Parameter settings)
isbayesshrink = false; %[control:checkbox:6aa8]{"position":[17,22]}
if ~isbayesshrink
    isaprxleft = true; %[control:checkbox:7551]{"position":[18,22]}
    lambda = 10^-0.6 %[control:slider:0b48]{"position":[17,21]}
end
%[text] ソフト閾値処理 (Soft-thresholding)
%[text]  $\\hat{\\mathbf{s}} = \\mathcal{T}\_\\lambda(\\mathbf{s})=\\mathrm{sign}(\\mathbf{s})\\odot\\max(\\mathrm{abs}(\\mathbf{s})-\\lambda\\mathbf{1},\\mathbf{0})$
% サブバンド適応ソフト縮退処理
if isbayesshrink
    import msip.bayesshrink
    coefs = bayesshrink(coefs,scales); 
else
    if isaprxleft
        mask = ones(size(coefs));
        mask(1:prod(scales(1,:))) = 0;
        lambda = lambda * mask;
    end
    softshrink = @(x) sign(x).*max(abs(x)-lambda,0);
    coefs = softshrink(coefs);
end
%[text] 合成処理 (Synthesis process)
if iswtb
    r = waverec2(coefs,scales,f0,f1);
else
    r = ezwaverec2(coefs,scales,F);
end
%%
%[text] ### 画像表示
%[text] (Image show)
figure
imshow(u)
title('Original image u')
figure
imshow(v)
title(sprintf('Noisy image v：PSNR = %5.2f [dB]',psnr(u,v)))
figure
imshow(r)
title(sprintf('Denoised image r：PSNR = %5.2f [dB]',psnr(u,r)))
%%
%[text] ### ウェーブレット画像ノイズ除去関数
%[text] (Wavelet image denoising function)
%[text] 参考資料 (Reference)
if iswtb
    help wthcoef2
    help wdenoise2
end
%%
%[text] ### 変換係数の抽出
%[text] (Extraction of Coefs.)
function s = extractcoefs(coefs,scales)
nscales = size(scales,1)-1;
s = cell(3*(nscales-1)+1,1);
sidx = 1;
ndims = scales(1,:);
eidx = sidx + prod(ndims) - 1;
s{1} = reshape(coefs(sidx:eidx),ndims);
sidx = eidx + 1; 
ich = 2;
for iscale = 2:nscales
    ndims = scales(iscale,:);
    for iband = 1:3
        eidx = sidx + prod(ndims) - 1;
        s{ich} = reshape(coefs(sidx:eidx),ndims);
        sidx = eidx + 1;
        ich = ich + 1;
    end
end
end
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:4ba3]
%   data: {"defaultValue":3,"label":"nlevels","max":5,"min":1,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:dropdown:1f55]
%   data: {"defaultValue":"\"sym4\"","itemLabels":["haar","db2","sym4"],"items":["\"haar\"","\"db2\"","\"sym4\""],"label":"wname","run":"SectionToEnd"}
%---
%[control:slider:3723]
%   data: {"defaultValue":30,"label":"スライダー","max":50,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":10}
%---
%[control:checkbox:6aa8]
%   data: {"defaultValue":false,"label":"isbayesshrink","run":"SectionToEnd"}
%---
%[control:checkbox:7551]
%   data: {"defaultValue":true,"label":"isaprxleft","run":"SectionToEnd"}
%---
%[control:slider:0b48]
%   data: {"defaultValue":-0.8,"label":"lambda","max":2,"min":-4,"run":"AllSections","runOn":"ValueChanging","step":0.1}
%---
