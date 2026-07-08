%[text] # Sample 7-2
%[text] ## 幾何学処理
%[text] 縮小処理
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Geometric image processing
%[text] Decimation
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ### 間引き率の設定
%[text] (Setting of downsampling factor)
%[text] - $M$: 間引き率 (downsampling factor)  \
% Downsampling factor
dFactor = 2; %[control:slider:3a5f]{"position":[11,12]}

% Downsampling phase
dPhase = 0; %[control:slider:0ca5]{"position":[10,11]}
%[text] 平均フィルタのインパルス応答 (Impulse response of averaging filter)
%[text]  $h\[n\]=\\left\\{\\begin{array}{ll} \\frac{1}{M} & 0\\leq n\\leq M-1 \\\\ 0 & \\mathrm{otherwise} \\end{array}\\right.$
%[text] - $\\{h\[n\]\\}\_n$: インパルス応答 (Impulse response) \
% Impulse response of averaging filter
h = ones(1,dFactor)/dFactor;
%%
%[text] ## フィルタ特性の表示
%[text] (Display of filter characteristics)
% Impulse response
figure(1)
impz(h)
ax = gca;
ax.XLim = [-1 length(h)];
ax.YLim = [-0.2 1];

% Frequency response
figure(2)
freqz(h)
ax = gca;
hold on
line([0 1/dFactor 1/dFactor],[0 0 ax.YLim(1)],...
    'LineStyle',':','LineWidth',2,'Color','red');
hold off
%%
%[text] ### 画像への適用
%[text] (Application to images)
%[text]  $v\[\\mathbf{m}\]=\\sum\_{\\mathbf{k}\\in\\mathbb{Z}^2}h\[\\mathbf{k}\]u\[M\\mathbf{m}-\\mathbf{k}\]=\\frac{1}{|\\det\\mathbf{M}|}\\sum\_{\\mathbf{k}\\in\\mathcal{N}(\\mathbf{M})}u\[\\mathbf{Mm}-\\mathbf{k}\]$
%[text]  $h\[\\mathbf{n}\]=\\left\\{\\begin{array}{ll} \\frac{1}{|\\det\\mathbf{M}|} & \\mathbf{n}\\in \\mathcal{N}(\\mathbf{M})\\\\ 0 & \\mathrm{otherwise} \\end{array}\\right.$
%[text] Note that if $\\mathbf{M}=\\mathrm{diag}(M,M)\\Rightarrow |\\det\\mathbf{M}|=M^2$ and $\\mathcal{N}(\\mathbf{M})=\\{0,1,\\cdots,M-1\\}^2$.
% Reading an image
u = imread('cameraman.tif');

% Generating the average filter
h = fspecial('average',dFactor);
figure(3)
stem3(0:(dFactor-1),0:dFactor-1,h,'filled')
axis ij
ax = gca;
ax.XLim = [-1 dFactor];
ax.YLim = [-1 dFactor];
figure(4)
freqz2(h)
axis ij

% Bivariate downsampling function
downsample2 = @(x,n,phase) ...
    shiftdim(downsample(...
    shiftdim(downsample(x,...
    n(1),phase(1)),1),...
    n(2),phase(2)),1);

% Box-averaging with filtering and downsampling
v = downsample2(imfilter(u,h,'conv','symmetric'),dFactor*[1 1],dPhase*[1 1]);

% Box-averaging with IMRESIZE
y = imresize(u,1/dFactor,'box');

%%
%[text] ### 画像表示
%[text] (Display image)
%[text] 原画像 (Original)
figure(5)
imshow(u)
title('Original')
%[text] 縮小画像 (Decimated image)
% Definition of MSE
mymse = @(x,y) sum((x-y).^2,'all')/numel(x);

% Display results
figure(6)
subplot(1,3,1)
imshow(v)
title('Decimation w/o IMRESIZE')
subplot(1,3,2)
imshow(y)
title('Decimation w/ IMRESIZE')
subplot(1,3,3)
imshow(imabsdiff(v,y))
title(['Absolute difference (MSE = ' num2str(mymse(v,y)) ')'])
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:3a5f]
%   data: {"defaultValue":2,"label":"dFactor","max":8,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:0ca5]
%   data: {"defaultValue":0,"label":"dFactor","max":7,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
