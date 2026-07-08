%[text] # Sample 7-4
%[text] ## 幾何学処理
%[text] 有理数比の解像度変換
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Geometric image processing
%[text] Resizing w/ rational factor
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ### 補間率の設定
%[text] (Setting of upsampling factor)
%[text] - $M$: 補間率 (upsampling factor)  \
% Upsampling factor
uFactor = 5; %[control:slider:21e9]{"position":[11,12]}
%[text] ### 間引き率の設定
%[text] (Setting of downsampling factor)
%[text] - $M$: 間引き率 (downsampling factor)  \
% Downsampling factor
dFactor = 3; %[control:slider:5b0c]{"position":[11,12]}
%%
%[text] ### フィルタの設定
%[text] (Setting of filter)
%[text] 平均フィルタのインパルス応答 (Impulse response of averaging filter)
%[text]  $h\[n\]=\\left\\{\\begin{array}{ll} \\frac{1}{M\_\\mathrm{d}} & 0\\leq n\\leq M\_\\mathrm{d}-1 \\\\ 0 & \\mathrm{otherwise} \\end{array}\\right.$
%[text] - $\\{h\[n\]\\}\_n$: インパルス応答 (Impulse response) \
% Impulse response of averaging filter
h = ones(1,dFactor)/dFactor;
%[text] 線形補間フィルタのインパルス応答 (Impulse response of linear interpolation filter)
%[text]  $f\[n\]=\\left\\{\\begin{array}{ll} \\frac{1}{M\_\\mathrm{u}}(M\_\n\\mathrm{u}-|n|) & -M\_\\mathrm{u}+1\\leq n\\leq M\_\\mathrm{u}-1 \\\\ 0 & \\mathrm{otherwise} \\end{array}\\right.$
%[text] ただし，非因果性に注意．(Note that the incausal property.)
%[text] - $\\{f\[n\]\\}\_n$: インパルス応答 (Impulse response) \
% Impulse response of interpolation filter
f = 1-abs(-(uFactor-1):(uFactor-1))/uFactor;
%[text] 縦続フィルタのインパルス応答 (Impulse response of the cascade filter)
%[text]  $g\[n\]=h\[n\]\\ast f\[n\]$
% Impulse response of the combination
g = conv(h,f);
%%
%[text] ## フィルタ特性の表示
%[text] (Display of filter characteristics)
% Impulse response
figure(1)
impz(g)
ax = gca;
ax.XLim = [-1 length(g)];
ax.YLim = [-0.2 1];

% Frequency response
figure(2)
freqz(g)
ax = gca;
hold on
line([0 min(1/uFactor,1/dFactor) min(1/uFactor,1/dFactor)],[20*log10(uFactor) 20*log10(uFactor) ax.YLim(1)],...
    'LineStyle',':','LineWidth',2,'Color','red');
hold off
%%
%[text] ### 画像への適用
%[text] (Application to images)
%[text]  $v\[\\mathbf{m}\]=\\sum\_{\\mathbf{\\ell}\\in\\mathbb{Z}^2}u\[\\mathbf{M}\_\\mathrm{u}\\mathbf{\\ell}\]g\[\\mathbf{M\_\\mathrm{d}m}-\\mathbf{M}\_\\mathrm{u}\\mathbf{\\ell}\]$
%[text] ただし，(where)
%[text]  $g\[\\mathbf{n}\]=h\[\\mathbf{n}\]\\ast f\[\\mathbf{n}\]$
%[text]  $h\[\\mathbf{n}\]=\\left\\{\\begin{array}{ll} \\frac{1}{|\\det\\mathbf{M}\_\\mathbf{d}|} & \\mathbf{n}\\in \\mathcal{N}(\\mathbf{M}\_\\mathbf{d})\\\\ 0 & \\mathrm{otherwise} \\end{array}\\right.$
%[text]  $f\[\\mathbf{n}\]=\\left\\{\\begin{array}{ll} \\mathrm{prod}\\left(\\mathbf{1}-\\mathrm{abs}\\left(\\mathbf{M}\_\\mathbf{u}^{-1}\\mathbf{n}\\right) \\right)& \\mathbf{n}\\in \\{\\mathbf{M}\_\\mathbf{u}\\mathbf{x}\\in\\mathbb{Z}^2\\ |\\ \\mathbf{x}\\in(-1,1)^2\\} \\\\ 0 & \\mathrm{otherwise} \\end{array}\\right.$
%[text] ただし，非因果性に注意．(Note that the incausal property.)
%[text] - $\\{g\[\\mathbf{n}\]\\}\_\\mathbf{n}$: インパルス応答 (Impulse response) \
% Reading an image
u = imread('cameraman.tif');

% Generating the bilinear interpolation filter
[n1,n2] = ndgrid(-uFactor+1:uFactor-1);
f = (1-abs(n1)/uFactor).*(1-abs(n2)/uFactor);

% Generating the average filter
h = fspecial('average',dFactor);

% Combination of h and f
g = conv2(f,h);
[n1,n2] = ndgrid(-uFactor-floor(dFactor/2)+1:uFactor+floor(dFactor/2)-1);

% Impluse response 
figure(3)
stem3(n2,n1,g,'filled')
axis ij
ax = gca;
ax.XLim = ax.XLim + [-1 1];
ax.YLim = ax.YLim + [-1 1];

% Frequency response
figure(4)
freqz2(g)
axis ij
% Bivariate upsampling function
upsample2 = @(x,n) ...
    shiftdim(upsample(...
    shiftdim(upsample(x,...
    n(1)),1),...
    n(2)),1);

% Bivariate downsampling function
downsample2 = @(x,n) ...
    shiftdim(downsample(...
    shiftdim(downsample(x,...
    n(1)),1),...
    n(2)),1);

% Interpolation with upsampling and filtering
x = padarray(u,[1 1],'replicate','both');
w = imfilter(upsample2(x,uFactor*[1 1]),g,'conv');
s = ceil(uFactor/2);
y = w(s+1:s+uFactor*size(u,1),s+1:s+uFactor*size(u,2));
v = downsample2(y,dFactor*[1 1]);
%%
%[text] ### 画像表示
%[text] (Display image)
%[text] 原画像 (Original)
figure(5)
imshow(u)
title('Original')
%[text] 結果画像 (Result)
% Display result
figure(6)
imshow(v)
title('Result')
%%
% Imresize
figure(7)
z = imresize(u,uFactor/dFactor);
imshow(z)
title('Imresize')
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:21e9]
%   data: {"defaultValue":5,"label":"dFactor","max":8,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:5b0c]
%   data: {"defaultValue":3,"label":"dFactor","max":8,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
