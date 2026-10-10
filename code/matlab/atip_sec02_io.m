%[text] # Lecture 2: Input and Output of Images
%[text] Shogo Muramatsu, "Advanced Topics in Image Processing"
%[text] Verified: MATLAB R2026b
%[text] This script makes all figures and numbers of the slides of lecture 2 (atip2027-02).
%[text] The notation follows the reference text \[M\] (MsipText), Chapter 2: Sections 2.1.4 (power-law transform),
%[text] 2.2.1--2.2.2 (histogram and histogram equalization), 2.3.1 (grayscale conversion) and 2.3.3 (YCbCr, HSV).
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
%[text] ## Image input and grayscale conversion
%[text] Grayscale conversion is the inner product $y=\\phi(\\vec{x})=a\_0x\_\\mathrm{R}+a\_1x\_\\mathrm{G}+a\_2x\_\\mathrm{B}$
%[text] (\[M\] Example "Grayscale conversion", Section 2.3.1).  The coefficients used by `rgb2gray` are obtained by
%[text] converting the three unit vectors (pure R, G and B pixels).
a = squeeze(rgb2gray(reshape(eye(3),[1 3 3])))
assert(all(abs(a(:).' - [0.299 0.587 0.114]) < 2e-3))   % ITU-R BT.601
for k = 1:3
    atip.savetex("atip-02-gray-a" + (k-1), sprintf("%.4f", a(k)));
end
%[text] The image of the 2026 slides (firenzeRgb.jpg in the data folder).
P = imread(fullfile(datfolder, "firenzeRgb.jpg"));
G = uint8(a(1)*double(P(:,:,1)) + a(2)*double(P(:,:,2)) + a(3)*double(P(:,:,3)));
assert(max(abs(double(G(:)) - double(reshape(rgb2gray(P),[],1)))) <= 1)
imwrite(imresize(P, 0.5), fullfile(resfolder, "atip-02-firenze.png"))
imwrite(imresize(G, 0.5), fullfile(resfolder, "atip-02-firenze-gray.png"))
sz = size(P);
atip.savetex("atip-02-firenze-size", sprintf("%d\\times %d\\times %d", sz));
%[text] One pixel as a numerical example, $\\vec{x}\[n\_\\mathrm{v},n\_\\mathrm{h}\]$ at $(n\_\\mathrm{v},n\_\\mathrm{h})=(100,400)$
xp = double(squeeze(P(101,401,:))).'
yp = a(:).'*xp(:)
atip.savetex("atip-02-gray-xp", strjoin(string(xp), "\quad "));
atip.savetex("atip-02-gray-yp", sprintf("%.2f", yp));
atip.savetex("atip-02-gray-ypr", sprintf("%d", G(101,401)));
%%
%[text] ## Video input
%[text] `VideoReader` gives the frame size, the frame rate and the number of frames.  Four frames of
%[text] shuttle.avi (a MATLAB demo video) are tiled in a row.
vr = VideoReader("shuttle.avi");
atip.savetex("atip-02-shuttle-size", sprintf("%d\\times %d", vr.Height, vr.Width));
atip.savetex("atip-02-shuttle-fps", sprintf("%g", vr.FrameRate));
atip.savetex("atip-02-shuttle-nframes", sprintf("%d", vr.NumFrames));
idx = round(linspace(0, vr.NumFrames-1, 4));     % frame numbers n_t (from 0)
frames = cell(1,4);
for k = 1:4
    frames{k} = read(vr, idx(k)+1);
end
imwrite(imtile(frames, "GridSize", [1 4], "BorderSize", 4, "BackgroundColor", "w"), ...
    fullfile(resfolder, "atip-02-shuttle.png"))
atip.savetex("atip-02-shuttle-idx", strjoin(string(idx), ",\,"));
%%
%[text] ## Video processing
%[text] The first frame of calcio (calcio000.jpg, the sequence behind calcio.avi) and its grayscale version.
F = imread(fullfile(datfolder, "calcio000.jpg"));
imwrite(imresize(F, 2, "nearest"), fullfile(resfolder, "atip-02-calcio.png"))
imwrite(imresize(rgb2gray(F), 2, "nearest"), fullfile(resfolder, "atip-02-calcio-gray.png"))
atip.savetex("atip-02-calcio-size", sprintf("%d\\times %d", size(F,1), size(F,2)));
%%
%[text] ## Power-law transform
%[text] $y=\\phi(x)=cx^\\gamma$, $x\\in\[0,1\]$ (\[M\] Section 2.1.4).  For unsigned integers with $L$ levels,
%[text] $y=(L-1)\\left(\\frac{x}{L-1}\\right)^\\gamma$.  Example: $L=256$, $x=64$.
L = 256; x0 = 64;
yb = (L-1)*(x0/(L-1))^0.5      % gamma = 0.5 (brighten)
yd = (L-1)*(x0/(L-1))^2        % gamma = 2   (darken)
assert(round(yb) == 128 && round(yd) == 16)
atip.savetex("atip-02-pow-yb", sprintf("%.2f", yb));
atip.savetex("atip-02-pow-ybr", sprintf("%d", round(yb)));
atip.savetex("atip-02-pow-yd", sprintf("%.2f", yd));
atip.savetex("atip-02-pow-ydr", sprintf("%d", round(yd)));
%%
%[text] ## Histograms of images
%[text] The histogram $h\_x$ counts the pixels with the value $x\\in\\{0,1,\\ldots,L-1\\}$ (\[M\] Section 2.2.1).
%[text] Four versions of the stone statue face (msipimg05) made by the scalar functions of \[M\] Section 2.1:
%[text] dark ($\\gamma=2$), bright ($\\gamma=0.5$), low contrast (scale $1/2$ and bias $1/4$) and high contrast
%[text] (contrast stretching with $\\gamma=0.4$).
X = im2double(atip.msipimg(5, 256, "gray"));
stretch = @(x,g) (x<0.5).*(1-(1-2*x).^g)/2 + (x>=0.5).*(1+(2*x-1).^g)/2;
versions = struct( ...
    "name", {"dark", "bright", "low", "high"}, ...
    "img",  {X.^2, X.^0.5, X/2+1/4, stretch(X,0.4)});
hfig = @() figure(Units="centimeters", Position=[2 2 4.2 2.6], Color="w");
for k = 1:numel(versions)
    U = im2uint8(versions(k).img);
    imwrite(U, fullfile(resfolder, "atip-02-hist-" + versions(k).name + ".png"))
    hx = histcounts(U, -0.5:1:255.5);
    fig = hfig();
    ax = axes(fig);
    bar(ax, 0:255, hx, 1, "FaceColor", cmain, "EdgeColor", "none")
    xlim(ax, [-1 256]), xticks(ax, [0 128 255]), yticks(ax, [])
    xlabel(ax, "$x$", "Interpreter", "latex"), ylabel(ax, "$h_x$", "Interpreter", "latex")
    set(ax, "FontSize", 8, "Box", "off", "TickDir", "out")
    exportgraphics(fig, fullfile(resfolder, "atip-02-hist-" + versions(k).name + "-h.png"), "Resolution", 300)
    close(fig)
end
%%
%[text] ## Histogram equalization: worked example
%[text] \[M\] Exercise "Histogram equalization" (Section 2.2.2): $L=8$, $6\\times 8$ array.
%[text] LUT $y=\\phi(x)=\\left\\lfloor (L-1)\\sum\_{v=0}^{x}p\_v\\right\\rceil$ with $p\_x=h\_x/N$.
x = [2 2 3 1 2 4 1 1;
     3 4 4 3 2 3 4 2;
     4 4 4 3 4 5 5 4;
     0 4 6 4 2 3 4 2;
     2 2 2 3 5 1 3 3;
     2 1 4 3 4 1 6 0];
L = 8; N = numel(x);
h = histcounts(x, -0.5:1:L-0.5)          % h_x, x = 0,...,L-1
p = h/N;                                 % p_x
c = (L-1)*cumsum(p)                      % before rounding
phi = round(c)                           % LUT
y = phi(x+1)                             % y = phi(x)
assert(isequal(h, [2 6 11 10 14 3 2 0]) && isequal(phi, [0 1 3 4 6 7 7 7]))
atip.savetex("atip-02-he-x",   atip.arr2tex(x, "%d"));
atip.savetex("atip-02-he-h",   strjoin(string(h), " & "));
atip.savetex("atip-02-he-c",   strjoin(compose("%.2f", c), " & "));
atip.savetex("atip-02-he-phi", strjoin(string(phi), " & "));
atip.savetex("atip-02-he-y",   atip.arr2tex(y, "%d"));
atip.savetex("atip-02-he-N",   sprintf("%d", N));
atip.savetex("atip-02-he-ex1", sprintf( ...                % phi(1) as in the solution of [M]
    "\\phi(1)=\\msipround{%d\\times\\left(\\frac{%d}{%d}+\\frac{%d}{%d}\\right)}=\\msipround{%.4f}=%d", ...
    L-1, h(1), N, h(2), N, c(2), phi(2)));
%%
%[text] ## Histogram equalization of images
%[text] The LUT of \[M\] Section 2.2.2 is applied to the dark and the bright versions ($L=256$).
%[text] The result is compared with `histeq(U,256)` of the Image Processing Toolbox, which uses a slightly different rule.
for name = ["dark", "bright"]
    U = imread(fullfile(resfolder, "atip-02-hist-" + name + ".png"));
    hx = histcounts(U, -0.5:1:255.5);
    lut = uint8(round(255*cumsum(hx)/numel(U)));
    V = lut(double(U)+1);
    Vref = histeq(U, 256);
    fprintf("%s: mean |LUT - histeq| = %.2f\n", name, mean(abs(double(V(:))-double(Vref(:)))));
    imwrite(V, fullfile(resfolder, "atip-02-histeq-" + name + ".png"))
    hy = histcounts(V, -0.5:1:255.5);
    fig = hfig();
    ax = axes(fig);
    bar(ax, 0:255, hy, 1, "FaceColor", ccool, "EdgeColor", "none")
    xlim(ax, [-1 256]), xticks(ax, [0 128 255]), yticks(ax, [])
    xlabel(ax, "$y$", "Interpreter", "latex"), ylabel(ax, "$h_y$", "Interpreter", "latex")
    set(ax, "FontSize", 8, "Box", "off", "TickDir", "out")
    exportgraphics(fig, fullfile(resfolder, "atip-02-histeq-" + name + "-h.png"), "Resolution", 300)
    close(fig)
    % LUT phi(x) (scaled cumulative histogram)
    fig = hfig();
    ax = axes(fig);
    plot(ax, 0:255, double(lut), "Color", cwarm, "LineWidth", 1.2)
    xlim(ax, [0 255]), ylim(ax, [0 255]), xticks(ax, [0 128 255]), yticks(ax, [0 128 255])
    xlabel(ax, "$x$", "Interpreter", "latex"), ylabel(ax, "$y=\phi(x)$", "Interpreter", "latex")
    set(ax, "FontSize", 8, "Box", "off", "TickDir", "out"), grid(ax, "on")
    exportgraphics(fig, fullfile(resfolder, "atip-02-histeq-" + name + "-lut.png"), "Resolution", 300)
    close(fig)
end
%%
%[text] ## RGB cube
%[text] The RGB space as a unit cube (\[M\] Fig. 2.8).  Each point is coloured by its own RGB value.
%[text] (a) oblique view, (b) view along the grey axis from white to black (hexagon).
[Vc, Fc] = deal([0 0 0; 1 0 0; 1 1 0; 0 1 0; 0 0 1; 1 0 1; 1 1 1; 0 1 1], ...
    [1 2 3 4; 5 6 7 8; 1 2 6 5; 2 3 7 6; 3 4 8 7; 4 1 5 8]);
views = {[115 22], [1 1 1]};
names = ["rgbcube", "rgbcube-top"];
vnames = ["Black","Red","Yellow","Green","Blue","Magenta","White","Cyan"];
loff = 0.07;                                     % label offset from a silhouette vertex (screen units)
lcol = [0.25 0.25 0.25];
for k = 1:2
    fig = figure(Units="centimeters", Position=[2 2 4.5 4.5], Color="w");
    ax = axes(fig);
    patch(ax, "Vertices", Vc, "Faces", Fc, "FaceVertexCData", Vc, ...
        "FaceColor", "interp", "EdgeColor", [0.5 0.5 0.5])
    axis(ax, "equal", "off"), axis(ax, [-0.4 1.4 -0.4 1.4 -0.4 1.4]), view(ax, views{k})
    hold(ax, "on")
    % Labels are placed in screen coordinates, outward from the projected centre of the cube, so that
    % they never cover the cube.  The vertex projected inside the silhouette (white) gets a leader line
    % to the largest free angular gap between the other labels.
    [az, el] = view(ax);
    T = viewmtx(az, el);
    Ps = T(1:2,1:3);                             % data -> screen (orthographic)
    pr = Ps(1,:); pu = Ps(2,:);                  % screen right / up directions in data coordinates
    d2 = Ps*(Vc - 0.5).';                        % projected vertices relative to the centre
    rad = vecnorm(d2);
    outer = setdiff(find(rad > 0.5), 1);         % silhouette vertices (black is hidden)
    for m = outer
        u = d2(:,m)/rad(m);
        pos = Vc(m,:) + loff*(u(1)*pr + u(2)*pu);
        [ha, va] = labelalign(u);
        text(ax, pos(1), pos(2), pos(3), vnames(m), "FontSize", 7, ...
            "HorizontalAlignment", ha, "VerticalAlignment", va, "Color", lcol)
    end
    m = 7;                                       % white: inside the silhouette
    ang = sort(atan2(d2(2,outer), d2(1,outer)));
    gaps = diff([ang ang(1)+2*pi]);
    mids = ang + gaps/2;                         % middle of each gap
    cand = find(gaps > max(gaps) - 1e-6);        % largest gap(s); on a tie prefer the upper right
    [~, g] = min(abs(angle(exp(1i*(mids(cand) - pi/4)))));
    th = mids(cand(g));
    u = [cos(th); sin(th)];
    r0 = max(rad(outer)) + loff;                 % just outside the silhouette
    tip = 0.5 + r0*(u(1)*pr + u(2)*pu);
    plot3(ax, [Vc(m,1) tip(1)], [Vc(m,2) tip(2)], [Vc(m,3) tip(3)], "-", "Color", lcol, "LineWidth", 0.5)
    plot3(ax, Vc(m,1), Vc(m,2), Vc(m,3), ".", "Color", lcol, "MarkerSize", 6)
    [ha, va] = labelalign(u);
    pos = tip + 0.02*(u(1)*pr + u(2)*pu);
    text(ax, pos(1), pos(2), pos(3), vnames(m), "FontSize", 7, ...
        "HorizontalAlignment", ha, "VerticalAlignment", va, "Color", lcol)
    hold(ax, "off")
    exportgraphics(fig, fullfile(resfolder, "atip-02-" + names(k) + ".png"), "Resolution", 300)
    close(fig)
end
%%
%[text] ## YCbCr space (ITU-R BT.601)
%[text] Affine transform $\\vec{y}=\\boldsymbol{A}\\vec{x}+\\vec{b}$ (\[M\] Example "YCbCr space", Section 2.3.3).
%[text] $\\boldsymbol{A}$ and $\\vec{b}$ are measured from `rgb2ycbcr` (double input in $\[0,1\]$).
b = squeeze(rgb2ycbcr(zeros(1,1,3)));
A = squeeze(rgb2ycbcr(reshape(eye(3),[1 3 3]))).' - b;   % column k = response to unit vector k
A256 = 256*A
Ainv = inv(A)
bt601 = [65.7380 129.0570 25.0640; -37.9450 -74.4940 112.4390; 112.4390 -94.1540 -18.2850];
assert(max(abs(A256(:)-bt601(:))) < 1e-3)                % values of [M] (rounded)
assert(max(abs(255*b(:)-[16;128;128])) < 1e-10)
fmt4 = @(M) regexprep(atip.arr2tex(M, "%.4f"), "-?0\.0000", "0");
atip.savetex("atip-02-ycc-A", atip.arr2tex(A256, "%.3f"));    % 3 decimals as in [M]
atip.savetex("atip-02-ycc-Ainv", fmt4(Ainv));
%[text] Components of the bouquet image (msipimg02)
P2 = atip.msipimg(2, 256);
Q = rgb2ycbcr(P2);
imwrite(P2, fullfile(resfolder, "atip-02-bouquet.png"))
cnames = ["y","cb","cr"];
for k = 1:3
    imwrite(Q(:,:,k), fullfile(resfolder, "atip-02-ycc-" + cnames(k) + ".png"))
end
%%
%[text] ## HSV space
%[text] \[M\] Example "HSV space" (Section 2.3.3).  Numerical example for an orange pixel.
xo = [0.8 0.5 0.2];
xmax = max(xo); xmin = min(xo);
yV = xmax; yS = (xmax-xmin)/xmax;
yH = (60 - 60*(xmax-xo(2))/(xmax-xmin))/360;      % x_R = x_max and x_G ~= x_min
assert(norm(rgb2hsv(xo) - [yH yS yV]) < 1e-12)
atip.savetex("atip-02-hsv-x", strjoin(compose("%.1f", xo), "\quad "));
atip.savetex("atip-02-hsv-xmax", sprintf("%.1f", xmax));
atip.savetex("atip-02-hsv-xmin", sprintf("%.1f", xmin));
atip.savetex("atip-02-hsv-S", sprintf("%.2f", yS));
atip.savetex("atip-02-hsv-Hdeg", sprintf("%g", 360*yH));
atip.savetex("atip-02-hsv-H", sprintf("%.4f", yH));
%[text] H, S and V components of the bouquet image
U = rgb2hsv(P2);
cnames = ["h","s","v"];
for k = 1:3
    imwrite(U(:,:,k), fullfile(resfolder, "atip-02-hsv-" + cnames(k) + ".png"))
end
%[text] Hue wheel ($y\_\\mathrm{V}=1$): angle = hue, radius = saturation
n = 401;
[u1,u2] = meshgrid(linspace(-1,1,n));
rho = hypot(u1,u2);
hue = mod(atan2(-u2,u1)/(2*pi), 1);          % counter-clockwise from red (image rows point downward)
W = hsv2rgb(cat(3, hue, min(rho,1), ones(n)));
W(repmat(rho>1,[1 1 3])) = 1;                 % white outside the disc
imwrite(W, fullfile(resfolder, "atip-02-huewheel.png"))
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

function [ha, va] = labelalign(u)
% LABELALIGN Text alignment for a label placed in the screen direction u (unit 2-vector) from its anchor
if u(1) > 0.35, ha = "left"; elseif u(1) < -0.35, ha = "right"; else, ha = "center"; end
if u(2) > 0.35, va = "bottom"; elseif u(2) < -0.35, va = "top"; else, va = "middle"; end
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
