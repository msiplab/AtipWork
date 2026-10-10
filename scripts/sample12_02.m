%[text] # Sample 12-2: Filtered backprojection (FBP)
%[text] Advanced Topics in Image Processing, Lecture 12 "Image Restoration"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Parameter settings
%[text] - nSlices: number $I$ of projection angles
%[text] - lambda: regularization parameter $\\lambda$ \
nSlices = 180; %[control:slider:9364]{"position":[11,14]}
lambda = 10^0 %[control:slider:4aca]{"position":[13,14]}
%%
%[text] ## Creation of a tomographic slice image
%[text] - $u(\\boldsymbol{q}), \\boldsymbol{q}\\in\\mathbb{R}^2$: distribution (absorption coefficients) \
%[text] Create the modified Shepp-Logan head phantom image $\\mathbf{x}$ (samples of $u(\\boldsymbol{q})$) by the function `phantom` and display it.
x = phantom(128);
figure
imshow(x)
title("Original image x")
%%
%[text] ### Two-dimensional DFT
%[text] $\\tilde{x}\[\\boldsymbol{k}\]=X(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top})|\_{\\boldsymbol{\\omega}=2\\pi\\boldsymbol{N}^{-\\top}\\boldsymbol{k}}$
nPointsQ = 2.^nextpow2(size(x));
Xt = fftn(x,nPointsQ);
figure
w0 = linspace(-pi,pi-2*pi/nPointsQ(2),nPointsQ(2));
w1 = linspace(-pi,pi-2*pi/nPointsQ(1),nPointsQ(1));
imagesc(w1,w0,fftshift(20*log10(abs(Xt))));
axis square
ylabel("\omega_1 [rad/sample]")
xlabel("\omega_2 [rad/sample]")
title("20log_{10}|X(e^{j\omega^T})|")
ax = gca;
ax.YLim = [-pi pi];
ax.XLim = [-pi pi];
ax.YTick = [-pi 0 pi];
ax.YTickLabel = { '-\pi', '0', '\pi'};
ax.XTick = [-pi 0 pi];
ax.XTickLabel = { '-\pi', '0', '\pi'};
%%
%[text] ## Radon transform
%[text] $r(p\_1;\\theta)=\\int\_{\\mathbb{R}}u(\\mathbf{R}\_\\theta\\boldsymbol{p})\\,\\mathrm{d}p\_2$
%[text] where
%[text] - $\\mathbf{R}\_\\theta=\\begin{pmatrix}\\cos\\theta & -\\sin\\theta\\\\ \\sin\\theta & \\cos\\theta\\end{pmatrix}$: rotation matrix
%[text] - $\\boldsymbol{p}=(p\_1\\ \\ p\_2)^\\top\\in\\mathbb{R}^2$ \
%[text] Use the function `radon`.
thetaset = linspace(0,180-180/nSlices,nSlices);
[r,p] = radon(x,thetaset);
%[text] Show the sinogram
figure
imshow(r,[],"XData",thetaset,"YData",p,"InitialMagnification","fit")
axis on
xlabel("\theta (degrees)")
ylabel("p_1")
title("Sinogram r(p_1;\theta)")
colormap(gca,hot), colorbar
%%
%[text] ## One-dimensional DFT of each slice
%[text] Central slice theorem
%[text] $\\tilde{r}(\\xi;\\theta)=\\tilde{u}\\left(\\xi\\begin{pmatrix}\\cos\\theta\\\\ \\sin\\theta\\end{pmatrix}\\right)$
%[text] NOTE that the coordinates are shown in the vertical and horizontal order.
%[text] Interpretation with the DFT
%[text] $\\tilde{r}\_{\\theta}\[k\]=\\tilde{r}(\\omega;\\theta)|\_{\\omega=2\\pi k/P}=X(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top})|\_{\\boldsymbol{\\omega}=(\\cos\\theta\\ \\ \\sin\\theta)^\\top 2\\pi k/P}$
nPoints = 2^nextpow2(max([size(Xt,1) length(p)]));
rc = circshift(padarray(r,nPoints-size(r,1),"post"),p(1));
R = fft(rc,nPoints,1);
%[text] Display the spectra of the slices
figure
wx = linspace(-pi,pi-2*pi/nPoints,nPoints);
imagesc(thetaset,wx,fftshift(20*log10(abs(R)),1))
ylabel("\omega [rad/sample]")
xlabel("\theta (degrees)")
title("20log_{10}|R(e^{j\omega};\theta)|")
ax = gca;
ax.YLim = [-pi pi];
ax.YTick = [-pi 0 pi];
ax.YTickLabel = { '-\pi', '0', '\pi'};
%%
%[text] ## Inverse Radon transform
%[text] ### Problem setting
%[text] $\\hat{\\mathbf{x}}=\\arg\\min\_\\mathbf{x}\\frac{1}{2}\\left\\|\\begin{pmatrix}\\mathbf{r}\_{\\theta\_0}\\\\ \\mathbf{r}\_{\\theta\_1}\\\\ \\vdots\\\\ \\mathbf{r}\_{\\theta\_{I-1}}\\end{pmatrix}-\\begin{pmatrix}\\mathbf{W}\_P^{-1}\\mathbf{S}\_{\\mathcal{I}\_{\\theta\_0}}\\\\ \\mathbf{W}\_P^{-1}\\mathbf{S}\_{\\mathcal{I}\_{\\theta\_1}}\\\\ \\vdots\\\\ \\mathbf{W}\_P^{-1}\\mathbf{S}\_{\\mathcal{I}\_{\\theta\_{I-1}}}\\end{pmatrix}\\mathbf{W}\_{\\boldsymbol{N}}\\mathbf{x}\\right\\|\_2^2+\\frac{\\lambda}{2}\\|\\mathbf{L}\\mathbf{x}\\|\_2^2$
%[text] where
%[text] - $\\mathbf{x}\\in\\mathbb{R}^N$: vector representation of the sampled array of $u(\\boldsymbol{q})$
%[text] - $\\mathbf{r}\_{\\theta\_i}\\in\\mathbb{R}^P$: vector representation of the sampled projection $r(p\_1;\\theta\_i)$
%[text] - $\\mathbf{W}\_P$, $\\mathbf{W}\_{\\boldsymbol{N}}$: one- and two-dimensional DFT matrices
%[text] - $\\mathbf{S}\_{\\mathcal{I}\_{\\theta\_i}}$: extraction of the line of direction $\\theta\_i$ in the frequency plane
%[text] - $\\mathbf{L}=(\\mathbf{G}\_1^\\top\\ \\ \\mathbf{G}\_2^\\top)^\\top$: gradient filters \
%[text] ### Solution
%[text] $\\hat{\\mathbf{x}}=\\mathbf{W}\_{\\boldsymbol{N}}^{-1}\\left\\{\\left(\\sum\_{i=0}^{I-1}\\mathbf{S}\_{\\mathcal{I}\_{\\theta\_i}}^\\top\\mathbf{S}\_{\\mathcal{I}\_{\\theta\_i}}\\right)+\\lambda\\frac{P}{N}\\mathbf{W}\_{\\boldsymbol{N}}\\mathbf{L}^\\top\\mathbf{L}\\mathbf{W}\_{\\boldsymbol{N}}^{-1}\\right\\}^{-1}\\left(\\sum\_{i=0}^{I-1}\\mathbf{S}\_{\\mathcal{I}\_{\\theta\_i}}^\\top\\mathbf{W}\_P\\mathbf{r}\_{\\theta\_i}\\right)$
%[text] $\\stackrel{\\mathrm{DFT}}{\\longleftrightarrow}\\tilde{\\hat{\\mathsf{x}}}=\\left(\\sum\_{i=0}^{I-1}\\tilde{\\mathsf{r}}\_{\\theta\_i}\\right)\\oslash\\left\[\\tilde{\\mathsf{z}}+\\lambda\\frac{P}{N}\\left(\\mathrm{abs}(\\tilde{\\mathsf{g}}\_1)^{\\circ 2}+\\mathrm{abs}(\\tilde{\\mathsf{g}}\_2)^{\\circ 2}\\right)\\right\]$
%[text] - $\\tilde{\\mathsf{z}}$: accumulated slice lines (mask) in the frequency plane
%[text] - $\\tilde{\\mathsf{g}}\_1$, $\\tilde{\\mathsf{g}}\_2$: frequency responses (2-D DFTs) of the gradient filters $\\mathbf{G}\_1$, $\\mathbf{G}\_2$ (here the Sobel filters) \
% Accumulation of the backprojected spectra
SR = zeros(nPoints+1);
% Accumulation of the slice lines in the frequency domain
SS = zeros(nPoints+1);
% Zero array
S0 = zeros(nPoints+1);
S1 = S0;
S1(1,:) = 1;
for iSlice = 1:length(thetaset)
    theta = thetaset(iSlice);
    Si = S0;
    Si(1,:) = [R(:,iSlice).' 0];
    SR = SR + imrotate(fftshift(Si),theta,"crop");
    SS = SS + imrotate(fftshift(S1,1),theta,"crop");
end
SR = ifftshift(SR(1:end-1,1:end-1));
SS = ifftshift(SS(1:end-1,1:end-1));
%[text] Display the accumulated slice lines
figure
[k0,k1] = ndgrid(linspace(-pi,pi-2*pi/nPoints,nPoints));
surf(k0,k1,fftshift(SS),"EdgeColor","none")
ylabel("\omega_1 [rad/sample]")
xlabel("\omega_2 [rad/sample]")
title("Accumulated slice lines z[{\bfk}]")
ax = gca;
ax.YDir = 'reverse';
ax.YLim = [-pi pi];
ax.XLim = [-pi pi];
ax.YTick = [-pi 0 pi];
ax.YTickLabel = { '-\pi', '0', '\pi'};
ax.XTick = [-pi 0 pi];
ax.XTickLabel = { '-\pi', '0', '\pi'};
%[text] Display the backprojected spectrum
figure
imagesc(w0,w1,fftshift(20*log10(abs(SR))))
axis square
ylabel("\omega_1 [rad/sample]")
xlabel("\omega_2 [rad/sample]")
title("Backprojected spectrum \Sigma_i r_{\theta_i}[{\bfk}]")
ax = gca;
ax.YDir = 'reverse';
ax.YLim = [-pi pi];
ax.XLim = [-pi pi];
ax.YTick = [-pi 0 pi];
ax.YTickLabel = { '-\pi', '0', '\pi'};
ax.XTick = [-pi 0 pi];
ax.XTickLabel = { '-\pi', '0', '\pi'};
%%
%[text] ### Power spectrum of the gradient filters
%[text] $\\mathbf{L}^\\top\\mathbf{L}\\stackrel{\\mathrm{DFT}}{\\longleftrightarrow}\\mathrm{abs}(\\tilde{\\mathsf{g}}\_1)^{\\circ 2}+\\mathrm{abs}(\\tilde{\\mathsf{g}}\_2)^{\\circ 2}$
%[text] Adopt the Sobel filters.
g0 = fspecial("sobel");
g1 = g0.';
GG = abs(fftn(g0,nPoints*[1 1])).^2+abs(fftn(g1,nPoints*[1 1])).^2;
%[text] Weight $P/N$ with $P$ points of the projection DFT and $N=P^2$ points of the two-dimensional DFT
%[text] (the 2026 version used the factor $P$ instead of $P/N$, which only rescales $\\lambda$).
LL = (nPoints/nPoints^2)*GG;
%[text] Display the power spectrum
figure
mesh(k1,k0,fftshift(GG))
ylabel("\omega_1 [rad/sample]")
xlabel("\omega_2 [rad/sample]")
title("|g_1|^2+|g_2|^2")
ax = gca;
ax.YDir = 'reverse';
ax.YLim = [-pi pi];
ax.XLim = [-pi pi];
ax.YTick = [-pi 0 pi];
ax.YTickLabel = { '-\pi', '0', '\pi'};
ax.XTick = [-pi 0 pi];
ax.XTickLabel = { '-\pi', '0', '\pi'};
%%
%[text] ## Image reconstruction
%[text] EPS is added to the denominator to avoid division by zero.
figure
tiledlayout(1,3)
% FBP with regularization
Ur = SR./(SS+lambda*LL+eps);
xr = circshift(real(ifft2(Ur)),size(x)/2);
xr = xr(1:size(x,1),1:size(x,2));
nexttile
imshow(xr,[])
title("FBP w/ regularization")

% FBP without regularization
Uo = SR./(SS+eps);
xo = circshift(real(ifft2(Uo)),size(x)/2);
xo = xo(1:size(x,1),1:size(x,2));
nexttile
imshow(xo,[])
title("FBP w/o regularization")

% BP without filtering
xb = circshift(real(ifft2(SR)),size(x)/2);
xb = xb(1:size(x,1),1:size(x,2));
nexttile
imshow(xb,[])
title("BP w/o filtering")
%%
%[text] ## Function iradon
%[text] An example of the MATLAB function `iradon` for the inverse Radon transform.
%[text] Perform the filtered backprojection.
I1 = iradon(r,thetaset);
%[text] Perform the unfiltered backprojection.
I2 = iradon(r,thetaset,"linear","none");
%[text] Display the reconstructed images.
figure
tiledlayout(1,2)
nexttile
imshow(I1,[])
title("Filtered backprojection")
nexttile
imshow(I2,[])
title("Unfiltered backprojection")
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:9364]
%   data: {"defaultValue":180,"label":"nSlices","max":180,"min":2,"run":"SectionToEnd","runOn":"ValueChanged","step":1}
%---
%[control:slider:4aca]
%   data: {"defaultValue":0,"label":"log10(lambda)","max":4,"min":-4,"run":"SectionToEnd","runOn":"ValueChanged","step":0.5}
%---
