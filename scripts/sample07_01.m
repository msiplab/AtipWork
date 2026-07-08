%[text] # Sample 7-1
%[text] ## 幾何学処理
%[text] 解像度変換
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Geometric image processing
%[text] Image resizing
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ### サイズ変換レートの設定
%[text] (Setting of resizing factor)
%[text]  $\\mathbf{M}=\\left(\\begin{array}{cc} M\_1 & 0 \\\\ 0 & M\_2 \\end{array}\\right)$
%[text] - $M\_1$: 垂直方向レート (Vertical factor)
%[text] - $M\_2$: 水平方向レート (Horizontal factor) \
% Vertical factor M1
verticalFactor = 2; %[control:slider:65bf]{"position":[18,19]}
% Horizontal factor M2
horizontalFactor = 2; %[control:slider:9cd7]{"position":[20,21]}
%%
%[text] ### 入力画像
%[text] (Input image)
%[text] -  $\\{u\[\\mathbf{n}\]\\}\_\\mathbf{n}$: 入力画像 (Input image) \
% Reading an imaege
u = rgb2gray(imread('./data/barbaraFaceRgb.tif'));
%%
%[text] ### 縮小処理
%[text] (Size decreasing)
%[text] 間引き処理による低解像度化 (Decreasing resolution with downsampling)
%[text]  $y\[\\mathbf{m}\]=u\[\\mathbf{Mm}\]$
%[text] -  $\\{y\[\\mathbf{m}\]\\}\_\\mathbf{m}$: 間引き処理の出力画像 (Output image of downsampling) \
% Bivariate downsampling function
downsample2 = @(x,n) ...
    shiftdim(downsample(...
    shiftdim(downsample(x,...
    n(1)),1),...
    n(2)),1);

% Downsampling
y = downsample2(u,[verticalFactor horizontalFactor]);
%[text] ブロック平均による低解像度化 (Decreasing resolution with box-averaging)
%[text]  $v\[\\mathbf{m}\]=\\frac{1}{|\\det\\mathbf{M}|}\\sum\_{\\mathbf{k}\\in\\mathcal{N}(\\mathbf{M})}u\[\\mathbf{Mm}-\\mathbf{k}\]$
%[text] -  $\\{v\[\\mathbf{m}\]\\}\_\\mathbf{m}$: ブロック平均処理の出力画像 (Output image of box-averaging) \
% Box-averaging
sizeNew = ceil(size(u)./[verticalFactor horizontalFactor]);
v = imresize(u,sizeNew,'box');
%%
%[text] ### 画像の表示
%[text] (Display images)
%[text] 原画像 (Original) $\\{u\[\\mathbf{n}\]\\}\_\\mathbf{n}$
% Original
figure(1)
imshow(u)
title('Original')
%[text] 間引き画像 (Downsampled)$\\{y\[\\mathbf{m}\]\\}\_\\mathbf{m}$
% Downsampled image
figure(2)
subplot(1,2,1)
imshow(y)
title('Downsampled')
%[text] ブロック平均画像 (Box-averaged)$\\{v\[\\mathbf{m}\]\\}\_\\mathbf{m}$
% Box-averaged image
subplot(1,2,2)
imshow(v)
title('Box-averaged')
%%
%[text] ### 拡大処理
%[text] (Size increasing)
%[text] 零値挿入処理による高解像度化 (Increasing resolution with upsampling)
%[text]  $y\[\\mathbf{m}\] = \\left\\{\\begin{array}{ll}  u\[\\mathbf{M}^{-1}\\mathbf{m}\] & \\mathbf{m}\\in\\mathcal{L}(\\mathbf{M}) \\\\ 0 &\\mathrm{otherwise} \\\\ \\end{array}\\right.$
%[text]  $\\mathcal{L}(\\mathbf{M})\\colon = \\{\\mathbf{Mk} | \\mathbf{k}\\in\\mathbb{Z}^2\\}$
%[text] -  $\\{y\[\\mathbf{m}\]\\}\_\\mathbf{m}$: 零値挿入処理の出力画像 (Output image of upsampling) \
% Bivariate upsampling function
upsample2 = @(x,n) ...
    shiftdim(upsample(...
    shiftdim(upsample(x,...
    n(1)),1),...
    n(2)),1);

% Upsampling
y = upsample2(u,[verticalFactor horizontalFactor]);
%%
%[text] 最近傍補間による高解像度化 (Increasing resolution with nearest-neighboring)
%[text]  $y\[\\mathbf{m}\] = v\\left\[\\lfloor\\mathbf{M}^{-1}\\mathbf{m}\\rfloor\\right\]$
%[text] -  $\\{v\[\\mathbf{m}\]\\}\_\\mathbf{m}$: ブロック平均処理の出力画像 (Output image of nearest-neighboring) \
% Box-averaging
sizeNew = size(u).*[verticalFactor horizontalFactor];
v = imresize(u,sizeNew,'nearest');
%%
%[text] ### 画像の表示
%[text] (Display images)
%[text] 零値挿入画像 (Upsampled)$\\{y\[\\mathbf{m}\]\\}\_\\mathbf{m}$
figure(3)
imshow(y)
title('Upsampled')
%[text] 最近傍補間画像 (Nearest-neigbored)$\\{v\[\\mathbf{m}\]\\}\_\\mathbf{m}$
figure(4)
imshow(v)
title('Nearest-neighbored')
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:65bf]
%   data: {"defaultValue":2,"label":"verticalFactor","max":8,"min":1,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:9cd7]
%   data: {"defaultValue":2,"label":"horizontalFactor","max":8,"min":1,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
