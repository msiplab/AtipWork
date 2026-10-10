%[text] # Lecture 4: Linear Shift-Invariant Systems
%[text] Shogo Muramatsu, "Advanced Topics in Image Processing"
%[text] Verified: MATLAB R2026b
%[text] This script makes all figures and numbers of the slides of lecture 4 (atip2027-04).
%[text] The notation follows the reference text \[M\] (MsipText), Sections 1.1.1, 1.2.1, 1.2.2, 4.1.2 and 4.3:
%[text] input $\\mathsf{x}$, output $\\mathsf{y}$, impulse response $\\mathsf{h}$ and system $\\mathsf{T}(\\cdot)$.
%[text:tableOfContents]{"heading":"Contents"}
%%
%[text] ## Preparation
%[text] Figures and LaTeX snippets are written to the `results` folder.  AtipSlides imports them with
%[text] `tools/sync-results.ps1`.  The figure colours are the three colours of the MSIP Lab logo and grey.
[~,resfolder] = atip.prjfolders();
cmain = [0 136 85]/255;     % main (green) #008855
ccool = [46 117 182]/255;   % cool (blue)  #2E75B6
cwarm = [197 90 17]/255;    % warm (orange) #C55A11
cgrey = [0.5 0.5 0.5];
%%
%[text] ## Multidimensional system
%[text] A system $\\mathsf{T}(\\cdot)$ maps an array to an array.  As an example, the horizontal difference
%[text] $h\[n\_1,n\_2\]$ with $(h\[0,0\],h\[0,1\],h\[0,2\])=(1,0,-1)$ is applied to `cameraman.tif`
%[text] (the output is shown with an offset of 0.5).
X = im2double(imread("cameraman.tif"));
hdiff = [1 0 -1];
Y = imfilter(X, hdiff, "conv", "replicate");
imwrite(imresize(X, [128 128]), fullfile(resfolder, "atip-04-sys-in.png"))
imwrite(imresize(Y+0.5, [128 128]), fullfile(resfolder, "atip-04-sys-out.png"))
%%
%[text] ## Standard-basis expansion
%[text] Example of \[M\] Section 1.1.1: $\\mathsf{x}=\\sum\_{\\boldsymbol{m}}x\[\\boldsymbol{m}\]\\left(\\delta\[\\boldsymbol{n}-\\boldsymbol{m}\]\\right)\_{\\boldsymbol{n}}$.
x = [3 2 7; 4 8 5];
[N1,N2] = size(x);
y = zeros(N1,N2);
for m2 = 0:N2-1
    for m1 = 0:N1-1
        e = zeros(N1,N2); e(m1+1,m2+1) = 1;     % (delta[n-m])_n
        y = y + x(m1+1,m2+1)*e;
    end
end
assert(isequal(x,y))
atip.savetex("atip-04-basis-x", atip.arr2tex(x, "%d"));
%[text] Shifted unit impulse $\\delta\[\\boldsymbol{n}-\\boldsymbol{m}\]$ with $\\boldsymbol{m}=(1,2)^\\top$.
[n2g,n1g] = meshgrid(0:4, 0:3);
d = double(n1g==1 & n2g==2);
fig = figure(Units="centimeters", Position=[2 2 4.6 3.6], Color="w");
ax = axes(fig);
stem3(ax, n2g(d==0), n1g(d==0), d(d==0), "filled", "Color", cgrey, "MarkerSize", 2)
hold(ax, "on")
stem3(ax, 2, 1, 1, "filled", "Color", cmain, "MarkerSize", 4, "LineWidth", 1.2)
hold(ax, "off")
set(ax, "YDir", "reverse", "FontSize", 8, "XTick", 0:4, "YTick", 0:3, "ZTick", [0 1])
xlabel(ax, "$n_2$", "Interpreter", "latex"), ylabel(ax, "$n_1$", "Interpreter", "latex")
zlim(ax, [0 1.2]), view(ax, -35, 30), grid(ax, "on")
exportgraphics(fig, fullfile(resfolder, "atip-04-delta.png"), "Resolution", 300)
close(fig)
%%
%[text] ## Univariate convolution
%[text] $y\[n\]=\\sum\_{m}x\[m\]h\[n-m\]$ with $x\[n\]=1,2,3$ and $h\[n\]=1/3$ for $n=0,1,2$.
x1 = [1 2 3];
h1 = [1 1 1]/3;
y1 = conv(x1, h1);
assert(max(abs(y1 - [1 3 6 5 3]/3)) < 1e-12)
[num,den] = rat(y1);
s = strings(1,numel(y1));
for k = 1:numel(y1)
    if den(k) == 1
        s(k) = sprintf("%d", num(k));
    else
        s(k) = sprintf("\\tfrac{%d}{%d}", num(k), den(k));
    end
end
atip.savetex("atip-04-conv1d-y", strjoin(s, " & "));
%[text] Figure: input, impulse response and the output as a sum of weighted, shifted impulse responses
%[text] $x\[m\]h\[n-m\]$ (stacked).
cols = [cmain; ccool; cwarm];
fig = figure(Units="centimeters", Position=[2 2 11.5 3.3], Color="w");
tl = tiledlayout(fig, 1, 3, "TileSpacing", "compact", "Padding", "compact");
ax = nexttile(tl);
for m = 0:2
    stem(ax, m, x1(m+1), "filled", "Color", cols(m+1,:), "MarkerSize", 3, "LineWidth", 1)
    hold(ax, "on")
end
hold(ax, "off")
xlim(ax, [-0.5 4.5]), ylim(ax, [0 3.4]), xticks(ax, 0:4)
xlabel(ax, "$n$", "Interpreter", "latex"), title(ax, "$x[n]$", "Interpreter", "latex")
ax = nexttile(tl);
stem(ax, 0:2, h1, "filled", "Color", cgrey, "MarkerSize", 3, "LineWidth", 1)
xlim(ax, [-0.5 4.5]), ylim(ax, [0 1.1]), xticks(ax, 0:4)
yticks(ax, [0 1/3 1]), yticklabels(ax, ["0" "1/3" "1"])
xlabel(ax, "$n$", "Interpreter", "latex"), title(ax, "$h[n]$", "Interpreter", "latex")
ax = nexttile(tl);
hold(ax, "on")
base = zeros(1,5);
lh = gobjects(1,3);
for m = 0:2
    c = zeros(1,5); c(m+1:m+3) = x1(m+1)*h1;      % x[m]h[n-m]
    for n = 0:4
        if c(n+1) > 0
            lh(m+1) = plot(ax, [n n], base(n+1)+[0 c(n+1)], "-", "Color", cols(m+1,:), "LineWidth", 3);
        end
    end
    base = base + c;
end
plot(ax, 0:4, y1, "o", "MarkerFaceColor", "k", "MarkerEdgeColor", "k", "MarkerSize", 3)
hold(ax, "off"), box(ax, "on")
xlim(ax, [-0.5 4.5]), ylim(ax, [0 4.5]), xticks(ax, 0:4), yticks(ax, 0:3)   % headroom for the legend
xlabel(ax, "$n$", "Interpreter", "latex"), title(ax, "$y[n]=\sum_m x[m]h[n-m]$", "Interpreter", "latex")
lg = legend(ax, lh, ["$m=0$" "$m=1$" "$m=2$"], "Interpreter", "latex", "Location", "northwest", "FontSize", 6, "Box", "off");   % above the stacked bars (max 2)
lg.ItemTokenSize = [8 8];
set(findall(fig, "Type", "axes"), "FontSize", 8)
exportgraphics(fig, fullfile(resfolder, "atip-04-conv1d.png"), "Resolution", 300)
close(fig)
%%
%[text] ## Impulse response and filter kernel
%[text] `imfilter` without options computes the correlation $y\[\\boldsymbol{n}\]=\\sum\_{\\boldsymbol{m}}f\[\\boldsymbol{m}\]x\[\\boldsymbol{n}+\\boldsymbol{m}\]$.
%[text] Its impulse response is the kernel flipped on each axis, $h\[\\boldsymbol{n}\]=f\[-\\boldsymbol{n}\]$ (`rot90(f,2)`).
f = reshape(1:9, [3 3]);
himp = imfilter(1, f, "full");          % response to the unit impulse
assert(isequal(himp, rot90(f,2)))
assert(isequal(imfilter(1, rot90(f,2), "conv", "full"), himp))
assert(isequal(conv2(1, rot90(f,2)), himp))
atip.savetex("atip-04-flip-f", atip.arr2tex(f, "%d"));
atip.savetex("atip-04-flip-h", atip.arr2tex(himp, "%d"));
%%
%[text] ## Bivariate convolution
%[text] Input $\\mathsf{x}\\in\\mathbb{R}^{3\\times 3}$ and impulse response $\\mathsf{h}$ with rows $(1,0,-1)$, both indexed from $\\boldsymbol{0}$.
%[text] The full output has the support $\\{0,\\ldots,4\\}^2$.
xb = [1 2 3; 4 5 6; 7 8 9];
hb = [1 0 -1; 1 0 -1; 1 0 -1];
yb = conv2(xb, hb);
assert(isequal(yb, [1 2 2 -2 -3; 5 7 4 -7 -9; 12 15 6 -15 -18; 11 13 4 -13 -15; 7 8 2 -8 -9]))
atip.savetex("atip-04-bi-x", atip.arr2tex(xb, "%d"));
atip.savetex("atip-04-bi-h", atip.arr2tex(hb, "%d"));
atip.savetex("atip-04-bi-y", atip.arr2tex(yb, "%d"));
%[text] Weighted sum of shifted impulse responses $\\sum\_{\\boldsymbol{m}}x\[\\boldsymbol{m}\]\\left(h\[\\boldsymbol{n}-\\boldsymbol{m}\]\\right)\_{\\boldsymbol{n}}$.
ysum = zeros(5);
for m2 = 0:2
    for m1 = 0:2
        S = zeros(5); S(m1+(1:3), m2+(1:3)) = hb;  % (h[n-m])_n
        ysum = ysum + xb(m1+1,m2+1)*S;
        if (m1==0 && m2==0) || (m1==0 && m2==1) || (m1==2 && m2==2)
            atip.savetex(sprintf("atip-04-bi-s%d%d", m1, m2), atip.arr2tex(S, "%d"));
        end
    end
end
assert(isequal(ysum, yb))
%[text] Local inner products $y\[\\boldsymbol{n}\]=\\sum\_{\\boldsymbol{m}}f\[\\boldsymbol{m}\]x\[\\boldsymbol{n}+\\boldsymbol{m}\]$
%[text] with $f\[\\boldsymbol{m}\]=h\[-\\boldsymbol{m}\]$: each output is a signed sum of input values (zero padding).
expr = strings(5);
xpad = zeros(7); xpad(3:5,3:5) = xb;        % zero padding by 2
fb = rot90(hb, 2);                          % filter kernel (centre at the middle)
for n1 = 0:4
    for n2 = 0:4
        blk = xpad(n1+(1:3), n2+(1:3));     % (x[n-2+m])_m
        w = fb.*(blk~=0);
        vals = blk.'; vals = vals(:); ws = w.'; ws = ws(:);  % row-major order
        t = "";
        for k = 1:numel(vals)
            if ws(k) ~= 0
                if ws(k) > 0
                    sg = "+";
                else
                    sg = "-";
                end
                if strlength(t) == 0 && sg == "+"
                    t = string(vals(k));
                else
                    t = t + sg + string(vals(k));
                end
            end
        end
        assert(sum(blk.*fb, "all") == yb(n1+1,n2+1))
        expr(n1+1,n2+1) = t;
    end
end
atip.savetex("atip-04-bi-expr", strjoin(join(expr, " & ", 2), "\\" + newline));
atip.savetex("atip-04-bi-e22", expr(3,3));
atip.savetex("atip-04-bi-y22", sprintf("%d", yb(3,3)));
atip.savetex("atip-04-bi-e02", expr(1,3));
atip.savetex("atip-04-bi-y02", sprintf("%d", yb(1,3)));
%%
%[text] ## Separable systems
%[text] $h\[n\_1,n\_2\]=h\_1\[n\_1\]h\_2\[n\_2\]$ iff the matrix of $\\mathsf{h}$ has rank 1.  The $3\\times 3$ box filter is separable,
%[text] the 4-neighbour Laplacian is not.  The factors are obtained by the SVD $\\mathbf{H}=\\sigma\_0\\mathbf{u}\_0\\mathbf{v}\_0^\\top$.
hbox = ones(3)/9;
[tf, hcol, hrow] = isfilterseparable(hbox);
assert(tf && rank(hbox) == 1)
[U,S,V] = svd(hbox);
sv = diag(S).';
g1 = sqrt(S(1,1))*U(:,1); g2 = sqrt(S(1,1))*V(:,1);
if g1(1) < 0, g1 = -g1; g2 = -g2; end
assert(norm(g1*g2.' - hbox) < 1e-12 && norm(abs(hcol*hrow) - hbox) < 1e-12)
atip.savetex("atip-04-sep-box-g", atip.arr2tex(g1.', "%.4f"));
hlap = fspecial("laplacian", 0);
assert(~isfilterseparable(hlap))
atip.savetex("atip-04-sep-lap", atip.arr2tex(hlap, "%d"));
atip.savetex("atip-04-sep-lap-rank", sprintf("%d", rank(hlap)));
atip.savetex("atip-04-sep-box-rank", sprintf("%d", rank(hbox)));
%[text] Figure: a non-separable (oriented Gaussian) and a separable (axis-aligned Gaussian) impulse response.
[q2,q1] = meshgrid(-8:8);
Cn = [8 5; 5 6]; Cs = [8 0; 0 3];
P = [q1(:) q2(:)];
hn = reshape(exp(-0.5*sum((P/Cn).*P, 2)), size(q1));
hs = reshape(exp(-0.5*sum((P/Cs).*P, 2)), size(q1));
assert(rank(hs, 1e-10) == 1 && rank(hn, 1e-10) > 1)
fig = figure(Units="centimeters", Position=[2 2 6.4 3.0], Color="w");
tl = tiledlayout(fig, 1, 2, "TileSpacing", "compact", "Padding", "compact");
names = ["Non-separable" "Separable"];
H = {hn, hs};
ecol = [ccool; cmain];
for k = 1:2
    ax = nexttile(tl);
    mesh(ax, q2, q1, H{k}, "EdgeColor", ecol(k,:))
    set(ax, "YDir", "reverse", "XTick", [], "YTick", [], "ZTick", [], "FontSize", 8)
    title(ax, names(k), "FontWeight", "normal"), view(ax, -30, 40), axis(ax, "tight")
end
exportgraphics(fig, fullfile(resfolder, "atip-04-sep.png"), "Resolution", 300)
close(fig)
%%
%[text] ## Column vectorization
%[text] Example of \[M\] Section 1.2.1 (column-major order, as `X(:)` in MATLAB).
xv = [0 2; 4 6];
v = xv(:);
assert(isequal(v.', [0 4 2 6]))
atip.savetex("atip-04-vec-x", atip.arr2tex(xv, "%d"));
atip.savetex("atip-04-vec-v", atip.arr2tex(v, "%d"));
%[text] A 4K frame of $2160\\times 3840$ pixels is a vector of dimension $N=2160\\times 3840$.
N4k = 2160*3840;
assert(N4k == 8294400)
atip.savetex("atip-04-4k-n", atip.fmtint(N4k));
%%
%[text] ## Periodic signals
%[text] Exercise "Integer vectors in the fundamental period" of \[M\] Section 4.1.2: $\\boldsymbol{N}=\\begin{bmatrix}2&1\\\\0&2\\end{bmatrix}$.
%[text] $\\mathcal{N}(\\boldsymbol{N})=\\{\\boldsymbol{n}\\in\\mathbb{Z}^2\\mid\\boldsymbol{N}^{-1}\\boldsymbol{n}\\in\[0,1)^2\\}$ and $|\\mathcal{N}(\\boldsymbol{N})|=|\\det\\boldsymbol{N}|$.
Np = [2 1; 0 2];
[c2,c1] = meshgrid(-4:4);
cand = [c1(:) c2(:)].';
r = Np\cand;
in = all(r >= -1e-12 & r < 1-1e-12, 1);
Nset = sortrows(cand(:,in).').';
assert(size(Nset,2) == abs(round(det(Np))))
assert(isequal(Nset, [0 1 1 2; 0 0 1 1]))
atip.savetex("atip-04-per-nset", strjoin(compose("\\begin{bmatrix}%d\\\\%d\\end{bmatrix}", Nset.'), ", "));
atip.savetex("atip-04-per-det", sprintf("%d", abs(round(det(Np)))));
%%
%[text] ## Modulo by a period matrix and circular shift
%[text] $(\\!(\\boldsymbol{n})\\!)\_{\\boldsymbol{N}}=\\boldsymbol{n}-\\boldsymbol{N}\\lfloor\\boldsymbol{N}^{-1}\\boldsymbol{n}\\rfloor$ and $y\[\\boldsymbol{n}\]=x\[(\\!(\\boldsymbol{n}-\\boldsymbol{k})\\!)\_{\\boldsymbol{N}}\]$.
msipmod = @(n,Nm) n - Nm*floor(Nm\n);
Nc = diag([2 3]);
assert(isequal(msipmod([-1;-2], Nc), [1;1]))
atip.savetex("atip-04-mod-ex", atip.arr2tex(msipmod([-1;-2], Nc), "%d"));
xc = [0 2 4; 1 3 5];
kc = [1; 2];
yc = zeros(size(xc));
for n2 = 0:2
    for n1 = 0:1
        mm = msipmod([n1;n2] - kc, Nc);
        yc(n1+1,n2+1) = xc(mm(1)+1, mm(2)+1);
    end
end
assert(isequal(yc, circshift(xc, kc.')))
assert(isequal(yc, [3 5 1; 2 4 0]))
%[text] Matrix representation by the responses to the standard basis (\[M\] Theorem "Linear map and matrix representation").
mapS = @(u) circshift(u, kc.');
Tc = zeros(numel(xc), numel(xc));
for idx = 1:numel(xc)
    e = zeros(size(xc)); e(idx) = 1;
    t = mapS(e);
    Tc(:,idx) = t(:);
end
assert(isequal(Tc*xc(:), yc(:)))
atip.savetex("atip-04-cs-x", atip.arr2tex(xc, "%d"));
atip.savetex("atip-04-cs-y", atip.arr2tex(yc, "%d"));
atip.savetex("atip-04-cs-xv", atip.arr2tex(xc(:), "%d"));
atip.savetex("atip-04-cs-yv", atip.arr2tex(yc(:), "%d"));
atip.savetex("atip-04-cs-T", atip.arr2tex(Tc, "%d"));
%[text] Circular shift of an image (period matrix = image size).
Xs = imresize(X, [128 128]);
kimg = [32 48];
imwrite(circshift(Xs, kimg), fullfile(resfolder, "atip-04-cshift-out.png"))
imwrite(Xs, fullfile(resfolder, "atip-04-cshift-in.png"))
atip.savetex("atip-04-cshift-k", atip.arr2tex(kimg, "%d"));
%%
%[text] ## Circular convolution
%[text] \[M\] Section 4.3.2: $y\[\\boldsymbol{n}\]=\\sum\_{\\boldsymbol{m}\\in\\mathcal{N}\_\\mathrm{h}}h\[\\boldsymbol{m}\]x\[(\\!(\\boldsymbol{n}-\\boldsymbol{m})\\!)\_{\\boldsymbol{N}}\]$, $\\boldsymbol{n}\\in\\mathcal{N}(\\boldsymbol{N})$,
%[text] with $h\[\\boldsymbol{n}\]$ indexed from $\\boldsymbol{0}$ ($\\mathcal{N}\_\\mathrm{h}=\\{0,1\\}^2$) and $\\boldsymbol{N}=\\mathrm{diag}(2,3)$.
hc = [1 -1; 1 -1];
cconvN = @(u) cconvmod(u, hc, Nc, msipmod);
yy = cconvN(xc);
assert(isequal(yy, [-8 4 4; -8 4 4]))
Tcc = zeros(numel(xc), numel(xc));
for idx = 1:numel(xc)
    e = zeros(size(xc)); e(idx) = 1;
    t = cconvN(e);
    Tcc(:,idx) = t(:);
end
assert(isequal(Tcc*xc(:), yy(:)))
%[text] `imfilter(x,h,"conv","circular")` puts the origin of a $2\\times 2$ kernel at `h(2,2)`, so its output is circularly
%[text] shifted by $(-1,-1)$ (this is the result shown in the 2026 slides).
yimf = imfilter(xc, hc, "conv", "circular");
assert(isequal(yimf, circshift(yy, [-1 -1])))
atip.savetex("atip-04-cc-h", atip.arr2tex(hc, "%d"));
atip.savetex("atip-04-cc-y", atip.arr2tex(yy, "%d"));
atip.savetex("atip-04-cc-yv", atip.arr2tex(yy(:), "%d"));
atip.savetex("atip-04-cc-T", atip.arr2tex(Tcc, "%d"));
atip.savetex("atip-04-cc-imf", atip.arr2tex(yimf, "%d"));
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.
%%
function y = cconvmod(x, h, Nm, msipmod)
% Circular convolution by the period matrix Nm (definition of [M] Sec. 4.3.2)
y = zeros(size(x));
[M1,M2] = size(h);
for n2 = 0:size(x,2)-1
    for n1 = 0:size(x,1)-1
        acc = 0;
        for m2 = 0:M2-1
            for m1 = 0:M1-1
                q = msipmod([n1;n2] - [m1;m2], Nm);
                acc = acc + h(m1+1,m2+1)*x(q(1)+1, q(2)+1);
            end
        end
        y(n1+1,n2+1) = acc;
    end
end
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
