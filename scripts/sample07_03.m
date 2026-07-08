%[text] # Sample 7-3
%[text] ## 幾何学処理
%[text] 拡大処理
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Geometric image processing
%[text] Interpolation
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
uFactor = 2; %[control:slider:43ae]{"position":[11,12]}

% Upsampling phase
uPhase = 0; %[control:slider:76fc]{"position":[10,11]}
%[text] 最近傍補間フィルタのインパルス応答 (Impulse response of nearest-neighbor filter)
%[text]  $f\[n\]=\\left\\{\\begin{array}{ll} 1& 0\\leq n\\leq M-1 \\\\ 0 & \\mathrm{otherwise} \\end{array}\\right.$
%[text] 一次補間フィルタのインパルス応答 (Impulse response of linear interpolation filter)
%[text]  $f\[n\]=\\left\\{\\begin{array}{ll} \\frac{1}{M}(M-|n|) & -M+1\\leq n\\leq M-1 \\\\ 0 & \\mathrm{otherwise} \\end{array}\\right.$
%[text] オフセットを考慮した場合 (When considering the offset)
%[text]  $f\[n\]=\\left\\{\\begin{array}{ll} \\frac{1}{M}\\left(M-\\left|n-\\frac{1}{2}\\right|\\right) & -M+1\\leq n\\leq M \\\\ 0 & \\mathrm{otherwise} \\end{array}\\right.$
%[text] ただし，非因果性に注意．(Note that the incausal property.)
%[text] - $\\{f\[n\]\\}\_n$: インパルス応答 (Impulse response) \
% Filter seletion
ftype = "Nearest neighbor"; %[control:dropdown:8ef0]{"position":[9,27]}
offset = false; % Set TRUE for even M, FALSE for odd M to make the handmade bilinear interpolation similar to IMRESIZE %[control:dropdown:376f]{"position":[10,15]}

% Impulse response of interpolation filter
if strcmp(ftype,'Nearest neighbor')
    f = ones(1,uFactor);
    offset = false;
elseif strcmp(ftype, 'Bilinear interpolation')
    if ~offset
         f = 1-abs((-uFactor+1):(uFactor-1))/uFactor;
    else
        f = 1-abs(((-uFactor+1):uFactor)-0.5)/uFactor;
    end
else
    error('Invalid ftype')
end
%%
%[text] ## フィルタ特性の表示
%[text] (Display of filter characteristics)
% Impulse response
figure(1)
impz(f)
ax = gca;
ax.XLim = [-1 length(f)];
ax.YLim = [-0.2 1.2];
% Frequency response
figure(2)
freqz(f)
ax = gca;
hold on
line([0 1/uFactor 1/uFactor],[20*log10(uFactor) 20*log10(uFactor) ax.YLim(1)],...
    'LineStyle',':','LineWidth',2,'Color','red');
hold off
%%
%[text] ### 画像への適用
%[text] (Application to images)
%[text]  $v\[\\mathbf{m}\]=\\sum\_{\\mathbf{k}\\in\\mathbb{Z}^2}u\[\\mathbf{Mk}\]f\[\\mathbf{m}-\\mathbf{Mk}\]$
%[text] 最近傍補間フィルタのインパルス応答 (Impulse response of nearest-neighbor filter)
%[text]  $f\[\\mathbf{n}\]=\\left\\{\\begin{array}{ll} 1 & \\mathbf{n}\\in \\mathcal{N}(\\mathbf{M})\\\\ 0 & \\mathrm{otherwise} \\end{array}\\right.$
%[text] 双一次補間フィルタのインパルス応答 (Impulse response of bilinear interpolation filter)
%[text]  $f\[\\mathbf{n}\]=\\left\\{\\begin{array}{ll} \\mathrm{prod}\\left(\\mathbf{1}-\\mathrm{abs}\\left(\\mathbf{M}^{-1}\\mathbf{n}\\right) \\right)& \\mathbf{n}\\in \\{\\mathbf{Mx}\\in\\mathbb{Z}^2\\ |\\ \\mathbf{x}\\in(-1,1)^2\\} \\\\ 0 & \\mathrm{otherwise} \\end{array}\\right.$
%[text] オフセットを考慮した場合
%[text]  $f\[\\mathbf{n}\]=\\left\\{\\begin{array}{ll} \\mathrm{prod}\\left(\\mathbf{1}-\\mathrm{abs}\\left(\\mathbf{M}^{-1}\\mathbf{n}-\\frac{1}{2}\\mathbf{1}\\right) \\right)& \\mathbf{n}\\in \\{\\mathbf{Mx}\\in\\mathbb{Z}^2\\ |\\ \\mathbf{x}\\in(-1,1\]^2\\} \\\\ 0 & \\mathrm{otherwise} \\end{array}\\right.$
%[text] ただし， $\\mathrm{prod}(\\cdot)$ は要素の積．非因果性に注意．(where $\\mathrm{prod}(\\cdot)$ denotes the product of the array elements. Note that the incausal property.)
%[text] Note that if $\\mathbf{M}=\\mathrm{diag}(M,M)\\Rightarrow \\mathrm{prod}(\\mathbf{1}-\\mathrm{abs}(\\mathbf{M}^{-1}\\mathbf{n}-\\alpha\\mathbf{1}))=\\frac{1}{M^2}(M-|n\_1-\\alpha|)(M-|n\_2-\\alpha|)$ , $\\{\\mathbf{Mx}\\in\\mathbb{Z}^2\\ |\\ \\mathbf{x}\\in(-1,1)^2\\}=\\{-M+1,-M+2,\\cdots,M-1\\}^2$ and $\\{\\mathbf{Mx}\\in\\mathbb{Z}^2\\ |\\ \\mathbf{x}\\in(-1,1\]^2\\}=\\{-M+1,-M+2,\\cdots,M\\}^2$.
% Reading an image
u = imread('cameraman.tif');

% Generating an interpolation filter
if strcmp(ftype,'Nearest neighbor')
    [n1,n2] = ndgrid(0:uFactor-1);
    f = ones(uFactor,uFactor);
elseif strcmp(ftype,'Bilinear interpolation')
    if ~offset
        [n1,n2] = ndgrid(-uFactor+1:uFactor-1);
        f = (1-abs(n1)/uFactor).*(1-abs(n2)/uFactor);
    else
        [n1,n2] = ndgrid(-uFactor+1:uFactor);
        f = (1-abs(n1-0.5)/uFactor).*(1-abs(n2-0.5)/uFactor);
    end
else
    error('Invalid ftype')
end
figure(3)
stem3(n2,n1,f,'filled')
axis ij
ax = gca;
ax.XLim = ax.XLim + [-1 1];
ax.YLim = ax.YLim + [-1 1];
figure(4)
freqz2(f)
axis ij
%%

% Bivariate upsampling function
upsample2 = @(x,n,phase) ...
    shiftdim(upsample(...
    shiftdim(upsample(x,...
    n(1),phase(1)),1),...
    n(2),phase(2)),1);

% Interpolation with upsampling and filtering
x = padarray(u,[1 1],'replicate','both');
w = imfilter(upsample2(x,uFactor*[1 1],uPhase*[1 1]),f,'conv');
s = ceil(uFactor/2);
v = w(s+1:s+uFactor*size(u,1),s+1:s+uFactor*size(u,2));

% Interpolation with IMRESIZE
if strcmp(ftype,'Nearest neighbor')
    y = imresize(u,uFactor,'nearest');
elseif strcmp(ftype, 'Bilinear interpolation')
    y = imresize(u,uFactor,'bilinear');
else
    error('Invalid ftype')
end

%%
%[text] ### 画像表示
%[text] (Display image)
%[text] 原画像 (Original)
figure(5)
imshow(u)
title('Original')
%[text] 拡大画像 (Interpolated image)
% Definition of MSE
mymse = @(x,y) sum((x-y).^2,'all')/numel(x);

% Display results
figure(6)
imshow(v)
title('Interpolation w/o IMRESIZE')
figure(7)
imshow(y)
title('Interpolation w/ IMRESIZE')
figure(8)
imshow(imabsdiff(v,y))
title(['Absolute difference (MSE = ' num2str(mymse(v,y)) ')'])
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:43ae]
%   data: {"defaultValue":2,"label":"dFactor","max":8,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:76fc]
%   data: {"defaultValue":0,"label":"dFactor","max":7,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:dropdown:8ef0]
%   data: {"defaultValue":"\"Nearest neighbor\"","itemLabels":["Nearest neighbor","Bilinear interpolation"],"items":["\"Nearest neighbor\"","\"Bilinear interpolation\""],"label":"ドロップ ダウン","run":"SectionToEnd"}
%---
%[control:dropdown:376f]
%   data: {"defaultValue":"false","itemLabels":["true","false"],"items":["true","false"],"label":"Offset","run":"SectionToEnd"}
%---
