%[text] # Sample 8-1
%[text] ## 離散コサイン変換
%[text] 画像変換の効果
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Discrete cosine transform
%[text] Effect of image transforms
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ### 原画像の読込と表示
%[text] (Read and display an image)
V = rgb2gray(imread('data/barbaraFaceRgb.tif'));
figure(1)
imshow(V)
title('Original picture')
%%
%[text] ### 2次元ベクトル集合の抽出
%[text] (Extraction of a set of 2-D vectors)
%[text] 水平方向のペアを抽出しデータ行列を生成 (Extract horizontal pairs and generates data matrix)
%[text] - 画素配列(pixel array) \
%[text]  $\\mathbf{V} = \\left(\\begin{array}{lllll} v\_{0,0} & v\_{0,1} & v\_{0,2} & \\cdots \\\\ v\_{1,0} & v\_{1,1} & v\_{1,2} & \\cdots \\\\ \\vdots & \\vdots & \\vdots & \\ddots \\end{array}\\right)$
%[text] - データ行列(data matrix) \
%[text]  $\\mathbf{X} = \\left(\\mathbf{x}\_1,\\mathbf{x}\_2,,\\cdots \\right)＝\\left(\\begin{array}{lllll} v\_{0,0} & v\_{0,2} & \\cdots & v\_{1,0} & \\cdots \\\\ v\_{0,1} & v\_{0,3} & \\cdots & v\_{1,1} & \\cdots \\end{array}\\right)$
nPixels = numel(V);
setOfX = reshape(V.', 2, nPixels/2);
%%
%[text] ###  変換前の散布図
%[text] (Scatter plot before transform)
figure(2)
scatter(setOfX(1,:),setOfX(2,:),'.')
axis square
xlabel('x_0')
ylabel('x_1')
title('Scatter plot (before transform)')
%[text] 標本分散共分散行列と相関係数 (Sample covariance matrix and correlation coefficient)
%[text] -  平均ベクトル (mean vector) \
%[text]  $\\mathbf{\\mu}\_\\mathrm{x} = E\[\\mathbf{x}\]$
%[text] - 分散共分散行列 (covariance matrix) \
%[text]  $\\mathbf{\\Sigma}\_{\\mathrm{xx}} = E\\left\[(\\mathbf{x}-\\mathbf{\\mu}\_{\\mathrm{x}})(\\mathbf{x}-\\mathbf{\\mu}\_{\\mathrm{x}})^T\\right\]$
%[text] - 相関係数 (correlation coefficient) \
%[text]  $\\mathbf{R}\_{\\mathrm{xx}} = \\mathbf{\\Lambda}\_{\\mathrm{x}}^{-\\frac{1}{2}}\\mathbf{\\Sigma}\_{\\mathrm{xx}}\\mathbf{\\Lambda}\_{\\mathrm{x}}^{-\\frac{1}{2}}$
%[text]  $\\mathbf{\\Lambda}\_{\\mathrm{x}} = \\left(\\begin{array}{ll}\\sigma\_{\\mathrm{x},0}^2 & 0 \\\\ 0 & \\sigma\_{\\mathrm{x},1}^2\\end{array}\\right)= \\left(\\begin{array}{ll}E\\left\[(x\_0-\\mu\_{\\mathrm{x,0}})^2\\right\] & 0 \\\\ 0 & E\\left\[(x\_1-\\mu\_{\\mathrm{x},1})^2\\right\]\\end{array}\\right)$
Sxx = cov(double(setOfX.'))
Rxx = corrcoef(double(setOfX.'))
%%
%[text] ### 信号変換
%[text] (Signal transform)
%[text] - 回転行列(rotation matrix) \
%[text]  $\\mathbf{A}\_{\\theta} = \\left(\\begin{array}{cc} \\cos\\theta & -\\sin\\theta \\\\ \\sin\\theta & \\cos\\theta \\end{array}\\right)$
%[text] - 行列 $\\mathbf{A}\_\\theta$による変換 \
%[text]  $\\mathbf{y} = \\mathbf{A}\_\\theta\\mathbf{x}$
Atheta = @(theta) [cos(theta) -sin(theta) ; sin(theta) cos(theta)];
theta = -pi/4;
A = Atheta(theta)
setOfY = A * double(setOfX);
%[text] ### 
%%
%[text] ###  変換後の散布図
%[text] (Scatter plot after transform)
figure(3)
scatter(setOfY(1,:),setOfY(2,:),'.')
axis square
xlabel('y_0')
ylabel('y_1')
title('Scatter plot (after transform)')
%[text] 標本分散共分散行列と相関係数 (Sample covariance matrix and correlation coefficient)
%[text] -  平均ベクトル (mean vector) \
%[text]  $\\mathbf{\\mu}\_\\mathrm{y} = E\[\\mathbf{y}\]$
%[text] - 分散共分散行列 (covariance matrix) \
%[text]  $\\mathbf{\\Sigma}\_{\\mathrm{yy}} = E\\left\[(\\mathbf{y}-\\mathbf{\\mu}\_{\\mathrm{y}})(\\mathbf{y}-\\mathbf{\\mu}\_{\\mathrm{y}})^T\\right\]=\\mathbf{A}\_\\theta\\mathbf{\\Sigma}\_\\mathrm{xx}\\mathbf{A}\_\\theta^{T}$
%[text] - 相関係数 (correlation coefficient) \
%[text]  $\\mathbf{R}\_{\\mathrm{yy}} = \\mathbf{\\Lambda}\_{\\mathrm{y}}^{-\\frac{1}{2}}\\mathbf{\\Sigma}\_{\\mathrm{yy}}\\mathbf{\\Lambda}\_{\\mathrm{y}}^{-\\frac{1}{2}}$
%[text]  $\\mathbf{\\Lambda}\_{\\mathrm{y}} = \\left(\\begin{array}{ll}\\sigma\_{\\mathrm{y},0}^2 & 0 \\\\ 0 & \\sigma\_{\\mathrm{y},1}^2\\end{array}\\right)= \\left(\\begin{array}{ll}E\\left\[(y\_0-\\mu\_{\\mathrm{y,0}})^2\\right\] & 0 \\\\ 0 & E\\left\[(y\_1-\\mu\_{\\mathrm{y},1})^2\\right\]\\end{array}\\right)$
Syy = cov(double(setOfY.'))
Ryy = corrcoef(double(setOfY.'))
%[text] 変換後の分散共分散行列と相関係数の非対角成分が変換前よりも小さい。すなわち、相関が低い。(The non-diagonal components of the sample covariance matrix and correlation coefficient after the transform is smaller than before. That is, the correlation becomes lower.)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
