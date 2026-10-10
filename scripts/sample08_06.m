%[text] # Sample 8-6: Relation to KLT
%[text] Advanced Topics in Image Processing, Lecture 8 "Discrete Cosine Transforms"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Setting of the dimension $M$
nPoints = 4; %[control:dropdown:5045]{"position":[11,12]}
%%
%[text] ## Read and display an image
[datfolder,~] = atip.prjfolders();
V = rgb2gray(imread(fullfile(datfolder,"barbaraFaceRgb.tif")));
figure
imshow(V)
title("Original picture")
%%
%[text] ## Extraction of a set of $M$-D vectors
%[text] The values of $M$ successive horizontal pixels are extracted as an $M$-D vector $\\mathbf{x}^{\[i\]}$.
nPixels = numel(V);
setOfX = reshape(V.', nPoints, nPixels/nPoints);
%%
%[text] ## Sample covariance matrix and correlation coefficient matrix before the transform
Sxx = cov(double(setOfX.'), 1)
Rxx = corrcoef(double(setOfX.'))
%%
%[text] ## Karhunen-Loeve transform (KLT)
%[text] Eigenvalue decomposition of the covariance matrix
%[text] - $\\boldsymbol{\\Sigma}\_{\\mathrm{x}}=\\boldsymbol{\\Phi}\\boldsymbol{\\Lambda}\\boldsymbol{\\Phi}^\\top$,
%[text]   $\\boldsymbol{\\Phi}=\\begin{pmatrix}\\mathbf{u}\_0 & \\mathbf{u}\_1 & \\cdots & \\mathbf{u}\_{M-1}\\end{pmatrix}$,
%[text]   $\\lambda\_0\\geq\\lambda\_1\\geq\\cdots\\geq\\lambda\_{M-1}\\geq 0$
[Phi,Lambda] = eig(Sxx);
%[text] Sorting of the eigenvalues in descending order and reordering of the eigenvectors
[~,I] = sort(diag(Lambda), "descend");
Phi = Phi(:,I);
%[text] Display of the basis vectors (columns of $\\boldsymbol{\\Phi}$)
figure
tiledlayout(ceil(nPoints/2), 2, "TileSpacing", "compact")
for idx = 1:nPoints
    ax = nexttile;
    stem(ax, 0:nPoints-1, Phi(:,idx), "filled");
    ax.YLim = 1.2*[min(Phi(:)) max(Phi(:))];
    xlabel(ax, "n")
end
%[text] KLT $\\mathbf{y}^{\[i\]}=\\boldsymbol{\\Phi}^\\top\\mathbf{x}^{\[i\]}$ (the mean only shifts $\\mathbf{y}^{\[i\]}$)
T = Phi.';
setOfY = T * double(setOfX);
%%
%[text] ## Scatter plots before and after the transform
if nPoints == 2
    figure
    scatter(setOfX(1,:), setOfX(2,:), ".")
    axis square
    xlabel("x_0")
    ylabel("x_1")
    title("Scatter plot (before transform)")
    figure
    scatter(setOfY(1,:), setOfY(2,:), ".")
    axis square
    xlabel("y_0")
    ylabel("y_1")
    title("Scatter plot (after transform)")
else
    figure
    plotmatrix(double(setOfX.'), ".")
    title("Scatter plot (before transform)")
    figure
    plotmatrix(setOfY.', ".")
    title("Scatter plot (after transform)")
end
%[text] Sample covariance matrix and correlation coefficient matrix after the transform
Syy = cov(setOfY.', 1)
Ryy = corrcoef(setOfY.')
%[text] The off-diagonal components of the covariance matrix and of the correlation coefficient matrix become zero
%[text] after the transform.  That is, the coefficients are uncorrelated.
%%
%[text] ## KLT of the AR(1) model
%[text] - AR(1): first-order autoregressive process $x\[n\]=\\rho x\[n-1\]+w\[n\]$ \
%[text]  $\\boldsymbol{\\Sigma}\_\\mathrm{x}=\\sigma\_\\mathrm{x}^2\\mathbf{R}\_\\mathrm{x}$,
%[text]  $\[\\mathbf{R}\_\\mathrm{x}\]\_{n,m}=\\rho^{|n-m|}$ (Toeplitz matrix)
% Correlation coefficient |rho|<1
rho = 0.999;  %[control:slider:942d]{"position":[7,12]}

% Covariance matrix
sigma = 1;
Sxx = sigma^2*toeplitz(power(rho,0:nPoints-1))
%[text] Karhunen-Loeve transform
[Phi,Lambda] = eig(Sxx);
[~,I] = sort(diag(Lambda), "descend");
Phi = Phi(:,I);
%[text] Display of the basis vectors
figure
tiledlayout(ceil(nPoints/2), 2, "TileSpacing", "compact")
for idx = 1:nPoints
    ax = nexttile;
    stem(ax, 0:nPoints-1, Phi(:,idx), "filled");
    ax.YLim = 1.2*[min(Phi(:)) max(Phi(:))];
    xlabel(ax, "n")
end
%%
%[text] ## DCT matrix
C = dctmtx(nPoints);
B = C.';
%[text] Display of the basis vectors (columns of $\\mathbf{C}\_M^\\top$)
figure
tiledlayout(ceil(nPoints/2), 2, "TileSpacing", "compact")
for idx = 1:nPoints
    ax = nexttile;
    stem(ax, 0:nPoints-1, B(:,idx), "filled");
    ax.YLim = 1.2*[min(B(:)) max(B(:))];
    xlabel(ax, "n")
end
%[text] The KLT matrix of the AR(1) model with the correlation coefficient $\\rho\\rightarrow 1$ converges to the
%[text] DCT matrix in the limit.  The signs of the basis vectors may be flipped.
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:dropdown:5045]
%   data: {"defaultValue":"4","itemLabels":["2","4","8"],"items":["2","4","8"],"label":"nPoints","run":"SectionToEnd"}
%---
%[control:slider:942d]
%   data: {"defaultValue":0.999,"label":"rho","max":0.999,"min":-0.999,"run":"SectionToEnd","runOn":"ValueChanging","step":0.001}
%---
