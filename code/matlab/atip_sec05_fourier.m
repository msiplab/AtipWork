%[text] # Lecture 5: Fourier Analysis
%[text] Shogo Muramatsu, "Advanced Topics in Image Processing"
%[text] Verified: MATLAB R2026b
%[text] This script makes all figures and numbers of the slides of lecture 5 (atip2027-05).
%[text] The notation follows the reference text \[M\] (MsipText), Chapter 4 and Section 1.2.2:
%[text] continuous coordinate $\\boldsymbol{q}$ and angular frequency $\\boldsymbol{\\nu}$, discrete index $\\boldsymbol{n}$ and
%[text] normalized angular frequency $\\boldsymbol{\\omega}$, periodic structure matrix $\\boldsymbol{N}$ of the DFT.
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
%[text] ## Overview: image, sinusoidal basis waves and spectrum
X = im2double(imread("cameraman.tif"));
Xs = imresize(X, [128 128]);
imwrite(Xs, fullfile(resfolder, "atip-05-ov-img.png"))
[qh,qv] = meshgrid((0:63)/64);
tiles = cell(3,3);
for iv = 1:3
    for ih = 1:3
        nu = 2*pi*[iv-2; ih-2]*2;           % (nu_v, nu_h)
        t = 0.5 + 0.5*cos(nu(1)*qv + nu(2)*qh);
        tiles{iv,ih} = padarray(t, [3 3], 1);
    end
end
imwrite(cell2mat(tiles), fullfile(resfolder, "atip-05-ov-basis.png"))
S = log(1 + abs(fftshift(fft2(Xs))));
imwrite(S/max(S(:)), fullfile(resfolder, "atip-05-ov-spec.png"))
%%
%[text] ## Sinusoidal expansion
%[text] A signal as a weighted sum of sinusoids $A\_k\\sin(\\nu\_kq+\\theta\_k)$; each sinusoid is a pair of complex sinusoids
%[text] $\\mathrm{e}^{\\pm\\mathrm{j}\\nu\_kq}$ with coefficients $(A\_k/2)\\mathrm{e}^{\\pm\\mathrm{j}(\\theta\_k-\\pi/2)}$ (\[M\] Exercise "Expansion of multidimensional sinusoids").
A = [1 0.6 0.3]; nuk = 2*pi*[1 3 7]; th = [pi/2 0 pi/4];
q = linspace(0, 1, 801);
fig = figure(Units="centimeters", Position=[2 2 11.5 3.6], Color="w");
tl = tiledlayout(fig, 1, 2, "TileSpacing", "compact", "Padding", "compact");
ax = nexttile(tl); hold(ax, "on")
cols = [cmain; ccool; cwarm];
for k = 1:3
    plot(ax, q, A(k)*sin(nuk(k)*q + th(k)) + 2.4*(4-k), "Color", cols(k,:), "LineWidth", 1)
end
plot(ax, q, sum(A.'.*sin(nuk.'*q + th.'), 1) - 0.4, "k", "LineWidth", 1.2)
hold(ax, "off"), box(ax, "on")
set(ax, "YTick", [], "FontSize", 8), xlim(ax, [0 1])
xlabel(ax, "$q$", "Interpreter", "latex")
title(ax, "Components and sum (bottom)", "FontWeight", "normal")
ax = nexttile(tl); hold(ax, "on")
for k = 1:3
    stem(ax, [-1 1]*nuk(k)/(2*pi), [1 1]*A(k)/2, "filled", "Color", cols(k,:), "MarkerSize", 3, "LineWidth", 1)
end
hold(ax, "off"), box(ax, "on")
xlim(ax, [-8 8]), ylim(ax, [0 0.65]), set(ax, "FontSize", 8)
xlabel(ax, "$\nu/(2\pi)$", "Interpreter", "latex")
title(ax, "Coefficient magnitudes (spectrum)", "FontWeight", "normal")
exportgraphics(fig, fullfile(resfolder, "atip-05-sinexp.png"), "Resolution", 300)
close(fig)
%%
%[text] ## Fourier transform (FT) of a Gaussian
%[text] \[M\] Example "FT of a Gaussian" with $D=1$, $\\mu=0$: $g(q)=\\frac{1}{\\sqrt{2\\pi}\\sigma}\\mathrm{e}^{-q^2/(2\\sigma^2)}$ and $\\tilde{g}(\\nu)=\\mathrm{e}^{-\\sigma^2\\nu^2/2}$.
sg = 1.5;
gfun = @(q) exp(-q.^2/(2*sg^2))/(sqrt(2*pi)*sg);
gtil = @(nu) exp(-sg^2*nu.^2/2);
nutest = 0.7;
gnum = integral(@(q) gfun(q).*exp(-1j*nutest*q), -inf, inf);
assert(abs(gnum - gtil(nutest)) < 1e-8)
q = linspace(-6, 6, 601); nu = linspace(-3*pi, 3*pi, 1201);
fig = figure(Units="centimeters", Position=[2 2 11.5 3.2], Color="w");
tl = tiledlayout(fig, 1, 2, "TileSpacing", "compact", "Padding", "compact");
ax = nexttile(tl);
plot(ax, q, gfun(q), "Color", cmain, "LineWidth", 1.2), grid(ax, "on")
xlabel(ax, "$q$", "Interpreter", "latex"), title(ax, "$g(q)$ (continuous, aperiodic)", "Interpreter", "latex")
ax = nexttile(tl);
plot(ax, nu, gtil(nu), "Color", ccool, "LineWidth", 1.2), grid(ax, "on")
xlim(ax, [-3*pi 3*pi]), xticks(ax, (-2:2)*pi), xticklabels(ax, ["$-2\pi$" "" "$0$" "" "$2\pi$"])
set(ax, "TickLabelInterpreter", "latex")
xlabel(ax, "$\nu$", "Interpreter", "latex"), title(ax, "$\tilde{g}(\nu)$ (continuous, aperiodic)", "Interpreter", "latex")
set(findall(fig, "Type", "axes"), "FontSize", 8)
exportgraphics(fig, fullfile(resfolder, "atip-05-ft.png"), "Resolution", 300)
close(fig)
atip.savetex("atip-05-ft-sigma", sprintf("%.1f", sg));
%%
%[text] ## Discrete-space Fourier transform (DSFT, $D=1$)
%[text] Samples $x\[n\]=g(n\\Delta)$ with $\\Delta=1$.  The DSFT is $2\\pi$-periodic:
%[text] $X(\\mathrm{e}^{\\mathrm{j}\\omega})=\\frac{1}{\\Delta}\\sum\_m\\tilde{g}\\left(\\frac{\\omega-2\\pi m}{\\Delta}\\right)$ (\[M\] relation between FT and DSFT).
Dl = 1;
n = -30:30; xg = gfun(n*Dl);
w = linspace(-3*pi, 3*pi, 1201);
Xd = xg*exp(-1j*n.'*w);                         % direct DSFT
Xp = zeros(size(w));
for m = -5:5
    Xp = Xp + gtil((w - 2*pi*m)/Dl)/Dl;
end
assert(max(abs(Xd - Xp)) < 1e-6)
fig = figure(Units="centimeters", Position=[2 2 11.5 3.2], Color="w");
tl = tiledlayout(fig, 1, 2, "TileSpacing", "compact", "Padding", "compact");
ax = nexttile(tl);
stem(ax, -8:8, gfun((-8:8)*Dl), "filled", "Color", cmain, "MarkerSize", 3), grid(ax, "on")
xlim(ax, [-8.5 8.5]), xlabel(ax, "$n$", "Interpreter", "latex")
title(ax, "$x[n]$ (discrete, aperiodic)", "Interpreter", "latex")
ax = nexttile(tl);
plot(ax, w, real(Xd), "Color", ccool, "LineWidth", 1.2), grid(ax, "on")
xlim(ax, [-3*pi 3*pi]), xticks(ax, (-2:2)*pi), xticklabels(ax, ["$-2\pi$" "" "$0$" "" "$2\pi$"])
set(ax, "TickLabelInterpreter", "latex")
xlabel(ax, "$\omega$", "Interpreter", "latex"), title(ax, "$X(\mathrm{e}^{\mathrm{j}\omega})$ (continuous, periodic)", "Interpreter", "latex")
set(findall(fig, "Type", "axes"), "FontSize", 8)
exportgraphics(fig, fullfile(resfolder, "atip-05-dsft1d.png"), "Resolution", 300)
close(fig)
%%
%[text] ## Frequency response and convolution ($D=1$)
%[text] Moving average $h\[n\]=1/3$, $n=0,1,2$ (lecture 4): $H(\\mathrm{e}^{\\mathrm{j}\\omega})=\\frac{1}{3}\\mathrm{e}^{-\\mathrm{j}\\omega}(1+2\\cos\\omega)$.
h1 = [1 1 1]/3; x1 = [1 2 3]; y1 = conv(h1, x1);
w = linspace(0, 2*pi, 1025); w = w(1:end-1);
dsft = @(s,w) s*exp(-1j*(0:numel(s)-1).'*w);
H1 = dsft(h1, w);
assert(max(abs(H1 - exp(-1j*w).*(1+2*cos(w))/3)) < 1e-12)
assert(max(abs(dsft(y1,w) - H1.*dsft(x1,w))) < 1e-12)     % Y = H X
wz = fzero(@(t) 1+2*cos(t), [pi/2 pi]);                   % zero of the magnitude response
[nz,dz] = rat(wz/pi);
assert(nz == 2 && dz == 3)
atip.savetex("atip-05-h1-zero", sprintf("\\tfrac{%d\\pi}{%d}", nz, dz));
fig = figure(Units="centimeters", Position=[2 2 5.6 4.4], Color="w");
tl = tiledlayout(fig, 2, 1, "TileSpacing", "compact", "Padding", "compact");
ax = nexttile(tl);
plot(ax, w, abs(H1), "Color", cmain, "LineWidth", 1.2), grid(ax, "on")
xlim(ax, [0 2*pi]), xticks(ax, [0 2*pi/3 pi 4*pi/3 2*pi]), xticklabels(ax, [])
ylabel(ax, "$|H(\mathrm{e}^{\mathrm{j}\omega})|$", "Interpreter", "latex")
ax = nexttile(tl);
plot(ax, w, angle(H1), "Color", ccool, "LineWidth", 1.2), grid(ax, "on")
xlim(ax, [0 2*pi]), ylim(ax, [-pi pi]), xticks(ax, [0 2*pi/3 pi 4*pi/3 2*pi])
xticklabels(ax, ["$0$" "$\frac{2\pi}{3}$" "$\pi$" "$\frac{4\pi}{3}$" "$2\pi$"]), yticks(ax, [-pi 0 pi]), yticklabels(ax, ["$-\pi$" "$0$" "$\pi$"])
set(ax, "TickLabelInterpreter", "latex")
xlabel(ax, "$\omega$", "Interpreter", "latex"), ylabel(ax, "$\angle H(\mathrm{e}^{\mathrm{j}\omega})$", "Interpreter", "latex")
set(findall(fig, "Type", "axes"), "FontSize", 8)
exportgraphics(fig, fullfile(resfolder, "atip-05-freqz.png"), "Resolution", 300)
close(fig)
%%
%[text] ## DFT as frequency sampling of the DSFT ($D=1$)
%[text] $X\[k\]=X(\\mathrm{e}^{\\mathrm{j}\\omega})|\_{\\omega=2\\pi k/N}$ for $x\[n\]=1,2,3$ ($n=0,1,2$) and $N=8$.
Nd = 8;
Xk = fft(x1, Nd);
assert(max(abs(Xk - dsft(x1, 2*pi*(0:Nd-1)/Nd))) < 1e-12)
fig = figure(Units="centimeters", Position=[2 2 5.6 3.9], Color="w");
ax = axes(fig); hold(ax, "on")
plot(ax, w, abs(dsft(x1,w)), "Color", cgrey, "LineWidth", 1)
stem(ax, 2*pi*(0:Nd-1)/Nd, abs(Xk), "filled", "Color", cwarm, "MarkerSize", 3, "LineWidth", 1)
hold(ax, "off"), box(ax, "on"), grid(ax, "on")
xlim(ax, [0 2*pi]), xticks(ax, [0 pi 2*pi]), xticklabels(ax, ["$0$" "$\pi$" "$2\pi$"]), set(ax, "TickLabelInterpreter", "latex", "FontSize", 8)
ylim(ax, [0 7]), yticks(ax, 0:2:6)
xlabel(ax, "$\omega$", "Interpreter", "latex")
lg = legend(ax, ["$|X(\mathrm{e}^{\mathrm{j}\omega})|$" "$|X[k]|$, $\omega=2\pi k/8$"], "Interpreter", "latex", "FontSize", 7, "Box", "off", ...
    "Location", "northoutside", "NumColumns", 2);                 % outside the axes: no overlap with the curves
lg.ItemTokenSize = [12 8];
drawnow                                          % close the gap MATLAB leaves below a northoutside legend
lp = lg.Position; ap = ax.Position;
lg.Location = "none";
ax.Position = [ap(1) ap(2) ap(3) lp(2)-ap(2)-0.02];
lg.Position = lp;
exportgraphics(fig, fullfile(resfolder, "atip-05-dft1d.png"), "Resolution", 300)
close(fig)
atip.savetex("atip-05-dft1d-x0", sprintf("%d", round(real(Xk(1)))));
%%
%[text] ## Circular convolution and DFT product ($D=1$)
%[text] $y\[n\]=\\sum\_m h\[m\]x\[(\\!(n-m)\\!)\_N\]$: with $N=3$ the output wraps around; with $N=5\\geq 3+3-1$ it equals the linear convolution.
fracs = @(v) strjoin(string(arrayfun(@fracstr, v, "UniformOutput", false)), " & ");
yN3 = cconv(h1, x1, 3);
yN5 = cconv(h1, x1, 5);
assert(max(abs(yN3 - [2 2 2])) < 1e-12 && max(abs(yN5 - y1)) < 1e-12)
assert(max(abs(ifft(fft(h1,3).*fft(x1,3)) - yN3)) < 1e-12)
assert(max(abs(ifft(fft(h1,5).*fft(x1,5)) - yN5)) < 1e-12)
atip.savetex("atip-05-cc-y3", fracs(yN3));
atip.savetex("atip-05-cc-y5", fracs(yN5));
%%
%[text] ## Bivariate cosine waves
%[text] $u(\\boldsymbol{q})=\\cos(\\boldsymbol{\\nu}^\\top\\boldsymbol{q})$, $\\boldsymbol{q}=(q\_\\mathrm{v},q\_\\mathrm{h})^\\top$, for $\\boldsymbol{\\nu}=(2\\pi,0)^\\top,(0,4\\pi)^\\top,(2\\pi,4\\pi)^\\top$.
nus = [2*pi 0; 0 4*pi; 2*pi 4*pi].';
[qh,qv] = meshgrid(linspace(-0.5, 0.5, 201));
fig = figure(Units="centimeters", Position=[2 2 11.0 4.0], Color="w");
tl = tiledlayout(fig, 1, 3, "TileSpacing", "compact", "Padding", "compact");
for k = 1:3
    ax = nexttile(tl);
    imagesc(ax, [-0.5 0.5], [-0.5 0.5], cos(nus(1,k)*qv + nus(2,k)*qh))
    colormap(ax, gray(256)), clim(ax, [-1 1]), axis(ax, "image")
    set(ax, "XTick", [-0.5 0 0.5], "YTick", [-0.5 0 0.5], "FontSize", 8)
    xlabel(ax, "$q_\mathrm{h}$", "Interpreter", "latex"), ylabel(ax, "$q_\mathrm{v}$", "Interpreter", "latex")
end
exportgraphics(fig, fullfile(resfolder, "atip-05-gratings.png"), "Resolution", 300)
close(fig)
%%
%[text] ## DSFT of a sampled 2-D Gaussian (periodicity $2\\pi\\mathbf{I}$)
%[text] $X(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top})=\\frac{1}{|\\det\\boldsymbol{L}|}\\sum\_{\\boldsymbol{m}}\\tilde{g}(\\boldsymbol{L}^{-\\top}(\\boldsymbol{\\omega}-2\\pi\\boldsymbol{m}))$ with $\\boldsymbol{L}=\\mathbf{I}$ and
%[text] $\\tilde{g}(\\boldsymbol{\\nu})=\\exp(-\\frac12\\boldsymbol{\\nu}^\\top\\boldsymbol{\\Sigma}\\boldsymbol{\\nu})$.
Sg = [1.6 0.9; 0.9 1.0];
[w2,w1] = meshgrid(linspace(-3*pi, 3*pi, 361));
X2 = zeros(size(w1));
for m1 = -3:3
    for m2 = -3:3
        d1 = w1 - 2*pi*m1; d2 = w2 - 2*pi*m2;
        X2 = X2 + exp(-0.5*(Sg(1,1)*d1.^2 + 2*Sg(1,2)*d1.*d2 + Sg(2,2)*d2.^2));
    end
end
% check one value against the direct DSFT of the samples
[n2g,n1g] = meshgrid(-12:12);
P = [n1g(:) n2g(:)];
gs = exp(-0.5*sum((P/Sg).*P, 2))/(2*pi*sqrt(det(Sg)));
wt = [0.4; -1.1];
Xdir = sum(gs.*exp(-1j*P*wt));
Xsum = 0;
for m1 = -3:3
    for m2 = -3:3
        d = wt - 2*pi*[m1; m2];
        Xsum = Xsum + exp(-0.5*d.'*Sg*d);
    end
end
assert(abs(Xdir - Xsum) < 1e-8)
fig = figure(Units="centimeters", Position=[2 2 4.6 4.2], Color="w");
ax = axes(fig);
imagesc(ax, [-3*pi 3*pi], [-3*pi 3*pi], X2), colormap(ax, flipud(gray(256))), axis(ax, "image")
hold(ax, "on")
for c = [-pi pi]
    plot(ax, [c c], [-3*pi 3*pi], "--", "Color", cmain, "LineWidth", 0.8)
    plot(ax, [-3*pi 3*pi], [c c], "--", "Color", cmain, "LineWidth", 0.8)
end
hold(ax, "off")
set(ax, "XTick", (-2:2)*pi, "YTick", (-2:2)*pi, "XTickLabel", ["$-2\pi$" "" "$0$" "" "$2\pi$"], ...
    "YTickLabel", ["$-2\pi$" "" "$0$" "" "$2\pi$"], "TickLabelInterpreter", "latex", "FontSize", 8, ...
    "XTickLabelRotation", 0)                     % no automatic rotation of the tick labels
xlabel(ax, "$\omega_2$", "Interpreter", "latex"), ylabel(ax, "$\omega_1$", "Interpreter", "latex")
exportgraphics(fig, fullfile(resfolder, "atip-05-dsft2d.png"), "Resolution", 300)
close(fig)
%%
%[text] ## Frequency response of the $3\\times3$ box filter
%[text] \[M\] Exercise "Frequency response": $H(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top})=\\frac19(1+2\\cos\\omega\_1)(1+2\\cos\\omega\_2)$, $\\mathcal{N}\_\\mathrm{h}=\\{-1,0,1\\}^2$.
hbox = ones(3)/9;
Nf = 64;
Hs = fft2(circshift(padarray(hbox, [Nf-3 Nf-3], 0, "post"), [-1 -1]));   % h[((n))_N], origin at the centre
[k2,k1] = meshgrid(0:Nf-1);
Hform = (1+2*cos(2*pi*k1/Nf)).*(1+2*cos(2*pi*k2/Nf))/9;
assert(max(abs(Hs(:) - Hform(:))) < 1e-12)
[w2,w1] = meshgrid(linspace(-pi, pi, 61));
Hb = (1+2*cos(w1)).*(1+2*cos(w2))/9;
fig = figure(Units="centimeters", Position=[2 2 5.0 4.0], Color="w");
ax = axes(fig);
mesh(ax, w2, w1, abs(Hb), "EdgeColor", ccool)
set(ax, "YDir", "reverse", "XTick", [-pi 0 pi], "YTick", [-pi 0 pi], "XTickLabel", ["$-\pi$" "$0$" "$\pi$"], ...
    "YTickLabel", ["$-\pi$" "$0$" "$\pi$"], "TickLabelInterpreter", "latex", "FontSize", 8)
xlabel(ax, "$\omega_2$", "Interpreter", "latex"), ylabel(ax, "$\omega_1$", "Interpreter", "latex")
axis(ax, "tight"), view(ax, -35, 35)
exportgraphics(fig, fullfile(resfolder, "atip-05-boxfreq.png"), "Resolution", 300)
close(fig)
%%
%[text] ## Multivariate DFT with a periodic structure matrix
%[text] $X\[\\boldsymbol{k}\]=\\sum\_{\\boldsymbol{n}\\in\\mathcal{N}(\\boldsymbol{N})}x\[\\boldsymbol{n}\]\\mathrm{e}^{-\\mathrm{j}\\boldsymbol{k}^\\top(2\\pi\\boldsymbol{N}^{-1})\\boldsymbol{n}}$, $\\boldsymbol{k}\\in\\mathcal{N}(\\boldsymbol{N}^\\top)$.
%[text] Direct implementation for a general $\\boldsymbol{N}$, checked against `fft2` for $\\boldsymbol{N}=\\mathrm{diag}(N\_1,N\_2)$.
Nr = diag([4 6]);
xr = magic(6); xr = xr(1:4,:);
assert(max(abs(dftN(xr, Nr) - fft2(xr)), [], "all") < 1e-9)
Nn = [2 1; 0 2];
Kset = fpdset(Nn.');
assert(size(Kset,2) == abs(det(Nn)))
atip.savetex("atip-05-dft-kset", strjoin(compose("\\begin{bmatrix}%d\\\\%d\\end{bmatrix}", Kset.'), ", "));
wsmp = 2*pi*(Nn.'\Kset)/pi;                    % frequency samples / pi
s = strings(1,size(Kset,2));
for k = 1:size(Kset,2)
    s(k) = "\begin{bmatrix}" + fracpi(wsmp(1,k)) + "\\" + fracpi(wsmp(2,k)) + "\end{bmatrix}";
end
atip.savetex("atip-05-dft-wset", strjoin(s, ", "));
%%
%[text] ## DFT matrix and FFT
%[text] \[M\] Example "Matrix representation of the 1-D DFT" with $N=4$: $[\\mathbf{W}\_N]\_{k,n}=W\_N^{kn}$, $W\_N=\\mathrm{e}^{-\\mathrm{j}2\\pi/N}$,
%[text] and $\\mathbf{W}\_N^{-1}=\\mathbf{W}\_N^\\mathsf{H}/N$.
N4 = 4;
W4 = exp(-1j*2*pi*(0:N4-1).'*(0:N4-1)/N4);
assert(norm(W4 - fft(eye(N4))) < 1e-12 && norm(inv(W4) - W4'/N4) < 1e-12)
c = strings(N4);
for r = 1:N4
    for k = 1:N4
        c(r,k) = cplxstr(W4(r,k));
    end
end
atip.savetex("atip-05-W4", strjoin(join(c, " & ", 2), "\\" + newline));
Nfft = 1024;
atip.savetex("atip-05-fft-N", atip.fmtint(Nfft));
atip.savetex("atip-05-fft-direct", atip.fmtint(Nfft^2));
atip.savetex("atip-05-fft-fast", atip.fmtint(Nfft*log2(Nfft)));
%%
%[text] ## Multivariate circular convolution by `imfilter` and by the DFT product
%[text] For the $3\\times 3$ box filter, `imfilter(x,h,"conv","circular")` (origin at the kernel centre) equals
%[text] `circshift(ifft2(H.*X),[-1 -1])`, where `H` is the DFT of `h` padded to the image size.
Xc = fft2(X);
Hc = fft2(fspecial("average"), size(X,1), size(X,2));
y1c = imfilter(X, fspecial("average"), "conv", "circular");
y2c = circshift(real(ifft2(Hc.*Xc)), [-1 -1]);
err = max(abs(y1c - y2c), [], "all");
assert(err < 1e-12)
atip.savetex("atip-05-cconv-err", texsci(err));
%%
%[text] ## Spectral norm and SVD
%[text] $\\|\\mathsf{T}\\|\_\\mathrm{S}=\\sqrt{\\lambda\_0(\\mathbf{T}^\\mathsf{H}\\mathbf{T})}=\\sigma\_0(\\mathbf{T})$ (largest singular value).
%[text] The circular right shift of \[M\] Example "Spectral norm" is isometric, so its spectral norm is 1.
Tsh = zeros(6);
for idx = 1:6
    e = zeros(2,3); e(idx) = 1;
    t = circshift(e, [0 1]);
    Tsh(:,idx) = t(:);
end
assert(abs(norm(Tsh) - 1) < 1e-12)
atip.savetex("atip-05-sn-shift", sprintf("%.4f", norm(Tsh)));
Ar = [1 2; 0 1; 1 0];
sv = svd(Ar);
assert(abs(norm(Ar) - sv(1)) < 1e-12 && abs(norm(Ar) - sqrt(max(eig(Ar'*Ar)))) < 1e-12)
atip.savetex("atip-05-sn-A", atip.arr2tex(Ar, "%d"));
atip.savetex("atip-05-sn-Asv", strjoin(compose("%.4f", sv.'), ", "));
%%
%[text] ## Spectral norm of the circular convolution
%[text] \[M\] Exercise "Spectral norm of the box filter": $\\boldsymbol{N}=\\mathrm{diag}(6,8)$; $\\|\\mathsf{T}\\|\_\\mathrm{S}=\\max\_{\\boldsymbol{k}}|H\[\\boldsymbol{k}\]|=|H\[\\mathbf{0}\]|=1$.
Ns = [6 8];
Tb = zeros(prod(Ns));
for idx = 1:prod(Ns)
    e = zeros(Ns); e(idx) = 1;
    t = imfilter(e, hbox, "conv", "circular");
    Tb(:,idx) = t(:);
end
hN = circshift(padarray(hbox, Ns-3, 0, "post"), [-1 -1]);      % periodized impulse response h_N
Hk = fft2(hN);
snT = norm(Tb); mxH = max(abs(Hk(:)));
assert(abs(snT - mxH) < 1e-12 && abs(snT - 1) < 1e-12)
% matrix form T = W^{-1} Lambda_h W (column-major vectorization)
WN = kron(fft(eye(Ns(2))), fft(eye(Ns(1))));
assert(norm(Tb - WN\diag(Hk(:))*WN) < 1e-10)
atip.savetex("atip-05-sn-box-T", sprintf("%.4f", snT));
atip.savetex("atip-05-sn-box-H", sprintf("%.4f", mxH));
atip.savetex("atip-05-sn-box-size", sprintf("%d\\times%d", size(Tb,1), size(Tb,2)));
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.
%%
function X = dftN(x, Nm)
% Multivariate DFT by the periodic structure matrix Nm (definition of [M] Sec. 4.1.3)
nset = fpdset(Nm); kset = fpdset(Nm.');
X = zeros(size(x));
for ik = 1:size(kset,2)
    k = kset(:,ik); acc = 0;
    for in = 1:size(nset,2)
        nn = nset(:,in);
        acc = acc + x(nn(1)+1, nn(2)+1)*exp(-1j*k.'*(2*pi*(Nm\nn)));
    end
    X(k(1)+1, k(2)+1) = acc;
end
end

function S = fpdset(Nm)
% Integer vectors in the fundamental parallelepiped FPD(Nm), sorted
r = max(abs(Nm), [], "all")*2;
[c2,c1] = meshgrid(-r:r);
cand = [c1(:) c2(:)].';
f = Nm\cand;
in = all(f >= -1e-12 & f < 1-1e-12, 1);
S = sortrows(cand(:,in).').';
end

function s = fracstr(v)
% Rational number as a LaTeX fraction
[nm,dn] = rat(v);
if dn == 1
    s = string(sprintf("%d", nm));
else
    s = string(sprintf("\\tfrac{%d}{%d}", nm, dn));
end
end

function s = fracpi(v)
% v*pi as a LaTeX string
[nm,dn] = rat(v);
if nm == 0
    s = "0";
elseif dn == 1
    s = string(sprintf("%d\\pi", nm));
else
    s = string(sprintf("\\tfrac{%d\\pi}{%d}", nm, dn));
end
s = replace(s, "1\pi", "\pi");
end

function s = cplxstr(z)
% Gaussian integer as a LaTeX string with the imaginary unit \iu
re = round(real(z)); im = round(imag(z));
if im == 0
    s = string(re);
elseif re == 0
    if im == 1, s = "\iu"; elseif im == -1, s = "-\iu"; else, s = im + "\iu"; end
else
    s = re + "+" + im + "\iu";
end
end

function s = texsci(v)
% Number in scientific notation for LaTeX
if v == 0
    s = "0";
    return
end
ex = floor(log10(v));
s = sprintf("%.1f\\times10^{%d}", v/10^ex, ex);
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
