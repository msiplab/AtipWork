%[text] # Lecture 9: Discrete Wavelet Transforms
%[text] Shogo Muramatsu, "Advanced Topics in Image Processing"
%[text] Verified: MATLAB R2026b
%[text] This script makes all figures and numbers of the slides of lecture 9 (atip2027-09).
%[text] The notation follows the reference text \[M\] (MsipText), Sections 6.3 (filter banks) and 6.4 (DWT):
%[text] input $\\mathbf{x}$, coefficients $\\mathbf{y}=\\mathbf{T}\\mathbf{x}$, output $\\hat{\\mathbf{x}}=\\mathbf{D}\\mathbf{y}$,
%[text] analysis/synthesis filters $h\_p\[n\]$/$f\_p\[n\]$, polyphase matrices $\\mathbf{E}(z)$/$\\mathbf{R}(z)$.
%[text] No toolbox other than the Image and Signal Processing Toolboxes is needed.
%[text:tableOfContents]{"heading":"Contents"}
%%
%[text] ## Preparation
[datfolder,resfolder] = atip.prjfolders();
cmain = [0 136 85]/255;     % main (green) #008855
ccool = [46 117 182]/255;   % cool (blue)  #2E75B6
cwarm = [197 90 17]/255;    % warm (orange) #C55A11
vec2tex = @(v,fmt) strjoin(compose(fmt, v), ",\ ");   % (a, b, c) style list
%%
%[text] ## Moving average and difference filter bank
%[text] Haar FB with the sign convention of \[M\] Example "Haar DWT" (Sec. 6.4.1): $H\_0(z)=\\frac{1}{2}(1+z^{-1})$,
%[text] $H\_1(z)=\\frac{1}{2}(-1+z^{-1})$ and the causal synthesis filters $F\_0(z)=z^{-1}(1+z^{-1})$, $F\_1(z)=z^{-1}(1-z^{-1})$;
%[text] decimation $y\_p\[m\]=v\_p\[2m\]$ and interpolation by $M=2$.  Input $x\[n\]=(0,3,1,3,1,5,3,0)$ of `sample09_01`.
h0 = [1 1]/2;  h1 = [-1 1]/2;
f0 = [0 1 1];  f1 = [0 1 -1];
x8 = [0 3 1 3 1 5 3 0];
y0 = downsample(conv(h0,x8),2);               % coarse (approximation) components, m = 0,1,...
y1 = downsample(conv(h1,x8),2);               % detail components
v = conv(f0,upsample(y0,2)) + conv(f1,upsample(y1,2));
assert(isequal(v(1:numel(x8)+2), [0 0 x8]))   % two-sample delay: xhat[n] = x[n-2]
y0 = y0(1:4), y1 = y1(1:4)                    % m = 0,...,3
assert(isequal(y0,[0 2 2 4]) && isequal(y1,[0 1 1 1]))
atip.savetex("atip-09-ma-x",  vec2tex(x8,"%d"));
atip.savetex("atip-09-ma-y0", vec2tex(y0,"%d"));
atip.savetex("atip-09-ma-y1", vec2tex(y1,"%d"));
%%
%[text] ## Polyphase decomposition and polyphase matrices
%[text] Serial-to-parallel conversion with the delay chain $\\mathbf{d}\_2(z)=(1\\ \\ z^{-1})^\\top$ (\[M\] Sec. 6.3.2):
%[text] $x\_0\[m\]=x\[2m\]$, $x\_1\[m\]=x\[2m-1\]$.  Polyphase matrices $\\mathbf{h}(z)=\\mathbf{E}(z^2)\\mathbf{d}\_2(z)$,
%[text] $\\mathbf{f}^\\top(z)=\\mathbf{d}\_2^\\top(z^{-1})\\mathbf{R}(z^2)$ with $\\mathbf{E}=\\frac12\\begin{pmatrix}1&1\\\\-1&1\\end{pmatrix}=\\frac{1}{\\sqrt{2}}\\mathbf{H}\_2\\mathbf{J}\_2$ and
%[text] $\\mathbf{R}(z)=z^{-1}\\mathbf{R}\_0$, $\\mathbf{R}\_0=\\begin{pmatrix}1&-1\\\\1&1\\end{pmatrix}=\\sqrt{2}\\mathbf{J}\_2\\mathbf{H}\_2$: $\\mathbf{R}(z)\\mathbf{E}(z)=z^{-1}\\mathbf{I}$ ($c=1$).
%[text] Block transform of the pairs $(x\[2m-1\],x\[2m\])$ (Example "Block transform"): $\\mathbf{A}=\\mathbf{E}\\mathbf{J}\_2=\\frac{1}{\\sqrt{2}}\\mathbf{H}\_2$, $\\mathbf{B}=\\mathbf{J}\_2\\mathbf{R}\_0=\\sqrt{2}\\mathbf{H}\_2$.
x0 = x8(1:2:end), x1 = [0 x8(2:2:end-1)]
E = [1 1; -1 1]/2;
R0 = [1 -1; 1 1];
assert(isequal(E, [h0; h1]))                         % h(z) = E(z^2) d_2(z)
assert(isequal([f0; f1], [0 R0(2,1) R0(1,1); 0 R0(2,2) R0(1,2)]))   % f^T(z) = d_2^T(z^{-1}) z^{-2} R0
Y = E*[x0; x1]
assert(isequal(Y, [y0; y1]))
Xr = R0*Y;
assert(isequal(Xr, [x0; x1]))
assert(isequal(R0*E, eye(2)))
H2 = [1 1; 1 -1]/sqrt(2); J2 = fliplr(eye(2));
assert(norm(E - H2*J2/sqrt(2)) < 1e-12 && norm(R0 - sqrt(2)*J2*H2) < 1e-12)
A = E*J2;  B = J2*R0;
assert(norm(A - H2/sqrt(2)) < 1e-12 && norm(B - sqrt(2)*H2) < 1e-12 && norm(B*A - eye(2)) < 1e-12)
atip.savetex("atip-09-ph-x0", vec2tex(x0,"%d"));
atip.savetex("atip-09-ph-x1", vec2tex(x1,"%d"));
atip.savetex("atip-09-RE", atip.arr2tex(R0*E,"%d"));
%%
%[text] ## Bivariate extension: 2x2 Haar kernels and subband images
%[text] Separable processing of $2\\times 2$ blocks: $\\mathbf{A}\\otimes\\mathbf{A}$ (analysis) and $\\mathbf{B}\\otimes\\mathbf{B}$ (synthesis).
%[text] Rows of $\\mathbf{A}\\otimes\\mathbf{A}$ reshaped to $2\\times2$ are the weights of the four channels,
%[text] columns of $\\mathbf{B}\\otimes\\mathbf{B}$ the synthesis patterns (block-wise basis images).
E2 = kron(A,A);  R2 = kron(B,B);
assert(norm(R2*E2 - eye(4)) < 1e-12)
chname = ["ll","hl","lh","hh"];
% Order of the channels: (p_v,p_h) = (0,0),(0,1),(1,0),(1,1); vec is column-major
order = [1 3 2 4];   % kron(A,A) row index for (p_v,p_h): p_h + 2*p_v -> kron index p_v + 2*p_h
W = cell(1,4); S = cell(1,4);
for k = 1:4
    W{k} = reshape(E2(order(k),:), 2, 2);     % analysis weights on the block [a b; c d]
    S{k} = reshape(R2(:,order(k)), 2, 2);     % synthesis pattern
    atip.savetex("atip-09-ka-" + chname(k), atip.arr2tex(round(4*W{k}),"%d"));
    atip.savetex("atip-09-ks-" + chname(k), atip.arr2tex(round(S{k}),"%d"));
end
X = im2double(imread("cameraman.tif"));
blk = @(X,r,c) X(r:2:end, c:2:end);
a = blk(X,1,1); b = blk(X,1,2); c = blk(X,2,1); d = blk(X,2,2);
ysub = cell(1,4);
for k = 1:4
    ysub{k} = W{k}(1,1)*a + W{k}(1,2)*b + W{k}(2,1)*c + W{k}(2,2)*d;
end
[yLL, yHL, yLH, yHH] = ysub{:};
% synthesis and perfect reconstruction
Xr = zeros(size(X));
for k = 1:4
    Xr(1:2:end,1:2:end) = Xr(1:2:end,1:2:end) + S{k}(1,1)*ysub{k};
    Xr(1:2:end,2:2:end) = Xr(1:2:end,2:2:end) + S{k}(1,2)*ysub{k};
    Xr(2:2:end,1:2:end) = Xr(2:2:end,1:2:end) + S{k}(2,1)*ysub{k};
    Xr(2:2:end,2:2:end) = Xr(2:2:end,2:2:end) + S{k}(2,2)*ysub{k};
end
assert(norm(Xr - X, "fro") < 1e-12)
gain = 4;  % amplification of the detail subbands for display
mosaic = [yLL, 0.5+gain*yHL; 0.5+gain*yLH, 0.5+gain*yHH];
imwrite(min(max(mosaic,0),1), fullfile(resfolder,"atip-09-subband.png"))
imwrite(X, fullfile(resfolder,"atip-09-cameraman.png"))
%%
%[text] ## Issues of block transforms: JPEG artifacts
%[text] Coarse quantization of the $8\\times 8$ block DCT coefficients (JPEG, quality 10) causes blocking artifacts
%[text] in flat regions and mosquito artifacts around edges.
tmpjpg = [tempname '.jpg'];
cleaner = onCleanup(@() delete(tmpjpg));
Xb = rgb2gray(imread(fullfile(datfolder,"barbaraFaceRgb.tif")));
imwrite(Xb, tmpjpg, "Quality", 10);
Jb = imread(tmpjpg);
psnrB = psnr(Jb, Xb)
Xm = imread("cameraman.tif");
imwrite(Xm, tmpjpg, "Quality", 10);
Jm = imread(tmpjpg);
psnrM = psnr(Jm, Xm)
cropB = Jb(41:160, 101:220);                  % face and scarf
cropM = Jm(21:140, 71:190);                   % head, camera and sky
imwrite(imresize(cropB, 3, "nearest"), fullfile(resfolder,"atip-09-blocking.png"))
imwrite(imresize(cropM, 3, "nearest"), fullfile(resfolder,"atip-09-mosquito.png"))
atip.savetex("atip-09-jpg-psnrb", sprintf("%.2f", psnrB));
atip.savetex("atip-09-jpg-psnrm", sprintf("%.2f", psnrM));
%%
%[text] ## Lapped transform: Daubechies-2 (DB2) filter bank
%[text] Analysis filters ($n\\in\\{0,1,2,3\\}$)
%[text] $h\_0\[n\]=2^{-5/2}(1-\\sqrt{3},\\ 3-\\sqrt{3},\\ 3+\\sqrt{3},\\ 1+\\sqrt{3})$,
%[text] $h\_1\[n\]=2^{-5/2}(-1-\\sqrt{3},\\ 3+\\sqrt{3},\\ -3+\\sqrt{3},\\ 1-\\sqrt{3})$.
s3 = sqrt(3);
hd0 = [1-s3, 3-s3, 3+s3, 1+s3]/(4*sqrt(2));
hd1 = [-1-s3, 3+s3, -3+s3, 1-s3]/(4*sqrt(2));
assert(abs(sum(hd0) - sqrt(2)) < 1e-12 && abs(sum(hd1)) < 1e-12)   % DC gains
if exist("wfilters","file")       % Wavelet Toolbox (optional check)
    [LoD,HiD] = wfilters("db2");
    assert(norm(LoD - hd0) < 1e-12 && norm(HiD - hd1) < 1e-12)
end
%[text] Type-I polyphase matrix of the analysis FB, $\\mathbf{h}(z)=\\mathbf{E}(z^2)\\mathbf{d}\_2(z)$, $\\mathbf{d}\_2(z)=(1,\\ z^{-1})^\\top$:
%[text] $\\mathbf{E}(z)=\\mathbf{E}\_0+\\mathbf{E}\_1z^{-1}$.
E0 = [hd0(1) hd0(2); hd1(1) hd1(2)]
E1 = [hd0(3) hd0(4); hd1(3) hd1(4)]
%[text] Synthesis FB as the adjoint (delayed): $\\mathbf{R}(z)=z^{-1}\\mathbf{E}^\\top(z^{-1})=\\mathbf{R}\_0+\\mathbf{R}\_1z^{-1}$,
%[text] $\\mathbf{R}\_0=\\mathbf{E}\_1^\\top$, $\\mathbf{R}\_1=\\mathbf{E}\_0^\\top$.
R0 = E1.';  R1 = E0.';
P0 = R0*E0, P1 = R0*E1 + R1*E0, P2 = R1*E1
assert(norm(P0) < 1e-12 && norm(P1 - eye(2)) < 1e-12 && norm(P2) < 1e-12)
%[text] Check with the polyphase matrix class `msip.ppmatrix` (third index = power of $z^{-1}$)
Ez = msip.ppmatrix(cat(3,E0,E1));
Rz = msip.ppmatrix(cat(3,R0,R1));
PRz = double(Rz*Ez);
assert(norm(PRz(:,:,1)) < 1e-12 && norm(PRz(:,:,2) - eye(2)) < 1e-12 && norm(PRz(:,:,3)) < 1e-12)
atip.savetex("atip-09-db2-E0", atip.arr2tex(E0,"%.4f"));
atip.savetex("atip-09-db2-E1", atip.arr2tex(E1,"%.4f"));
%[text] Time-domain check: the output is the input delayed by $Mc=2$ samples when $f\_p\[n\]=h\_p\[2-n\]$.
%[text] With the causal synthesis filters $h\_p\[3-n\]$ the delay becomes 3.
xr = randn(1,32);
yy0 = downsample(conv(hd0,xr),2); yy1 = downsample(conv(hd1,xr),2);
xh = conv(fliplr(hd0),upsample(yy0,2)) + conv(fliplr(hd1),upsample(yy1,2));
assert(norm(xh(4:3+numel(xr)) - xr) < 1e-12)
%[text] Impulse and magnitude responses of the analysis filters
% Axes at fixed inner positions (cm); each legend is put right above its own plot box
% (MATLAB leaves a large gap below northoutside legends).  Compact size: shown small on the slide.
apos = [0.85 0.8 2.45 1.5; 3.8 0.8 2.5 1.5];
fig = figure(Units="centimeters", Position=[2 2 7.0 3.3], Color="w");
ax = axes(fig, "Units", "centimeters", "Position", apos(1,:));
stem(ax, 0:3, hd0, "filled", "Color", cmain, "MarkerSize", 3), hold(ax, "on")
stem(ax, (0:3)+0.15, hd1, "filled", "Color", cwarm, "MarkerSize", 3), hold(ax, "off")
xlim(ax, [-0.5 3.7]), ylim(ax, [-0.6 1.0]), grid(ax, "on")
xlabel(ax, "$n$", "Interpreter", "latex")
lgs = legend(ax, ["$h_0[n]$","$h_1[n]$"], "Interpreter", "latex", "Orientation", "horizontal", "FontSize", 7, "Box", "off");
set(ax, "FontSize", 8, "TickLabelInterpreter", "latex")
ax = axes(fig, "Units", "centimeters", "Position", apos(2,:));
[H0w,w] = freqz(hd0,1,512); H1w = freqz(hd1,1,512);
plot(ax, w, abs(H0w), "Color", cmain, "LineWidth", 1.2), hold(ax, "on")
plot(ax, w, abs(H1w), "Color", cwarm, "LineWidth", 1.2), hold(ax, "off")
xlim(ax, [0 pi]), ylim(ax, [0 1.6]), grid(ax, "on")
xticks(ax, [0 pi/2 pi]), xticklabels(ax, ["$0$","$\pi/2$","$\pi$"])
xlabel(ax, "$\omega$", "Interpreter", "latex")
lgs(2) = legend(ax, ["$|H_0(\mathrm{e}^{\mathrm{j}\omega})|$","$|H_1(\mathrm{e}^{\mathrm{j}\omega})|$"], "Interpreter", "latex", "Orientation", "horizontal", "FontSize", 7, "Box", "off");
set(ax, "FontSize", 8, "TickLabelInterpreter", "latex")
set(lgs, "ItemTokenSize", [10 8])
drawnow
for k = 1:2
    lgs(k).Location = "none"; lgs(k).Units = "centimeters";
    lp = lgs(k).Position;
    lgs(k).Position(1:2) = [apos(k,1) + (apos(k,3) - lp(3))/2, apos(k,2) + apos(k,4) + 0.03];
end
exportgraphics(fig, fullfile(resfolder,"atip-09-db2.png"), "Resolution", 300)
close(fig)
%%
%[text] ## Lifting structure: Le Gall-Tabatabai (LGT) 5/3 filter bank
%[text] Prediction $P(z)=-(z^{+1}+1)/2$ and update $U(z)=(1+z^{-1})/4$ on the polyphase components.
%[text] The impulse responses of the analysis filters are obtained by applying the lifting steps to unit impulses.
N = 16;
resp0 = zeros(1,N); resp1 = zeros(1,N);
for n0 = 1:N
    xi = zeros(1,N); xi(n0) = 1;
    xo = xi(1:2:end); xe = xi(2:2:end);       % x[2m-1] (odd) and x[2m] (even), m = 1..N/2
    % prediction: d[m] = x[2m] - (x[2m-1] + x[2m+1])/2
    xoNext = [xo(2:end) 0];
    dm = xe - (xo + xoNext)/2;
    % update: y0[m] = x[2m-1] + (d[m] + d[m-1])/4
    dPrev = [0 dm(1:end-1)];
    ym = xo + (dm + dPrev)/4;
    resp0(n0) = ym(4);  resp1(n0) = dm(4);    % responses at m = 4
end
h0lgt = fliplr(resp0(resp0 ~= 0));   % impulse response (time reversed contribution)
h1lgt = fliplr(resp1(resp1 ~= 0));
assert(norm(h0lgt - [-1 2 6 2 -1]/8) < 1e-12 && norm(h1lgt - [-1 2 -1]/2) < 1e-12)
atip.savetex("atip-09-lgt-h0", vec2tex(8*h0lgt,"%d"));
atip.savetex("atip-09-lgt-h1", vec2tex(2*h1lgt,"%d"));
%%
%[text] ## Bivariate DWT (3-level Haar) and multiresolution analysis
%[text] The lowpass subband $\\mathbf{y}\_{\\mathrm{LL}}$ is decomposed repeatedly (tree structure).
J = 3;
L = X; tiles = cell(J,1);
for j = 1:J
    a = blk(L,1,1); b = blk(L,1,2); c = blk(L,2,1); d = blk(L,2,2);
    LL = (a+b+c+d)/2;  HL = (a-b+c-d)/2;  LH = (a+b-c-d)/2;  HH = (a-b-c+d)/2;  % orthonormal, A = H2/sqrt(2)
    tiles{j} = {HL, LH, HH};
    L = LL;
end
mos = L/2^J;                         % scale the lowpass subband back to [0,1]
for j = J:-1:1
    t = tiles{j}; g = 2;            % detail amplification for display
    mos = [mos, 0.5+g*t{1}; 0.5+g*t{2}, 0.5+g*t{3}];
end
imwrite(min(max(mos,0),1), fullfile(resfolder,"atip-09-dwt2.png"))
%[text] Energy compaction: ratio of the energy in the lowest subband (orthonormal transform)
ratioLL = sum(L(:).^2)/sum(X(:).^2)*100
atip.savetex("atip-09-dwt-ll", sprintf("%.1f", ratioLL));
atip.savetex("atip-09-dwt-llsize", sprintf("%d\\times %d", size(L)));
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
