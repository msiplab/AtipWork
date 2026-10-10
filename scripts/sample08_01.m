%[text] # Sample 8-1: Effect of image transforms
%[text] Advanced Topics in Image Processing, Lecture 8 "Discrete Cosine Transforms"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Read and display an image
[datfolder,~] = atip.prjfolders();
V = rgb2gray(imread(fullfile(datfolder,"barbaraFaceRgb.tif")));
figure
imshow(V)
title("Original picture")
%%
%[text] ## Extraction of a set of 2-D vectors
%[text] Horizontal pixel pairs are extracted and arranged as the columns of a data matrix.
%[text] - Pixel array \
%[text]  $\\mathbf{V}=\\begin{pmatrix} v\[0,0\] & v\[0,1\] & v\[0,2\] & \\cdots \\\\ v\[1,0\] & v\[1,1\] & v\[1,2\] & \\cdots \\\\ \\vdots & \\vdots & \\vdots & \\ddots \\end{pmatrix}$
%[text] - Data matrix \
%[text]  $\\mathbf{X}=\\begin{pmatrix}\\mathbf{x}^{\[1\]} & \\mathbf{x}^{\[2\]} & \\cdots\\end{pmatrix}=\\begin{pmatrix} v\[0,0\] & v\[0,2\] & \\cdots & v\[1,0\] & \\cdots \\\\ v\[0,1\] & v\[0,3\] & \\cdots & v\[1,1\] & \\cdots \\end{pmatrix}$
nPixels = numel(V);
setOfX = reshape(V.', 2, nPixels/2);
%%
%[text] ## Scatter plot before the transform
figure
scatter(setOfX(1,:), setOfX(2,:), ".")
axis square
xlabel("x_0")
ylabel("x_1")
title("Scatter plot (before transform)")
%[text] Sample covariance matrix and correlation coefficient matrix of $\\mathcal{X}=\\{\\mathbf{x}^{\[i\]}\\}\_{i=1}^S$
%[text] - Sample mean \
%[text]  $\\hat{\\boldsymbol{\\mu}}\_\\mathcal{X}=\\frac{1}{S}\\sum\_{i=1}^S\\mathbf{x}^{\[i\]}$
%[text] - Sample covariance matrix \
%[text]  $\\hat{\\boldsymbol{\\Sigma}}\_\\mathcal{X}=\\frac{1}{S}\\sum\_{i=1}^S(\\mathbf{x}^{\[i\]}-\\hat{\\boldsymbol{\\mu}}\_\\mathcal{X})(\\mathbf{x}^{\[i\]}-\\hat{\\boldsymbol{\\mu}}\_\\mathcal{X})^\\top$
%[text] - Correlation coefficient matrix \
%[text]  $\\mathbf{R}\_\\mathcal{X}=\\mathbf{S}\_\\mathcal{X}^{-1/2}\\hat{\\boldsymbol{\\Sigma}}\_\\mathcal{X}\\mathbf{S}\_\\mathcal{X}^{-1/2}$,
%[text]  $\\mathbf{S}\_\\mathcal{X}=\\begin{pmatrix}\\sigma\_0^2 & 0 \\\\ 0 & \\sigma\_1^2\\end{pmatrix}$ (diagonal part of $\\hat{\\boldsymbol{\\Sigma}}\_\\mathcal{X}$)
%[text] `cov(X,1)` normalizes by $S$ as in the reference text (`cov(X)` by $S-1$).
Sxx = cov(double(setOfX.'), 1)
Rxx = corrcoef(double(setOfX.'))
%%
%[text] ## Signal transform
%[text] - Discrete Haar transform (DHT) matrix of the reference text (Sec. 6.2.2) \
%[text]  $\\mathbf{H}\_2=\\frac{1}{\\sqrt{2}}\\begin{pmatrix} 1 & 1 \\\\ 1 & -1 \\end{pmatrix}$,
%[text]  symmetric and orthonormal: $\\mathbf{H}\_2^{-1}=\\mathbf{H}\_2^\\top=\\mathbf{H}\_2$
%[text] - Transform by the matrix $\\mathbf{H}\_2$ \
%[text]  $\\mathbf{y}^{\[i\]}=\\mathbf{H}\_2\\mathbf{x}^{\[i\]}$
%[text] $\\mathbf{H}\_2$ rotates the coordinate axes by $\\pi/4$ and flips the second axis ($\\det\\mathbf{H}\_2=-1$).
H2 = [1 1 ; 1 -1]/sqrt(2)
setOfY = H2 * double(setOfX);
%%
%[text] ## Scatter plot after the transform
figure
scatter(setOfY(1,:), setOfY(2,:), ".")
axis square
xlabel("y_0")
ylabel("y_1")
title("Scatter plot (after transform)")
%[text] Sample covariance matrix and correlation coefficient matrix of $\\mathcal{Y}=\\{\\mathbf{y}^{\[i\]}\\}\_{i=1}^S$
%[text] - Sample mean \
%[text]  $\\hat{\\boldsymbol{\\mu}}\_\\mathcal{Y}=\\mathbf{H}\_2\\hat{\\boldsymbol{\\mu}}\_\\mathcal{X}$
%[text] - Sample covariance matrix \
%[text]  $\\hat{\\boldsymbol{\\Sigma}}\_\\mathcal{Y}=\\frac{1}{S}\\sum\_{i=1}^S(\\mathbf{y}^{\[i\]}-\\hat{\\boldsymbol{\\mu}}\_\\mathcal{Y})(\\mathbf{y}^{\[i\]}-\\hat{\\boldsymbol{\\mu}}\_\\mathcal{Y})^\\top=\\mathbf{H}\_2\\hat{\\boldsymbol{\\Sigma}}\_\\mathcal{X}\\mathbf{H}\_2^\\top$
%[text] - Correlation coefficient matrix \
%[text]  $\\mathbf{R}\_\\mathcal{Y}=\\mathbf{S}\_\\mathcal{Y}^{-1/2}\\hat{\\boldsymbol{\\Sigma}}\_\\mathcal{Y}\\mathbf{S}\_\\mathcal{Y}^{-1/2}$
Syy = cov(setOfY.', 1)
Ryy = corrcoef(setOfY.')
%[text] The off-diagonal components of the sample covariance matrix and of the correlation coefficient matrix
%[text] become smaller after the transform.  That is, the correlation becomes lower.
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
