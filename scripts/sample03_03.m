%[text] # Sample 3-3
%[text] ## 平滑化／先鋭化処理
%[text] 勾配フィルタ 
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Image smoothing/sharpening
%[text] Gradient filter
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### サンプル画像の準備
%[text] (Preparation of sample image)
close
% Reading original image
I = im2double(imread('cameraman.tif'));
figure(1)
imshow(I)
title('Original')
%%
%[text] ### フィルタカーネルの選択
%[text] (Selecting the filter kernel)
%[text] - Sobel
%[text] - Prewitt \
ftype = 'Sobel'; %[control:dropdown:66f6]{"position":[9,16]}
%%
%[text] ### 勾配フィルタ
%[text] (Gradient filter)
%[text]{"align":"center"} $\\nabla x=\\left(\\begin{array}{c}\\frac{\\partial x}{\\partial p\_\\mathrm{v}}\\\\\n\\frac{\\partial x}{\\partial p\_\\mathrm{h}}\n\\end{array}\\right)$
% Gradient flter
[Gh,Gv] = imgradientxy(I,ftype);

% Show result in the horizontal direction
figure(2)
subplot(1,2,1)
imshow(Gh+.5)
title([ftype ' horizontal filter'])
% Show result in the vertical direction
subplot(1,2,2)
imshow(Gv+.5)
title([ftype ' vertical filter'])
%%
%[text] ### 勾配の可視化
%[text] (Visualization of gradient)
%[text]{"align":"center"} $\\nabla x=\\left(\\begin{array}{c}\\frac{\\partial x}{\\partial p\_\\mathrm{v}}\\\\\n\\frac{\\partial x}{\\partial p\_\\mathrm{h}}\n\\end{array}\\right)$
% Gradient
figure(3)
quiver(Gh,Gv)
title('Gradient')
axis equal
axis off
axis ij
%%
%[text] ### 勾配の大きさと方向
%[text] (Magnitude and direction of gradient)
%[text]{"align":"center"} $\\left|\\nabla x\\right|=\\sqrt{\\left(\\frac{\\partial x}{\\partial p\_\\mathrm{v}}\\right)^2+\\left(\\frac{\\partial x}{\\partial p\_\\mathrm{h}}\\right)^2}$
%[text]{"align":"center"} $\\angle\\nabla x=\\tan^{-1}\\frac{\\left(\\frac{\\partial x}{\\partial p\_\\mathrm{v}}\\right)}{\\left(\\frac{\\partial x}{\\partial p\_\\mathrm{h}}\\right)}$
% Magnitude and direction of the gradient image
[Gm,Gd] = imgradient(Gh,Gv);

% Show result of magnitude
figure(4)
imshow(Gm)
title('Magnitude of gradient')
%%
% Show result of direction
figure(5)
quiver(cosd(Gd),-sind(Gd))
title('Direction of gradient')
axis equal
axis off
axis ij
%%
%[text] ### エッジ検出
%[text] (Edge detection)
% Edge detection
E = edge(I,ftype);

% Show result 
figure(6)
imshow(E)
title(['Edge detection with ' ftype])
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:dropdown:66f6]
%   data: {"defaultValue":"'Sobel'","itemLabels":["Sobel","Prewitt"],"items":["'Sobel'","'Prewitt'"],"label":"ドロップ ダウン","run":"SectionToEnd"}
%---
