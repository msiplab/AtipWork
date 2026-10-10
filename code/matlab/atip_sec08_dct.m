%[text] # Lecture 8: Discrete Cosine Transforms
%[text] Shogo Muramatsu, "Advanced Topics in Image Processing"
%[text] Verified: MATLAB R2026b
%[text] This script makes all figures and numbers of the slides of lecture 8 (atip2027-08).
%[text] The notation follows the reference text \[M\] (MsipText), Sections 6.1 (basics of image transforms),
%[text] 6.2 (representative discrete transforms) and 7.3.2 (transform coding).
%[text:tableOfContents]{"heading":"Contents"}
%%
%[text] ## Preparation
%[text] Figures and LaTeX snippets are written to the `results` folder.  AtipSlides imports them with
%[text] `tools/sync-results.ps1`.  The figure colours are the three colours of the MSIP Lab logo and grey.
[datfolder,resfolder] = atip.prjfolders();
cmain = [0 136 85]/255;     % main (green) #008855
ccool = [46 117 182]/255;   % cool (blue)  #2E75B6
cwarm = [197 90 17]/255;    % warm (orange) #C55A11
%%
%[text] ## Scatter plot of neighbouring pixel pairs
%[text] Horizontal pixel pairs $\\mathbf{x}^{\[i\]}=(x\[n\_\\mathrm{v},2k\],\\ x\[n\_\\mathrm{v},2k+1\])^\\top$ of the
%[text] grayscale image of `barbaraFaceRgb.tif` (values in $\[0,1\]$) form the set
%[text] $\\mathcal{X}=\\{\\mathbf{x}^{\[i\]}\\}\_{i=1}^S\\subset\\mathbb{R}^2$ (Example "Covariance matrix" of \[M\] Sec. 6.1.2).
V = im2double(rgb2gray(imread(fullfile(datfolder,"barbaraFaceRgb.tif"))));
imwrite(V, fullfile(resfolder,"atip-08-barbara.png"))
Xset = reshape(V.', 2, []);          % 2 x S data matrix (horizontal pairs)
S = size(Xset,2)
%[text] Sample covariance matrix $\\hat{\\boldsymbol{\\Sigma}}\_\\mathcal{X}=(1/S)\\sum\_i\\underline{\\mathbf{x}}^{\[i\]}(\\underline{\\mathbf{x}}^{\[i\]})^\\top$
%[text] (normalized by $S$ as in the text) and the correlation coefficient matrix
%[text] $\\mathbf{R}\_\\mathcal{X}=\\mathbf{S}\_\\mathcal{X}^{-1/2}\\hat{\\boldsymbol{\\Sigma}}\_\\mathcal{X}\\mathbf{S}\_\\mathcal{X}^{-1/2}$
%[text] ($\\mathbf{S}\_\\mathcal{X}$: diagonal part of $\\hat{\\boldsymbol{\\Sigma}}\_\\mathcal{X}$; \[M\] COLUMN "First-order autoregressive process", Sec. 6.2.1).
SigmaX = cov(Xset.', 1)
RX = corrcoef(Xset.')
%%
%[text] ## Haar transform of each pair
%[text] DHT matrix of \[M\] Sec. 6.2.2: $\\mathbf{H}\_2=\\frac{1}{\\sqrt{2}}\\begin{pmatrix}1&1\\\\1&-1\\end{pmatrix}$ ($=\\mathbf{C}\_2$),
%[text] symmetric and orthonormal, $\\mathbf{H}\_2^{-1}=\\mathbf{H}\_2^\\top=\\mathbf{H}\_2$.  It rotates the coordinate axes
%[text] by $\\pi/4$ and flips the second axis ($\\det\\mathbf{H}\_2=-1$).
%[text] $\\hat{\\boldsymbol{\\Sigma}}\_\\mathcal{Y}=\\mathbf{H}\_2\\hat{\\boldsymbol{\\Sigma}}\_\\mathcal{X}\\mathbf{H}\_2^\\top$.
H2 = [1 1; 1 -1]/sqrt(2);
assert(norm(H2 - dctmtx(2)) < 1e-12 && abs(det(H2) + 1) < 1e-12)
Yset = H2*Xset;
SigmaY = cov(Yset.', 1)
RY = corrcoef(Yset.')
assert(norm(SigmaY - H2*SigmaX*H2.') < 1e-12)
assert(abs(RY(1,2)) < abs(RX(1,2)))
atip.savetex("atip-08-S",      atip.fmtint(S));
atip.savetex("atip-08-SigmaX", atip.arr2tex(SigmaX, "%.4f"));
atip.savetex("atip-08-SigmaY", atip.arr2tex(SigmaY, "%.4f"));
atip.savetex("atip-08-rhoX",   sprintf("%.3f", RX(1,2)));
atip.savetex("atip-08-rhoY",   sprintf("%.3f", RY(1,2)));
%[text] Scatter plots before and after the transform (same scale on both axes)
names = ["x","y"];
sets = {Xset, Yset};
labs = {["$x_0$","$x_1$"], ["$y_0$","$y_1$"]};
lims = {[0 1; 0 1], [0 1.45; -0.725 0.725]};
rng(0)
idx = randperm(S, min(S, 8000));     % thin out the points for a light figure
for k = 1:2
    fig = figure(Units="centimeters", Position=[2 2 4.6 4.6], Color="w");
    ax = axes(fig);
    P = sets{k};
    scatter(ax, P(1,idx), P(2,idx), 2, cmain, "filled", "MarkerFaceAlpha", 0.3)
    axis(ax, "equal"), grid(ax, "on")
    xlim(ax, lims{k}(1,:)), ylim(ax, lims{k}(2,:))
    xlabel(ax, labs{k}(1), "Interpreter", "latex")
    ylabel(ax, labs{k}(2), "Interpreter", "latex")
    set(ax, "FontSize", 8, "TickLabelInterpreter", "latex")
    exportgraphics(fig, fullfile(resfolder, "atip-08-scatter-" + names(k) + ".png"), "Resolution", 300)
    close(fig)
end
%%
%[text] ## Expansion with basis vectors
%[text] The basis vectors are the columns of $\\mathbf{B}=\\mathbf{H}\_2^{-1}$: $\\mathbf{b}\_m=\\mathbf{B}\\mathbf{e}\_m$
%[text] (responses to the standard basis vectors).
B = inv(H2);
assert(norm(B - H2) < 1e-12)        % symmetric orthogonal matrix: H2^{-1} = H2^T = H2
b0 = B*[1;0]
b1 = B*[0;1]
atip.savetex("atip-08-b0", atip.arr2tex(round(sqrt(2)*b0), "%d"));   % sqrt(2)*b0
atip.savetex("atip-08-b1", atip.arr2tex(round(sqrt(2)*b1), "%d"));   % sqrt(2)*b1
%[text] Coefficients $\\mathbf{y}=\\mathbf{H}\_2\\mathbf{x}$ of three vectors: coordinates on the new axes
%[text] $(\\sqrt{2},\\sqrt{2})$, $(\\sqrt{2},2\\sqrt{2})$ and $(2\\sqrt{2},\\sqrt{2})$.
Xv = sqrt(2)*[1 1 2; 1 2 1];
Yv = round(H2*Xv, 12)
assert(isequal(Yv, [2 3 3; 0 -1 1]))
assert(norm(Xv - (b0*Yv(1,:) + b1*Yv(2,:))) < 1e-12)
for k = 1:3
    atip.savetex("atip-08-coord-" + char('a'+k-1), atip.arr2tex(Yv(:,k), "%d"));
    for m = 0:1   % single coefficients y[m] of each vector
        atip.savetex("atip-08-coord-" + char('a'+k-1) + m, sprintf("%d", Yv(m+1,k)));
    end
end
%%
%[text] ## Expansion with basis images (separable transform)
%[text] For a $2\\times 2$ array, $\\mathbf{Y}=\\mathbf{H}\_2\\mathbf{X}\\mathbf{H}\_2^\\top$ and
%[text] $\\mathbf{X}=\\mathbf{B}\\mathbf{Y}\\mathbf{B}^\\top=\\sum\_{m\_\\mathrm{v},m\_\\mathrm{h}}y\[m\_\\mathrm{v},m\_\\mathrm{h}\]\\,\\mathbf{B}\\mathbf{E}\_{m\_\\mathrm{v},m\_\\mathrm{h}}\\mathbf{B}^\\top$.
X2 = [0 2; 4 6];
Y2 = round(H2*X2*H2.', 12)
assert(isequal(Y2, [6 -2; -4 0]))
atip.savetex("atip-08-X2", atip.arr2tex(X2, "%d"));
atip.savetex("atip-08-Y2", atip.arr2tex(Y2, "%d"));
R2 = zeros(2);
bimg = zeros(2,2,2,2);
for mv = 0:1
    for mh = 0:1
        E = zeros(2); E(mv+1,mh+1) = 1;
        bimg(:,:,mv+1,mh+1) = B*E*B.';                         % basis image b_{mv,mh}
        R2 = R2 + Y2(mv+1,mh+1)*bimg(:,:,mv+1,mh+1);
        atip.savetex(sprintf("atip-08-bimg%d%d",mv,mh), ...
            atip.arr2tex(round(2*bimg(:,:,mv+1,mh+1)), "%d"));  % 2*b_{mv,mh}
        atip.savetex(sprintf("atip-08-y2-%d%d",mv,mh), sprintf("%d", Y2(mv+1,mh+1)));
        atip.savetex(sprintf("atip-08-y2s-%d%d",mv,mh), sprintf("%+d", Y2(mv+1,mh+1)));   % signed term
        % the basis image is the outer product of the basis vectors
        assert(norm(bimg(:,:,mv+1,mh+1) - B(:,mv+1)*B(:,mh+1).') < 1e-12)
    end
end
assert(norm(R2 - X2) < 1e-12)
%[text] Tiles of the patch $\\mathbf{X}$ (dark = 0, bright = 6) and of the basis images (white = positive, black = negative)
up = @(T) imresize(T, 32, "nearest");
imwrite(up(X2/6), fullfile(resfolder,"atip-08-patch.png"))
for mv = 0:1
    for mh = 0:1
        imwrite(up(0.5 + bimg(:,:,mv+1,mh+1)), ...
            fullfile(resfolder, sprintf("atip-08-bimg%d%d.png",mv,mh)))
    end
end
%%
%[text] ## Coding gain of the DCT for AR(1)
%[text] Exercise "Coding gain" of \[M\] Sec. 7.3.2: AR(1) with $\\rho=0.95$, $M=4$,
%[text] $\\boldsymbol{\\Sigma}\_\\mathrm{y}=\\mathbf{C}\_4\\boldsymbol{\\Sigma}\_\\mathrm{x}\\mathbf{C}\_4^\\top$ and
%[text] $G=\\frac{(1/M)\\sum\_p\\sigma\_{\\mathrm{y}\_p}^2}{(\\prod\_p\\sigma\_{\\mathrm{y}\_p}^2)^{1/M}}$.
rho = 0.95; M = 4;
Rx = toeplitz(rho.^(0:M-1));
C4 = dctmtx(M);
SigmaYc = C4*Rx*C4.';
vary = diag(SigmaYc).'
G = mean(vary)/geomean(vary);
GdB = 10*log10(G)
assert(abs(GdB - 7.57) < 0.005)
atip.savetex("atip-08-cg-vary", strjoin(compose("%.4f", vary), ",\ "));
atip.savetex("atip-08-cg-gdb",  sprintf("%.2f", GdB));
%%
%[text] ## DCT matrix and 8x8 basis images
%[text] $\[\\mathbf{C}\_M\]\_{m,n}=\\alpha\_m\\cos\\frac{m(2n+1)\\pi}{2M}$, $\\alpha\_0=1/\\sqrt{M}$, $\\alpha\_m=\\sqrt{2/M}$ ($m>0$).
%[text] `dctmtx` gives the same matrix.  The basis images are $\\mathbf{b}\_{m\_\\mathrm{v}}\\mathbf{b}\_{m\_\\mathrm{h}}^\\top$
%[text] with $\\mathbf{b}\_m=\[\\mathbf{C}\_M^\\top\]\_{:,m}$.
M = 8;
[m,n] = ndgrid(0:M-1);
alphaK = [1/sqrt(M); sqrt(2/M)*ones(M-1,1)];
C8 = alphaK(m+1).*cos(m.*(2*n+1)*pi/(2*M));
assert(norm(C8 - dctmtx(M)) < 1e-12)
assert(norm(C8*C8.' - eye(M)) < 1e-12)
Bc = C8.';
gap = 1; tile = M + gap;
mosaic = ones(M*tile+gap);           % white separators
vmax = max(abs(Bc(:)))^2;
for mv = 0:M-1
    for mh = 0:M-1
        bb = Bc(:,mv+1)*Bc(:,mh+1).';
        r = gap + mv*tile + (1:M); c = gap + mh*tile + (1:M);
        mosaic(r,c) = 0.5 + 0.5*bb/vmax;
    end
end
imwrite(imresize(mosaic, 6, "nearest"), fullfile(resfolder,"atip-08-dct8.png"))
%%
%[text] ## Block DCT of an image
%[text] $8\\times 8$ block DCT by `blockproc` and `dct2`; non-linear approximation keeping the 5% of the coefficients
%[text] with the largest magnitudes (the exercise uses 10% for cameraman.tif).
blk = [8 8];
Xb = V(1:8*floor(end/8), 1:8*floor(end/8));
Yb = blockproc(Xb, blk, @(b) dct2(b.data));
ratio = 5;
K = round(ratio/100*numel(Yb));
[~,order] = sort(abs(Yb(:)), "descend");
Yk = zeros(size(Yb)); Yk(order(1:K)) = Yb(order(1:K));
Xk = blockproc(Yk, blk, @(b) idct2(b.data));
psnrK = psnr(Xk, Xb)
imwrite(Xb, fullfile(resfolder,"atip-08-bdct-org.png"))
coefimg = log1p(50*abs(Yb)); coefimg = coefimg/max(coefimg(:));
imwrite(coefimg, fullfile(resfolder,"atip-08-bdct-coef.png"))
imwrite(min(max(Xk,0),1), fullfile(resfolder,"atip-08-bdct-rec.png"))
atip.savetex("atip-08-bdct-ratio", sprintf("%d", ratio));
atip.savetex("atip-08-bdct-psnr",  sprintf("%.2f", psnrK));
atip.savetex("atip-08-bdct-size",  sprintf("%d\\times %d", size(Xb)));
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
