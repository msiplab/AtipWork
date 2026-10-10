%[text] # Lecture 12: Image Restoration
%[text] Shogo Muramatsu, "Advanced Topics in Image Processing"
%[text] Verified: MATLAB R2026b
%[text] This script makes all figures and numbers of the slides of lecture 12 (atip2027-12).
%[text] The notation follows the reference text \[M\] (MsipText), Chapter 8 (image restoration),
%[text] Sections 1.3.3 and 1.4.2, Section 7.4 and Appendix A.6 (convex optimization):
%[text] observation $\\mathbf{v}=\\mathbf{H}\\mathbf{x}+\\mathbf{w}$, synthesis model $\\mathbf{x}=\\mathbf{D}\\mathbf{s}$,
%[text] step size $\\eta$, soft thresholding $\\phi\_\\mathrm{ST}(\\cdot;\\tau)$.
%[text:tableOfContents]{"heading":"Contents"}
%%
%[text] ## Preparation
%[text] Figures and LaTeX snippets are written to the `results` folder.  AtipSlides imports them with
%[text] `tools/sync-results.ps1`.  The figure colours are the three colours of the MSIP Lab logo and grey.
[~,resfolder] = atip.prjfolders();
cmain = [0 136 85]/255;     % main (green) #008855
ccool = [46 117 182]/255;   % cool (blue)  #2E75B6
cwarm = [197 90 17]/255;    % warm (orange) #C55A11
mag = 3;                    % magnification of 96x96 images (nearest neighbour) for the slides
saveimg = @(X,name) imwrite(imresize(min(max(X,0),1),mag,"nearest"), fullfile(resfolder,name));
%%
%[text] ## Original image and observation model
%[text] As in Example "Deblurring" of \[M\] Section 1.3.3 and Example "Observation model in the pixel domain"
%[text] of \[M\] Section 8.1.2: $\\mathbf{x}\\in\[0,1\]^{96\\times 96}$ (msipimg08, watermelon),
%[text] $\\mathbf{H}$ is the circular convolution with the Gaussian filter of $\\sigma\_\\mathrm{g}=2$ and
%[text] $\\mathbf{w}$ is AWGN of variance $\\sigma\_\\mathrm{w}^2=(10/255)^2$.
[~,imgfile] = atip.msipimg(8);
x = imresize(im2double(rgb2gray(imread(imgfile))),[96 96],"bilinear");
hsigma = 2;
hsize  = 2*ceil(2*hsigma)+1;
sgmw   = 10/255;
psf = fspecial("gaussian",hsize,hsigma);
linproc = @(u) imfilter(u,psf,"conv","circular");   % H
adjproc = @(u) imfilter(u,psf,"corr","circular");   % H^T
rng(0)
v = imnoise(linproc(x),"gaussian",0,sgmw^2);
psnrObs = psnr(v,x)
saveimg(x,"atip-12-org.png")
saveimg(v,"atip-12-obs.png")
atip.savetex("atip-12-psnr-obs", sprintf("%.2f",psnrObs));
%%
%[text] ## Least squares: ill-posedness
%[text] $\\mathbf{H}$ is diagonalized by the 2-D DFT.  The eigenvalues of $\\mathbf{H}^\\top\\mathbf{H}$ are
%[text] $|\\tilde{h}\[\\boldsymbol{k}\]|^2$, so the condition number is $\\max|\\tilde{h}|^2/\\min|\\tilde{h}|^2$.
N = size(x);
Ht = psf2otf(psf,N);                   % frequency response (DFT of h)
Vt = fft2(v);
h2max = max(abs(Ht).^2,[],"all")
h2min = min(abs(Ht).^2,[],"all")
condHtH = h2max/h2min
assert(abs(h2max-1) < 1e-12)           % DC gain of the Gaussian filter is 1, ||H||_S = 1
atip.savetex("atip-12-h2min", sci2tex(h2min));
atip.savetex("atip-12-cond",  sci2tex(condHtH));
%[text] Inverse filter $(\\mathbf{H}^\\top\\mathbf{H})^{-1}\\mathbf{H}^\\top\\mathbf{v}=\\mathbf{H}^{-1}\\mathbf{v}$
xinv = real(ifft2(Vt./Ht));
psnrInv = psnr(xinv,x)
saveimg(xinv,"atip-12-inv.png")
atip.savetex("atip-12-psnr-inv", sprintf("%.2f",psnrInv));
%%
%[text] ## Tikhonov regularization and Wiener filter
%[text] Ridge regularization $\\mathbf{L}=\\mathbf{I}$ and the Wiener filter for a white $\\mathbf{x}$
%[text] ($\\boldsymbol{\\Sigma}\_\\mathrm{x}=\\sigma\_\\mathrm{x}^2\\mathbf{I}$) coincide with $\\lambda=(\\sigma\_\\mathrm{w}/\\sigma\_\\mathrm{x})^2$:
%[text] $\\tilde{\\hat{x}}\[\\boldsymbol{k}\]=\\overline{\\tilde{h}\[\\boldsymbol{k}\]}\\tilde{v}\[\\boldsymbol{k}\]/(|\\tilde{h}\[\\boldsymbol{k}\]|^2+(\\sigma\_\\mathrm{w}/\\sigma\_\\mathrm{x})^2)$.
sgmx = std(x(:));
lambdaW = (sgmw/sgmx)^2
xwnr = real(ifft2(conj(Ht).*Vt./(abs(Ht).^2+lambdaW)));
psnrWnr = psnr(xwnr,x)
%[text] Check with `deconvwnr` (same formula with the noise-to-signal ratio $\\lambda$)
xchk = deconvwnr(v,psf,lambdaW);
assert(norm(xchk-xwnr,"fro")/norm(xwnr,"fro") < 1e-6)
saveimg(xwnr,"atip-12-wnr.png")
atip.savetex("atip-12-lambda-wnr", sprintf("%.3f",lambdaW));
atip.savetex("atip-12-psnr-wnr",   sprintf("%.2f",psnrWnr));
%[text] Minimum eigenvalue of $\\mathbf{H}^\\top\\mathbf{H}+\\lambda\\mathbf{I}$ is at least $\\lambda$
eigminRidge = h2min + lambdaW;
assert(eigminRidge >= lambdaW)
atip.savetex("atip-12-cond-ridge", sprintf("%.1f",(h2max+lambdaW)/eigminRidge));
%[text] Check of Exercise "Tikhonov regularization" of \[M\] Section 8.3.1 (Sobel filters):
%[text] $G(\\boldsymbol{\\omega})=16\\sin^2\\omega\_1(1+\\cos\\omega\_2)^2+16(1+\\cos\\omega\_1)^2\\sin^2\\omega\_2$ sampled at $\\boldsymbol{\\omega}=2\\pi\\boldsymbol{N}^{-\\top}\\boldsymbol{k}$
sb1 = [1 2 1; 0 0 0; -1 -2 -1];          % d[n1]a[n2]
sb2 = sb1.';                              % a[n1]d[n2]
[k1,k2] = ndgrid(0:N(1)-1,0:N(2)-1);
w1 = 2*pi*k1/N(1); w2 = 2*pi*k2/N(2);
Gw = 16*sin(w1).^2.*(1+cos(w2)).^2 + 16*(1+cos(w1)).^2.*sin(w2).^2;
assert(max(abs(abs(psf2otf(sb1,N)).^2 + abs(psf2otf(sb2,N)).^2 - Gw),[],"all") < 1e-9)
%[text] Gradient regularizer $\\mathbf{L}=(\\mathbf{G}\_1^\\top\\ \\mathbf{G}\_2^\\top)^\\top$ with the backward differences
%[text] (the Sobel filters vanish at $\\omega\_2=\\pi$, where $|\\tilde{h}|$ is small).  $\\lambda$ is chosen from a grid.
gb1 = [0 1 0; 0 -1 0; 0 0 0];
gb2 = gb1.';
Gt2 = abs(psf2otf(gb1,N)).^2 + abs(psf2otf(gb2,N)).^2;
lambdas = 10.^(-4:0.25:2);
psnrs = zeros(size(lambdas));
for idx = 1:numel(lambdas)
    xg = real(ifft2(conj(Ht).*Vt./(abs(Ht).^2+lambdas(idx)*Gt2)));
    psnrs(idx) = psnr(xg,x);
end
[psnrGrd,imax] = max(psnrs);
lambdaG = lambdas(imax)
xgrd = real(ifft2(conj(Ht).*Vt./(abs(Ht).^2+lambdaG*Gt2)));
atip.savetex("atip-12-lambda-grd", sci2tex(lambdaG));
atip.savetex("atip-12-psnr-grd",   sprintf("%.2f",psnrGrd));
%%
%[text] ## X-ray CT: Radon transform and central slice theorem
%[text] Modified Shepp-Logan phantom $128\\times128$.  The projection for $\\theta=0$ is the sum along one axis,
%[text] and its 1-D DFT equals the 2-D DFT on the line through the origin (discrete central slice theorem).
u = phantom(128);
r0 = sum(u,1);                 % projection along n1
U = fft2(u);
errSlice = max(abs(fft(r0) - U(1,:)))
assert(errSlice < 1e-10)
atip.savetex("atip-12-slice-err", sci2tex(errSlice));
%[text] Sinogram with `radon` (180 angles) and the radial sampling lines of $I$ angles in the frequency plane
thetaAll = 0:179;
[rAll,pAll] = radon(u,thetaAll);
nAngles = 18;                  % number of angles I for the reconstruction example
fig = figure(Units="centimeters", Position=[2 2 9.6 3.5], Color="w");
tl = tiledlayout(fig,1,3,"TileSpacing","compact","Padding","compact");
ax = nexttile(tl);
imagesc(ax,u), colormap(ax,gray), axis(ax,"image"), clim(ax,[0 1])
set(ax,"XTick",[],"YTick",[],"FontSize",8)
title(ax,"$u(q_1,q_2)$","Interpreter","latex","FontSize",9)
ax = nexttile(tl);
imagesc(ax,thetaAll,pAll,rAll), colormap(ax,gray)
set(ax,"FontSize",8,"XTick",0:90:180)
xlabel(ax,"$\theta$ [deg]","Interpreter","latex"), ylabel(ax,"$p_1$","Interpreter","latex")
title(ax,"$r(p_1;\theta)$","Interpreter","latex","FontSize",9)
ax = nexttile(tl);
nu = linspace(-pi,pi,128);
imagesc(ax,nu,nu,log10(abs(fftshift(U))+1e-3)), colormap(ax,gray), axis(ax,"image")
hold(ax,"on")
for th = (0:nAngles-1)*180/nAngles
    plot(ax,pi*[-cosd(th) cosd(th)],pi*[-sind(th) sind(th)],"-","Color",cwarm,"LineWidth",0.6)
end
hold(ax,"off")
set(ax,"FontSize",8,"XTick",[-pi 0 pi],"XTickLabel",["$-\pi$","0","$\pi$"], ...
    "YTick",[-pi 0 pi],"YTickLabel",["$-\pi$","0","$\pi$"],"TickLabelInterpreter","latex")
title(ax,"$|\tilde{u}|$ and $I="+nAngles+"$ lines","Interpreter","latex","FontSize",9)
exportgraphics(fig, fullfile(resfolder,"atip-12-ct.png"), "Resolution", 300)
close(fig)
atip.savetex("atip-12-ct-nangles", sprintf("%d",nAngles));
%%
%[text] ## Filtered backprojection as Tikhonov regularization
%[text] Reconstruction in the DFT domain (same procedure as sample12\_02):
%[text] $\\tilde{\\hat{\\mathsf{x}}}=\\left(\\sum\_i\\tilde{\\mathsf{r}}\_{\\theta\_i}\\right)\\oslash\\left\[\\tilde{\\mathsf{z}}+\\lambda\\frac{P}{N}\\left(\\mathrm{abs}(\\tilde{\\mathsf{g}}\_1)^{\\circ2}+\\mathrm{abs}(\\tilde{\\mathsf{g}}\_2)^{\\circ2}\\right)\\right\]$
thetaSet = (0:nAngles-1)*180/nAngles;
[r,p] = radon(u,thetaSet);
lambdaCT = 10;
[ub,uo,ur] = fbprecon(r,p,thetaSet,size(u),lambdaCT);
uir = iradon(r,thetaSet,"linear","Ram-Lak",1,size(u,1));     % reference: iradon
fig = figure(Units="centimeters", Position=[2 2 9.2 2.9], Color="w");
tl = tiledlayout(fig,1,4,"TileSpacing","compact","Padding","compact");
names = ["BP (no filter)","FBP, $\lambda=0$","FBP, $\lambda="+lambdaCT+"$","iradon"];
imgs = {ub,uo,ur,uir};
for idx = 1:4
    ax = nexttile(tl);
    imagesc(ax,imgs{idx}), colormap(ax,gray), axis(ax,"image")
    set(ax,"XTick",[],"YTick",[])
    title(ax,names(idx),"Interpreter","latex","FontSize",8)
end
exportgraphics(fig, fullfile(resfolder,"atip-12-fbp.png"), "Resolution", 300)
close(fig)
%%
%[text] ## Deblurring by FISTA (lasso with the undecimated Haar DWT)
%[text] Example "Deblurring" of \[M\] Section 1.3.3: $J=3$, $\\lambda=10^{-3}$, $\\eta=1/\\|\\mathbf{H}\\|\_\\mathrm{S}^2$, 20 iterations.
%[text] For the circular convolution $\\|\\mathbf{H}\\|\_\\mathrm{S}^2=\\max\_{\\boldsymbol{k}}|\\tilde{h}\[\\boldsymbol{k}\]|^2$; $\\mathbf{D}$ is a Parseval tight frame,
%[text] so $\\|\\mathbf{HD}\\|\_\\mathrm{S}=\\|\\mathbf{H}\\|\_\\mathrm{S}$ (Exercise "Step size condition", \[M\] Section 8.4.2).
sqnormH = h2max
atip.savetex("atip-12-normH2", sprintf("%.3f",sqnormH));
nLevels = 3;
[coefs,scales] = msip.udhaarwtdec2(x,nLevels);
adjdic = @(u) msip.udhaarwtdec2(u,nLevels);   % D^T
syndic = @(s) msip.udhaarwtrec2(s,scales);    % D
assert(norm(x-syndic(coefs),"fro")^2/numel(x) < 1e-18)
lambdaL1 = 1e-3;
eta = 1/sqnormH;
nIters = 20;
y = zeros(size(coefs)); s = y; apre = 1;
for iter = 1:nIters
    g = adjdic(adjproc(linproc(syndic(y))-v));
    spre = s;
    s = softthresh(y-eta*g,lambdaL1*eta);
    a = (1+sqrt(1+4*apre^2))/2;
    y = s + (apre-1)/a*(s-spre);
    apre = a;
end
xl1 = syndic(s);
psnrL1 = psnr(xl1,x)
saveimg(xl1,"atip-12-l1.png")
atip.savetex("atip-12-psnr-l1", sprintf("%.2f",psnrL1));
%%
%[text] ## Deblurring by TV regularization (PDS)
%[text] Algorithm "PDS for constrained TV-regularized LS" of \[M\] Section 8.4.4 with backward differences,
%[text] $\\mathcal{C}=\[0,1\]^N$, $\\eta\_1=\\lambda/\\|\\mathbf{H}\\|\_\\mathrm{S}^2$, $\\eta\_2=0.99(2\\eta\_1\\|\\mathbf{G}\\|\_\\mathrm{S}^2)^{-1}$
%[text] (factor 0.99: the unrelaxed PDS needs the strict condition $\\eta\_1^{-1}-\\eta\_2\\|\\mathbf{G}\\|\_\\mathrm{S}^2>\\|\\mathbf{H}\\|\_\\mathrm{S}^2/(2\\lambda)$).
gv = [0 1 0; 0 -1 0; 0 0 0];
gh = rot90(gv);
gradproc = @(u) cat(3,imfilter(u,gv,"conv","circ"),imfilter(u,gh,"conv","circ"));
gradadjp = @(y) imfilter(y(:,:,1),gv,"corr","circ") + imfilter(y(:,:,2),gh,"corr","circ");
sqnormG = max(abs(psf2otf(gv,N)).^2+abs(psf2otf(gh,N)).^2,[],"all")
lambdaTV = 2e-3;
nItersTV = 100;
xtv = tvpds(v,linproc,adjproc,gradproc,gradadjp,sqnormH,sqnormG,lambdaTV,nItersTV);
psnrTV = psnr(xtv,x)
saveimg(xtv,"atip-12-tv.png")
atip.savetex("atip-12-lambda-tv", sci2tex(lambdaTV));
atip.savetex("atip-12-iters-tv",  sprintf("%d",nItersTV));
atip.savetex("atip-12-psnr-tv",   sprintf("%.2f",psnrTV));
atip.savetex("atip-12-normG2",    sprintf("%g",sqnormG));
%%
%[text] ## Toy problems: ISTA, FISTA and constrained ISTA (PDS)
%[text] $\\mathbf{H}=1$, $\\mathbf{D}=(2/3\\ \\ 1/3)$, $v=1/2$, $\\lambda=0.2$, $\\eta=0.4$, 20 iterations from a fixed initial point.
D = [2 1]/3; vt = 0.5; lambdaT = 0.2; etaT = 0.4; nItersT = 20;
s0 = [-0.8; 0.9];
cost = @(s) 0.5*(vt-D*s).^2 + lambdaT*sum(abs(s),1);
kappaT = D*D';                         % Lipschitz constant of the gradient
assert(etaT <= 1/kappaT)               % FISTA condition (stricter than ISTA)
pathI = zeros(2,nItersT+1); pathF = pathI;
pathI(:,1) = s0; pathF(:,1) = s0;
s = s0; yF = s0; sF = s0; apre = 1;
for iter = 1:nItersT
    s = softthresh(s-etaT*D'*(D*s-vt),lambdaT*etaT);            % ISTA
    pathI(:,iter+1) = s;
    sp = sF;
    sF = softthresh(yF-etaT*D'*(D*yF-vt),lambdaT*etaT);         % FISTA
    a = (1+sqrt(1+4*apre^2))/2;
    yF = sF + (apre-1)/a*(sF-sp);
    apre = a;
    pathF(:,iter+1) = sF;
end
%[text] Analytic minimizer: $s\_1=0$ and $-\\frac{2}{3}(v-\\frac{2}{3}s\_0)+\\lambda=0\\Rightarrow s\_0=0.3$
sopt = [0.3; 0];
assert(norm(pathF(:,end)-sopt) < 5e-2)
costOpt = cost(sopt);
gapI = cost(pathI(:,end)) - costOpt
gapF = cost(pathF(:,end)) - costOpt
assert(gapF < gapI)
atip.savetex("atip-12-toy-sopt",  "\tr{(" + sprintf("%.1f\\ \\ %.1f",sopt) + ")}");
atip.savetex("atip-12-toy-gapI",  sci2tex(gapI));
atip.savetex("atip-12-toy-gapF",  sci2tex(gapF));
%[text] 3-D surface of $f(\\mathbf{s})+g(\\mathbf{s})$ (as in the 2026 slides) with the ISTA and FISTA iterates
%[text] on the surface and on the bottom plane; the legend is placed above the axes.
cdark = [0 82 51]/255;          % dark green (msipmaindark): minimizer, constraint set
ccdark = 0.6*ccool;             % dark blue (msipcooldark): FISTA
Jfun = @(a,b) 0.5*(vt - D(1)*a - D(2)*b).^2 + lambdaT*(abs(a) + abs(b));
zl = [0 1.5];
fig = figure(Units="centimeters", Position=[2 2 5.0 4.4], Color="w");
ax = axes(fig, "Position", [0.17 0.13 0.76 0.70]);    % the top 15 % of the figure is kept for the legend
costsurf(ax, Jfun, [-1 1], zl, 0.05:0.1:1.45, "$f(\mathbf{s})+g(\mathbf{s})$")
hF = plottraj(ax, pathF, Jfun, zl(1), ccdark, "s", 3.0);   % FISTA below, ISTA drawn on top of it
hI = plottraj(ax, pathI, Jfun, zl(1), cwarm, "o", 2.0);
hS = markpt(ax, sopt, Jfun(sopt(1),sopt(2)), zl(1), cdark, "p", 7);
lgd = legend(ax, [hI hF hS], ["ISTA", "FISTA", "$\hat{\mathbf{s}}$"], "FontSize", 7, "Box", "off", ...
    "Orientation", "horizontal", "Interpreter", "latex");
lgd.ItemTokenSize = [14 6];
lgd.Position = [0.05 0.90 0.90 0.08];                 % above the axes: never on the plotted data
exportgraphics(fig, fullfile(resfolder,"atip-12-fista.png"), "Resolution", 300)
close(fig)
%[text] Constrained problem $\\mathbf{Ds}\\in\\mathcal{C}=\[-1/2,0\]$ by PDS with $\\mathbf{L}=\\mathbf{D}$.
%[text] Step sizes: $\\eta\_1=0.4$ and $\\eta\_2$ from $\\eta\_1^{-1}-\\eta\_2\\|\\mathbf{D}\\|\_\\mathrm{S}^2>\\kappa/2$.
lo = -0.5; hi = 0;
eta1 = etaT;
eta2 = 1/(1.05*kappaT)*(1/eta1-kappaT/2);
assert(1/eta1 - eta2*kappaT > kappaT/2)
nItersC = 40;
pathC = zeros(2,nItersC+1); pathC(:,1) = s0;
s = s0; yd = 0;
for iter = 1:nItersC
    sp = s;
    s = softthresh(sp-eta1*D'*((D*sp-vt)+yd),lambdaT*eta1);     % primal
    t = yd + eta2*D*(2*s-sp);
    yd = t - eta2*min(max(t/eta2,lo),hi);                       % dual (Moreau)
    pathC(:,iter+1) = s;
end
soptC = [0; 0];                % on the boundary Ds = 0 with the minimum l1-norm
assert(norm(pathC(:,end)-soptC) < 1e-2)
atip.savetex("atip-12-toyc-eta2", sprintf("%.3f",eta2));
sfin = round(pathC(:,end),3);
sfin(sfin == 0) = 0;           % avoid "-0.000"
atip.savetex("atip-12-toyc-s", "\tr{(" + sprintf("%.3f\\ \\ %.3f",sfin) + ")}");
%[text] 3-D surface with the constraint set: the band $\\mathcal{C}$ (shaded on the bottom plane, bounded by the
%[text] lines $\\mathbf{D}\\mathbf{s}=-1/2$ and $\\mathbf{D}\\mathbf{s}=0$); the cost is drawn solid over $\\mathcal{C}$ and faint outside
%[text] (where $\\iota\_\\mathcal{C}(\\mathbf{D}\\mathbf{s})=\\infty$), with the PDS iterates.
infeas = @(a,b) D(1)*a + D(2)*b < lo | D(1)*a + D(2)*b > hi;
bnd = @(c,a) (c - D(1)*a)/D(2);                     % line D s = c as s[1] = (c - D(1) s[0])/D(2)
fig = figure(Units="centimeters", Position=[2 2 5.0 4.0], Color="w");
ax = axes(fig);
hold(ax, "on")
ax.SortMethod = "childorder";
ta = linspace(-1, 1, 401);
bl = max(bnd(lo, ta), -1);                          % band clipped to the square (D(2) > 0)
bh = min(bnd(hi, ta), 1);
ok = bl <= bh;
patch(ax, [ta(ok) fliplr(ta(ok))], [bl(ok) fliplr(bh(ok))], zl(1)*ones(1,2*nnz(ok)), cdark, ...
    "FaceAlpha", 0.18, "EdgeColor", "none")
zlab = "$f(\mathbf{s})+g(\mathbf{s})+h(\mathbf{D}\mathbf{s})$";
costsurf(ax, @(a,b) maskz(Jfun(a,b), ~infeas(a,b)), [-1 1], zl, 0.05:0.1:1.45, zlab)
costsurf(ax, @(a,b) maskz(Jfun(a,b), infeas(a,b)), [-1 1], zl, [], zlab, [], 0.15)
for c = [lo hi]
    tb = bnd(c, ta);
    in = abs(tb) <= 1;
    plot3(ax, ta(in), tb(in), zl(1)*ones(1,nnz(in)), "-", "Color", cdark, "LineWidth", 1.0)
end
plottraj(ax, pathC, Jfun, zl(1), cwarm, "o");
markpt(ax, soptC, Jfun(soptC(1),soptC(2)), zl(1), cdark, "p", 7);
exportgraphics(fig, fullfile(resfolder,"atip-12-cista.png"), "Resolution", 300)
close(fig)
%%
%[text] ## Proximal map vs gradient descent
%[text] As in the 2026 slides: a differentiable function $f(\\mathbf{x})=\\frac12\\|\\mathbf{x}\\|\_2^2$ minimized by gradient descent
%[text] ($\\eta=0.5$) and a non-differentiable one $g(\\mathbf{x})=\\|\\mathbf{x}\\|\_1$ minimized by repeating the proximal map
%[text] $\\mathrm{prox}\_{\\eta g}(\\mathbf{x})=\\arg\\min\_{\\mathbf{y}}g(\\mathbf{y})+\\frac{1}{2\\eta}\\|\\mathbf{y}-\\mathbf{x}\\|\_2^2=\\phi\_\\mathrm{ST}(\\mathbf{x};\\eta)$ ($\\eta=1$),
%[text] both from $\\mathbf{x}^{(0)}=(1.5,0.5)^\\top$.  The proximal steps reach the sparse minimizer $\\mathbf{0}$ in two steps.
xin = [1.5; 0.5]; etaP = 1; etaG = 0.5; nStepsG = 4;
[Y0,Y1] = meshgrid(linspace(-2,2.5,901));
obj = abs(Y0) + abs(Y1) + ((Y0-xin(1)).^2 + (Y1-xin(2)).^2)/(2*etaP);
[~,imin] = min(obj(:));
proxval = [Y0(imin); Y1(imin)];
assert(norm(proxval - softthresh(xin,etaP)) < 1e-2)        % grid search = soft thresholding
pathP = [xin, softthresh(xin,etaP), softthresh(softthresh(xin,etaP),etaP)];
assert(isequal(pathP(:,end), [0; 0]))
pathG = xin*(1-etaG).^(0:nStepsG);                          % x - eta*grad f(x) = (1 - eta) x
atip.savetex("atip-12-prox-x",    "\tr{(" + sprintf("%.1f\\ \\ %.1f",xin) + ")}");
atip.savetex("atip-12-prox-val",  "\tr{(" + sprintf("%.1f\\ \\ %g",softthresh(xin,etaP)) + ")}");
atip.savetex("atip-12-prox-etag", sprintf("%.1f",etaG));
fig = figure(Units="centimeters", Position=[2 2 7.4 3.1], Color="w");
tl = tiledlayout(fig,1,2,"TileSpacing","compact","Padding","compact");
fq = @(a,b) 0.5*(a.^2 + b.^2);
fa = @(a,b) abs(a) + abs(b);
zl = [0 3];
ax = nexttile(tl);
costsurf(ax, fq, [-2 2], zl, 0.25:0.25:2.75, "$f(\mathbf{x})$")
plottraj(ax, pathG, fq, zl(1), cwarm, "o");
xlabel(ax, "$x[0]$", "Interpreter", "latex", "FontSize", 8)
ylabel(ax, "$x[1]$", "Interpreter", "latex", "FontSize", 8)
title(ax, "Differentiable: GD", "Interpreter", "latex", "FontSize", 8, "FontWeight", "normal")
ax = nexttile(tl);
costsurf(ax, fa, [-2 2], zl, 0.25:0.25:2.75, "$g(\mathbf{x})$")
plottraj(ax, pathP, fa, zl(1), cwarm, "o");
xlabel(ax, "$x[0]$", "Interpreter", "latex", "FontSize", 8)
ylabel(ax, "$x[1]$", "Interpreter", "latex", "FontSize", 8)
title(ax, "Non-differentiable: prox", "Interpreter", "latex", "FontSize", 8, "FontWeight", "normal")
exportgraphics(fig, fullfile(resfolder,"atip-12-prox.png"), "Resolution", 300)
close(fig)
%%
%[text] ## Super-resolution
%[text] Example "Super-resolution" of \[M\] Section 8.4.4: $\\mathbf{H}=\\mathbf{SB}$ (Gaussian blur $\\sigma\_\\mathrm{g}=2$
%[text] and decimation by $\\boldsymbol{M}=\\mathrm{diag}(2,2)$), AWGN $\\sigma\_\\mathrm{w}^2=(10/255)^2$, $\\mathcal{C}=\[0,1\]^N$, 30 iterations.
srproc = @(u) downsample2(imfilter(u,psf,"conv","circular"));   % H = SB
sradjp = @(y) imfilter(upsample2(y),psf,"corr","circular");     % H^T
rng(0)
vsr = imnoise(srproc(x),"gaussian",0,sgmw^2);
ytst = rand(size(vsr)); utst = srproc(x);
assert(abs(dot(utst(:),ytst(:)) - dot(x(:),reshape(sradjp(ytst),[],1))) < 1e-9)   % adjoint check
xbic = imresize(vsr,2,"bicubic");
psnrBic = psnr(xbic,x)
sqnormHsr = powermethod(srproc,sradjp,size(x))
nItersSR = 30;
%[text] (c) constrained 1-norm regularization ($J=5$ undecimated Haar DWT, $\\lambda=8\\times10^{-4}$)
nLv = 5;
[coefs5,scales5] = msip.udhaarwtdec2(x,nLv);
adjdic5 = @(u) msip.udhaarwtdec2(u,nLv);
syndic5 = @(s) msip.udhaarwtrec2(s,scales5);
lambdaSR = 8e-4;
eta1 = 1/sqnormHsr;
eta2 = 0.99/(2*eta1);                  % 0.99: strict condition (unrelaxed PDS)
assert((1/eta1)-eta2 > sqnormHsr/2)
X = zeros(size(x)); s = zeros(size(coefs5));
for iter = 1:nItersSR
    g = adjdic5(sradjp(srproc(syndic5(s))-vsr));
    sp = s;
    s = softthresh(sp - eta1*(g + adjdic5(X)), lambdaSR*eta1);
    t = X + eta2*syndic5(2*s-sp);
    X = t - eta2*min(max(t/eta2,0),1);
end
xsrl1 = syndic5(s);
psnrSRL1 = psnr(xsrl1,x)
%[text] (d) constrained TV regularization ($\\lambda=3\\times10^{-3}$)
lambdaSRTV = 3e-3;
xsrtv = tvpds(vsr,srproc,sradjp,gradproc,gradadjp,sqnormHsr,sqnormG,lambdaSRTV,nItersSR,zeros(size(x)));
psnrSRTV = psnr(xsrtv,x)
%[text] Compare with the values in the caption of Fig. 8.10 of \[M\] (21.47, 22.74, 22.81 dB)
assert(all(abs([psnrBic psnrSRL1 psnrSRTV]-[21.47 22.74 22.81]) < 0.2))
imwrite(imresize(vsr,2*mag,"nearest"), fullfile(resfolder,"atip-12-sr-obs.png"))
saveimg(xbic,"atip-12-sr-bic.png")
saveimg(xsrl1,"atip-12-sr-l1.png")
saveimg(xsrtv,"atip-12-sr-tv.png")
atip.savetex("atip-12-sr-normH2",  sprintf("%.3f",sqnormHsr));
atip.savetex("atip-12-psnr-sr-bic", sprintf("%.2f",psnrBic));
atip.savetex("atip-12-psnr-sr-l1",  sprintf("%.2f",psnrSRL1));
atip.savetex("atip-12-psnr-sr-tv",  sprintf("%.2f",psnrSRTV));
%%
%[text] ## Robust PCA by ADMM
%[text] Same setting as sample12\_06: $\\mathbf{M}=\\mathbf{L}+\\mathbf{S}$ with a checkerboard (low rank) and a text image (sparse),
%[text] $\\lambda=10^{-2}$, $\\rho=1$, 100 iterations.
T = 0.3*im2double(imread("text.png"));
B = 0.7*imresize(checkerboard,size(T));
M = T + B;
[L,S] = rpcaadmm(M,1e-2,1,100);
rankB = rank(B)
errL = 100*norm(L-B,"fro")/norm(B,"fro")
errS = 100*norm(S-T,"fro")/norm(T,"fro")
errM = norm(M-L-S,"fro")/norm(M,"fro")
assert(errL < 5 && errM < 1e-3)
imwrite(M, fullfile(resfolder,"atip-12-rpca-m.png"))
imwrite(min(max(L,0),1), fullfile(resfolder,"atip-12-rpca-l.png"))
imwrite(mat2gray(S), fullfile(resfolder,"atip-12-rpca-s.png"))
atip.savetex("atip-12-rpca-rankb", sprintf("%d",rankB));
atip.savetex("atip-12-rpca-errl",  sprintf("%.1f",errL));
atip.savetex("atip-12-rpca-errs",  sprintf("%.1f",errS));
atip.savetex("atip-12-rpca-size",  sprintf("%d\\times %d",size(M)));
%%
%[text] ## Functions
function y = softthresh(x,tau)
% Soft thresholding phi_ST(x;tau) (element-wise)
y = sign(x).*max(abs(x)-tau,0);
end

function y = magshrink(u)
% Soft thresholding of the gradient magnitude with threshold 1 (phi_MS(u;1))
mag = sqrt(u(:,:,1).^2 + u(:,:,2).^2);
y = u.*max(1 - 1./mag, 0);
end

function y = downsample2(x)
y = x(1:2:end,1:2:end);
end

function y = upsample2(x)
y = zeros(2*size(x));
y(1:2:end,1:2:end) = x;
end

function lambda = powermethod(fwd,adj,sz)
% Largest eigenvalue of H^T H (squared spectral norm of H) by the power method
rng(1)
u = rand(sz);
lambda = 1; err = Inf; iter = 0;
while err > 1e-6*lambda && iter < 5000
    iter = iter + 1;
    u = u/norm(u(:));
    w = adj(fwd(u));
    lnew = dot(w(:),w(:))/dot(w(:),u(:));
    err = abs(lnew-lambda);
    lambda = lnew;
    u = w;
end
end

function x = tvpds(v,fwd,adj,grad,gradadj,sqnormH,sqnormG,lambda,nIters,x0)
% PDS for the constrained TV-regularized LS (Algorithm of [M] Sec. 8.4.4), C = [0,1]^N
if nargin < 10, x0 = adj(v); end
kappa = sqnormH/lambda;
eta1 = 1/kappa;
eta2 = 0.99/(2*eta1*sqnormG);          % 0.99: strict condition (unrelaxed PDS)
assert((1/eta1)-eta2*sqnormG > kappa/2)
xp = x0;
y = grad(xp);
for iter = 1:nIters
    g = adj(fwd(xp)-v);
    x = min(max(xp - eta1*(g/lambda + gradadj(y)),0),1);   % primal
    t = y + eta2*grad(2*x - xp);
    y = t - magshrink(t);                                   % dual
    xp = x;
end
end

function [ub,uo,ur] = fbprecon(r,p,thetaSet,szu,lambda)
% Backprojection, FBP without and with the gradient (Sobel) regularizer in the DFT domain
nPoints = 2^nextpow2(max([2^nextpow2(szu(1)) length(p)]));
rc = circshift(padarray(r,nPoints-size(r,1),"post"),p(1));
R = fft(rc,nPoints,1);
SR = zeros(nPoints+1); SS = zeros(nPoints+1);
S1 = zeros(nPoints+1); S1(1,:) = 1;
for iSlice = 1:numel(thetaSet)
    Si = zeros(nPoints+1);
    Si(1,:) = [R(:,iSlice).' 0];
    SR = SR + imrotate(fftshift(Si),thetaSet(iSlice),"crop");
    SS = SS + imrotate(fftshift(S1,1),thetaSet(iSlice),"crop");
end
SR = ifftshift(SR(1:end-1,1:end-1));
SS = ifftshift(SS(1:end-1,1:end-1));
g0 = fspecial("sobel"); g1 = g0.';
GG = abs(fft2(g0,nPoints,nPoints)).^2 + abs(fft2(g1,nPoints,nPoints)).^2;
LL = (nPoints/nPoints^2)*GG;           % lambda*P/N*(|g1|^2+|g2|^2), P = nPoints, N = nPoints^2
crop = @(Z) Z(1:szu(1),1:szu(2));
ur = crop(circshift(real(ifft2(SR./(SS+lambda*LL+eps))),szu/2));
uo = crop(circshift(real(ifft2(SR./(SS+eps))),szu/2));
ub = crop(circshift(real(ifft2(SR)),szu/2));
end

function [L,S] = rpcaadmm(M,lambda,rho,nIters)
% Robust PCA min ||L||_* + lambda ||S||_1 s.t. M = L + S by ADMM (G = [I O; O I; I I])
Y1 = M; Y2 = zeros(size(M)); Y3 = M;
D1 = zeros(size(M)); D2 = D1; D3 = D1;
for iter = 1:nIters
    L = (2*(Y1-D1) - (Y2-D2) + (Y3-D3))/3;
    S = (Y1-D1) + (Y3-D3) - 2*L;
    [Uu,Ss,Vv] = svd(L + D1,"econ");
    Y1 = Uu*diag(softthresh(diag(Ss),1/rho))*Vv';          % singular value thresholding
    Y2 = softthresh(S + D2,lambda/rho);
    Y3 = M;                                                 % projection onto {M}
    D1 = D1 + L - Y1;
    D2 = D2 + S - Y2;
    D3 = D3 + L + S - Y3;
end
end

function z = maskz(z, keep)
% Values outside the mask as NaN (not drawn)
z(~keep) = NaN;
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
    "EdgeAlpha", 0.25*min(1, alpha/0.7), "LineWidth", 0.3)
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

function h = plottraj(ax, traj, fcost, zmin, col, mk, msz)
% Iterates on the bottom plane (opaque) and on the surface (lighter tint, thin, semi-transparent,
% so that the surface stays visible); returns the handle of the bottom path (for legends)
if nargin < 7, msz = 2.2; end
zt = fcost(traj(1,:), traj(2,:)) + 0.01*diff(ax.ZLim);
h = plot3(ax, traj(1,:), traj(2,:), zmin*ones(1,size(traj,2)), "-" + mk, "Color", col, ...
    "MarkerFaceColor", col, "MarkerSize", msz, "LineWidth", 0.8);
ctint = 0.6*col + 0.4;                                % mixed with white
plot3(ax, traj(1,:), traj(2,:), zt, "-", "Color", [ctint 0.6], "LineWidth", 0.5);
scatter3(ax, traj(1,:), traj(2,:), zt, (0.8*msz)^2, ctint, mk, "filled", ...
    "MarkerFaceAlpha", 0.5, "MarkerEdgeAlpha", 0.5);
end

function h = markpt(ax, s, z, zmin, col, mk, msz)
% Point on the surface with a vertical drop line to the bottom plane; returns the marker handle
plot3(ax, [s(1) s(1)], [s(2) s(2)], [zmin z], ":", "Color", col, "LineWidth", 1.0)
h = plot3(ax, s(1), s(2), z, mk, "MarkerFaceColor", col, "MarkerEdgeColor", "w", "MarkerSize", msz, "LineWidth", 0.4);
plot3(ax, s(1), s(2), zmin, mk, "MarkerFaceColor", col, "MarkerEdgeColor", "w", "MarkerSize", msz, "LineWidth", 0.4)
end

function s = sci2tex(v)
% Number in the form a\times10^{b} for LaTeX (math mode)
e = floor(log10(abs(v)));
m = v/10^e;
if e == 0
    s = sprintf("%.2f",v);
else
    s = sprintf("%.1f\\times10^{%d}",m,e);
end
end
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
