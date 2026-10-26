%[text] # Lecture 3: Image Smoothing and Sharpening
%[text] Shogo Muramatsu, "Advanced Topics in Image Processing"
%[text] Verified: MATLAB R2026b
%[text] This script makes all figures and numbers of the slides of lecture 3 (atip2027-03).
%[text] The notation follows the reference text \[M\] (MsipText): Section 1.2.1 (inner product, norm, distance,
%[text] PSNR) and Chapter 3: Sections 3.1 (linear filters, boundary processing), 3.2 (gradient filters) and
%[text] 3.3 (order statistic filters).
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
%[text] ## Vectors in $\\mathbb{R}^2$
%[text] Sum and scalar product of $\\mathbf{u}=(2\\ \\ -2)^\\top$ and $\\mathbf{v}=(1\\ \\ 1)^\\top$.
u = [2; -2]; v = [1; 1];
upv = u + v
m2v = -2*v
atip.savetex("atip-03-vec-upv", atip.arr2tex(upv, "%d"));
atip.savetex("atip-03-vec-m2v", atip.arr2tex(m2v, "%d"));
%%
%[text] ## Inner product, norm and distance of arrays
%[text] \[M\] Examples "Inner product of multidimensional arrays", "Norm of multidimensional arrays",
%[text] "Relations between multidimensional arrays" and Exercise "Sum of squared errors" (Section 1.2.1).
x = [7 5 3; 3 2 2];
y = [-4 9 6; 7 5 7];
ip = sum(x.*y, "all")                     % <x,y>
nx = norm(x(:)); ny = norm(y(:));         % ||x||_2, ||y||_2
costh = ip/(nx*ny)
dxy = norm(x(:)-y(:))                     % ||x-y||_2
sseXY = dxy^2
assert(ip == 80 && nx == 10 && ny == 16 && abs(costh-0.5) < 1e-12 && abs(dxy-14) < 1e-12)
atip.savetex("atip-03-ip-x", atip.arr2tex(x, "%d"));
atip.savetex("atip-03-ip-y", atip.arr2tex(y, "%d"));
atip.savetex("atip-03-ip-xy", sprintf("%d", ip));
atip.savetex("atip-03-ip-nx", sprintf("%g", nx));
atip.savetex("atip-03-ip-ny", sprintf("%g", ny));
atip.savetex("atip-03-ip-cos", sprintf("%g", costh));
atip.savetex("atip-03-ip-theta", sprintf("%g", round(acos(costh)/pi*180)));
atip.savetex("atip-03-dist-2", sprintf("%g", dxy));
atip.savetex("atip-03-dist-sse", sprintf("%g", sseXY));
atip.savetex("atip-03-dist-div", sprintf("%g", sseXY/2));
atip.savetex("atip-03-dist-mse", sprintf("%.2f", sseXY/numel(x)));
%[text] $\\ell\_1$-norms (\[M\] Appendix A.1, $p$-norm with $p=1$) and the norms of $\\mathsf{x}$ as a matrix
n1x = norm(x(:), 1)
d1xy = norm(x(:)-y(:), 1)
nfro = norm(x, "fro")                     % Frobenius norm = l2-norm of the array
nspec = norm(x)                           % spectral norm (largest singular value)
assert(n1x == 22 && d1xy == 30 && abs(nfro-10) < 1e-12)
atip.savetex("atip-03-norm-1x", sprintf("%g", n1x));
atip.savetex("atip-03-dist-1", sprintf("%g", d1xy));
atip.savetex("atip-03-norm-fro", sprintf("%g", nfro));
atip.savetex("atip-03-norm-spec", sprintf("%.2f", nspec));
%%
%[text] ## Moving average and moving differences
%[text] Local inner product $y\[\\boldsymbol{n}\]=\\langle\\boldsymbol{f},\\boldsymbol{x}\_{\\boldsymbol{n}}\\rangle=\\sum\_{\\boldsymbol{m}}f\[\\boldsymbol{m}\]x\[\\boldsymbol{n}+\\boldsymbol{m}\]$
%[text] (\[M\] Section 3.1) for the $3\\times 3$ local array of the array of \[M\] Exercises "Box filter" and
%[text] "Prewitt filter" at $\\boldsymbol{n}=(1\\ 1)^\\top$: average (box) and Prewitt (horizontal, vertical) kernels.
xn = [18 9 9; 27 9 9; 36 9 9];
favg = ones(3)/9;
fhor = [-1 0 1; -1 0 1; -1 0 1];
fver = fhor.';
yavg = sum(favg.*xn, "all")
yhor = sum(fhor.*xn, "all")
yver = sum(fver.*xn, "all")
% agrees with y_box[1,1] = 15, x_h[1,1] = -54 and x_v[1,1] = 18 of the exercises
assert(abs(yavg - 15) < 1e-12 && yhor == -54 && yver == 18)
atip.savetex("atip-03-md-x", atip.arr2tex(xn, "%d"));
atip.savetex("atip-03-md-avg", sprintf("%g", yavg));
atip.savetex("atip-03-md-hor", sprintf("%g", yhor));
atip.savetex("atip-03-md-ver", sprintf("%g", yver));
%%
%[text] ## Image filters
%[text] $3\\times 3$ kernels: average, 4-neighbour Laplacian, Sobel (horizontal and vertical) applied to the stone
%[text] building (msipimg04).  Results with negative values are shown with the bias $1/2$ (\[M\] Example "Bias processing").
X = im2double(atip.msipimg(4, 256, "gray"));
fbox = ones(3)/9;
flap = [0 1 0; 1 -4 1; 0 1 0];
fsobh = [-1 0 1; -2 0 2; -1 0 1];
fsobv = [-1 -2 -1; 0 0 0; 1 2 1];
imwrite(X, fullfile(resfolder, "atip-03-filt-org.png"))
imwrite(imfilter(X, fbox, "symmetric"), fullfile(resfolder, "atip-03-filt-avg.png"))
imwrite(imfilter(X, flap, "symmetric") + 0.5, fullfile(resfolder, "atip-03-filt-lap.png"))
imwrite(imfilter(X, fsobh, "symmetric")/2 + 0.5, fullfile(resfolder, "atip-03-filt-sobh.png"))
imwrite(imfilter(X, fsobv, "symmetric")/2 + 0.5, fullfile(resfolder, "atip-03-filt-sobv.png"))
%%
%[text] ## Worked examples on a $3\\times 4$ array
%[text] \[M\] Exercises "Box filter", "4-neighbour Laplacian", "4-neighbour unsharp mask", "Prewitt filter",
%[text] "Gradient magnitude", "Median filter" and "Max/min filters" with zero padding (`imfilter` default).
xe = [18 9 9 9; 27 9 9 9; 36 9 9 9];
ybox = imfilter(xe, fbox)
ylap = imfilter(xe, flap)
funs = [0 -1 0; -1 5 -1; 0 -1 0];
yuns = imfilter(xe, funs)
assert(isequal(round(ybox,10), [7 9 6 4; 12 15 9 6; 9 11 6 4]))
assert(isequal(ylap, [-36 0 -9 -18; -45 18 0 -9; -108 18 -9 -18]))
assert(isequal(yuns, xe - ylap) && isequal(funs, [0 0 0; 0 1 0; 0 0 0] - flap))
fprev = [-1 -1 -1; 0 0 0; 1 1 1];
fpreh = [-1 0 1; -1 0 1; -1 0 1];
xv = imfilter(xe, fprev)
xh = imfilter(xe, fpreh)
ymag = sqrt(xv.^2 + xh.^2)
assert(isequal(xv, [36 45 27 18; 18 18 0 0; -36 -45 -27 -18]))
assert(isequal(xh, [18 -27 0 -18; 27 -54 0 -27; 18 -45 0 -18]))
ymed = medfilt2(xe, [3 3])                 % zero padding
ymax = ordfilt2(xe, 9, ones(3));
ymin = ordfilt2(xe, 1, ones(3));
assert(isequal(ymed, [0 9 9 0; 9 9 9 9; 0 9 9 0]))
assert(isequal(ymax, [27 27 9 9; 36 36 9 9; 36 36 9 9]) && isequal(ymin, [0 0 0 0; 0 9 9 0; 0 0 0 0]))
atip.savetex("atip-03-ex-x", atip.arr2tex(xe, "%d"));
atip.savetex("atip-03-ex-box", atip.arr2tex(ybox, "%g"));
atip.savetex("atip-03-ex-lap", atip.arr2tex(ylap, "%d"));
atip.savetex("atip-03-ex-uns", atip.arr2tex(yuns, "%d"));
%[text] MATLAB `imgradientxy` gives the same differences at the interior pixels (replica padding);
%[text] `imgradient` measures the direction counterclockwise, i.e. $\\mathrm{atan2}(-x\_\\mathrm{v},x\_\\mathrm{h})$.
[gx, gy] = imgradientxy(xe, "prewitt");
assert(isequal(gx(2,2:3), xh(2,2:3)) && isequal(gy(2,2:3), xv(2,2:3)))   % interior pixel
%%
%[text] ## Gaussian filter
%[text] \[M\] Example "Gaussian filter" ($3\\times 3$, $\\sigma\_\\mathrm{g}=0.5$) and Exercise "Gaussian filter"
%[text] ($\\sigma\_\\mathrm{g}\\simeq 0.849$, close to $\\frac{1}{16}(1\\ 2\\ 1)^\\top(1\\ 2\\ 1)$).
fg05 = fspecial("gaussian", 3, 0.5)
fg849 = fspecial("gaussian", 3, 0.849)
assert(max(abs(fg05(:) - [0.0113 0.0838 0.0113 0.0838 0.6193 0.0838 0.0113 0.0838 0.0113]')) < 1e-4)
assert(max(abs(fg849(:)*16 - [1 2 1 2 4 2 1 2 1]')) < 5e-3)
atip.savetex("atip-03-gauss-05", atip.arr2tex(fg05, "%.4f"));
%[text] Mesh of the $9\\times 9$ Gaussian kernel with $\\sigma\_\\mathrm{g}=2$ (2026 slides: `fspecial`)
hsize = 9; sigma = 2;
fg = fspecial("gaussian", hsize, sigma);
[m2, m1] = meshgrid(-4:4);
fig = figure(Units="centimeters", Position=[2 2 5.5 4.2], Color="w");
ax = axes(fig);
mesh(ax, m2, m1, fg, "EdgeColor", cmain, "FaceAlpha", 0.6, "FaceColor", "w")
xlabel(ax, "$m_2$", "Interpreter", "latex"), ylabel(ax, "$m_1$", "Interpreter", "latex")
zlabel(ax, "$f[m_1,m_2]$", "Interpreter", "latex")
xticks(ax, -4:2:4), yticks(ax, -4:2:4)
set(ax, "FontSize", 8), view(ax, -35, 30)
exportgraphics(fig, fullfile(resfolder, "atip-03-gauss-mesh.png"), "Resolution", 300)
close(fig)
%%
%[text] ## Order statistic filters
%[text] The $3\\times 3$ local array of the 2026 slides: minimum, median and maximum.
xo = [181 158 115; 90 77 44; 56 35 19];
vs = sort(xo(:)).'
assert(vs(1) == 19 && vs(5) == 77 && vs(9) == 181)
atip.savetex("atip-03-ord-x", atip.arr2tex(xo, "%d"));
atip.savetex("atip-03-ord-sorted", strjoin(string(vs), ",\,"));
atip.savetex("atip-03-ord-min", sprintf("%d", vs(1)));
atip.savetex("atip-03-ord-med", sprintf("%d", vs(5)));
atip.savetex("atip-03-ord-max", sprintf("%d", vs(9)));
%[text] Min, median and max filters ($3\\times 3$) applied to the watermelon (msipimg08)
W = im2double(atip.msipimg(8, 256, "gray"));
imwrite(W, fullfile(resfolder, "atip-03-ord-org.png"))
imwrite(ordfilt2(W, 1, ones(3), "symmetric"), fullfile(resfolder, "atip-03-ord-minimg.png"))
imwrite(medfilt2(W, [3 3], "symmetric"), fullfile(resfolder, "atip-03-ord-medimg.png"))
imwrite(ordfilt2(W, 9, ones(3), "symmetric"), fullfile(resfolder, "atip-03-ord-maximg.png"))
%%
%[text] ## Mean as the least-squares estimate, median as the least-absolute-deviation estimate
%[text] $f(x)=\\|\\mathbf{v}-x\\mathbf{1}\\|\_2^2$ is minimized by the mean and $g(x)=\\|\\mathbf{v}-x\\mathbf{1}\\|\_1$ by the median.
%[text] The subdifferential is $\\partial g(x)=\\#\\{v\_i<x\\}-\\#\\{v\_i>x\\}+\\#\\{v\_i=x\\}\\cdot\[-1,1\]$.
vv = xo(:);
N = numel(vv);
xmean = mean(vv)
xmed = median(vv)
xs = linspace(0, 200, 2001);
fx = sum((vv - xs).^2, 1);
gxs = sum(abs(vv - xs), 1);
[~, k1] = min(fx); [~, k2] = min(gxs);
assert(abs(xs(k1) - xmean) < 0.1 && abs(xs(k2) - xmed) < 0.1)
atip.savetex("atip-03-ls-mean", sprintf("%.2f", xmean));
atip.savetex("atip-03-ls-sum", sprintf("%d", sum(vv)));
atip.savetex("atip-03-ls-N", sprintf("%d", N));
% robustness to an outlier: 181 -> 1000
vo = vv; vo(vv == 181) = 1000;
atip.savetex("atip-03-ls-meano", sprintf("%.2f", mean(vo)));
atip.savetex("atip-03-ls-medo", sprintf("%d", median(vo)));
%[text] Plots of $f(x)$ and $g(x)$ and the subdifferential $\\partial g(x)$
fig = figure(Units="centimeters", Position=[2 2 5.0 3.4], Color="w");
ax = axes(fig);
plot(ax, xs, fx/1e4, "Color", cmain, "LineWidth", 1.2), hold(ax, "on")
plot(ax, vv, zeros(N,1), "o", "Color", cwarm, "MarkerSize", 3, "MarkerFaceColor", cwarm)
xline(ax, xmean, "--", "Color", ccool, "LineWidth", 1)
hold(ax, "off"), xlim(ax, [0 200]), ylim(ax, [0 max(fx)/1e4])
xlabel(ax, "$x$", "Interpreter", "latex"), ylabel(ax, "$f(x)\ [\times 10^4]$", "Interpreter", "latex")
set(ax, "FontSize", 8, "Box", "off", "TickDir", "out")
exportgraphics(fig, fullfile(resfolder, "atip-03-ls.png"), "Resolution", 300)
close(fig)
fig = figure(Units="centimeters", Position=[2 2 5.0 3.4], Color="w");
ax = axes(fig);
plot(ax, xs, gxs, "Color", cmain, "LineWidth", 1.2), hold(ax, "on")
plot(ax, vv, zeros(N,1), "o", "Color", cwarm, "MarkerSize", 3, "MarkerFaceColor", cwarm)
xline(ax, xmed, "--", "Color", ccool, "LineWidth", 1)
hold(ax, "off"), xlim(ax, [0 200]), ylim(ax, [0 max(gxs)])
xlabel(ax, "$x$", "Interpreter", "latex"), ylabel(ax, "$g(x)$", "Interpreter", "latex")
set(ax, "FontSize", 8, "Box", "off", "TickDir", "out")
exportgraphics(fig, fullfile(resfolder, "atip-03-lad.png"), "Resolution", 300)
close(fig)
% subdifferential: vertical segments [-1,1]*#{v_i = x} at the data points
fig = figure(Units="centimeters", Position=[2 2 5.0 3.4], Color="w");
ax = axes(fig); hold(ax, "on")
vsrt = [0; sort(vv); 200];
for k = 1:numel(vsrt)-1
    s = sum(vv < (vsrt(k)+vsrt(k+1))/2) - sum(vv > (vsrt(k)+vsrt(k+1))/2);
    plot(ax, vsrt(k:k+1), [s s], "Color", cmain, "LineWidth", 1.2)
    if k > 1
        plot(ax, [vsrt(k) vsrt(k)], [s-2 s], "Color", cmain, "LineWidth", 1.2)
    end
end
yline(ax, 0, ":", "Color", [0.5 0.5 0.5])
xline(ax, xmed, "--", "Color", ccool, "LineWidth", 1)
hold(ax, "off"), xlim(ax, [0 200]), ylim(ax, [-N-1 N+1]), yticks(ax, [-N 0 N])
xlabel(ax, "$x$", "Interpreter", "latex"), ylabel(ax, "$\partial g(x)$", "Interpreter", "latex")
set(ax, "FontSize", 8, "Box", "off", "TickDir", "out")
exportgraphics(fig, fullfile(resfolder, "atip-03-lad-sub.png"), "Resolution", 300)
close(fig)
%%
%[text] ## Robustness to impulsive noise (PSNR)
%[text] Salt \& pepper noise of density 5% on msipimg08; $3\\times 3$ mean and median filters.
%[text] $\\mathrm{PSNR}=10\\log\_{10}(V\_\\mathrm{peak}^2/\\mathrm{MSE})$ with $V\_\\mathrm{peak}=1$ (\[M\] Definition "PSNR", Section 1.2.1).
rng(0)
Wn = imnoise(W, "salt & pepper", 0.05);
Wmean = imfilter(Wn, fbox, "symmetric");
Wmed = medfilt2(Wn, [3 3], "symmetric");
mymse = @(a,b) mean((a(:)-b(:)).^2);
mypsnr = @(a,b) 10*log10(1/mymse(a,b));
pn = mypsnr(W, Wn), pa = mypsnr(W, Wmean), pm = mypsnr(W, Wmed)
assert(abs(pm - psnr(Wmed, W)) < 1e-10 && pm > pa)
atip.savetex("atip-03-sp-psnr-n", sprintf("%.2f", pn));
atip.savetex("atip-03-sp-psnr-a", sprintf("%.2f", pa));
atip.savetex("atip-03-sp-psnr-m", sprintf("%.2f", pm));
%%
%[text] ## Boundary processing
%[text] \[M\] Exercise "Boundary processing" (Section 3.1.3): the $3\\times 4$ array extended to
%[text] $\\Omega\_\\mathrm{pad}=\\{-2,\\ldots,4\\}\\times\\{-2,\\ldots,5\\}$.  `padarray` with "symmetric" is the
%[text] symmetric padding with half-sample symmetry (HS).
pz = padarray(xe, [2 2], 0);
pc = padarray(xe, [2 2], "circular");
pr = padarray(xe, [2 2], "replicate");
ps = padarray(xe, [2 2], "symmetric");
assert(isequal(pc(1,:), [9 9 27 9 9 9 27 9]) && isequal(pr(end,:), [36 36 36 9 9 9 9 9]))
assert(isequal(ps(:,1).', [9 9 9 9 9 9 9]) && isequal(ps(:,2).', [27 18 18 27 36 36 27]))
atip.savetex("atip-03-pad-zero", atip.arr2tex(pz, "%d"));
atip.savetex("atip-03-pad-circ", atip.arr2tex(pc, "%d"));
atip.savetex("atip-03-pad-sym",  atip.arr2tex(ps, "%d"));
%[text] Extended images of the Barbara face (data/barbaraFaceRgb.tif) with the original boundary drawn
B = im2double(imread(fullfile(datfolder, "barbaraFaceRgb.tif")));
[N1, N2, ~] = size(B);
padSz = round([N1 N2]/2);
padModes = {0, "circular", "symmetric"};
mnames = ["zero", "circ", "sym"];
for k = 1:3
    E = padarray(B, padSz, padModes{k});
    % boundary lines of the original support (main colour)
    r = [padSz(1)-2:padSz(1), padSz(1)+N1+1:padSz(1)+N1+3];      % 3-pixel lines
    c = [padSz(2)-2:padSz(2), padSz(2)+N2+1:padSz(2)+N2+3];
    for ch = 1:3
        E(r, padSz(2)-2:padSz(2)+N2+3, ch) = cmain(ch);
        E(padSz(1)-2:padSz(1)+N1+3, c, ch) = cmain(ch);
    end
    imwrite(imresize(E, 0.5), fullfile(resfolder, "atip-03-ext-" + mnames(k) + ".png"))
end
%[text] Comparison as in \[M\] Example "Boundary processing" and Fig. 3.4 (Section 3.1.3): the macarons (msipimg03)
%[text] in grayscale, resized to $96\\times 96$ (bilinear), $3\\times 3$ box filter, lower-right $19\\times 19$ part of the
%[text] output (rows and columns 78 to 96).  The parts are enlarged by pixel replication (factor 8) so that the
%[text] one-pixel artefacts at the border stay visible on the slide.
Xm = imresize(im2double(rgb2gray(atip.msipimg(3))), [96 96], "bilinear");
hsize = 3;
fb = ones(hsize)/hsize^2;
crop = round(96*13/16):96;                                % = 78:96 as in [M]
padModes = {0, "circular", "replicate", "symmetric"};
mnames = ["zero", "circ", "rep", "sym"];
for k = 1:4
    Y = imfilter(Xm, fb, padModes{k});
    imwrite(imresize(Y(crop, crop), 8, "nearest"), fullfile(resfolder, "atip-03-bnd-" + mnames(k) + ".png"))
    % check against the textbook figure if MsipText is placed next to AtipWork
    [~,~,prjroot] = atip.prjfolders();
    tbfile = fullfile(fileparts(prjroot), "MsipText", "figures", "fig03-04" + char('a'+k-1) + ".png");
    if isfile(tbfile)
        fprintf("fig03-04%s: max |diff| = %d\n", char('a'+k-1), ...
            max(abs(double(im2uint8(Y(crop,crop))) - double(imread(tbfile))), [], "all"));
    end
end
%[text] Input image with the cropped part framed (main colour)
Xf = repmat(imresize(Xm, 4, "nearest"), [1 1 3]);
r0 = 4*(crop(1)-1)+1; r1 = 4*crop(end);
for ch = 1:3
    Xf([r0:r0+2, r1-2:r1], r0:r1, ch) = cmain(ch);
    Xf(r0:r1, [r0:r0+2, r1-2:r1], ch) = cmain(ch);
end
imwrite(Xf, fullfile(resfolder, "atip-03-bnd-input.png"))
atip.savetex("atip-03-bnd-hsize", sprintf("%d", hsize));
atip.savetex("atip-03-bnd-crop", sprintf("%d", numel(crop)));
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
