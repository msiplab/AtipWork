%[text] # Lecture 6: Sampling
%[text] Shogo Muramatsu, "Advanced Topics in Image Processing"
%[text] Verified: MATLAB R2026b
%[text] This script makes all figures and numbers of the slides of lecture 6 (atip2027-06).
%[text] The notation follows the reference text \[M\] (MsipText): Sections 1.2.2 (dual space, adjoint),
%[text] 1.4.1 (direct sampling, generalized sampling theorem), 4.1.3 (relation between FT and DSFT),
%[text] 5.1.1 (downsampling) and 5.1.2 (upsampling).  A continuous distribution is $u(\\cdot)$ with the FT
%[text] $\\tilde{u}(\\cdot)$, the sampling matrix is $\\boldsymbol{L}$, the resampling matrix is $\\boldsymbol{M}$,
%[text] and the input and output arrays of a resampler are $\\mathsf{x}$ and $\\mathsf{y}$.
%[text:tableOfContents]{"heading":"Contents"}
%%
%[text] ## Preparation
%[text] Figures and LaTeX snippets are written to the `results` folder.  AtipSlides imports them with
%[text] `tools/sync-results.ps1`.  The figure colours are the three colours of the MSIP Lab logo and grey.
[~,resfolder] = atip.prjfolders();
cmain = [0 136 85]/255;     % main (green) #008855
ccool = [46 117 182]/255;   % cool (blue)  #2E75B6
cwarm = [197 90 17]/255;    % warm (orange) #C55A11
cgray = [0.45 0.45 0.45];   % grey
%%
%[text] ## Direct sampling with an array sensor
%[text] Example "Array sensor" of \[M\] Section 1.4.1: the light intensity $u(q\_\\mathrm{v},q\_\\mathrm{h})$ on the
%[text] sensor is sampled as $x\[n\_\\mathrm{v},n\_\\mathrm{h}\]=\\iint\\breve{\\varphi}(\\Delta\_\\mathrm{v}n\_\\mathrm{v}-q\_\\mathrm{v},\\Delta\_\\mathrm{h}n\_\\mathrm{h}-q\_\\mathrm{h})u(q\_\\mathrm{v},q\_\\mathrm{h})\\,\\mathrm{d}q\_\\mathrm{v}\\mathrm{d}q\_\\mathrm{h}$.
%[text] Here the PSF $\\breve{\\varphi}(\\cdot,\\cdot)$ is the pixel aperture (box), i.e. each sample is the average of
%[text] $u(\\cdot,\\cdot)$ over one pixel.  A smooth elliptic blob stands for $u(\\cdot,\\cdot)$ (cf. Fig. 1.5 of \[M\]).
Nq = 480; Ns = 16;                              % fine grid for u, number of pixels per side
[qh,qv] = meshgrid(((0:Nq-1)+0.5)/Nq);          % sensor positions in [0,1)^2
r2 = ((qv-0.52)/0.30).^2 + ((qh-0.50)/0.25).^2; % elliptic blob
u = 0.92 - 0.55*exp(-r2.^3) .* (1 - 0.35*(qv-0.25));
xs = imresize(u, [Ns Ns], "box");               % box PSF + sampling (pixel average)
sensorfig(u,  (0:Nq-1)/Nq*Ns, Ns, "$q_\mathrm{h}$", "$q_\mathrm{v}$", fullfile(resfolder,"atip-06-sensor-u.png"), cmain)
sensorfig(kron(xs,ones(Nq/Ns)), (0:Nq-1)/Nq*Ns, Ns, "$n_\mathrm{h}$", "$n_\mathrm{v}$", fullfile(resfolder,"atip-06-sensor-x.png"), cmain)
%%
%[text] ## Univariate sampling and periodization of the spectrum
%[text] The sampled distribution $x(t)=u(t)\\,\\mathrm{comb}\_{\\Delta\_\\mathrm{t}}(t)$ (Dirac comb) has the FT
%[text] $\\tilde{x}(\\nu)=\\frac{1}{\\Delta\_\\mathrm{t}}\\sum\_{k}\\tilde{u}(\\nu-k\\nu\_\\mathrm{s})$, $\\nu\_\\mathrm{s}=2\\pi/\\Delta\_\\mathrm{t}$
%[text] (\[M\] Section 4.1.3 with $D=1$, $\\boldsymbol{L}=\\Delta\_\\mathrm{t}$).  For a band $|\\nu|<\\nu\_\\mathrm{max}$, a large
%[text] $\\Delta\_\\mathrm{t}$ with $\\nu\_\\mathrm{s}<2\\nu\_\\mathrm{max}$ makes the copies overlap (aliasing).  The plot shows $\\Delta\_\\mathrm{t}\\tilde{x}(\\nu)$.
nuv = linspace(-5, 5, 2001);                    % angular frequency in units of nu_max
tri = @(v) max(1 - abs(v), 0);                  % triangular spectrum (band nu_max)
nusList = [3 1.4];                              % nu_s = 2*pi/Delta_t in units of nu_max
fig = figure(Units="centimeters", Position=[2 2 6.6 5.6], Color="w");
tl = tiledlayout(fig, 3, 1, "TileSpacing","compact", "Padding","compact");
ax = nexttile(tl); plot(ax, nuv, tri(nuv), "Color", ccool, "LineWidth", 1.5)
title(ax, "$\tilde{u}(\nu)$", "Interpreter","latex")
for nus = nusList
    ax = nexttile(tl); hold(ax, "on")
    S = zeros(size(nuv));
    for k = -5:5
        plot(ax, nuv, tri(nuv - k*nus), ":", "Color", cgray)
        S = S + tri(nuv - k*nus);
    end
    if nus >= 2
        cs = cmain; note = "no overlap";
    else
        cs = cwarm; note = "aliasing";
    end
    plot(ax, nuv, S, "Color", cs, "LineWidth", 1.5)
    text(ax, -4.9, 1.62, note, "Color", cs, "FontSize", 8)
    hold(ax, "off")
    title(ax, "$\Delta_\mathrm{t}\tilde{x}(\nu),\ \nu_\mathrm{s}=" + nus + "\nu_\mathrm{max}$", "Interpreter","latex")
end
xlabel(ax, "$\nu/\nu_\mathrm{max}$", "Interpreter","latex")
for ax = findobj(fig, "Type","axes").'
    set(ax, "YLim", [0 2.0], "YTick", [0 1], "XTick", -4:2:4, "TickLabelInterpreter","latex", "FontSize", 8)
    grid(ax, "on")
end
axs = flipud(findobj(fig, "Type","axes"));
set(axs(1:2), "XTickLabel", [])
exportgraphics(fig, fullfile(resfolder,"atip-06-period1d.png"), "Resolution", 300)
close(fig)
%%
%[text] ## Sampling lattice
%[text] A sampling matrix $\\boldsymbol{L}=(\\boldsymbol{l}\_1\\ \\boldsymbol{l}\_2)$ generates the lattice
%[text] $\\mathcal{L}(\\boldsymbol{L})=\\{\\boldsymbol{L}\\boldsymbol{n}\\mid\\boldsymbol{n}\\in\\mathbb{Z}^2\\}$.  A non-rectangular example
%[text] (first coordinate $q\_1$ downward, second $q\_2$ rightward).  The shaded parallelogram is $\\mathrm{FPD}(\\boldsymbol{L})$
%[text] with the area $|\\det(\\boldsymbol{L})|$.
Lh = [2 1; 0 1]                                 % columns l1 = (2,0)^T, l2 = (1,1)^T
detLh = abs(det(Lh))
atip.savetex("atip-06-latL", atip.arr2tex(Lh, "%d"));
atip.savetex("atip-06-latdet", sprintf("%d", detLh));
[n2,n1] = meshgrid(-6:6, -6:6);
P = Lh*[n1(:) n2(:)].';
inwin = P(1,:) >= -0.2 & P(1,:) <= 5.2 & P(2,:) >= -0.2 & P(2,:) <= 5.2;
fig = figure(Units="centimeters", Position=[2 2 4.4 4.4], Color="w");
ax = axes(fig); hold(ax, "on")
fpd = Lh*[0 1 1 0; 0 0 1 1];
fill(ax, fpd(2,:), fpd(1,:), cmain, "FaceAlpha", 0.15, "EdgeColor", "none")
plot(ax, P(2,inwin), P(1,inwin), "o", "MarkerSize", 4, "MarkerFaceColor", cmain, "MarkerEdgeColor", cmain)
quiver(ax, 0, 0, Lh(2,1), Lh(1,1), 0, "Color", ccool, "LineWidth", 1.5, "MaxHeadSize", 0.4)
quiver(ax, 0, 0, Lh(2,2), Lh(1,2), 0, "Color", cwarm, "LineWidth", 1.5, "MaxHeadSize", 0.6)
text(ax, -0.15, 1.1, "{\bf\itl}_1", "Interpreter","tex", "Color", ccool, "HorizontalAlignment","right", "FontSize", 9)
text(ax, 1.15, 0.75, "{\bf\itl}_2", "Interpreter","tex", "Color", cwarm, "FontSize", 9)
hold(ax, "off")
set(ax, "YDir","reverse", "XAxisLocation","top", "TickLabelInterpreter","latex", "FontSize", 8, ...
    "XTick", 0:5, "YTick", 0:5)
axis(ax, "equal"), xlim(ax, [-0.6 5.4]), ylim(ax, [-0.4 5.4]), grid(ax, "on")
xlabel(ax, "$q_2$", "Interpreter","latex"), ylabel(ax, "$q_1$", "Interpreter","latex")
exportgraphics(fig, fullfile(resfolder,"atip-06-lattice.png"), "Resolution", 300)
close(fig)
%%
%[text] ## Multivariate periodization of the spectrum
%[text] $\\tilde{x}(\\boldsymbol{\\nu})=\\frac{1}{|\\det(\\boldsymbol{L})|}\\sum\_{\\boldsymbol{m}\\in\\mathbb{Z}^D}\\tilde{u}(\\boldsymbol{\\nu}-\\boldsymbol{Q}\\boldsymbol{m})$
%[text] with the periodic structure matrix $\\boldsymbol{Q}=2\\pi\\boldsymbol{L}^{-\\top}$ (\[M\] Section 4.1.3).  Rectangular lattice
%[text] $\\boldsymbol{L}=\\mathrm{diag}(\\Delta\_1,\\Delta\_2)$ with $\\Delta\_1=2$, $\\Delta\_2=1$ and a diamond-shaped support of $\\tilde{u}(\\boldsymbol{\\nu})$.
D1 = 2; D2 = 1;
Lr = diag([D1 D2])
Q = 2*pi*(Lr.'\eye(2))                          % periodic structure matrix of the spectrum
assert(norm(Q - diag([pi 2*pi])) < 1e-12)
atip.savetex("atip-06-perL", atip.arr2tex(Lr, "%d"));
atip.savetex("atip-06-perQ", strjoin(join(arrayfun(@pistr, Q), " & ", 2), "\\" + newline));
atip.savetex("atip-06-perdet", sprintf("%d", abs(det(Lr))));
a1 = 0.45*pi; a2 = 0.9*pi;                      % radii of the diamond (nu_1, nu_2)
sup = polyshape([0 a2 0 -a2], [-a1 0 a1 0]);    % x-axis nu_2, y-axis nu_1
lim = 2.5*pi;
fig = figure(Units="centimeters", Position=[2 2 8.4 4.6], Color="w");
tl = tiledlayout(fig, 1, 2, "TileSpacing","compact", "Padding","compact");
for k = 1:2
    ax = nexttile(tl); hold(ax, "on")
    if k == 2
        for m1 = -4:4
            for m2 = -2:2
                if m1 == 0 && m2 == 0, continue, end
                s = Q*[m1; m2];
                plot(ax, translate(sup, s(2), s(1)), "FaceColor", cmain, "FaceAlpha", 0.3, "EdgeColor", cmain)
            end
        end
        xline(ax, (-3:2:3)*Q(2,2)/2, "--", "Color", cgray)
        yline(ax, (-5:2:5)*Q(1,1)/2, "--", "Color", cgray)
    end
    plot(ax, sup, "FaceColor", ccool, "FaceAlpha", 0.7, "EdgeColor", ccool)
    xline(ax, 0, "k"), yline(ax, 0, "k")
    hold(ax, "off")
    tk = (-2:2:2)*pi;
    set(ax, "YDir","reverse", "TickLabelInterpreter","latex", "XTick", tk, "YTick", tk, "FontSize", 8, ...
        "XTickLabel", arrayfun(@(v) "$"+pistr(v)+"$", tk), "YTickLabel", arrayfun(@(v) "$"+pistr(v)+"$", tk))
    axis(ax, "equal"), box(ax, "on"), xlim(ax, [-lim lim]), ylim(ax, [-lim lim])
    xlabel(ax, "$\nu_2$", "Interpreter","latex"), ylabel(ax, "$\nu_1$", "Interpreter","latex")
    if k == 1
        title(ax, "$\tilde{u}(\nu_1,\nu_2)$", "Interpreter","latex")
    else
        title(ax, "$\Delta_1\Delta_2\,\tilde{x}(\nu_1,\nu_2)$", "Interpreter","latex")
    end
end
exportgraphics(fig, fullfile(resfolder,"atip-06-period2d.png"), "Resolution", 300)
close(fig)
%[text] The copies do not overlap (no aliasing).
ovl = 0;
for m1 = -1:1
    for m2 = -1:1
        if m1 == 0 && m2 == 0, continue, end
        s = Q*[m1; m2];
        ovl = ovl + area(intersect(sup, translate(sup, s(2), s(1))));
    end
end
assert(ovl < 1e-12)
%%
%[text] ## Shannon's sampling theorem
%[text] Example "Shannon's sampling theorem" of \[M\] Section 1.4.1: the interpolation kernel
%[text] $\\varphi(t)=\\mathrm{sinc}(\\Delta\_\\mathrm{t}^{-1}t)$ for several sampling intervals $\\Delta\_\\mathrm{t}$.  The zeros are at $t=k\\Delta\_\\mathrm{t}$, $k\\neq0$.
tv = linspace(-6, 6, 1201);
dts = [0.5 1 2]; cols = [cwarm; cmain; ccool];
fig = figure(Units="centimeters", Position=[2 2 6.0 4.0], Color="w");
ax = axes(fig); hold(ax, "on")
for k = 1:numel(dts)
    plot(ax, tv, msinc(tv/dts(k)), "Color", cols(k,:), "LineWidth", 1.2, ...
        "DisplayName", "$\Delta_\mathrm{t}=" + dts(k) + "$")
end
hold(ax, "off"), grid(ax, "on")
lg = legend(ax, "Interpreter","latex", "Location","northoutside", "Orientation","horizontal", ...
    "FontSize", 7, "Box","off");
lg.ItemTokenSize = [10 8];                       % short line samples: the legend fits the figure width
set(ax, "TickLabelInterpreter","latex", "FontSize", 8, "XTick", -6:3:6, "YLim", [-0.3 1.1])
xlabel(ax, "$t$", "Interpreter","latex"), ylabel(ax, "$\varphi(t)$", "Interpreter","latex")
drawnow                                          % close the gap MATLAB leaves below a northoutside legend
lp = lg.Position; ap = ax.Position;
lg.Location = "none";
ax.Position = [ap(1) ap(2) ap(3) lp(2)-ap(2)-0.02];
lg.Position = lp;
exportgraphics(fig, fullfile(resfolder,"atip-06-sinc.png"), "Resolution", 300)
close(fig)
%[text] Orthogonality of the shifted sinc functions, $\\int\\mathrm{sinc}(t-n)\\mathrm{sinc}(t-m)\\,\\mathrm{d}t=\\delta\[n-m\]$,
%[text] checked numerically (trapezoidal rule on a long finite interval).
tt = -2000:0.01:2000;
I00 = trapz(tt, msinc(tt).^2)
I01 = trapz(tt, msinc(tt).*msinc(tt-1))
assert(abs(I00-1) < 1e-2 && abs(I01) < 1e-2)
atip.savetex("atip-06-orth00", sprintf("%.3f", I00));
atip.savetex("atip-06-orth01", sprintf("%.3f", abs(I01)));
%%
%[text] ## Univariate downsampling
%[text] Definition "Downsampling" of \[M\] Section 5.1.1 with $D=1$: $y\[n\]=x\[Mn\]$.  Example with $M=2$.
xd = [2 2 2 3 4 4];
yd = xd(1:2:end)
assert(isequal(yd, [2 2 4]))
atip.savetex("atip-06-ds-x", strjoin(string(xd), ",\,"));
atip.savetex("atip-06-ds-y", strjoin(string(yd), ",\,"));
stemfig(xd, yd, 1:2:numel(xd), "$x[m]$", "$y[n]$", "$m$", "$n$", fullfile(resfolder,"atip-06-ds1d.png"), cmain, cwarm)
%%
%[text] ## Aliasing
%[text] $Y(\\mathrm{e}^{\\mathrm{j}\\omega})=\\frac{1}{M}\\sum\_{k=0}^{M-1}X(\\mathrm{e}^{\\mathrm{j}(\\omega-2\\pi k)/M})$ (\[M\] Section 5.1.1 with $D=1$).
%[text] For $M=2$ and a band $0.7\\pi$, the stretched component and its copy shifted by $2\\pi$ overlap.
w = linspace(-pi, 3*pi, 2001);
Xw = @(om) max(1 - abs(mod(om+pi, 2*pi) - pi)/(0.7*pi), 0);   % 2*pi periodic, band 0.7*pi
fig = figure(Units="centimeters", Position=[2 2 6.4 4.2], Color="w");
tl = tiledlayout(fig, 2, 1, "TileSpacing","compact", "Padding","compact");
ax = nexttile(tl); plot(ax, w, Xw(w), "Color", ccool, "LineWidth", 1.5)
title(ax, "$X(\mathrm{e}^{\mathrm{j}\omega})$", "Interpreter","latex")
ax = nexttile(tl); hold(ax, "on")
plot(ax, w, 0.5*Xw(w/2), "--", "Color", cmain, "LineWidth", 1.2)
plot(ax, w, 0.5*Xw((w-2*pi)/2), "--", "Color", cgray, "LineWidth", 1.2)
plot(ax, w, 0.5*(Xw(w/2) + Xw((w-2*pi)/2)), "Color", cwarm, "LineWidth", 1.5)
hold(ax, "off")
title(ax, "$Y(\mathrm{e}^{\mathrm{j}\omega})$, $M=2$", "Interpreter","latex")
xlabel(ax, "$\omega$", "Interpreter","latex")
axs = flipud(findobj(fig, "Type","axes"));
for k = 1:2
    set(axs(k), "XTick", -pi:pi:3*pi, "XTickLabel", ["$-\pi$","$0$","$\pi$","$2\pi$","$3\pi$"], ...
        "TickLabelInterpreter","latex", "FontSize", 8), grid(axs(k), "on")
end
set(axs(1), "YLim", [0 1.2], "YTick", [0 1], "XTickLabel", [])
set(axs(2), "YLim", [0 0.8], "YTick", [0 0.5])
exportgraphics(fig, fullfile(resfolder,"atip-06-alias.png"), "Resolution", 300)
close(fig)
%%
%[text] ## Multivariate downsampling of an image
%[text] $y\[\\boldsymbol{n}\]=x\[\\boldsymbol{M}\\boldsymbol{n}\]$ with $\\boldsymbol{M}=\\mathrm{diag}(2,2)$ (cameraman.tif, $128\\times128$).
C = im2double(imresize(imread("cameraman.tif"), [128 128], "bicubic"));
Cd = C(1:2:end, 1:2:end);
imwrite(C,  fullfile(resfolder,"atip-06-cam.png"))
imwrite(Cd, fullfile(resfolder,"atip-06-cam-ds.png"))
%[text] Example "Downsampling" of \[M\] Section 5.1.1: $M=|\\det(\\boldsymbol{M})|=4$ and the aliasing components are at
%[text] $\\boldsymbol{k}\\in\\mathcal{N}(\\boldsymbol{M}^\\top)\\setminus\\{\\mathbf{0}\\}$, i.e. shifts $-2\\pi\\boldsymbol{M}^{-\\top}\\boldsymbol{k}$.
Md = [2 0; 0 2];
atip.savetex("atip-06-mds-M", atip.arr2tex(Md, "%d"));
atip.savetex("atip-06-mds-det", sprintf("%d", abs(det(Md))));
%%
%[text] ## Matrix expression of downsampling
%[text] Bivariate example: $\\boldsymbol{M}=\\mathrm{diag}(1,2)$ (horizontal downsampling), $\\mathsf{x}\\in\\mathbb{R}^{2\\times4}$.
%[text] The matrix $\\mathbf{T}\_{\\downarrow\\boldsymbol{M}}$ consists of the responses to the standard basis (Theorem "Linear map and
%[text] matrix representation", \[M\] Section 1.2.2), with the column-wise vectorization $\\mathrm{vec}(\\cdot)$.
X = [0 2 4 6; 1 3 5 7];
Mh = [1 0; 0 2];
ds = @(A) A(1:Mh(1,1):end, 1:Mh(2,2):end);      % diagonal resampling matrix
Y = ds(X)
assert(isequal(Y, [0 4; 1 5]))
Tds = zeros(numel(Y), numel(X));
for idx = 1:numel(X)
    e = zeros(size(X)); e(idx) = 1;             % standard basis
    t = ds(e);
    Tds(:,idx) = t(:);
end
Tds
assert(isequal(Tds*X(:), Y(:)))
atip.savetex("atip-06-mx-x", atip.arr2tex(X, "%d"));
atip.savetex("atip-06-mx-y", atip.arr2tex(Y, "%d"));
atip.savetex("atip-06-mx-xv", atip.arr2tex(X(:), "%d"));
atip.savetex("atip-06-mx-yv", atip.arr2tex(Y(:), "%d"));
atip.savetex("atip-06-mx-T", atip.arr2tex(Tds, "%d"));
atip.savetex("atip-06-mx-size", sprintf("%d\\times %d", size(Tds)));
%%
%[text] ## Adjoint operator
%[text] For a matrix $\\mathbf{A}$, $\\langle\\mathbf{y},\\mathbf{A}\\mathbf{x}\\rangle=\\langle\\mathbf{A}^\\mathsf{H}\\mathbf{y},\\mathbf{x}\\rangle$ with
%[text] $\\langle\\mathbf{a},\\mathbf{b}\\rangle=\\mathbf{a}^\\mathsf{H}\\mathbf{b}$ (Example "Pull-back and adjoint map", \[M\] Section 1.2.2).
A = [1 2; 3 4; 5 6];
xa = [1; -1]; ya = [1; 0; 2];
ip1 = ya'*(A*xa)
ip2 = (A'*ya)'*xa
assert(ip1 == ip2)
atip.savetex("atip-06-adj-A", atip.arr2tex(A, "%d"));
atip.savetex("atip-06-adj-x", atip.arr2tex(xa, "%d"));
atip.savetex("atip-06-adj-y", atip.arr2tex(ya, "%d"));
atip.savetex("atip-06-adj-Ax", atip.arr2tex(A*xa, "%d"));
atip.savetex("atip-06-adj-AHy", atip.arr2tex(A'*ya, "%d"));
atip.savetex("atip-06-adj-ip", sprintf("%d", ip1));
%%
%[text] ## Adjoint of downsampling
%[text] $M=2$, $\\mathsf{x}\\in\\mathbb{R}^4$.  $\\mathbf{T}\_{\\downarrow2}^\\mathsf{H}$ puts the samples back on the even positions and
%[text] inserts zeros: the adjoint of downsampling is zero insertion.
T2 = zeros(2,4);
for idx = 1:4
    e = zeros(4,1); e(idx) = 1;
    T2(:,idx) = e(1:2:end);
end
x4 = (1:4).';
v2 = T2*x4
r4 = T2'*v2
assert(isequal(v2, [1;3]) && isequal(r4, [1;0;3;0]))
ytest = [2; -1];
ipa = ytest'*(T2*x4)
ipb = (T2'*ytest)'*x4
assert(ipa == ipb)
atip.savetex("atip-06-adt-T", atip.arr2tex(T2, "%d"));
atip.savetex("atip-06-adt-TH", atip.arr2tex(T2', "%d"));
atip.savetex("atip-06-adt-x", atip.arr2tex(x4, "%d"));
atip.savetex("atip-06-adt-v", atip.arr2tex(v2, "%d"));
atip.savetex("atip-06-adt-r", atip.arr2tex(r4, "%d"));
%%
%[text] ## Univariate upsampling
%[text] Definition "Upsampling" (zero insertion) of \[M\] Section 5.1.2 with $D=1$: $y\[n\]=x\[n/M\]$ for $n\\in M\\mathbb{Z}$, 0 otherwise.
xu = [2 2 4];
yu = zeros(1, 2*numel(xu)); yu(1:2:end) = xu
assert(isequal(yu, [2 0 2 0 4 0]))
atip.savetex("atip-06-us-x", strjoin(string(xu), ",\,"));
atip.savetex("atip-06-us-y", strjoin(string(yu), ",\,"));
stemfig(xu, yu, [], "$x[m]$", "$y[n]$", "$m$", "$n$", fullfile(resfolder,"atip-06-us1d.png"), cmain, cwarm)
%%
%[text] ## Imaging
%[text] $Y(\\mathrm{e}^{\\mathrm{j}\\omega})=X(\\mathrm{e}^{\\mathrm{j}M\\omega})$ (\[M\] Section 5.1.2 with $D=1$).  For $M=2$ an image of the
%[text] spectrum appears around $\\omega=\\pi$.
Xw2 = @(om) max(1 - abs(mod(om+pi, 2*pi) - pi)/(0.8*pi), 0);
fig = figure(Units="centimeters", Position=[2 2 6.4 4.2], Color="w");
tl = tiledlayout(fig, 2, 1, "TileSpacing","compact", "Padding","compact");
ax = nexttile(tl); plot(ax, w, Xw2(w), "Color", ccool, "LineWidth", 1.5)
title(ax, "$X(\mathrm{e}^{\mathrm{j}\omega})$", "Interpreter","latex")
ax = nexttile(tl); hold(ax, "on")
wb = abs(mod(w+pi, 2*pi) - pi) < pi/2;          % baseband part of the output
yi = Xw2(2*w);
plot(ax, w, yi, "Color", cwarm, "LineWidth", 1.5)
yb = yi; yb(~wb) = NaN;
plot(ax, w, yb, "Color", cmain, "LineWidth", 1.5)
hold(ax, "off")
title(ax, "$Y(\mathrm{e}^{\mathrm{j}\omega})=X(\mathrm{e}^{\mathrm{j}2\omega})$", "Interpreter","latex")
xlabel(ax, "$\omega$", "Interpreter","latex")
axs = flipud(findobj(fig, "Type","axes"));
for k = 1:2
    set(axs(k), "YLim", [0 1.2], "YTick", [0 1], "XTick", -pi:pi:3*pi, ...
        "XTickLabel", ["$-\pi$","$0$","$\pi$","$2\pi$","$3\pi$"], "TickLabelInterpreter","latex", "FontSize", 8)
    grid(axs(k), "on")
end
set(axs(1), "XTickLabel", [])
exportgraphics(fig, fullfile(resfolder,"atip-06-imaging.png"), "Resolution", 300)
close(fig)
%%
%[text] ## Multivariate upsampling of an image
%[text] Zero insertion with $\\boldsymbol{M}=\\mathrm{diag}(2,2)$: the $64\\times64$ image $\\mathsf{x}$ is placed on the lattice
%[text] $\\mathcal{L}(\\boldsymbol{M})$ of a $128\\times128$ array.
Cu = zeros(2*size(Cd)); Cu(1:2:end, 1:2:end) = Cd;
imwrite(Cu, fullfile(resfolder,"atip-06-cam-us.png"))
%%
%[text] ## Matrix expression of upsampling
%[text] Bivariate example: $\\boldsymbol{M}=\\mathrm{diag}(1,2)$ (horizontal upsampling).  $\\mathbf{T}\_{\\uparrow\\boldsymbol{M}}=\\mathbf{T}\_{\\downarrow\\boldsymbol{M}}^\\top$.
Xs = [0 4; 1 5];
us = @(A) upsamplediag(A, Mh);
Yu = us(Xs)
assert(isequal(Yu, [0 0 4 0; 1 0 5 0]))
Tus = zeros(numel(Yu), numel(Xs));
for idx = 1:numel(Xs)
    e = zeros(size(Xs)); e(idx) = 1;
    t = us(e);
    Tus(:,idx) = t(:);
end
Tus
assert(isequal(Tus, Tds.'))
assert(isequal(Tus*Xs(:), Yu(:)))
atip.savetex("atip-06-umx-x", atip.arr2tex(Xs, "%d"));
atip.savetex("atip-06-umx-y", atip.arr2tex(Yu, "%d"));
atip.savetex("atip-06-umx-xv", atip.arr2tex(Xs(:), "%d"));
atip.savetex("atip-06-umx-yv", atip.arr2tex(Yu(:), "%d"));
atip.savetex("atip-06-umx-T", atip.arr2tex(Tus, "%d"));
atip.savetex("atip-06-umx-size", sprintf("%d\\times %d", size(Tus)));
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

function y = msinc(t)
% MSINC sinc function of [M] (sin(pi t)/(pi t), 1 at t = 0), without the Signal Processing Toolbox
y = ones(size(t));
nz = t ~= 0;
y(nz) = sin(pi*t(nz))./(pi*t(nz));
end

function Y = upsamplediag(X, M)
% UPSAMPLEDIAG Zero insertion with a diagonal resampling matrix M
Y = zeros(size(X).*diag(M).');
Y(1:M(1,1):end, 1:M(2,2):end) = X;
end

function s = pistr(v)
% PISTR Integer multiple of pi as a LaTeX string (2*pi -> "2\pi", pi -> "\pi", 0 -> "0")
c = round(v/pi, 6);
if c == 0
    s = "0";
elseif c == 1
    s = "\pi";
elseif c == -1
    s = "-\pi";
else
    s = sprintf("%g", c) + "\pi";
end
end

function sensorfig(img, ax1, Ns, xlab, ylab, fname, cmain)
% SENSORFIG Image on the sensor plane with the pixel grid (vertical axis downward)
fig = figure(Units="centimeters", Position=[2 2 3.6 3.6], Color="w");
ax = axes(fig);
imagesc(ax, ax1, ax1, img), colormap(ax, gray(256)), clim(ax, [0 1])
axis(ax, "image"), hold(ax, "on")
for k = 0:Ns
    plot(ax, [0 Ns], [k k], "-", "Color", [0.25 0.25 0.25], "LineWidth", 0.3)
    plot(ax, [k k], [0 Ns], "-", "Color", [0.25 0.25 0.25], "LineWidth", 0.3)
end
hold(ax, "off")
set(ax, "XAxisLocation","top", "XTick", [], "YTick", [], "XColor", cmain, "YColor", cmain, "FontSize", 9)
xlabel(ax, xlab, "Interpreter","latex"), ylabel(ax, ylab, "Interpreter","latex")
xlim(ax, [0 Ns]), ylim(ax, [0 Ns])
exportgraphics(fig, fname, "Resolution", 300)
close(fig)
end

function stemfig(xin, yout, keep, ylabx, ylaby, xlabx, xlaby, fname, cmain, cwarm)
% STEMFIG Input and output sequences of a resampler side by side, values above the stems.
%   KEEP: indices of the input samples that remain (others are marked as discarded)
fig = figure(Units="centimeters", Position=[2 2 8.4 2.6], Color="w");
tl = tiledlayout(fig, 1, 2, "TileSpacing","loose", "Padding","compact");
seqs = {xin, yout}; ylabs = {ylabx, ylaby}; xlabs = {xlabx, xlaby};
ymax = max([xin yout]) + 2.0;
for k = 1:2
    ax = nexttile(tl); hold(ax, "on")
    s = seqs{k}; idx = 0:numel(s)-1;
    if k == 1 && ~isempty(keep)
        drop = setdiff(1:numel(s), keep);
        stem(ax, idx(keep), s(keep), "filled", "Color", cmain, "MarkerSize", 3.5, "LineWidth", 1)
        stem(ax, idx(drop), s(drop), "Color", [0.6 0.6 0.6], "MarkerSize", 3.5, "LineWidth", 1)
    else
        stem(ax, idx, s, "filled", "Color", cmain, "MarkerSize", 3.5, "LineWidth", 1)
        if k == 2 && any(s == 0)
            z = idx(s == 0);
            plot(ax, z, zeros(size(z)), "o", "MarkerFaceColor", cwarm, "MarkerEdgeColor", cwarm, "MarkerSize", 3.5)
        end
    end
    for i = 1:numel(s)
        text(ax, idx(i), s(i) + 0.6, string(s(i)), "HorizontalAlignment","center", ...   % clear of the marker
            "VerticalAlignment","bottom", "FontSize", 7)
    end
    hold(ax, "off")
    set(ax, "XTick", idx, "YTick", [], "YLim", [-0.3 ymax], "XLim", [-0.6 numel(s)-0.4], ...
        "TickLabelInterpreter","latex", "FontSize", 8, "Box","off", "YColor","none")
    xlabel(ax, xlabs{k}, "Interpreter","latex")
    title(ax, ylabs{k}, "Interpreter","latex", "FontWeight","normal")
end
exportgraphics(fig, fname, "Resolution", 300)
close(fig)
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
