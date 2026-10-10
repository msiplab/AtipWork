%[text] # Sample 8-4: Basis images
%[text] Advanced Topics in Image Processing, Lecture 8 "Discrete Cosine Transforms"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Number of DCT points
nPoints = 4; %[control:slider:1ca1]{"position":[11,12]}
%%
%[text] ## Extraction of the DCT basis vectors
%[text]  $\[\\mathbf{C}\_M\]\_{m,n}=\\alpha\_m\\cos\\frac{m(2n+1)\\pi}{2M},\\ m,n\\in\\{0,1,\\ldots,M-1\\}$
%[text]  $\\alpha\_m=\\left\\{\\begin{array}{ll} 1/\\sqrt{M} & m=0 \\\\ \\sqrt{2/M} & m\\in\\{1,2,\\ldots,M-1\\}\\end{array}\\right.$
%[text] Basis vectors (responses of the inverse transform to the standard basis vectors)
%[text]  $\\mathbf{b}\_m=\\mathbf{C}\_M^{-1}\\mathbf{e}\_m,\\ m\\in\\{0,1,\\ldots,M-1\\}$
%[text]  $\\mathbf{e}\_0=(1\\ 0\\ \\cdots\\ 0)^\\top$
%[text]  $\\mathbf{e}\_1=(0\\ 1\\ \\cdots\\ 0)^\\top$
%[text]  $\\vdots$
%[text]  $\\mathbf{e}\_{M-1}=(0\\ 0\\ \\cdots\\ 1)^\\top$
B = zeros(nPoints,nPoints);
for idx = 1:nPoints
    e = zeros(nPoints,1);
    e(idx) = 1;
    B(:,idx) = idct(e);
end
%%
%[text] ## Display of the basis vectors
figure
tiledlayout(ceil(nPoints/2), 2, "TileSpacing", "compact")
for idx = 1:nPoints
    ax = nexttile;
    stem(ax, 0:nPoints-1, B(:,idx), "filled");
    ax.YLim = 1.2*[min(B(:)) max(B(:))];
    xlabel(ax, "n")
    title(ax, "b_" + (idx-1))
end
%%
%[text] ## Extraction of the DCT basis images
%[text]  $\\mathsf{b}\_{m\_\\mathrm{v},m\_\\mathrm{h}}=\\mathbf{C}\_M^{-1}\\mathbf{E}\_{m\_\\mathrm{v},m\_\\mathrm{h}}\\mathbf{C}\_M^{-\\top},\\ m\_\\mathrm{v},m\_\\mathrm{h}\\in\\{0,1,\\ldots,M-1\\}$
%[text]  $\\mathbf{E}\_{m\_\\mathrm{v},m\_\\mathrm{h}}=\\mathbf{e}\_{m\_\\mathrm{v}}\\mathbf{e}\_{m\_\\mathrm{h}}^\\top$
B = zeros(nPoints,nPoints,nPoints^2);
iBasis = 1;
for iRow = 1:nPoints
    for iCol = 1:nPoints
        E = zeros(nPoints,nPoints);
        E(iRow,iCol) = 1;
        B(:,:,iBasis) = idct2(E,nPoints,nPoints);
        iBasis = iBasis + 1;
    end
end
%%
%[text] ## Display of the basis images
hfig = figure;
hfig.Color = 0.9*[1 1 1];
tiledlayout(hfig, nPoints, nPoints, "TileSpacing", "tight")
for iBasis = 1:nPoints^2       % row-major order (m_v, m_h)
    nexttile
    imshow(B(:,:,iBasis) + 0.5)
end
%%
%[text] ## Non-linear approximation
%[text] Reconstruction leaving only the coefficients with large absolute values
% Ratio of the remaining coefficients [%]
coefRatio = 5 ; %[control:slider:5b43]{"position":[13,14]}

% Read an image
X = im2double(imread("cameraman.tif"));

% Block DCT
U = blockproc(X,nPoints*[1 1],@(x) dct2(x.data));

% Non-linear approximation (set the small coefficients to zero)
nCoefs = round(coefRatio/100*numel(U));
[~,I] = mink(U(:),numel(U)-nCoefs,"ComparisonMethod","abs");
U(I) = 0;
disp("Sparsity: " + nnz(U(:)) + "/" + numel(U(:)))

% Block IDCT
R = blockproc(U,nPoints*[1 1],@(x) idct2(x.data));
%%
%[text] ## Display of the non-linear approximation result
figure
tiledlayout(1, 2, "TileSpacing", "compact")
nexttile
imshow(X)
title("Original")
nexttile
imshow(R)
title("NLA w/ " + coefRatio + "% coefs. (PSNR: " + psnr(X,R) + " dB)")
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:1ca1]
%   data: {"defaultValue":4,"label":"nPoints","max":8,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:5b43]
%   data: {"defaultValue":5,"label":"coefRatio","max":100,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
