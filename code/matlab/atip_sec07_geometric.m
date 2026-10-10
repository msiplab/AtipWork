%[text] # Lecture 7: Geometric Image Processing
%[text] Shogo Muramatsu, "Advanced Topics in Image Processing"
%[text] Verified: MATLAB R2026b
%[text] This script makes all figures and numbers of the slides of lecture 7 (atip2027-07).
%[text] The notation follows the reference text \[M\] (MsipText), Chapter 5: Sections 5.1 (resampling: downsizing,
%[text] upsizing, polyphase filters), 5.2 (sampling and reconstruction: B-spline and cubic convolution interpolation),
%[text] 5.3 (linear transforms of coordinates) and 5.4 (affine and projective transforms), and Section 4.3.2
%[text] (circular convolution).  The input and output arrays of a resampler are $\\mathsf{x}=\\left(x\[\\boldsymbol{m}\]\\right)\_{\\boldsymbol{m}}$
%[text] and $\\mathsf{y}=\\left(y\[\\boldsymbol{n}\]\\right)\_{\\boldsymbol{n}}$, the resampling matrix is $\\boldsymbol{M}$.
%[text:tableOfContents]{"heading":"Contents"}
%%
%[text] ## Preparation
%[text] Figures and LaTeX snippets are written to the `results` folder.  AtipSlides imports them with
%[text] `tools/sync-results.ps1`.  The figure colours are the three colours of the MSIP Lab logo and grey.
[datfolder,resfolder] = atip.prjfolders();
cmain = [0 136 85]/255;     % main (green) #008855
ccool = [46 117 182]/255;   % cool (blue)  #2E75B6
cwarm = [197 90 17]/255;    % warm (orange) #C55A11
cgray = [0.45 0.45 0.45];   % grey
%%
%[text] ## Decreasing the resolution
%[text] Downsampling $y\[\\boldsymbol{n}\]=x\[\\boldsymbol{M}\\boldsymbol{n}\]$ versus $2\\times2$ block average
%[text] $y\[\\boldsymbol{n}\]=\\frac{1}{|\\det(\\boldsymbol{M})|}\\sum\_{\\boldsymbol{m}\\in\\mathcal{N}(\\boldsymbol{M})}x\[\\boldsymbol{M}\\boldsymbol{n}+\\boldsymbol{m}\]$
%[text] with $\\boldsymbol{M}=\\mathrm{diag}(2,2)$ (\[M\] Example "Block average", Sec. 5.1.1).
X4 = [0 4 8 6; 2 2 4 6; 8 2 0 4; 6 8 2 2];
Yds = X4(1:2:end, 1:2:end)
Yavg = (X4(1:2:end,1:2:end) + X4(2:2:end,1:2:end) + X4(1:2:end,2:2:end) + X4(2:2:end,2:2:end))/4
assert(isequal(Yds, [0 8; 8 0]) && isequal(Yavg, [2 6; 6 2]))
atip.savetex("atip-07-x4",   atip.arr2tex(X4, "%d"));
atip.savetex("atip-07-ds",   atip.arr2tex(Yds, "%d"));
atip.savetex("atip-07-avg",  atip.arr2tex(Yavg, "%d"));
%[text] The same operations on an image (barbaraFaceRgb.tif, grayscale).
B = im2double(rgb2gray(imread(fullfile(datfolder, "barbaraFaceRgb.tif"))));
Bds  = B(1:2:end, 1:2:end);
Bbox = imresize(B, size(B)/2, "box");
imwrite(B,    fullfile(resfolder, "atip-07-barb.png"))
imwrite(Bds,  fullfile(resfolder, "atip-07-barb-ds.png"))
imwrite(Bbox, fullfile(resfolder, "atip-07-barb-box.png"))
%%
%[text] ## Increasing the resolution
%[text] Zero insertion versus zero-order hold ($2\\times2$ copies) of the block-averaged $2\\times2$ array.
Yzi = zeros(4); Yzi(1:2:end, 1:2:end) = Yavg
Yzoh = kron(Yavg, ones(2))
atip.savetex("atip-07-zi",  atip.arr2tex(Yzi, "%d"));
atip.savetex("atip-07-zoh", atip.arr2tex(Yzoh, "%d"));
Bzi = zeros(size(B)); Bzi(1:2:end, 1:2:end) = Bbox;
Bnn = imresize(Bbox, 2, "nearest");
imwrite(Bzi, fullfile(resfolder, "atip-07-barb-zi.png"))
imwrite(Bnn, fullfile(resfolder, "atip-07-barb-nn.png"))
%%
%[text] ## Decimation with the ideal lowpass filter
%[text] Ideal anti-aliasing filter $H\_\\mathrm{I}(\\mathrm{e}^{\\mathrm{j}\\omega})=1$ for $|\\omega|<\\pi/M$ and 0 otherwise ($M=2$).
%[text] The filtered spectrum does not overlap after downsampling.
w = linspace(-pi, 3*pi, 2001);
wrapw = @(om) abs(mod(om+pi, 2*pi) - pi);       % |omega| folded into [0, pi]
Xw = @(om) max(1 - wrapw(om)/(0.75*pi), 0);     % band 0.75 pi
HI = @(om) double(wrapw(om) < pi/2);            % ideal lowpass (M = 2)
Vw = @(om) HI(om).*Xw(om);
fig = figure(Units="centimeters", Position=[2 2 6.4 5.6], Color="w");
tl = tiledlayout(fig, 3, 1, "TileSpacing","compact", "Padding","compact");
ax = nexttile(tl); hold(ax, "on")
plot(ax, w, Xw(w), "Color", ccool, "LineWidth", 1.5)
plot(ax, w, HI(w), ":", "Color", cwarm, "LineWidth", 1.5)
hold(ax, "off")
title(ax, "$X(\mathrm{e}^{\mathrm{j}\omega})$ and $H_\mathrm{I}(\mathrm{e}^{\mathrm{j}\omega})$ (dotted)", "Interpreter","latex")
ax = nexttile(tl); plot(ax, w, Vw(w), "Color", cmain, "LineWidth", 1.5)
title(ax, "$H_\mathrm{I}(\mathrm{e}^{\mathrm{j}\omega})X(\mathrm{e}^{\mathrm{j}\omega})$", "Interpreter","latex")
ax = nexttile(tl); hold(ax, "on")
plot(ax, w, 0.5*Vw(w/2), "--", "Color", cmain, "LineWidth", 1.2)
plot(ax, w, 0.5*Vw((w-2*pi)/2), "--", "Color", cgray, "LineWidth", 1.2)
plot(ax, w, 0.5*(Vw(w/2) + Vw((w-2*pi)/2)), "Color", cwarm, "LineWidth", 1.5)
hold(ax, "off")
title(ax, "$Y(\mathrm{e}^{\mathrm{j}\omega})$: no aliasing", "Interpreter","latex")
xlabel(ax, "$\omega$", "Interpreter","latex")
fmtspec(fig, [0 1.3; 0 1.3; 0 0.75])
exportgraphics(fig, fullfile(resfolder, "atip-07-dec.png"), "Resolution", 300)
close(fig)
%%
%[text] ## Approximation with averaging
%[text] Averaging filter $h\[n\]=1/M$ for $n\\in\\mathcal{N}\_\\mathrm{h}=\\tau\_0-\\mathcal{N}(M)=\\mathcal{N}(M)$ with $\\tau\_0=M-1$
%[text] (\[M\] Exercise "Type-I polyphase filter"), $M=2$: $y\[n\]=\\frac{1}{2}(x\[2n\]+x\[2n-1\])$.
%[text] Type-I polyphase filters $E\_0(z)=E\_1(z)=\\frac12$: average of the phases $x\[2n\]$ and $x\[2n-1\]$.
xa = [0 1 3 5 3];                               % x[m], m = 0,...,4 (zero outside)
v  = conv(xa, [1/2 1/2]);                       % filter with h on {0,1}: v[n] = (x[n]+x[n-1])/2
ya = v(1:2:numel(xa))                           % y[n] = v[2n], n = 0,1,2
xodd = [0 xa(2:2:end)];                         % x[2n-1]
ya2 = (xa(1:2:end) + xodd(1:numel(ya)))/2;      % polyphase form E_0 = E_1 = 1/2
assert(isequal(ya2, ya) && isequal(ya, [0 2 4]))
atip.savetex("atip-07-avg-x", strjoin(string(xa), ",\,"));
atip.savetex("atip-07-avg-y", strjoin(string(ya), ",\,"));
%[text] Amplitude response $|H(\\mathrm{e}^{\\mathrm{j}\\omega})|=|\\cos(\\omega/2)|$ against the ideal filter.
wp = linspace(0, pi, 501);
fig = figure(Units="centimeters", Position=[2 2 5.6 3.8], Color="w");
ax = axes(fig); hold(ax, "on")
plot(ax, wp, double(wp < pi/2), ":", "Color", cwarm, "LineWidth", 1.5)
plot(ax, wp, abs(cos(wp/2)), "Color", cmain, "LineWidth", 1.5)
hold(ax, "off"), grid(ax, "on"), box(ax, "on")
text(ax, 0.04*pi, 1.12, "ideal $H_\mathrm{I}$", "Interpreter","latex", "Color", cwarm, "FontSize", 8)
text(ax, 0.62*pi, 0.85, "average", "Color", cmain, "FontSize", 8)
set(ax, "XLim", [0 pi], "YLim", [0 1.25], "XTick", [0 pi/2 pi], "XTickLabel", ["$0$","$\pi/2$","$\pi$"], ...
    "TickLabelInterpreter","latex", "FontSize", 8)
xlabel(ax, "$\omega$", "Interpreter","latex"), ylabel(ax, "$|H(\mathrm{e}^{\mathrm{j}\omega})|$", "Interpreter","latex")
exportgraphics(fig, fullfile(resfolder, "atip-07-havg.png"), "Resolution", 300)
close(fig)
%%
%[text] ## Interpolation with the ideal lowpass filter
%[text] Ideal anti-imaging filter $F\_\\mathrm{I}(\\mathrm{e}^{\\mathrm{j}\\omega})=M$ for $|\\omega|<\\pi/M$ and 0 otherwise ($M=2$).
Xw2 = @(om) max(1 - wrapw(om)/(0.8*pi), 0);
FI = @(om) 2*double(wrapw(om) < pi/2);
fig = figure(Units="centimeters", Position=[2 2 6.4 5.6], Color="w");
tl = tiledlayout(fig, 3, 1, "TileSpacing","compact", "Padding","compact");
ax = nexttile(tl); plot(ax, w, Xw2(w), "Color", ccool, "LineWidth", 1.5)
title(ax, "$X(\mathrm{e}^{\mathrm{j}\omega})$", "Interpreter","latex")
ax = nexttile(tl); hold(ax, "on")
plot(ax, w, Xw2(2*w), "Color", cwarm, "LineWidth", 1.5)
plot(ax, w, FI(w), ":", "Color", cmain, "LineWidth", 1.5)
hold(ax, "off")
title(ax, "$X(\mathrm{e}^{\mathrm{j}2\omega})$ and $F_\mathrm{I}(\mathrm{e}^{\mathrm{j}\omega})$ (dotted)", "Interpreter","latex")
ax = nexttile(tl); plot(ax, w, FI(w).*Xw2(2*w), "Color", cmain, "LineWidth", 1.5)
title(ax, "$Y(\mathrm{e}^{\mathrm{j}\omega})$: imaging removed", "Interpreter","latex")
xlabel(ax, "$\omega$", "Interpreter","latex")
fmtspec(fig, [0 1.2; 0 2.4; 0 2.4])
exportgraphics(fig, fullfile(resfolder, "atip-07-int.png"), "Resolution", 300)
close(fig)
%%
%[text] ## Approximation with nearest-neighbour and linear interpolation
%[text] Zero-order hold $f\[n\]=1$ for $n\\in\\mathcal{N}(M)-\\tau\_0$ ($\\tau\_0=0$): $y\[n\]=x\[\\lfloor n/M\\rfloor\]$.
%[text] Linear interpolation $f\[n\]=1-|n|/M$, $n\\in\\{-M+1,\\ldots,M-1\\}$ (\[M\] Sec. 5.1.2).  $M=2$, $\\mathsf{x}=(2,4)$, zeros outside.
xi = [2 4];
xz = zeros(1, 2*numel(xi)); xz(1:2:end) = xi;   % zero insertion
ynn = conv(xz, [1 1]);  ynn = ynn(1:numel(xz))  % f on {0,1}
ylin = conv(xz, [1/2 1 1/2]); ylin = ylin(2:numel(xz)+1)   % f on {-1,0,1}
assert(isequal(ynn, [2 2 4 4]) && isequal(ylin, [2 3 4 2]))
atip.savetex("atip-07-int-x",   strjoin(string(xi), ",\,"));
atip.savetex("atip-07-int-zi",  strjoin(string(xz), ",\,"));
atip.savetex("atip-07-int-nn",  strjoin(string(ynn), ",\,"));
atip.savetex("atip-07-int-lin", strjoin(string(ylin), ",\,"));
%[text] Amplitude responses: $|F\_\\mathrm{NN}|=2|\\cos(\\omega/2)|$, $F\_\\mathrm{lin}=1+\\cos\\omega$.
for k = 1:2
    fig = figure(Units="centimeters", Position=[2 2 5.6 3.8], Color="w");
    ax = axes(fig); hold(ax, "on")
    plot(ax, wp, 2*double(wp < pi/2), ":", "Color", cwarm, "LineWidth", 1.5)
    plot(ax, wp, 2*abs(cos(wp/2)), "Color", cmain, "LineWidth", 1.5)
    text(ax, 0.04*pi, 2.25, "ideal $F_\mathrm{I}$", "Interpreter","latex", "Color", cwarm, "FontSize", 8)
    text(ax, 0.62*pi, 1.65, "NN", "Color", cmain, "FontSize", 8)
    if k == 2
        plot(ax, wp, 1 + cos(wp), "Color", ccool, "LineWidth", 1.5)
        text(ax, 0.30*pi, 0.9, "linear", "Color", ccool, "FontSize", 8)
    end
    hold(ax, "off"), grid(ax, "on"), box(ax, "on")
    set(ax, "XLim", [0 pi], "YLim", [0 2.5], "XTick", [0 pi/2 pi], "XTickLabel", ["$0$","$\pi/2$","$\pi$"], ...
        "TickLabelInterpreter","latex", "FontSize", 8)
    xlabel(ax, "$\omega$", "Interpreter","latex"), ylabel(ax, "$|F(\mathrm{e}^{\mathrm{j}\omega})|$", "Interpreter","latex")
    names = ["atip-07-fnn.png", "atip-07-flin.png"];
    exportgraphics(fig, fullfile(resfolder, names(k)), "Resolution", 300)
    close(fig)
end
%[text] At $\\omega=\\pi/2$ the gains are $\\sqrt{2}$ (NN) and 1 (linear): the linear filter suppresses imaging more.
gnn = 2*abs(cos(pi/4)); glin = 1 + cos(pi/2);
atip.savetex("atip-07-gnn",  sprintf("%.2f", gnn));
atip.savetex("atip-07-glin", sprintf("%.2f", glin));
%%
%[text] ## Resizing with a rational factor
%[text] $M\_\\mathrm{u}/M\_\\mathrm{d}=2/3$: zero insertion by $M\_\\mathrm{u}$, ideal filter $G\_\\mathrm{I}$ with gain $M\_\\mathrm{u}$ and cut-off
%[text] $\\min(\\pi/M\_\\mathrm{u},\\pi/M\_\\mathrm{d})$, and downsampling by $M\_\\mathrm{d}$.
Mu = 2; Md = 3; wc = min(pi/Mu, pi/Md);
Xw3 = @(om) max(1 - wrapw(om)/(0.8*pi), 0);
Uw = @(om) Xw3(Mu*om);                           % after zero insertion
GI = @(om) Mu*double(wrapw(om) < wc);
Vw3 = @(om) GI(om).*Uw(om);
Yw3 = zeros(size(w));
for k = 0:Md-1
    Yw3 = Yw3 + Vw3((w - 2*pi*k)/Md)/Md;
end
fig = figure(Units="centimeters", Position=[2 2 6.4 5.6], Color="w");
tl = tiledlayout(fig, 3, 1, "TileSpacing","compact", "Padding","compact");
ax = nexttile(tl); plot(ax, w, Xw3(w), "Color", ccool, "LineWidth", 1.5)
title(ax, "$X(\mathrm{e}^{\mathrm{j}\omega})$", "Interpreter","latex")
ax = nexttile(tl); hold(ax, "on")
plot(ax, w, Uw(w), "Color", cwarm, "LineWidth", 1.5)
plot(ax, w, GI(w), ":", "Color", cmain, "LineWidth", 1.5)
hold(ax, "off")
title(ax, "after $\uparrow M_\mathrm{u}$ and $G_\mathrm{I}(\mathrm{e}^{\mathrm{j}\omega})$ (dotted)", "Interpreter","latex")
ax = nexttile(tl); plot(ax, w, Yw3, "Color", cmain, "LineWidth", 1.5)
title(ax, "$Y(\mathrm{e}^{\mathrm{j}\omega})$ after $\downarrow M_\mathrm{d}$", "Interpreter","latex")
xlabel(ax, "$\omega$", "Interpreter","latex")
fmtspec(fig, [0 1.2; 0 2.4; 0 1.2])
exportgraphics(fig, fullfile(resfolder, "atip-07-rat.png"), "Resolution", 300)
close(fig)
atip.savetex("atip-07-rat-mu", sprintf("%d", Mu));
atip.savetex("atip-07-rat-md", sprintf("%d", Md));
%%
%[text] ## Adjoint of circular convolution
%[text] Circular convolution with the periodic structure matrix $\\boldsymbol{N}=\\mathrm{diag}(2,3)$ (\[M\] Sec. 4.3.2):
%[text] $y\[\\boldsymbol{n}\]=\\sum\_{\\boldsymbol{m}}h\[\\boldsymbol{m}\]x\[((\\boldsymbol{n}-\\boldsymbol{m}))\_{\\boldsymbol{N}}\]$.
%[text] Impulse response with $h\[0,0\]=h\[1,0\]=-1$, $h\[0,-1\]=h\[1,-1\]=1$ (a horizontal difference of Prewitt type).
%[text] Its adjoint is the circular convolution with $f\[\\boldsymbol{n}\]=\\overline{h\[-\\boldsymbol{n}\]}$.
Nper = [2 3];
hset = [0 0 -1; 1 0 -1; 0 -1 1; 1 -1 1];       % [n1 n2 value]
fset = [-hset(:,1:2) conj(hset(:,3))];          % f[n] = conj(h[-n])
Xc = [0 2 4; 1 3 5];
Yc = cconvset(Xc, hset, Nper)
Wc = [2 1 2; 4 2 4];
Rc = cconvset(Wc, fset, Nper)
assert(isequal(Yc, [4 4 -8; 4 4 -8]) && isequal(Rc, [0 3 -3; 0 3 -3]))
%[text] Matrix representation (responses to the standard basis) and the check $\\mathbf{T}\_\\mathrm{f}=\\mathbf{T}\_\\mathrm{h}^\\mathsf{H}$.
Th = basismatrix(@(A) cconvset(A, hset, Nper), Nper);
Tf = basismatrix(@(A) cconvset(A, fset, Nper), Nper);
assert(isequal(Tf, Th'))
ipa = Wc(:)'*(Th*Xc(:))
ipb = (Th'*Wc(:))'*Xc(:)
assert(ipa == ipb)
%[text] The periodized impulse responses on $\\mathcal{N}(\\boldsymbol{N})$, $h\_{\\boldsymbol{N}}\[\\boldsymbol{n}\]$ and $f\_{\\boldsymbol{N}}\[\\boldsymbol{n}\]$.
hN = periodize(hset, Nper)
fN = periodize(fset, Nper)
atip.savetex("atip-07-cc-x",  atip.arr2tex(Xc, "%d"));
atip.savetex("atip-07-cc-y",  atip.arr2tex(Yc, "%d"));
atip.savetex("atip-07-cc-w",  atip.arr2tex(Wc, "%d"));
atip.savetex("atip-07-cc-r",  atip.arr2tex(Rc, "%d"));
atip.savetex("atip-07-cc-hN", atip.arr2tex(hN, "%d"));
atip.savetex("atip-07-cc-fN", atip.arr2tex(fN, "%d"));
atip.savetex("atip-07-cc-T",  atip.arr2tex(Th, "%d"));
atip.savetex("atip-07-cc-TH", atip.arr2tex(Th', "%d"));
atip.savetex("atip-07-cc-xv", atip.arr2tex(Xc(:), "%d"));
atip.savetex("atip-07-cc-yv", atip.arr2tex(Yc(:), "%d"));
atip.savetex("atip-07-cc-wv", atip.arr2tex(Wc(:), "%d"));
atip.savetex("atip-07-cc-rv", atip.arr2tex(Rc(:), "%d"));
atip.savetex("atip-07-cc-ip", sprintf("%d", ipa));
%[text] DFT check of the proof: $\\mathbf{T}\_\\mathrm{h}=\\mathbf{W}\_{\\boldsymbol{N}}^{-1}\\boldsymbol{\\Lambda}\_\\mathrm{h}\\mathbf{W}\_{\\boldsymbol{N}}$ and
%[text] $\\mathrm{DFT}(f\_{\\boldsymbol{N}})=\\overline{\\mathrm{DFT}(h\_{\\boldsymbol{N}})}$.
W = kron(dftmtx(Nper(2)), dftmtx(Nper(1)));     % DFT matrix for the column-wise vectorization
assert(norm(W\diag(W*hN(:))*W - Th) < 1e-12)
assert(norm(W*fN(:) - conj(W*hN(:))) < 1e-12)
%%
%[text] ## B-spline and cubic convolution kernels
%[text] $\\beta^0,\\ldots,\\beta^3$ (\[M\] Sec. 5.2.2) and Keys' kernel $\\kappa(q)$ with $a=-1/2$ (\[M\] Sec. 5.2.3).
q = linspace(-2.5, 2.5, 1001);
b0 = double(abs(q) < 0.5) + 0.5*double(abs(q) == 0.5);
b1 = max(1 - abs(q), 0);
b2 = (0.75 - q.^2).*(abs(q) <= 0.5) + 0.5*(1.5 - abs(q)).^2.*(abs(q) > 0.5 & abs(q) <= 1.5);
b3 = (2/3 - 0.5*q.^2.*(2 - abs(q))).*(abs(q) <= 1) + (2 - abs(q)).^3/6.*(abs(q) > 1 & abs(q) <= 2);
a = -1/2;
kappa = @(t) ((a+2)*abs(t).^3 - (a+3)*abs(t).^2 + 1).*(abs(t) <= 1) ...
    + (a*abs(t).^3 - 5*a*abs(t).^2 + 8*a*abs(t) - 4*a).*(abs(t) > 1 & abs(t) <= 2);
fig = figure(Units="centimeters", Position=[2 2 7.6 4.0], Color="w");
ax = axes(fig); hold(ax, "on")
plot(ax, q, b0, "Color", cgray, "LineWidth", 1.2, "DisplayName", "$\beta^0$")
plot(ax, q, b1, "Color", cmain, "LineWidth", 1.2, "DisplayName", "$\beta^1$")
plot(ax, q, b2, "--", "Color", ccool, "LineWidth", 1.2, "DisplayName", "$\beta^2$")
plot(ax, q, b3, "Color", ccool, "LineWidth", 1.2, "DisplayName", "$\beta^3$")
plot(ax, q, kappa(q), "Color", cwarm, "LineWidth", 1.5, "DisplayName", "$\kappa\ (a=-1/2)$")
hold(ax, "off"), grid(ax, "on"), box(ax, "on")
legend(ax, "Interpreter","latex", "Location","eastoutside", "FontSize", 7, "Box","off")
set(ax, "XLim", [-2.5 2.5], "YLim", [-0.15 1.1], "XTick", -2:2, "TickLabelInterpreter","latex", "FontSize", 8)
xlabel(ax, "$q$", "Interpreter","latex")
exportgraphics(fig, fullfile(resfolder, "atip-07-kernels.png"), "Resolution", 300)
close(fig)
%[text] Interpolation filter $f\_d\[n\_d\]=\\kappa(n\_d/2)$ for the factor 2, checked against \[M\] Exercise "Cubic convolution interpolation".
fk = kappa((-4:4)/2)
assert(isequal(round(fk, 4), [0 -0.0625 0 0.5625 1 0.5625 0 -0.0625 0]))
s = compose("%.4f", fk); s(abs(fk) < 1e-12) = "0"; s(fk == 1) = "1";
atip.savetex("atip-07-cubic", strjoin(s, ",\,"));
%%
%[text] ## Linear transforms of coordinates
%[text] $\\Pi(\\boldsymbol{q})=\\boldsymbol{P}\\boldsymbol{q}$ with $\\boldsymbol{q}=(q\_1\\ q\_2)^\\top$, $q\_1$ downward and $q\_2$ rightward (\[M\] Sec. 5.3).
%[text] `imwarp` works in $(x,y)=(q\_2,q\_1)$, so the matrix is converted by $\\mathbf{S}\\boldsymbol{P}\\mathbf{S}$ with $\\mathbf{S}=\\begin{pmatrix}0&1\\\\1&0\\end{pmatrix}$
%[text] and given to `affinetform2d` (premultiply convention).
C = 0.15 + 0.7*double(checkerboard(8, 2, 2) > 0.5);   % 32 x 32 test image
C(1:8, 1:8) = 0.45;                                   % mark the corner at the origin
th = pi/6;
Plist = {eye(2), diag([0.75 1.5]), diag([1 -1]), [cos(th) -sin(th); sin(th) cos(th)], ...
    [1 tan(th); 0 1], [1 0; tan(th) 1]};
tnames = ["Original", "Scaling", "Reflection", "Rotation", "Shearing (1st axis)", "Shearing (2nd axis)"];
fig = figure(Units="centimeters", Position=[2 2 8.4 5.8], Color="w");
tl = tiledlayout(fig, 2, 3, "TileSpacing","compact", "Padding","compact");
for k = 1:numel(Plist)
    tform = affinetform2d(blkdiag(swapxy(Plist{k}), 1));
    warpshow(nexttile(tl), C, tform, tnames(k), cmain)
end
exportgraphics(fig, fullfile(resfolder, "atip-07-lin.png"), "Resolution", 300)
close(fig)
atip.savetex("atip-07-lin-th", "\pi/6");
%%
%[text] ## Affine and projective transforms
%[text] Translation $\\Pi(\\boldsymbol{q})=\\boldsymbol{q}+\\boldsymbol{t}$, affine $\\Pi(\\boldsymbol{q})=\\boldsymbol{P}\\boldsymbol{q}+\\boldsymbol{t}$ and projective
%[text] $\\Pi(\\boldsymbol{q})=\[\\boldsymbol{H}\\boldsymbol{q}^\\mathrm{h}\]\_{1:2}/\[\\boldsymbol{H}\\boldsymbol{q}^\\mathrm{h}\]\_3$ (\[M\] Sec. 5.4), with `affinetform2d` and `projtform2d`.
tv = [6; 10];
R = [cos(th) -sin(th); sin(th) cos(th)];
Haff = [R tv; 0 0 1]                            % [M] Exercise "Affine transform"
Hprj = [1.0 0.2 4; -0.1 1.0 6; 0.006 0.012 1]  % a homography in (q1, q2)
Sh = blkdiag([0 1; 1 0], 1);
tforms = {affinetform2d(Sh*[eye(2) tv; 0 0 1]*Sh), affinetform2d(Sh*Haff*Sh), projtform2d(Sh*Hprj*Sh)};
tnames = ["Translation", "Affine", "Projective"];
fig = figure(Units="centimeters", Position=[2 2 8.4 3.2], Color="w");
tl = tiledlayout(fig, 1, 3, "TileSpacing","compact", "Padding","compact");
for k = 1:3
    warpshow(nexttile(tl), C, tforms{k}, tnames(k), cmain)
end
exportgraphics(fig, fullfile(resfolder, "atip-07-aff.png"), "Resolution", 300)
close(fig)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

function fmtspec(fig, ylims)
% FMTSPEC Common axis format of the spectrum plots (top to bottom)
axs = flipud(findobj(fig, "Type","axes"));
for k = 1:numel(axs)
    set(axs(k), "XLim", [-pi 3*pi], "YLim", ylims(k,:), "YTick", [], "XTick", -pi:pi:3*pi, ...
        "XTickLabel", ["$-\pi$","$0$","$\pi$","$2\pi$","$3\pi$"], "TickLabelInterpreter","latex", "FontSize", 8)
    grid(axs(k), "on")
    if k < numel(axs)
        set(axs(k), "XTickLabel", [])
    end
end
end

function Y = cconvset(X, hset, Nper)
% CCONVSET Circular convolution y[n] = sum_m h[m] x[((n-m))_N] with h given as rows [m1 m2 value]
Y = zeros(Nper);
for n1 = 0:Nper(1)-1
    for n2 = 0:Nper(2)-1
        for k = 1:size(hset,1)
            m = mod([n1 n2] - hset(k,1:2), Nper);
            Y(n1+1, n2+1) = Y(n1+1, n2+1) + hset(k,3)*X(m(1)+1, m(2)+1);
        end
    end
end
end

function T = basismatrix(op, sz)
% BASISMATRIX Matrix representation of a linear map on sz arrays (column-wise vectorization)
T = zeros(prod(sz));
for idx = 1:prod(sz)
    e = zeros(sz); e(idx) = 1;
    t = op(e);
    T(:,idx) = t(:);
end
end

function hN = periodize(hset, Nper)
% PERIODIZE Periodized impulse response on N(N)
hN = zeros(Nper);
for k = 1:size(hset,1)
    m = mod(hset(k,1:2), Nper);
    hN(m(1)+1, m(2)+1) = hN(m(1)+1, m(2)+1) + hset(k,3);
end
end

function A = swapxy(P)
% SWAPXY Matrix in (x,y) = (q2,q1) coordinates for P acting on (q1,q2)
S = [0 1; 1 0];
A = S*P*S;
end

function warpshow(ax, C, tform, ttl, cmain)
% WARPSHOW Warp C with tform into a fixed output view and show it with the q1 (down) and q2 (right) axes
% The view covers the reflected image (q2 < 0); the q2 arrow is longer than every warped image so
% that its label never touches the image.
Rout = imref2d([72 96], [-34 62], [-14 58]);
Bw = imwarp(C, imref2d(size(C)), tform, "linear", "OutputView", Rout, "FillValues", 1);
imshow(Bw, Rout, "Parent", ax)
hold(ax, "on")
plot(ax, [0 60], [0 0], "-", "Color", cmain, "LineWidth", 0.8)
plot(ax, [0 0], [0 54], "-", "Color", cmain, "LineWidth", 0.8)
plot(ax, 60, 0, ">", "MarkerSize", 3, "MarkerFaceColor", cmain, "MarkerEdgeColor", cmain)
plot(ax, 0, 54, "v", "MarkerSize", 3, "MarkerFaceColor", cmain, "MarkerEdgeColor", cmain)
text(ax, 58, -2, "$q_2$", "Interpreter","latex", "FontSize", 8, "Color", cmain, ...
    "HorizontalAlignment","center", "VerticalAlignment","bottom")
text(ax, -2, 52, "$q_1$", "Interpreter","latex", "FontSize", 8, "Color", cmain, ...
    "HorizontalAlignment","right", "VerticalAlignment","middle")
hold(ax, "off")
axis(ax, "off")
title(ax, ttl, "FontSize", 8, "Interpreter","latex")
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
