%[text] # Sample 8-2
%[text] ## 離散コサイン変換
%[text] 可分離変換
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Discrete cosine transform
%[text] Separable transforms
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ### 2変量の配列定義
%[text] (Definition of bivariate array)
X = [ 0 2 ; 4 6 ]
%%
%[text] ### 単変量変換行列の定義
%[text] (Definition of univariate transform)
%[text] - 回転行列(rotation matrix) \
%[text]  $\\mathbf{A}\_{\\theta} = \\left(\\begin{array}{cc} \\cos\\theta & -\\sin\\theta \\\\ \\sin\\theta & \\cos\\theta \\end{array}\\right)$
%[text] - 行列 $\\mathbf{A}\_\\theta$による変換 \
%[text]  $\\mathbf{y} = \\mathbf{A}\_\\theta\\mathbf{x}$
Atheta = @(theta) [cos(theta) -sin(theta) ; sin(theta) cos(theta)];
theta = -pi/4;
A = Atheta(theta)
%%
%[text] ### 順変換の分離処理
%[text] (Separate process of the forward transform)
%[text]  $\\mathbf{Y} = \\mathbf{AXA}^T$
fwdT = @(x) A*x*A.';
Y = fwdT(X)
%%
%[text] ### 逆変換の分離処理
%[text] (Separate process of the inverse transform)
%[text]  $\\mathbf{X} = \\mathbf{A}^{-1}\\mathbf{YA}^{-T}$
invA = inv(A)
invT = @(y) invA*y*invA.'; 
R = invT(Y)
%%
%[text] ### 基底展開
%[text] (Basis expansion)
B00 = invT([1 0; 0 0])
B01 = invT([0 1; 0 0])
B10 = invT([0 0; 1 0])
B11 = invT([0 0; 0 1])
%[text] 
hfig1 = figure(1);
hfig1.Color = 0.9*[1 1 1];
subplot(2,2,1)
imshow(B00+.5)
subplot(2,2,2)
imshow(B01+.5)
subplot(2,2,3)
imshow(B10+.5)
subplot(2,2,4)
imshow(B11+.5)
%[text] 
Y(1,1)*B00 + Y(1,2)*B01 + Y(2,1)*B10 + Y(2,2)*B11
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
