%[text] # Lecture 10: Redundant Transforms
%[text] Shogo Muramatsu, "Advanced Topics in Image Processing"
%[text] Verified: MATLAB R2026b
%[text] This script makes all figures and numbers of the slides of lecture 10 (atip2027-10).
%[text] The notation follows the reference text \[M\] (MsipText), Sections 6.3, 6.4.1, 7.1.2 and 7.2,
%[text] and Appendices A.5 and A.6: signal $\\mathbf{x}\\in\\mathbb{R}^N$, dictionary (synthesis FB)
%[text] $\\mathbf{D}\\in\\mathbb{R}^{N\\times L}$, coefficient vector $\\mathbf{s}\\in\\mathbb{R}^L$, $\\mathbf{x}=\\mathbf{D}\\mathbf{s}$.
%[text:tableOfContents]{"heading":"Contents"}
%%
%[text] ## Preparation
%[text] Figures and LaTeX snippets are written to the `results` folder.  AtipSlides imports them with
%[text] `tools/sync-results.ps1`.  The figure colours are the three colours of the MSIP Lab logo and grey.
[~,resfolder] = atip.prjfolders();
cmain = [0 136 85]/255;     % main (green) #008855
ccool = [46 117 182]/255;   % cool (blue)  #2E75B6
cwarm = [197 90 17]/255;    % warm (orange) #C55A11
cgray = [0.55 0.55 0.55];
%%
%[text] ## Solution space of a redundant representation
%[text] Toy example: $x=\\mathbf{D}\\mathbf{s}$ with $\\mathbf{D}=\\begin{pmatrix}2/3 & 1/3\\end{pmatrix}$ ($N=1$, $L=2$) and $x=1/2$.
%[text] All solutions lie on the line $s\[1\]=-2s\[0\]+3/2$.
D = [2/3 1/3];
x = 1/2;
slope = -D(1)/D(2)
icept = x/D(2)
assert(abs(slope+2) < 1e-12 && abs(icept-3/2) < 1e-12)
atip.savetex("atip-10-sol-line", sprintf("%ds[0]+%s", round(slope), frac2tex(icept)));
%[text] Minimum-energy ($\\ell\_2$) solution by the Moore--Penrose pseudo-inverse
%[text] $\\hat{\\mathbf{s}}=\\mathbf{D}^\\top(\\mathbf{D}\\mathbf{D}^\\top)^{-1}x=\\mathbf{D}^+x$
DDt = D*D.'
s2 = D.'/DDt*x
assert(norm(s2 - pinv(D)*x) < 1e-12 && norm(s2 - [3/5; 3/10]) < 1e-12)
atip.savetex("atip-10-l2-ddt",    frac2tex(DDt));
atip.savetex("atip-10-l2-ddtinv", frac2tex(1/DDt));
atip.savetex("atip-10-l2-scale",  frac2tex(s2(end)));
atip.savetex("atip-10-l2-dir",    atip.arr2tex(round(s2/s2(end)), "%d"));
atip.savetex("atip-10-l2-dirrow", atip.arr2tex(round(s2.'/s2(end)), "%d"));
atip.savetex("atip-10-l2-vec",    strjoin(arrayfun(@frac2tex, s2), "\\"));
%[text] Minimum-$\\ell\_1$ solution by basis pursuit (linear programming), $\\mathbf{s}=\\mathbf{s}\_+-\\mathbf{s}\_-$
L = numel(D);
opts = optimoptions("linprog", "Display", "none");
z = linprog(ones(2*L,1), [], [], [D -D], x, zeros(2*L,1), [], opts);
s1 = z(1:L) - z(L+1:end)
assert(norm(s1 - [3/4; 0]) < 1e-9)
s1(abs(s1) < 1e-9) = 0;
atip.savetex("atip-10-l1-vec", strjoin(arrayfun(@frac2tex, s1), "\\"));
atip.savetex("atip-10-l1-row", strjoin(arrayfun(@frac2tex, s1), " & "));
%[text] The $\\ell\_0$-minimal solutions are not unique: both points on the axes have one non-zero element.
sz0 = [x/D(1); 0];
sz1 = [0; x/D(2)];
assert(norm(D*sz0 - x) < 1e-12 && norm(D*sz1 - x) < 1e-12)
atip.savetex("atip-10-l0-a", strjoin(arrayfun(@frac2tex, sz0), "\\"));
atip.savetex("atip-10-l0-b", strjoin(arrayfun(@frac2tex, sz1), "\\"));
%[text] Comparison of the two solutions ($\\ell\_0$, $\\ell\_1$, squared $\\ell\_2$ norms)
nrm = @(s) [nnz(abs(s) > 1e-9), norm(s,1), norm(s,2)^2];
n2 = nrm(s2)
n1 = nrm(s1)
atip.savetex("atip-10-cmp-l2", sprintf("$%d$ & $%s$ & $%s$", n2(1), frac2tex(n2(2)), frac2tex(n2(3))));
atip.savetex("atip-10-cmp-l1", sprintf("$%d$ & $%s$ & $%s$", n1(1), frac2tex(n1(2)), frac2tex(n1(3))));
%%
%[text] ### Figures of the solution space (3-D, as in the 2026 slides)
%[text] The plane $z=\\mathbf{D}\\mathbf{s}=\\frac23s\[0\]+\\frac13s\[1\]$ over the $(s\[0\],s\[1\])$ plane and the horizontal
%[text] plane $z=x=1/2$.  Their intersection, projected on the bottom, is the line of solutions with the
%[text] $\\ell\_1$-minimal solution (circle, on the plane and on the bottom) and the $\\ell\_2$-minimal one (square).
%[text] The plane is drawn in two parts (below and above $z=x$) so that the horizontal plane lies between them.
cdark = [0 82 51]/255;      % dark green (msipmaindark) for constraints
lim = 1.5;
zl = [-1.5 1.5];
fplane = @(a,b) D(1)*a + D(2)*b;
fig = figure(Units="centimeters", Position=[2 2 5.6 4.6], Color="w");
ax = axes(fig);
costsurf(ax, @(a,b) maskz(fplane(a,b), fplane(a,b) <= x), [-lim lim], zl, [], "$\mathbf{D}\mathbf{s}$")
[P0,P1] = meshgrid([-lim lim]);
surf(ax, P0, P1, x*ones(2), "FaceColor", [0.55 0.55 0.55], "FaceAlpha", 0.3, ...
    "EdgeColor", [0.45 0.45 0.45], "EdgeAlpha", 0.5)
costsurf(ax, @(a,b) maskz(fplane(a,b), fplane(a,b) >= x), [-lim lim], zl, [], "$\mathbf{D}\mathbf{s}$")
t0 = [(-lim - icept)/slope, (lim - icept)/slope];       % line inside the box
plot3(ax, t0, slope*t0 + icept, [x x], "-", "Color", cdark, "LineWidth", 1.4)
plot3(ax, t0, slope*t0 + icept, zl(1)*[1 1], "-", "Color", cdark, "LineWidth", 1.2)
plot3(ax, s2(1), s2(2), zl(1), "s", "MarkerFaceColor", ccool, "MarkerEdgeColor", "w", "MarkerSize", 4.5, "LineWidth", 0.4)
markpt(ax, s1, x, zl(1), cwarm)
exportgraphics(fig, fullfile(resfolder, "atip-10-solspace.png"), "Resolution", 300)
close(fig)
%[text] Surfaces of $\\|\\mathbf{s}\\|\_2^2$ (bowl) and $\\|\\mathbf{s}\\|\_1$ (pyramid) with the constraint $x=\\mathbf{D}\\mathbf{s}$:
%[text] the line on the bottom plane and its curve on the surface.  The minimizer is marked on both.
for p = [2 1]
    fig = figure(Units="centimeters", Position=[2 2 5.0 4.0], Color="w");
    ax = axes(fig);
    if p == 2
        fp = @(a,b) a.^2 + b.^2;  sp = s2;  zlab = "$\|\mathbf{s}\|_2^2$";
    else
        fp = @(a,b) abs(a) + abs(b);  sp = s1;  zlab = "$\|\mathbf{s}\|_1$";
    end
    costsurf(ax, fp, [-1 1], [0 1], 0.1:0.1:0.9, zlab)
    constrline(ax, fp, slope, icept, [-1 1], [0 1], cdark)
    markpt(ax, sp, fp(sp(1),sp(2)), 0, cwarm)
    exportgraphics(fig, fullfile(resfolder, sprintf("atip-10-l%dmin.png", p)), "Resolution", 300)
    close(fig)
end
%[text] Minimizers of $\\|\\mathbf{s}\\|\_p^p=|s\[0\]|^p+|s\[1\]|^p$ on the line for $p=2,1,1/2,1/10$ (grid search).
%[text] For $p\\le 1$ the minimizer lies on an axis (sparse solution); the surface is convex only for $p\\ge1$.
ps = [2 1 1/2 1/10];
zmaxs = [1 1 1.5 2];
s0grid = linspace(-1, 2, 300001);
fig = figure(Units="centimeters", Position=[2 2 11.0 2.9], Color="w");
tl = tiledlayout(fig, 1, numel(ps), "TileSpacing", "tight", "Padding", "compact");
for k = 1:numel(ps)
    p = ps(k);
    cost = abs(s0grid).^p + abs(slope*s0grid + icept).^p;
    [~, imin] = min(cost);
    sp = [s0grid(imin); slope*s0grid(imin) + icept];
    if p == 2
        assert(norm(sp - s2) < 1e-4)
    else
        assert(norm(sp - s1) < 1e-4)
        sp = s1;                 % exact point on the axis
    end
    fp = @(a,b) abs(a).^p + abs(b).^p;
    zmax = zmaxs(k);             % flat top for p < 1 would hide the shape, so cut it higher
    ax = nexttile(tl);
    costsurf(ax, fp, [-1 1], [0 zmax], (0.1:0.1:0.9)*zmax, sprintf("$\\|\\mathbf{s}\\|_{%s}^{%s}$", pstr(p), pstr(p)), 321)
    constrline(ax, fp, slope, icept, [-1 1], [0 zmax], cdark)
    markpt(ax, sp, fp(sp(1),sp(2)), 0, cwarm)
    set(ax, "XTick", [-1 0 1], "YTick", [0 1], "ZTick", [0 zmax/2 zmax], "FontSize", 6)   % no s[1] = -1 label at the crowded front corner
    ax.XLabel.FontSize = 7; ax.YLabel.FontSize = 7; ax.ZLabel.FontSize = 7;
    title(ax, "$p=" + pstr(p) + "$", "Interpreter", "latex", "FontSize", 8)
end
exportgraphics(fig, fullfile(resfolder, "atip-10-lp.png"), "Resolution", 300)
close(fig)
%%
%[text] ## Redundancy of filter banks
%[text] $R=\\sum\_{p=0}^{P-1}M\_p^{-1}$ with $M\_p=|\\det(\\boldsymbol{M}\_p)|$ (\[M\] Sec. 6.3.1).
%[text] Undecimated DWT with $J$ levels: $R=(2^D-1)J+1$ (\[M\] Sec. 6.4.1).
Rcrit = sum(1./[2 2])            % 2-channel, M_p = 2
Rud2  = sum(1./[1 1])            % 2-channel, no decimation
J = 3;
Rudwt1 = (2^1-1)*J + 1           % 1-D, J = 3
Rudwt2 = (2^2-1)*J + 1           % 2-D, J = 3
assert(Rcrit == 1 && Rud2 == 2 && Rudwt1 == 4 && Rudwt2 == 10)
atip.savetex("atip-10-R-ud2",   sprintf("%d", Rud2));
atip.savetex("atip-10-R-udwt1", sprintf("%d", Rudwt1));
atip.savetex("atip-10-R-udwt2", sprintf("%d", Rudwt2));
%%
%[text] ## Undecimated Haar DWT ($J=3$)
%[text] Synthesis filters $F\_0(z)=(1+z^{-1})/2$, $F\_1(z)=(1-z^{-1})/2$ and analysis filters
%[text] $H\_0(z)=(1+z^{-1})/2$, $H\_1(z)=(-1+z^{-1})/2$ (sample10\_01).  The equivalent filters of the
%[text] parallel (non-tree) structure follow from the noble identities:
%[text] $F\_{3,0}(z)=F\_0(z^4)F\_0(z^2)F\_0(z)$, $F\_{3,1}(z)=F\_1(z^4)F\_0(z^2)F\_0(z)$, $F\_{2,1}(z)=F\_1(z^2)F\_0(z)$, $F\_{1,1}(z)=F\_1(z)$.
f0 = [1 1]/2;  f1 = [1 -1]/2;
h0 = [1 1]/2;  h1 = [-1 1]/2;
f30 = conv(conv(f0, upz(f0,2)), upz(f0,4));
f31 = conv(conv(f0, upz(f0,2)), upz(f1,4));
f21 = conv(f0, upz(f1,2));
f11 = f1;
h30 = conv(conv(h0, upz(h0,2)), upz(h0,4));
h31 = conv(conv(h0, upz(h0,2)), upz(h1,4));
h21 = conv(h0, upz(h1,2));
h11 = h1;
%[text] Perfect reconstruction with the delays of the channels: $\\sum\_p F\_p(z)H\_p(z)z^{-\\tau\_p}=z^{-7}$
T = conv(f30,h30) + conv(f31,h31) ...
    + [zeros(1,4) conv(f21,h21) zeros(1,4)] + [zeros(1,6) conv(f11,h11) zeros(1,6)];
assert(norm(T - [zeros(1,7) 1 zeros(1,7)]) < 1e-12)
%[text] Parseval tight frame: $\\sum\_p|F\_p(\\mathrm{e}^{\\mathrm{j}\\omega})|^2=1$
w = linspace(0, pi, 513);
Fr = @(f) abs(polyval(fliplr(f), exp(-1j*w)));   % F(e^{jw}) = sum f[n] e^{-jwn}
psum = Fr(f30).^2 + Fr(f31).^2 + Fr(f21).^2 + Fr(f11).^2;
assert(max(abs(psum - 1)) < 1e-12)
%[text] Impulse responses of the four synthesis filters
fs = {f30, f31, f21, f11};
names = ["$f_{3,0}[n]$", "$f_{3,1}[n]$", "$f_{2,1}[n]$", "$f_{1,1}[n]$"];
fig = figure(Units="centimeters", Position=[2 2 5.6 5.0], Color="w");
tl = tiledlayout(fig, 2, 2, "TileSpacing", "compact", "Padding", "compact");
for k = 1:4
    ax = nexttile(tl);
    stem(ax, 0:numel(fs{k})-1, fs{k}, "filled", "Color", cmain, "MarkerSize", 2.5, "LineWidth", 0.8)
    xlim(ax, [-0.5 7.5]), ylim(ax, [-0.6 0.6])
    xticks(ax, 0:2:7), yticks(ax, [-0.5 0 0.5])
    title(ax, names(k), "Interpreter", "latex", "FontSize", 8)
    set(ax, "FontSize", 7, "TickLabelInterpreter", "latex")
    grid(ax, "on")
end
xlabel(tl, "$n$", "Interpreter", "latex", "FontSize", 8)
exportgraphics(fig, fullfile(resfolder, "atip-10-udhaar-imp.png"), "Resolution", 300)
close(fig)
%%
%[text] ## Analysis problem
%[text] Flexible analysis FB $H\_0(z)=\\gamma+\\delta z^{-1}$, $H\_1(z)=-\\gamma+\\delta z^{-1}$ and fixed synthesis FB
%[text] $F\_0(z)=(1+z^{-1})/2$, $F\_1(z)=(1-z^{-1})/2$ (\[M\] Example "Haar DWT", delayed and scaled) without resampling:
%[text] $F\_0(z)H\_0(z)+F\_1(z)H\_1(z)=(\\gamma+\\delta)z^{-1}$ for any $\\gamma,\\delta$, hence PR if and only if $\\gamma+\\delta=1$.
for gamma = [-0.5 0 0.3 0.5 1.2]
    for delta = [1-gamma, -0.7, 0.4]
        Tz = conv(f0, [gamma delta]) + conv(f1, [-gamma delta]);
        assert(norm(Tz - [0 gamma+delta 0]) < 1e-12)
    end
end
%[text] The minimum-energy (adjoint) analysis FB $h\_p[n]=f\_p[-n]$ (delayed) corresponds to $\\gamma=\\delta=1/2$.
assert(isequal([0.5 0.5], fliplr(f0)) && isequal([-0.5 0.5], fliplr(f1)))
%%
%[text] ## Non-redundant dictionary (basis)
%[text] $\\begin{pmatrix}1\\\\3\\end{pmatrix}=\\begin{pmatrix}1 & -1\\\\ 1 & 1\\end{pmatrix}\\mathbf{s}$ has the unique solution $\\mathbf{s}=\\mathbf{D}^{-1}\\mathbf{x}$.
Dnr = [1 -1; 1 1];
xnr = [1; 3];
sNr = Dnr\xnr
assert(isequal(round(sNr), sNr) && rank(Dnr) == 2)
atip.savetex("atip-10-nr-s", atip.arr2tex(sNr, "%d"));
%%
%[text] ## Redundant dictionary (frame) and its kernel
%[text] $\\mathbf{D}=\\begin{pmatrix}1 & -1 & 0\\\\ 0 & 1 & -1\\end{pmatrix}$: $\\mathrm{Ker}(\\mathbf{D})=\\{t\\,(1,1,1)^\\top\\}$.
Drd = [1 -1 0; 0 1 -1];
kv = null(Drd);
kv = kv/kv(1)
assert(norm(Drd*kv) < 1e-12 && norm(kv - [1;1;1]) < 1e-12)
atip.savetex("atip-10-ker", atip.arr2tex(round(kv.'), "%d"));
%[text] For $\\mathbf{x}=(1,1)^\\top$, $\\mathbf{a}=\\mathbf{D}^+\\mathbf{x}$ is a solution, and so is $\\mathbf{a}+\\mathbf{k}$, $\\mathbf{k}\\in\\mathrm{Ker}(\\mathbf{D})$.
xrd = [1; 1];
ard = pinv(Drd)*xrd
ard(abs(ard) < 1e-12) = 0;
ard2 = ard + kv
assert(norm(Drd*ard - xrd) < 1e-12 && norm(Drd*ard2 - xrd) < 1e-12)
assert(norm(ard - round(ard)) < 1e-12)
atip.savetex("atip-10-rd-a",  atip.arr2tex(round(ard.'), "%d"));
atip.savetex("atip-10-rd-a2", atip.arr2tex(round(ard2.'), "%d"));
%%
%[text] ## Parseval tight frame
%[text] Matrix representation of the 2-channel undecimated Haar synthesis FB for $N=4$ (circular convolution):
%[text] $\\mathbf{D}=(\\mathbf{C}\_{f\_0}\\ \\mathbf{C}\_{f\_1})\\in\\mathbb{R}^{4\\times 8}$ satisfies $\\mathbf{D}\\mathbf{D}^\\top=\\mathbf{I}\_4$.
N = 4;
Cf0 = cconvmtx(f0, N);
Cf1 = cconvmtx(f1, N);
Dpt = [Cf0 Cf1]
lam = eig(Dpt*Dpt.')
assert(norm(Dpt*Dpt.' - eye(N)) < 1e-12)
assert(norm(pinv(Dpt) - Dpt.') < 1e-12)
atip.savetex("atip-10-ptf-D2", atip.arr2tex(2*Dpt, "%d"));
atip.savetex("atip-10-ptf-lam", sprintf("%g", mean(lam)));
%%
%[text] ## Matching pursuit in $\\mathbb{R}^2$
%[text] Three unit-norm atoms $\\mathbf{d}\_0=(1,0)^\\top$, $\\mathbf{d}\_1=(0.6,0.8)^\\top$, $\\mathbf{d}\_2=(-0.6,0.8)^\\top$ and
%[text] $\\mathbf{x}=(1.4,0.9)^\\top$.  MP and OMP with $K=2$ (\[M\] Figs. 7.4 and 7.5).
Dmp = [1 0.6 -0.6; 0 0.8 0.8];
xmp = [1.4; 0.9];
K = 2;
% MP
s = zeros(3,1); r = xmp; idx = []; t = 0; mphist = [];
while numel(idx) < K
    a = (Dmp.'*r)./sum(Dmp.^2).';
    e = norm(r)^2 - abs(a).^2.*sum(Dmp.^2).';
    [~, imin] = min(e);
    idx = union(idx, imin);
    s(imin) = s(imin) + a(imin);
    rprev = r;
    r = xmp - Dmp*s;
    t = t + 1;
    mphist(t,:) = [imin-1, a(imin), norm(r)]; %#ok<SAGROW>
    rs{t} = {rprev, a(imin)*Dmp(:,imin)}; %#ok<SAGROW>
end
mphist
smp = s;
% OMP
s = zeros(3,1); r = xmp; idx = [];
for t = 1:K
    a = (Dmp.'*r)./sum(Dmp.^2).';
    e = norm(r)^2 - abs(a).^2.*sum(Dmp.^2).';
    [~, imin] = min(e);
    idx = union(idx, imin);
    s(:) = 0;
    s(idx) = pinv(Dmp(:,idx))*xmp;
    r = xmp - Dmp*s;
end
somp = s
assert(isequal(mphist(:,1).', [1 2]) && norm(r) < 1e-12)
atip.savetex("atip-10-mp-i1", sprintf("%d", mphist(1,1)));
atip.savetex("atip-10-mp-i2", sprintf("%d", mphist(2,1)));
atip.savetex("atip-10-mp-a1", sprintf("%.2f", mphist(1,2)));
atip.savetex("atip-10-mp-a2", sprintf("%.2f", mphist(2,2)));
atip.savetex("atip-10-mp-r0", sprintf("%.2f", norm(xmp)));
atip.savetex("atip-10-mp-r1", sprintf("%.2f", mphist(1,3)));
atip.savetex("atip-10-mp-r2", sprintf("%.2f", mphist(2,3)));
atip.savetex("atip-10-omp-r2", zero2tex(sprintf("%.2f", norm(r))));
%[text] Figure: atoms (grey), $\\mathbf{x}$ (green), selected components (blue) and residuals (orange)
fig = figure(Units="centimeters", Position=[2 2 5.2 4.6], Color="w");
ax = axes(fig); hold(ax, "on")
lofs = [0.05 0.06 -0.12; 0.06 -0.14 0.06];   % label offsets of the atoms
for k = 1:3
    quiver(ax, 0, 0, Dmp(1,k), Dmp(2,k), 0, "Color", cgray, "LineWidth", 0.8, "MaxHeadSize", 0.4)
    text(ax, Dmp(1,k)+lofs(1,k), Dmp(2,k)+lofs(2,k), sprintf("$\\mathbf{d}_%d$", k-1), ...
        "Interpreter", "latex", "Color", cgray, "FontSize", 8)
end
quiver(ax, 0, 0, xmp(1), xmp(2), 0, "Color", cmain, "LineWidth", 1.2, "MaxHeadSize", 0.3)
text(ax, xmp(1)+0.04, xmp(2)+0.06, "$\mathbf{x}$", "Interpreter", "latex", "Color", cmain, "FontSize", 9)
p0 = [0; 0];
for t = 1:numel(rs)
    c = rs{t}{2};
    quiver(ax, p0(1), p0(2), c(1), c(2), 0, "Color", ccool, "LineWidth", 1.1, "MaxHeadSize", 0.4)
    p0 = p0 + c;
    plot(ax, [p0(1) xmp(1)], [p0(2) xmp(2)], "--", "Color", cwarm, "LineWidth", 0.9)
end
text(ax, 0.02, 1.02, "$a[1]\mathbf{d}_1$", "Interpreter", "latex", "Color", ccool, "FontSize", 8)
text(ax, 1.22, 1.17, "$\mathbf{r}^{(1)}$", "Interpreter", "latex", "Color", cwarm, "FontSize", 8)   % next to the dashed residual, clear of the arrows
hold(ax, "off")
axis(ax, "equal"), xlim(ax, [-0.8 1.7]), ylim(ax, [-0.1 1.3])
set(ax, "FontSize", 7, "TickLabelInterpreter", "latex", "Box", "off")
exportgraphics(fig, fullfile(resfolder, "atip-10-mp.png"), "Resolution", 300)
close(fig)
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

function C = cconvmtx(f, N)
% N x N circular convolution matrix with the impulse response f (causal)
c = zeros(N,1);
c(1:numel(f)) = f(:);
C = zeros(N);
for k = 0:N-1
    C(:,k+1) = circshift(c, k);
end
end

function str = zero2tex(str)
% "0.00" and "-0.00" entries as "0"
str = regexprep(str, "(?<![\d.])-?0\.00(?!\d)", "0");
end

function g = upz(f, M)
% Zero insertion (factor M) without trailing zeros: F(z) -> F(z^M)
g = zeros(1, (numel(f)-1)*M + 1);
g(1:M:end) = f;
end

function z = maskz(z, keep)
% Values outside the mask as NaN (not drawn)
z(~keep) = NaN;
end

function str = pstr(p)
% Exponent p as a short string
str = string(sprintf("%g", p));
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

function constrline(ax, fcost, slope, icept, srange, zlims, col)
% Constraint line s[1] = slope*s[0] + icept on the bottom plane and its curve on the surface
sa = sort([(srange(1) - icept)/slope, (srange(2) - icept)/slope]);
t = linspace(max(sa(1), srange(1)), min(sa(2), srange(2)), 401);
u = slope*t + icept;
z = fcost(t, u);
z(z > zlims(2)) = NaN;
plot3(ax, t, u, zlims(1)*ones(size(t)), "-", "Color", col, "LineWidth", 1.2)
plot3(ax, t, u, z + 0.01*diff(zlims), "-", "Color", [0.65*col + 0.35 0.7], "LineWidth", 0.9)   % lighter on the surface
end

function markpt(ax, s, z, zmin, col)
% Point on the surface with a vertical drop line to the bottom plane
plot3(ax, [s(1) s(1)], [s(2) s(2)], [zmin z], ":", "Color", col, "LineWidth", 1.0)
plot3(ax, s(1), s(2), z, "o", "MarkerFaceColor", col, "MarkerEdgeColor", "w", "MarkerSize", 4.5, "LineWidth", 0.4)
plot3(ax, s(1), s(2), zmin, "o", "MarkerFaceColor", col, "MarkerEdgeColor", "w", "MarkerSize", 4.5, "LineWidth", 0.4)
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
