%[text] # Sample 3-2
%[text] ## 平滑化／先鋭化処理
%[text] 移動平均とラプラシアン 
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Image smoothing/sharpening
%[text] Moving averages and Laplacian
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
%[text] ### 移動平均フィルタ
%[text] (Moving average filter)
%[text] 以下に$3\\times 3$サイズの平均値カーネルを示す。
%[text] (The averaging kernel of size $3\\times 3$is shown below.)
%[text]{"align":"center"} $\\mathbf{f}=\\frac{1}{9}\\left(\\begin{array}{ccc}\n1 & 1 & 1 \\\\\n1 & 1 & 1 \\\\\n1 & 1 & 1\n\\end{array}\\right)$
% Kernel size setting
hsize = 3; %[control:slider:0ce7]{"position":[9,10]}

% Generating the filter kernel
f = fspecial('average',hsize)
% Moving average filter
J = imfilter(I,f);

% Show the result
figure(2)
imshow(J)
title(['Moving averaging filer of size ' num2str(hsize) '\times' num2str(hsize)])
%%
%[text] ### ガウシアンフィルタ
%[text] (Gaussian filter)
%[text] $3\\times 3$ サイズのガウシアンフィルタの定義を以下に示す。
%[text] (The definition of a Gaussian filter of size $3\\times 3$ is given below.)
%[text]{"align":"center"} $\\mathbf{f}=\\frac{1}{\\sum\_{j=-1}^{1}\\sum\_{i=-1}^{1}g(i,j)}\\left(\\begin{array}{ccc}\ng(-1,-1) & g(-1,0) & g(-1,1) \\\\\ng(0,-1) & g(0,0) & g(0,1) \\\\\ng(1,-1) & g(1,0) & g(1,1)\n\\end{array}\\right),$
%[text] ただし，$\\sigma$ を標準偏差として
%[text] (where let $\\sigma$ be a standard deviation and )
%[text]{"align":"center"} $g(p\_1,p\_2)=\\exp\\left(-\\frac{p\_1^2+p\_2^2}{2\\sigma^2}\\right).$
% Setting of kernel size and standard deviation
hsize = 3; %[control:slider:9a8c]{"position":[9,10]}
sigma = 0.5; %[control:slider:2967]{"position":[9,12]}

% Generating the filter kernel
f = fspecial('gaussian',hsize,sigma)
% Mesh plot of the Gaussian kernel
[x,y] = meshgrid(-ceil(hsize/2-1):floor(hsize/2),-ceil(hsize/2-1):floor(hsize/2));
figure(3)
mesh(x,y,f)
title('Gaussian kernel')
xlabel('n_2')
ylabel('n_1')



% Gaussian filtering with IMFILTER
J = imfilter(I,f);

% Show result
figure(4)
imshow(J)
title(['Gaussian filer (IMFILTER) of size ' num2str(hsize) '\times' num2str(hsize) ', where \sigma = ' num2str(sigma)])
% Gaussian filtering with IMGAUSSFILT
K = imgaussfilt(I,sigma);

% Kernel size
hsize = 2*ceil(2*sigma)+1;

% Show the result
figure(5)
imshow(K)
title(['Gaussian filer (IMGAUSSFILT) of size ' num2str(hsize) '\times' num2str(hsize) ', where \sigma = ' num2str(sigma)])
%%
%[text] ### ラプラシアンフィルタ
%[text] (Laplacian filter)
%[text] 以下に4近傍ラプラシアンカーネルを示す。
%[text] (The four neighborhood Laplacian kernel is  shown below.)
%[text]{"align":"center"} $\\mathbf{f}=\\left(\\begin{array}{ccc}\n0 & 1 & 0 \\\\\n1 & -4 & 1 \\\\\n0 & 1 & 0\n\\end{array}\\right)$
% Shape parameter setting
alpha = 0; %[control:slider:3978]{"position":[9,10]}

% Generating the filter kernel
f = fspecial('laplacian',alpha)
% Laplacian filtering
J = imfilter(I,f);

% Show the result with bias
figure(6)
imshow(J+.5)
title(['Laplacian filter, where \alpha = ' num2str(alpha)])
%%
%[text] ### アンシャープマスクフィルタ
%[text] (Unsharp mask filter)
%[text] 以下に4近傍ラプラシアンカーネルを示す。
%[text] (The four neighborhood Laplacian kernel is  shown below.)
%[text]{"align":"center"} $\\mathbf{f}=\\left(\\begin{array}{ccc}\n0 & -1 & 0 \\\\\n-1 & 5 & -1 \\\\\n0 & -1 & 0\n\\end{array}\\right)$
% Shape parameter setting
alpha = 0; %[control:slider:5fe8]{"position":[9,10]}

% Generating the filter kernel
f = fspecial('unsharp',alpha)
% Unsharp mask filtering
J = imfilter(I,f);

% Show result
figure(7)
imshow(J)
title(['Unsharp mask filter, where \alpha = ' num2str(alpha)])
%%
%[text] ### ソーベルフィルタ
%[text] (Sobel filter)
%[text] ソーベル水平フィルタカーネル
%[text] (Sobel horizontal filter kernel)
%[text]{"align":"center"} $\\mathbf{f}=\\left(\\begin{array}{ccc}\n-1 & 0 & 1 \\\\\n-2 & 0 & 2 \\\\\n-1 & 0 & 1\n\\end{array}\\right)$
% Generating the filter kernel
f = fspecial('sobel');
f = rot90(f,-1)
% Sobel horizontal filtering
H = imfilter(I,f);

% Show result with bias
figure(8)
imshow(H+.5)
title('Sobel horizontal filter')
%[text] ソーベル水平フィルタカーネル
%[text] (Sobel vertical filter kernel)
%[text]{"align":"center"} $\\mathbf{f}=\\left(\\begin{array}{ccc}\n\n-1 & -2 & -1 \\\\\n0 & 0 & 0 \\\\\n1 & 2 & 1\n\\end{array}\\right)$
% Generating the filter kernel
f = fspecial('sobel');
f = flipud(f)
% Sobel vertical filtering
V = imfilter(I,f);

% Show result with bias
figure(9)
imshow(V+.5)
title('Sobel vertical filter')
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:0ce7]
%   data: {"defaultValue":3,"label":"hsize","max":16,"min":1,"run":"Section","runOn":"ValueChanging","step":1}
%---
%[control:slider:9a8c]
%   data: {"defaultValue":3,"label":"hsize","max":16,"min":1,"run":"Section","runOn":"ValueChanging","step":1}
%---
%[control:slider:2967]
%   data: {"defaultValue":0.5,"label":"sigma","max":16,"min":0.1,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:3978]
%   data: {"defaultValue":0,"label":"alpha","max":1,"min":0,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:5fe8]
%   data: {"defaultValue":0,"label":"alpha","max":1,"min":0,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
