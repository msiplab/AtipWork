%[text] # Sample 8-2: Separable transforms
%[text] Advanced Topics in Image Processing, Lecture 8 "Discrete Cosine Transforms"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Definition of a bivariate array
X = [ 0 2 ; 4 6 ]
%%
%[text] ## Definition of a univariate transform
%[text] - Discrete Haar transform (DHT) matrix of the reference text (Sec. 6.2.2) \
%[text]  $\\mathbf{A}=\\mathbf{H}\_2=\\frac{1}{\\sqrt{2}}\\begin{pmatrix} 1 & 1 \\\\ 1 & -1 \\end{pmatrix}$,
%[text]  symmetric and orthonormal: $\\mathbf{H}\_2^{-1}=\\mathbf{H}\_2^\\top=\\mathbf{H}\_2$
%[text] - Transform by the matrix $\\mathbf{A}$ \
%[text]  $\\mathbf{y}=\\mathbf{A}\\mathbf{x}$
A = [1 1 ; 1 -1]/sqrt(2)
%%
%[text] ## Separable processing of the forward transform
%[text]  $\\mathbf{Y}=\\mathbf{A}\\mathbf{X}\\mathbf{A}^\\top$
fwdT = @(x) A*x*A.';
Y = fwdT(X)
%%
%[text] ## Separable processing of the inverse transform
%[text]  $\\mathbf{X}=\\mathbf{B}\\mathbf{Y}\\mathbf{B}^\\top$, $\\mathbf{B}=\\mathbf{A}^{-1}$
invA = inv(A)
invT = @(y) invA*y*invA.';
R = invT(Y)
%%
%[text] ## Basis expansion
%[text] The basis images $\\mathsf{b}\_{m\_\\mathrm{v},m\_\\mathrm{h}}$ are the responses of the inverse transform
%[text] to the standard basis images (a single 1 at $(m\_\\mathrm{v},m\_\\mathrm{h})$).
B00 = invT([1 0; 0 0])
B01 = invT([0 1; 0 0])
B10 = invT([0 0; 1 0])
B11 = invT([0 0; 0 1])
%[text] Display of the basis images (white: positive, black: negative)
hfig = figure;
hfig.Color = 0.9*[1 1 1];
tiledlayout(hfig, 2, 2, "TileSpacing", "compact")
bases = {B00, B01, B10, B11};
labels = ["b_{0,0}", "b_{0,1}", "b_{1,0}", "b_{1,1}"];
for k = 1:4
    nexttile
    imshow(bases{k} + 0.5)
    title(labels(k))
end
%[text] Linear combination of the basis images with the coefficients $y\[m\_\\mathrm{v},m\_\\mathrm{h}\]$
Y(1,1)*B00 + Y(1,2)*B01 + Y(2,1)*B10 + Y(2,2)*B11
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
