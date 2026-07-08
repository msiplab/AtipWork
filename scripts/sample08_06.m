%[text] # Sample 8-6
%[text] ## 離散コサイン変換
%[text] KLT との関係
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Discrete cosine transform
%[text] Relation to KLT
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ### 次元 $M$ の設定
%[text] (Setting of dimension $M$)
nPoints = 4; %[control:dropdown:1adf]{"position":[11,12]}
%%
%[text] ### 原画像の読込と表示
%[text] (Read and display an image)
V = rgb2gray(imread('data/barbaraFaceRgb.tif'));
figure(1)
imshow(V)
title('Original picture')
%%
%[text] ### $M$次元ベクトル集合の抽出
%[text] (Extraction of a set of $M$-D vectors)
%[text] $M$点の水平方向に連続する画素値をベクトルとして抽出。(Extracts the values of successive horizontal pixels as an $M$-D vector.)
nPixels = numel(V);
setOfX = reshape(V.', nPoints, nPixels/nPoints);
%%
%[text] ###  変換前の散布図
%[text] (Scatter plot before transform)
%[text] 標本分散共分散行列と相関係数 (Sample covariance matrix and correlation coefficient)
Sxx = cov(double(setOfX.'))
Rxx = corrcoef(double(setOfX.'))
%%
%[text] ### カル―ネンレーべ(K-L)変換
%[text] (Karhunen-Loève transform)
%[text] 分散共分散行列の固有値分解(Eigenvalue decomposition of the variance-covariance matrix)
%[text] - $\\mathbf{\\Sigma}\_{\\mathrm{xx}}=\\mathbf{\\Phi}\\mathbf{\\Lambda}\\mathbf{\\Phi}^T$ \
[Phi,Lambda] = eig(Sxx);
%[text] 固有値のソート (Sorting the eigen valuess)
[~,I] = sort(diag(Lambda));
%[text] 固有ベクトルを並び換え (Reordering eigenvectors)
Phi = Phi(:,nPoints-I+1);
%[text] 基底ベクトルの表示 (Display the basis vectors)
figure(2)
for idx = 1:nPoints
    subplot(ceil(nPoints/2),2,idx);
    stem(0:nPoints-1,Phi(:,idx),'filled');
    ax = gca;
    ax.YLim = 1.2*[min(Phi(:)) max(Phi(:))];
    xlabel('n')
end
%[text] K-L 変換 (K-L transform)
T = Phi.';
setOfY = T * double(setOfX);
%%
%[text] ###  変換前後の散布図
%[text] (Scatter plots before and after transform)
if nPoints == 2
    figure(3)
    scatter(setOfX(1,:),setOfX(2,:),'.')
    axis square
    xlabel('x_0')
    ylabel('x_1')
    title('Scatter plot (before transform)')
    figure(4)
    scatter(setOfY(1,:),setOfY(2,:),'.')
    axis square
    xlabel('y_0')
    ylabel('y_1')
    title('Scatter plot (after transform)')
else
    figure(3)
    plotmatrix(setOfX.','.')
    title('Scatter plot (before transform)')
    figure(4)
    plotmatrix(setOfY.','.')
    title('Scatter plot (after transform)')
end
%[text] 標本分散共分散行列と相関係数 (Sample covariance matrix and correlation coefficient)
Syy = cov(double(setOfY.'))
Ryy = corrcoef(double(setOfY.'))
%[text] 変換後の分散共分散行列と相関係数の非対角成分が0となり、無相関となる。(The non-diagonal components of the sample covariance matrix and correlation coefficient after the transform is zero. That is, the coefficients become uncorrelated.)
%%
%[text] ### AR(1)モデルのKLT
%[text] (KLT of AR(1) model)
%[text] - AR(1): the 1-st order autoregressive model \
% Correlation coefficient |ρ|<1
rho = 0.999;  %[control:slider:0cb0]{"position":[7,12]}

% Covariance matrix
sigma = 1;
Sxx = sigma^2*toeplitz(power(rho,0:nPoints-1))
%[text] カル―ネンレーべ(K-L)変換 (Karuhen Loeve transform)
[Phi,Lambda] = eig(Sxx);
[~,I] = sort(diag(Lambda));
Phi = Phi(:,nPoints-I+1);
%[text] 基底ベクトルの表示 (Display the basis vectors)
figure(5)
for idx = 1:nPoints
    subplot(ceil(nPoints/2),2,idx);
    stem(0:nPoints-1,Phi(:,idx),'filled');
    ax = gca;
    ax.YLim = 1.2*[min(Phi(:)) max(Phi(:))];
    xlabel('n')
end
%%
%[text] ## DCT 行列
%[text] (DCT matrix)
C = dctmtx(nPoints);
B = C.';
%[text] 基底ベクトルの表示 (Display the basis vectors)
figure(6)
for idx = 1:nPoints
    subplot(ceil(nPoints/2),2,idx);
    stem(0:nPoints-1,B(:,idx),'filled');
    ax = gca;
    ax.YLim = 1.2*[min(B(:)) max(B(:))];
    xlabel('n')
end
%[text] 相関係数$\\rho\\rightarrow 1$のAR(1)モデルに対するKLT行列は極限でDCT行列に収束する。符号の反転は無視してよい。(The KLT matrix for the AR(1) model with correlation coefficient $\\rho\\rightarrow 1$converges to the DCT matrix in the limit. Flipping in signs can be ignored.)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:dropdown:1adf]
%   data: {"defaultValue":"4","itemLabels":["2","4","8"],"items":["2","4","8"],"label":"nPoints","run":"SectionToEnd"}
%---
%[control:slider:0cb0]
%   data: {"defaultValue":0.999,"label":"rho","max":0.999,"min":-0.999,"run":"SectionToEnd","runOn":"ValueChanging","step":0.001}
%---
