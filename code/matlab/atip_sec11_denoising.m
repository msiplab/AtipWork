%[text] # Lecture 11: Image Denoising
%[text] Shogo Muramatsu, "Advanced Topics in Image Processing"
%[text] Verified: MATLAB R2026b
%[text] This script makes all figures and numbers of the slides of lecture 11 (atip2027-11).
%[text] The notation follows the reference text \[M\] (MsipText), Sections 8.1--8.4 and Appendix A.6:
%[text] observation $\\mathbf{v}=\\mathbf{x}+\\mathbf{w}$, synthesis model $\\mathbf{x}=\\mathbf{D}\\mathbf{s}$,
%[text] step size $\\eta$, Lipschitz constant $\\kappa$ and soft thresholding $\\phi\_\\mathrm{ST}(\\cdot;\\tau)$.
%[text:tableOfContents]{"heading":"Contents"}
%%
%[text] ## Preparation
%[text] Figures and LaTeX snippets are written to the `results` folder.  AtipSlides imports them with
%[text] `tools/sync-results.ps1`.  The figure colours are the three colours of the MSIP Lab logo and grey.
[~,resfolder] = atip.prjfolders();
cmain = [0 136 85]/255;     % main (green) #008855
ccool = [46 117 182]/255;   % cool (blue)  #2E75B6
cwarm = [197 90 17]/255;    % warm (orange) #C55A11
%%
%[text] ## Toy example
%[text] $\\mathbf{D}=\\begin{pmatrix}2/3 & 1/3\\end{pmatrix}$ ($N=1$, $L=2$), observation $v=1/2$ (2026 slides, sample11\_03, 11\_04, 11\_06).
D = [2 1]/3;
v = 1/2;
%%
%[text] ## Likelihood
%[text] $p(v\\mid\\mathbf{s})=\\mathcal{N}(v;\\mathbf{D}\\mathbf{s},\\sigma\_\\mathrm{w}^2)$ with $\\sigma\_\\mathrm{w}^2=0.001$ for $\\mathbf{s}=(1/2,1/2)^\\top$.
sgmw2 = 0.001;
s = [1/2; 1/2];
mu = D*s
assert(abs(mu - 1/2) < 1e-12)
vv = linspace(0, 1, 1001);
lik = normpdf(vv, mu, sqrt(sgmw2));
fig = figure(Units="centimeters", Position=[2 2 4.8 3.4], Color="w");
ax = axes(fig);
plot(ax, vv, lik, "-", "Color", ccool, "LineWidth", 1.0)
xlabel(ax, "$v$", "Interpreter", "latex", "FontSize", 8)
ylabel(ax, "$p(v\mid\mathbf{s})$", "Interpreter", "latex", "FontSize", 8)
set(ax, "FontSize", 7, "TickLabelInterpreter", "latex", "Box", "off")
grid(ax, "on")
exportgraphics(fig, fullfile(resfolder, "atip-11-likelihood.png"), "Resolution", 300)
close(fig)
atip.savetex("atip-11-lik-mean", frac2tex(mu));
%%
%[text] ## Gaussian and Laplace priors
%[text] Both with zero mean and variance $\\sigma\_\\mathrm{s}^2=0.001$: $\\mathcal{N}(s;0,\\sigma\_\\mathrm{s}^2)$ and
%[text] $\\mathcal{L}(s;0,b)=(2b)^{-1}\\exp(-|s|/b)$ with $2b^2=\\sigma\_\\mathrm{s}^2$ (sample11\_05).
sgms2 = 0.001;
b = sqrt(sgms2/2)
ss = linspace(-0.15, 0.15, 1201);
pg = normpdf(ss, 0, sqrt(sgms2));
pl = exp(-abs(ss)/b)/(2*b);
sc_ = linspace(-1, 1, 200001); plc = exp(-abs(sc_)/b)/(2*b);   % check: unit mass and variance
assert(abs(trapz(sc_, plc) - 1) < 1e-6 && abs(trapz(sc_, sc_.^2.*plc) - sgms2) < 1e-8)
fig = figure(Units="centimeters", Position=[2 2 5.0 3.6], Color="w");
ax = axes(fig, "Position", [0.17 0.24 0.78 0.60]); hold(ax, "on")
plot(ax, ss, pg, "-", "Color", ccool, "LineWidth", 1.0)
plot(ax, ss, pl, "-", "Color", cwarm, "LineWidth", 1.0)
hold(ax, "off")
% legend above the axes box (outside it, so never on the curves)
lgd = legend(ax, ["Gaussian", "Laplace"], "FontSize", 7, "Box", "off", "Orientation", "horizontal");
lgd.Position = [0.17 0.87 0.78 0.10];
xlabel(ax, "$s$", "Interpreter", "latex", "FontSize", 8)
ylabel(ax, "$p(s)$", "Interpreter", "latex", "FontSize", 8)
ylim(ax, [0 24])
set(ax, "FontSize", 7, "TickLabelInterpreter", "latex", "Box", "off")
grid(ax, "on")
exportgraphics(fig, fullfile(resfolder, "atip-11-pdf.png"), "Resolution", 300)
close(fig)
atip.savetex("atip-11-pdf-b", sprintf("%.4f", b));
%%
%[text] ## Ridge regularization and the normal equation
%[text] $\\hat{\\mathbf{s}}=(\\mathbf{D}^\\top\\mathbf{D}+\\lambda\\mathbf{I})^{-1}\\mathbf{D}^\\top v$ for $\\lambda\\in\\{0.1,1,10\\}$.
%[text] The eigenvalues of $\\mathbf{D}^\\top\\mathbf{D}$ are $0$ and $\\|\\mathbf{D}\\|\_2^2=5/9$.
ev = sort(eig(D.'*D)).'
assert(abs(ev(1)) < 1e-12 && abs(ev(2) - 5/9) < 1e-12)
atip.savetex("atip-11-dtd-eig", frac2tex(ev(2)));
lmds = [0.1 1 10];
sr = zeros(2, numel(lmds));
for k = 1:numel(lmds)
    sr(:,k) = (D.'*D + lmds(k)*eye(2))\(D.'*v);
end
sr
rows = strings(numel(lmds),1);
for k = 1:numel(lmds)
    rows(k) = sprintf("\\lambda=%g\\colon\\ (%.3f,\\ %.3f)^\\top", lmds(k), sr(1,k), sr(2,k));
end
atip.savetex("atip-11-ridge-list", strjoin(rows, ",\quad "));
%[text] Path of the solution (all on the direction of $\\mathbf{D}^\\top$) and the limit $\\lambda\\to0$ ($\\mathbf{D}^+v$)
lpath = logspace(-3, 2, 200);
spath = zeros(2, numel(lpath));
for k = 1:numel(lpath)
    spath(:,k) = (D.'*D + lpath(k)*eye(2))\(D.'*v);
end
s0lim = pinv(D)*v;
assert(norm(spath(:,1) - s0lim) < 1e-2)
%[text] 3-D figure as in the 2026 slides: surface of the cost for $\\lambda=1$ with its contours on the bottom,
%[text] the path of $\\hat{\\mathbf{s}}$ (dotted) with the solutions for $\\lambda=10,1,0.1$ (from the origin outwards),
%[text] the limit $\\mathbf{D}^+v$ (square) and the solution for $\\lambda=1$ on the surface.
cdark = [0 82 51]/255;      % dark green (msipmaindark)
lmdshow = 1;
fridge = @(a,b) 0.5*(v - (D(1)*a + D(2)*b)).^2 + lmdshow/2*(a.^2 + b.^2);
zl = [0 1.2];
fig = figure(Units="centimeters", Position=[2 2 5.0 4.0], Color="w");
ax = axes(fig);
costsurf(ax, fridge, [-1 1], zl, 0.05:0.1:1.15, "$f(\mathbf{s})$")
plot3(ax, spath(1,:), spath(2,:), zl(1)*ones(1,numel(lpath)), ":", "Color", cwarm, "LineWidth", 1.1)
plot3(ax, s0lim(1), s0lim(2), zl(1), "s", "MarkerFaceColor", cdark, "MarkerEdgeColor", "w", "MarkerSize", 4.5, "LineWidth", 0.4)
k1 = find(lmds == lmdshow);
markpt(ax, sr(:,k1), fridge(sr(1,k1), sr(2,k1)), zl(1), cwarm, "o", 3.5)
plot3(ax, sr(1,:), sr(2,:), zl(1)*ones(1,numel(lmds)), "o", "MarkerFaceColor", cwarm, "MarkerEdgeColor", "w", "MarkerSize", 3.5, "LineWidth", 0.4)
exportgraphics(fig, fullfile(resfolder, "atip-11-ridge.png"), "Resolution", 300)
close(fig)
%%
%[text] ## Gradient descent for ridge regularization
%[text] $f(\\mathbf{s})=\\frac12(v-\\mathbf{D}\\mathbf{s})^2+\\frac{\\lambda}{2}\\|\\mathbf{s}\\|\_2^2$,
%[text] $\\nabla f(\\mathbf{s})=\\mathbf{D}^\\top(\\mathbf{D}\\mathbf{s}-v)+\\lambda\\mathbf{s}$, Lipschitz constant
%[text] $\\kappa=\\|\\mathbf{D}\\|\_\\mathrm{S}^2+\\lambda$, step size $\\eta\\in(0,2/\\kappa)$ (sample11\_04: $\\lambda=0.2$, $\\eta=0.4$).
lambda = 0.2;
eta = 0.4;
niters = 20;
kappa = norm(D)^2 + lambda
assert(eta < 2/kappa)
sopt = (D.'*D + lambda*eye(2))\(D.'*v);
sgd = [-0.8; -0.6];
traj = zeros(2, niters+1); traj(:,1) = sgd;
for t = 1:niters
    sgd = sgd - eta*(D.'*(D*sgd - v) + lambda*sgd);
    traj(:,t+1) = sgd;
end
sgd
sopt
errgd = norm(sgd - sopt)
atip.savetex("atip-11-gd-kappa", sprintf("%.3f", kappa));
atip.savetex("atip-11-gd-s", sprintf("(%.3f,\\ %.3f)^\\top", sgd(1), sgd(2)));
atip.savetex("atip-11-gd-sopt", sprintf("(%.3f,\\ %.3f)^\\top", sopt(1), sopt(2)));
fcost = @(s0,s1) 0.5*(v - (D(1)*s0 + D(2)*s1)).^2 + lambda/2*(s0.^2 + s1.^2);
plotpath(fcost, traj, sopt, fullfile(resfolder, "atip-11-gd.png"), cwarm, cdark, "$f(\mathbf{s})$")
%%
%[text] ## Lasso (BPDN) and ISTA
%[text] $\\hat{\\mathbf{s}}=\\arg\\min\\frac12(v-\\mathbf{D}\\mathbf{s})^2+\\lambda\\|\\mathbf{s}\\|\_1$ with $\\lambda=0.2$:
%[text] the minimizer $(0.3,0)^\\top$ lies on an axis.  ISTA:
%[text] $\\mathbf{s}^{(t+1)}\\leftarrow\\phi\_\\mathrm{ST}(\\mathbf{s}^{(t)}-\\eta\\mathbf{D}^\\top(\\mathbf{D}\\mathbf{s}^{(t)}-v);\\lambda\\eta)$, $\\eta\\in(0,2/\\|\\mathbf{D}\\|\_\\mathrm{S}^2)$.
soft = @(x,tau) sign(x).*max(abs(x)-tau, 0);
kappa1 = norm(D)^2
assert(eta < 2/kappa1)
sis = [-0.8; -0.6];
traj = zeros(2, niters+1); traj(:,1) = sis;
for t = 1:niters
    sis = soft(sis - eta*D.'*(D*sis - v), lambda*eta);
    traj(:,t+1) = sis;
end
slas = sis;
for t = 1:2000
    slas = soft(slas - eta*D.'*(D*slas - v), lambda*eta);
end
slas
% optimality (subgradient) check of (0.3, 0)
assert(norm(slas - [0.3; 0]) < 1e-9)
g = D.'*(D*slas - v);
assert(abs(g(1) + lambda*sign(slas(1))) < 1e-9 && abs(g(2)) <= lambda)
atip.savetex("atip-11-ista-kappa", frac2tex(kappa1));
atip.savetex("atip-11-lasso-s", sprintf("(%.1f,\\ %g)^\\top", slas(1), slas(2)));
atip.savetex("atip-11-ista-s20", sprintf("(%.3f,\\ %.3f)^\\top", traj(1,end), traj(2,end)));
fcost = @(s0,s1) 0.5*(v - (D(1)*s0 + D(2)*s1)).^2 + lambda*(abs(s0) + abs(s1));
plotpath(fcost, traj, slas, fullfile(resfolder, "atip-11-ista.png"), cwarm, cdark, "$f(\mathbf{s})+g(\mathbf{s})$")
%[text] BPDN cost surface: the ridges along the axes $s\[0\]=0$ and $s\[1\]=0$ (dark lines) are the points where
%[text] $\\lambda\\|\\mathbf{s}\\|\_1$ is not differentiable; the minimizer lies on one of them.
fig = figure(Units="centimeters", Position=[2 2 5.0 4.0], Color="w");
ax = axes(fig);
zl = [0 1.5];
costsurf(ax, fcost, [-1 1], zl, 0.05:0.1:1.45, "$f(\mathbf{s})+g(\mathbf{s})$")
t = linspace(-1, 1, 201);
plot3(ax, t, zeros(size(t)), fcost(t, 0) + 0.01, "-", "Color", [0.25 0.25 0.25], "LineWidth", 0.9)
plot3(ax, zeros(size(t)), t, fcost(0, t) + 0.01, "-", "Color", [0.25 0.25 0.25], "LineWidth", 0.9)
markpt(ax, slas, fcost(slas(1), slas(2)), zl(1), cdark, "p", 7)
exportgraphics(fig, fullfile(resfolder, "atip-11-bpdn.png"), "Resolution", 300)
close(fig)
%%
%[text] ## Image and noise in an orthonormal DWT domain
%[text] cameraman.tif ($256\\times256$), AWGN with $\\sigma\_\\mathrm{w}=20/255$, 3-level orthonormal DWT (sym4, periodic extension).
%[text] The DWT coefficients of the image are sparse, those of the noise are dense:
%[text] the covariance of the noise coefficients is $\\sigma\_\\mathrm{w}^2\\mathbf{T}\\mathbf{T}^\\top=\\sigma\_\\mathrm{w}^2\\mathbf{I}$.
x = im2double(imread("cameraman.tif"));
sgmw = 20/255;
rng(0)
w = sgmw*randn(size(x));
vimg = x + w;
nlevels = 3;
dwtmode("per", "nodisp")
[h0,h1,f0,f1] = wfilters("sym4");
[cx,sc] = wavedec2(x, nlevels, h0, h1);
[cv,~]  = wavedec2(vimg, nlevels, h0, h1);
[cw,~]  = wavedec2(w, nlevels, h0, h1);
assert(abs(norm(cw) - norm(w(:))) < 1e-9)     % Parseval
xr = waverec2(cx, sc, f0, f1);
assert(norm(xr - x, "fro") < 1e-9)            % PR
imwrite(x,    fullfile(resfolder, "atip-11-cam.png"))
imwrite(vimg, fullfile(resfolder, "atip-11-cam-noisy.png"))
imwrite(min(aligncoefs(cx, sc)*3, 1), fullfile(resfolder, "atip-11-coef-x.png"))
imwrite(min(aligncoefs(cv, sc)*3, 1), fullfile(resfolder, "atip-11-coef-v.png"))
%[text] Ratio of the coefficients with $|s|<\\sigma\_\\mathrm{w}$ in the high-pass channels
nlow = prod(sc(1,:));
rx = mean(abs(cx(nlow+1:end)) < sgmw)
rw = mean(abs(cw(nlow+1:end)) < sgmw)
atip.savetex("atip-11-sparse-x", sprintf("%.0f", 100*rx));
atip.savetex("atip-11-sparse-w", sprintf("%.0f", 100*rw));
%%
%[text] ## Wavelet shrinkage
%[text] $\\hat{\\mathbf{x}}=\\mathbf{D}\\phi\_\\mathrm{ST}(\\mathbf{D}^\\top\\mathbf{v};\\lambda)$ for the high-pass coefficients
%[text] (the low-pass coefficients are kept).  $\\lambda$ is chosen by a grid search (with the original image).
lmdset = (0.2:0.1:2.0)*sgmw;
pv = zeros(size(lmdset));
mask = ones(size(cv)); mask(1:nlow) = 0;
for k = 1:numel(lmdset)
    xh = waverec2(soft(cv, lmdset(k)*mask), sc, f0, f1);
    pv(k) = psnr(xh, x);
end
[pbest, kbest] = max(pv);
lbest = lmdset(kbest)
xh = waverec2(soft(cv, lbest*mask), sc, f0, f1);
psnrv = psnr(vimg, x)
psnrd = psnr(xh, x)
assert(abs(psnrd - pbest) < 1e-9 && psnrd > psnrv)
imwrite(xh, fullfile(resfolder, "atip-11-ws-xhat.png"))
atip.savetex("atip-11-ws-sgmw",  "20/255");
atip.savetex("atip-11-ws-lambda", sprintf("%.3f", lbest));
atip.savetex("atip-11-ws-psnrv", sprintf("%.2f", psnrv));
atip.savetex("atip-11-ws-psnrd", sprintf("%.2f", psnrd));
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.
%%
%[text] ## Local functions
function str = frac2tex(v)
% Rational number as LaTeX (\tfrac{n}{d} or an integer)
[n,d] = rat(v, 1e-10);
if d == 1
    str = sprintf("%d", n);
elseif n < 0
    str = sprintf("-\\tfrac{%d}{%d}", -n, d);
else
    str = sprintf("\\tfrac{%d}{%d}", n, d);
end
str = string(str);
end

function plotpath(fcost, traj, sopt, fname, ctraj, csol, zlab)
% 3-D surface of a cost function with an iteration path (on the surface and on the bottom plane)
% and the minimizer (pentagram with a drop line)
zl = [0 1.5];
fig = figure(Units="centimeters", Position=[2 2 5.0 4.0], Color="w");
ax = axes(fig);
costsurf(ax, fcost, [-1 1], zl, 0.05:0.1:1.45, zlab)
zt = fcost(traj(1,:), traj(2,:)) + 0.01;
plot3(ax, traj(1,:), traj(2,:), zl(1)*ones(1,size(traj,2)), "-o", "Color", ctraj, ...
    "MarkerFaceColor", ctraj, "MarkerSize", 2, "LineWidth", 0.8)
% on the surface: lighter tint, thin and semi-transparent, so that the surface stays visible
ctint = 0.6*ctraj + 0.4;
plot3(ax, traj(1,:), traj(2,:), zt, "-", "Color", [ctint 0.6], "LineWidth", 0.5)
scatter3(ax, traj(1,:), traj(2,:), zt, 2.6, ctint, "o", "filled", ...
    "MarkerFaceAlpha", 0.5, "MarkerEdgeAlpha", 0.5)
markpt(ax, sopt, fcost(sopt(1), sopt(2)), zl(1), csol, "p", 7)
exportgraphics(fig, fname, "Resolution", 300)
close(fig)
end

function cmap = msipcmap(n)
% Colormap from the MSIP colours: blue (low) -> green -> light green (high)
ccool = [46 117 182]/255;
cmain = [0 136 85]/255;
stops = [0.35*[1 1 1] + 0.65*ccool; 0.45*[1 1 1] + 0.55*cmain; 0.85*[1 1 1] + 0.15*cmain];
cmap = interp1([0 0.5 1], stops, linspace(0, 1, n));
end

function costsurf(ax, fcost, srange, zlims, levels, zlab, npts, alpha)
% Semi-transparent surface of fcost(s[0],s[1]) on srange^2 (cut at zlims(2)) with a light mesh and
% its contours (levels) projected on the bottom plane z = zlims(1), viewed as in the 2026 slides.
% Objects are drawn in the order of creation (SortMethod "childorder"): the contours lie under the
% surface, and the lines and markers added afterwards stay visible on top of it.
if nargin < 7 || isempty(npts), npts = 241; end
if nargin < 8, alpha = 0.7; end
t = linspace(srange(1), srange(2), npts);
[S0,S1] = meshgrid(t);
Z = fcost(S0, S1);
Zc = Z;
Zc(Z > zlims(2)) = NaN;
cmap = msipcmap(256);
hold(ax, "on")
ax.SortMethod = "childorder";
if numel(levels) > 1
    C = contourc(t, t, Z, levels);
    ic = 1;
    while ic < size(C,2)
        lev = C(1,ic);
        np = C(2,ic);
        col = 0.8*interp1(linspace(zlims(1), zlims(2), 256), cmap, min(max(lev, zlims(1)), zlims(2)));
        plot3(ax, C(1,ic+1:ic+np), C(2,ic+1:ic+np), zlims(1)*ones(1,np), "-", "Color", col, "LineWidth", 0.5)
        ic = ic + np + 1;
    end
end
surf(ax, S0, S1, Zc, "EdgeColor", "none", "FaceAlpha", alpha, "FaceColor", "interp")
k = round(linspace(1, npts, 11));
mesh(ax, S0(k,k), S1(k,k), Zc(k,k), "FaceColor", "none", "EdgeColor", [0.3 0.3 0.3], ...
    "EdgeAlpha", 0.25, "LineWidth", 0.3)
colormap(ax, cmap)
clim(ax, zlims)
view(ax, 52.5, 30)            % s[0] on the left and s[1] on the right edge, as in 2026
xlim(ax, srange), ylim(ax, srange), zlim(ax, zlims)
grid(ax, "on")
xlabel(ax, "$s[0]$", "Interpreter", "latex", "FontSize", 8)
ylabel(ax, "$s[1]$", "Interpreter", "latex", "FontSize", 8)
zlabel(ax, zlab, "Interpreter", "latex", "FontSize", 8)
set(ax, "FontSize", 7, "TickLabelInterpreter", "latex")
end

function markpt(ax, s, z, zmin, col, mk, msz)
% Point on the surface with a vertical drop line to the bottom plane
plot3(ax, [s(1) s(1)], [s(2) s(2)], [zmin z], ":", "Color", col, "LineWidth", 1.0)
plot3(ax, s(1), s(2), z, mk, "MarkerFaceColor", col, "MarkerEdgeColor", "w", "MarkerSize", msz, "LineWidth", 0.4)
plot3(ax, s(1), s(2), zmin, mk, "MarkerFaceColor", col, "MarkerEdgeColor", "w", "MarkerSize", msz, "LineWidth", 0.4)
end

function c00 = aligncoefs(coefs, scales)
% Octave-band arrangement of the DWT coefficients (absolute values; low-pass scaled by 2^-J)
nlevels = size(scales,1) - 2;
dim = scales(1,:);
nel = prod(dim);
c00 = abs(reshape(coefs(1:nel), dim))/(2^nlevels);
pos = nel;
for ilv = 1:nlevels
    dim = scales(ilv+1,:);
    nel = prod(dim);
    c01 = abs(reshape(coefs(pos+1:pos+nel), dim)); pos = pos + nel;
    c10 = abs(reshape(coefs(pos+1:pos+nel), dim)); pos = pos + nel;
    c11 = abs(reshape(coefs(pos+1:pos+nel), dim)); pos = pos + nel;
    c00 = [ c00 c01; c10 c11 ];
end
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
