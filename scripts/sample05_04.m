%[text] # Sample 5-4: Spectrum of images
%[text] Advanced Topics in Image Processing, Lecture 5 "Fourier Analysis"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Preparation of a sample image
x = im2double(imread('cameraman.tif'));
figure
imshow(x)
title('Original')
%%
%[text] ## Spectrum of an image (bivariate signal) $(x\[\\boldsymbol{n}\])\_{\\boldsymbol{n}\\in\\Omega}$
%[text]{"align":"center"} $X\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)= \\sum\_{\\boldsymbol{n}\\in\\Omega}x\[\\boldsymbol{n}\]\\mathrm{e}^{-\\mathrm{j}\\boldsymbol{\\omega}^\\top \\boldsymbol{n}},\\ \\boldsymbol{\\omega}\\in\\mathbb{R}^2$
%[text] where $\\Omega\\subset\\mathbb{Z}^2$ is the region of support of the image.
%[text] Frequency sampling of the DSFT by the DFT (FFT)
%[text]{"align":"center"} $X\[\\boldsymbol{k}\] = \\left.X\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)\\right|\_{\\boldsymbol{\\omega}=2\\pi \\boldsymbol{N}^{-\\top}\\boldsymbol{k}},\\ \\boldsymbol{k}\\in\\mathcal{N}\\left(\\boldsymbol{N}^\\top\\right)$
%[text] In the following, the periodic structure matrix $\\boldsymbol{N}$ is the diagonal matrix
%[text]{"align":"center"} $\\boldsymbol{N}=\\begin{bmatrix}N\_1 & 0 \\\\ 0 & N\_2 \\end{bmatrix},$
%[text] that is,
%[text]{"align":"center"} $\\mathcal{N}(\\boldsymbol{N})=\\mathcal{N}(\\boldsymbol{N}^\\top)=\\{0,1,\\ldots,N\_1-1\\}\\times\\{0,1,\\ldots,N\_2-1\\},\\quad \\left|\\mathcal{N}(\\boldsymbol{N})\\right|=\\left|\\det(\\boldsymbol{N})\\right|=N\_1N\_2,$
%[text] where $\\mathcal{N}(\\cdot)$ is the set of integer vectors in the fundamental parallelepiped,
%[text]{"align":"center"} $\\mathcal{N}(\\boldsymbol{P})\\coloneqq\\{\\boldsymbol{P}\\boldsymbol{r}\\in\\mathbb{Z}^D\\mid \\boldsymbol{r}\\in\[0,1)^D\\}.$
%[text] Here, $\\Omega\\subseteq\\mathcal{N}(\\boldsymbol{N})$ is assumed.
% Number of frequency sample points in [0,2pi)
nPoints1 = 256; % N_1 %[control:slider:98a6]{"position":[12,15]}
nPoints2 = 256; % N_2 %[control:slider:70ae]{"position":[12,15]}

% Spectrum of x[n]
X = fft2(x,nPoints1,nPoints2);
%%
%[text] ## Coefficient shift for display
%[text] Shift the direct-current (DC) component to the centre of the array.
Xsft = fftshift(X);

% Frequency sampling points
[w2,w1] = meshgrid(-pi:2*pi/nPoints2:pi-2*pi/nPoints2,-pi:2*pi/nPoints1:pi-2*pi/nPoints1);
%%
%[text] ## Display of the magnitude spectrum $\\left|X\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)\\right|$
%[text]{"align":"center"} $\\left|X\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)\\right|=\\sqrt{\\Re\\left(X\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)\\right)^2+\\Im\\left(X\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)\\right)^2}$
Xmag = abs(Xsft);

figure
mesh(w2,w1,10*log10(Xmag))
ax = gca;
xlabel('\omega_2 [rad]')
ylabel('\omega_1 [rad]')
zlabel('Magnitude 10log_{10} |X(e^{j\omega^T})| [dB]')
axis ij
ax.XLim = [-pi pi];
ax.XTick = [-pi 0 pi];
ax.XTickLabel = {'-\pi', '0', '\pi'};
ax.YLim = [-pi pi];
ax.YTick = [-pi 0 pi];
ax.YTickLabel = {'-\pi', '0', '\pi'};
colorbar(ax)
%%
%[text] ## Display of the phase spectrum $\\angle X\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)$
%[text]{"align":"center"} $\\angle X\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)=\\tan^{-1}\\frac{\\Im\\left(X\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)\\right)}{\\Re\\left(X\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)\\right)}$
Xphs = angle(Xsft);

figure
mesh(w2,w1,Xphs)
ax = gca;
xlabel('\omega_2 [rad]')
ylabel('\omega_1 [rad]')
zlabel('Phase \angle X(e^{j\omega^T}) [rad]')
axis ij
ax.XLim = [-pi pi];
ax.XTick = [-pi 0 pi];
ax.XTickLabel = {'-\pi', '0', '\pi'};
ax.YLim = [-pi pi];
ax.YTick = [-pi 0 pi];
ax.YTickLabel = {'-\pi', '0', '\pi'};
ax.ZLim = [-pi pi];
ax.ZTick = [-pi 0 pi];
ax.ZTickLabel = {'-\pi', '0', '\pi'};
colorbar(ax,'Ticks',[-pi -pi/2 0 pi/2 pi],'TickLabels',{'-\pi', '-\pi/2', '0', '\pi/2', '\pi'})
%%
%[text] ## Reconstruction from the spectrum $X\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)$
%[text]{"align":"center"} $x\[\\boldsymbol{n}\]=\\frac{1}{(2\\pi)^2}\\int\_{\[0,2\\pi)^2}X\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top\\boldsymbol{n}}\\mathrm{d}\\boldsymbol{\\omega},\\ \\boldsymbol{n}\\in\\Omega$
%[text] Reconstruction by the IDFT (IFFT)
%[text]{"align":"center"} $x\[\\boldsymbol{n}\] = \\frac{1}{\\left|\\det(\\boldsymbol{N})\\right|}\\sum\_{\\boldsymbol{k}\\in\\mathcal{N}(\\boldsymbol{N}^\\top)}X\[\\boldsymbol{k}\]\\mathrm{e}^{\\mathrm{j}\\boldsymbol{k}^\\top(2\\pi\\boldsymbol{N}^{-1})\\boldsymbol{n}},\\ \\boldsymbol{n}\\in\\Omega\\subseteq\\mathcal{N}(\\boldsymbol{N})$
r = ifft2(X,nPoints1,nPoints2);

% Clipping to the region of support
xrec = r(1:size(x,1),1:size(x,2));
figure
imshow(xrec)
mymse = @(a,b) mean((double(a)-double(b)).^2,'all');
title("Reconstruction MSE: " + mymse(x,xrec))
%%
%[text] ## Reconstruction from the magnitude spectrum $\\left|X\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)\\right|$
%[text]{"align":"center"} $x\_\\mathrm{mag}\[\\boldsymbol{n}\]=\\frac{1}{(2\\pi)^2}\\int\_{\[0,2\\pi)^2}\\left|X\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)\\right|\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top\\boldsymbol{n}}\\mathrm{d}\\boldsymbol{\\omega},\\ \\boldsymbol{n}\\in\\Omega$
%[text] Calculation by the IDFT (IFFT)
%[text]{"align":"center"} $x\_\\mathrm{mag}\[\\boldsymbol{n}\] = \\frac{1}{\\left|\\det(\\boldsymbol{N})\\right|}\\sum\_{\\boldsymbol{k}\\in\\mathcal{N}(\\boldsymbol{N}^\\top)}\\left|X\[\\boldsymbol{k}\]\\right|\\mathrm{e}^{\\mathrm{j}\\boldsymbol{k}^\\top(2\\pi\\boldsymbol{N}^{-1})\\boldsymbol{n}},\\ \\boldsymbol{n}\\in\\Omega$
rmag = ifft2(ifftshift(Xmag),nPoints1,nPoints2);

% Clipping to the region of support
xmag = rmag(1:size(x,1),1:size(x,2));
figure
imshow(real(xmag)+.5)
title('Magnitude only')
%%
%[text] ## Reconstruction from the phase spectrum $\\angle X\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)$
%[text]{"align":"center"} $x\_\\mathrm{phs}\[\\boldsymbol{n}\]=\\frac{1}{(2\\pi)^2}\\int\_{\[0,2\\pi)^2}\\mathrm{e}^{\\mathrm{j}\\angle X\\left(\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top}\\right)}\\mathrm{e}^{\\mathrm{j}\\boldsymbol{\\omega}^\\top\\boldsymbol{n}}\\mathrm{d}\\boldsymbol{\\omega},\\ \\boldsymbol{n}\\in\\Omega$
%[text] Calculation by the IDFT (IFFT)
%[text]{"align":"center"} $x\_\\mathrm{phs}\[\\boldsymbol{n}\] = \\frac{1}{\\left|\\det(\\boldsymbol{N})\\right|}\\sum\_{\\boldsymbol{k}\\in\\mathcal{N}(\\boldsymbol{N}^\\top)}\\mathrm{e}^{\\mathrm{j}\\angle X\[\\boldsymbol{k}\]}\\mathrm{e}^{\\mathrm{j}\\boldsymbol{k}^\\top(2\\pi\\boldsymbol{N}^{-1})\\boldsymbol{n}},\\ \\boldsymbol{n}\\in\\Omega$
rphs = ifft2(exp(1j*ifftshift(Xphs)),nPoints1,nPoints2);

% Clipping to the region of support
xphs = rphs(1:size(x,1),1:size(x,2));
figure
imshow(nPoints1*nPoints2*real(xphs)+.5)
title('Phase only')
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:98a6]
%   data: {"defaultValue":256,"label":"N_1","max":1024,"min":256,"run":"SectionToEnd","runOn":"ValueChanging","step":256}
%---
%[control:slider:70ae]
%   data: {"defaultValue":256,"label":"N_2","max":1024,"min":256,"run":"SectionToEnd","runOn":"ValueChanging","step":256}
%---
