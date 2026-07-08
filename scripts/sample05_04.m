%[text] # Sample 5-4
%[text] ## 周波数解析
%[text] 画像スペクトル
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Fourier analysis
%[text] Spectrum of images
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ### サンプル画像の準備
%[text] (Preparation of sample image)
% Reading original image
u = im2double(imread('cameraman.tif'));
figure(1)
imshow(u)
title('Original')
%%
%[text] ### 画像（2変量信号） $\\{u\[\\mathbf{n}\]\\in\\mathbb{R}\\}\_{\\mathbf{n}\\in\\mathbb{Z}^2}\n$ のスペクトル
%[text] (Spectrum of an image (bivariate signal)  $\\{u\[\\mathbf{n}\]\\in\\mathbb{R}\\}\_{\\mathbf{n}\\in\\mathbb{Z}^2}\n$)
%[text]  $U\\left(e^{\\j\\mathbf{\\omega}^T}\\right)= \\sum\_{\\mathbf{n}\\in\\Omega\\subset\\mathbb{Z}^2}u\[\\mathbf{n}\]e^{-\\j\\mathbf{\\omega}^T \\mathbf{n}},\\ \\mathbf{\\omega}\\in\\mathbb{R}^2$
%[text] ただし， $\\Omega$は画像のサポート領域を意味する． (where  $\\Omega$ denotes the support region of the image.)
%[text] DFT(FFT)によるDSFTの周波数サンプル計算 (Frequency sampling of DSFT by DFT (FFT))
%[text]  $U\[\\mathbf{k}\] = \\left.U\\left(e^{j\\mathbf{\\omega}^T}\\right)\\right|\_{\\mathbf{\\omega}=2\\pi \\mathbf{Q}^{-T}\\mathbf{k}},\\ \\mathbf{k}\\in\\mathcal{N}\\left(\\mathbf{Q}^T\\right)$
%[text] 以下では周期行列 $\\mathbf{Q}$ を対角行列 (In the following, the periodic matrix  $\\mathbf{Q}$ is set to a diagonal matrix)
%[text]  $\\mathbf{Q}=\\left(\\begin{array}{cc}\nN\_1 & 0 \\\\\n0 & N\_2 \\end{array}\\right)$ 
%[text] に設定する．すなわち，(That is,)
%[text]  $\\mathcal{N}(\\mathbf{Q})=\\mathcal{N}(\\mathbf{Q}^T)=\\{0,1,2,\\cdots,N\_1-1\\}\\times\\{0,1,2,\\cdots,N\_2-1\\}$
%[text]  $N=\\left|\\mathcal{N}(\\mathbf{Q})\\right|=\\left|\\det(\\mathbf{Q})\\right|=N\_1N\_2$
%[text] ただし，$\\mathcal{N}(\\cdot)$は基本周期内の整数ベクトル集合　(where $\\mathcal{N}(\\cdot)$ denotes a set of interger vectors in the fundamental pallalelpiped as) 
%[text]  $\\mathcal{N}(\\mathbf{P})\\colon=\\{\\mathbf{Px}\\in\\mathbb{Z}^D|\\ \\mathbf{x}\\in\[0,1)^D\\}$
%[text] である．ここでは，$\\Omega\\subseteq\\mathcal{N}(\\mathbf{Q})$ を仮定する．( Here, let us assume $\\Omega\\subseteq\\mathcal{N}(\\mathbf{Q})$.)
% Setting the number of frequency sample points in [0,2π)
nPoints1 = 256; % N_1 %[control:slider:3ff5]{"position":[12,15]}
nPoints2 = 256; % N_2 %[control:slider:1b20]{"position":[12,15]}

% Spectrum of u[n]
U = fft2(u,nPoints1,nPoints2);
%%
%[text] ### 表示のための係数シフト
%[text] (Coefficient shift for display)
%[text] 直流(DC)成分を配列の中心にシフト (Shift the direct current (DC) component to the center of the array)
% Shift the DC Coef. to the center
Usft = fftshift(U);

% Frequency sampling points
[w2,w1] = meshgrid(-pi:2*pi/nPoints2:pi-2*pi/nPoints2,-pi:2*pi/nPoints1:pi-2*pi/nPoints1);
%%
%[text] ### 振幅スペクトル $\\left|U\\left(e^{\\j\\mathbf{\\omega}^T}\\right)\\right|$の表示
%[text] Display of magnitude spectrum $\\left|U\\left(e^{\\j\\mathbf{\\omega}^T}\\right)\\right|$
%[text]  $\\left|U\\left(e^{\\j\\mathbf{\\omega}^T}\\right)\\right|=\\sqrt{\\Re\\left(U\\left(e^{\\j\\mathbf{\\omega}^T}\\right)\\right)^2+\\Im\\left(U\\left(e^{\\j\\mathbf{\\omega}^T}\\right)\\right)^2}$
% Calculation of the magnitude spectrum
Umag = abs(Usft);

% Display the magnitude spectrum
figure(2)
mesh(w1,w2,10*log10(Umag))
ax = gca;
xlabel('\omega_2 [rad]')
ylabel('\omega_1 [rad]')
zlabel('Magnitude 10log_{10} |U(e^{-j\omega^T})| [dB]')
axis ij
ax.XLim = [-pi pi];
ax.XTick = [ -pi 0 pi ];
ax.XTickLabel = { '-\pi', '0', '\pi'};
ax.YLim = [-pi pi];
ax.YTick = [ -pi 0 pi ];
ax.YTickLabel = { '-\pi', '0', '\pi'};
colorbar(ax)
%%
%[text] ### 位相スペクトル $\\angle U\\left(e^{\\j\\mathbf{\\omega}^T}\\right)$の表示
%[text] (Display of phase spectrum $\\angle U\\left(e^{\\j\\mathbf{\\omega}^T}\\right)$)
%[text]  $\\angle U\\left(e^{\\j\\mathbf{\\omega}^T}\\right)=\\tan^{-1}\\frac{\\Im\\left(U\\left(e^{\\j\\mathbf{\\omega}^T}\\right)\\right)}{\\Re\\left(U\\left(e^{\\j\\mathbf{\\omega}^T}\\right)\\right)}$
% Calculation of the magnitude spectrum
Uphs = angle(Usft);

% Display the magnitude spectrum
figure(3)
mesh(w1,w2,Uphs)
ax = gca;
xlabel('\omega_2 [rad]')
ylabel('\omega_1 [rad]')
zlabel('Phase \angle U(e^{-j\omega^T}) [rad]')
axis ij
ax.XLim = [-pi pi];
ax.XTick = [ -pi 0 pi ];
ax.XTickLabel = { '-\pi', '0', '\pi'};
ax.YLim = [-pi pi];
ax.YTick = [ -pi 0 pi ];
ax.YTickLabel = { '-\pi', '0', '\pi'};
ax.ZLim = [-pi pi];
ax.ZTick = [ -pi 0 pi ];
ax.ZTickLabel = { '-\pi', '0', '\pi'};
colorbar(ax,'Ticks',[ -pi -pi/2 0 pi/2 pi],'TickLabels', { '-\pi', '-\pi/2', '0', 'pi/2', '\pi'})
%%
%[text] ### スペクトル$U\\left(e^{\\j\\mathbf{\\omega}^T}\\right)$からの画像再構成 
%[text] (Reconstruction from the spectrum $U\\left(e^{\\j\\mathbf{\\omega}^T}\\right)$)
%[text]  $u\[\\mathbf{n}\]=\\frac{1}{(2\\pi)^2}\\int\_{\\mathbf{\\omega}\\in\[0,2\\pi)^2}U\\left(e^{\\j\\mathbf{\\omega}^T}\\right)e^{\\j\\mathbf{\\omega}^T\\mathbf{n}}d\\mathbf{\\omega},\\ \\mathbf{n}\\in\\Omega\\subset\\mathbb{Z}^2 $
%[text] IDFT(IFFT)による再構成 (Reconstruction by IDFT (IFFT))
%[text]  $u\[\\mathbf{n}\] = \\frac{1}{\\left|\\det(\\mathbf{Q})\\right|}\\sum\_{\\mathbf{n}\\in\\mathcal{N}(\\mathbf{Q})}U\[\\mathbf{k}\]e^{\\j2\\pi\\mathbf{k}\\mathbf{Q}^{-1}\\mathbf{n}},\\ \\mathbf{n}\\in\\Omega\\subseteq\\mathcal{N}(\\mathbf{Q})$
% Reconstruction from the spectrum
r = ifft2(U,nPoints1,nPoints2);

% Clipping to the support region Ω
urec = r(1:size(u,1),1:size(u,2)); 
figure(4)
imshow(urec)
% MSE
mymse = @(x,y) mean((double(x)-double(y)).^2,'all');
title(['Reconstruction MSE: ' num2str(mymse(u,urec))])
%%
%[text] ### 振幅スペクトル$\\left|U\\left(e^{\\j\\mathbf{\\omega}^T}\\right)\\right|$からの画像再構成 
%[text] (Reconstruction from the spectrum$\\left|U\\left(e^{\\j\\mathbf{\\omega}^T}\\right)\\right|$)
%[text]  $u\_\\mathrm{mag}\[\\mathbf{n}\]=\\frac{1}{(2\\pi)^2}\\int\_{\\mathbf{\\omega}\\in\[0,2\\pi)^2}\\left|U\\left(e^{\\j\\mathbf{\\omega}^T}\\right)\\right|e^{\\j\\mathbf{\\omega}^T\\mathbf{n}}d\\mathbf{\\omega},\\ \\mathbf{n}\\in\\Omega\\subset\\mathbb{Z}^2 $
%[text] IDFT(IFFT)による計算 (Calculation by IDFT (IFFT))
%[text]  $u\_\\mathrm{mag}\[\\mathbf{n}\] = \\frac{1}{\\left|\\det(\\mathbf{Q})\\right|}\\sum\_{\\mathbf{k}\\in\\mathcal{N}(\\mathbf{Q}^T)}\\left|U\[\\mathbf{k}\]\\right|e^{\\j2\\pi\\mathbf{k}^T\\mathbf{Q}^{-1}\\mathbf{n}},\\ \\mathbf{n}\\in\\Omega\\subseteq\\mathcal{N}(\\mathbf{Q})$
% Reconstruction from the spectrum
rmag = ifft2(ifftshift(Umag),nPoints1,nPoints2);

% Clipping to the support region Ω
umag = rmag(1:size(u,1),1:size(u,2)); 
figure(5)
imshow(umag+.5)
title('Magnitude only')
%%
%[text] ### 位相スペクトル$\\angle U\\left(e^{\\j\\mathbf{\\omega}^T}\\right)$からの画像再構成 
%[text] (Reconstruction from the spectrum $\\angle U\\left(e^{\\j\\mathbf{\\omega}^T}\\right)$)
%[text]  $u\_\\mathrm{phs}\[\\mathbf{n}\]=\\frac{1}{(2\\pi)^2}\\int\_{\\mathbf{\\omega}\\in\[0,2\\pi)^2}e^{\\j\\angle U\\left(e^{\\j\\mathbf{\\omega}^T}\\right)}e^{\\j\\mathbf{\\omega}^T\\mathbf{n}}d\\mathbf{\\omega},\\ \\mathbf{n}\\in\\Omega\\subset\\mathbb{Z}^2 $
%[text] IDFT(IFFT)による計算 (Calculation by IDFT (IFFT))
%[text]  $u\_\\mathrm{phs}\[\\mathbf{n}\] = \\frac{1}{\\left|\\det(\\mathbf{Q})\\right|}\\sum\_{\\mathbf{k}\\in\\mathcal{N}(\\mathbf{Q}^T)}e^{\\j\\angle U\[\\mathbf{k}\]}e^{\\j2\\pi\\mathbf{k}^T\\mathbf{Q}^{-1}\\mathbf{n}},\\ \\mathbf{n}\\in\\Omega\\subseteq\\mathcal{N}(\\mathbf{Q}) $
% Reconstruction from the spectrum
rphs = ifft2(exp(1j*ifftshift(Uphs)),nPoints1,nPoints2);

% Clipping to the suppor region Ω
uphs = rphs(1:size(u,1),1:size(u,2)); 
figure(6)
imshow(nPoints1*nPoints2*real(uphs)+.5)
title('Phase only')
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:3ff5]
%   data: {"defaultValue":256,"label":"nPoints","max":1024,"min":256,"run":"SectionToEnd","runOn":"ValueChanging","step":256}
%---
%[control:slider:1b20]
%   data: {"defaultValue":256,"label":"nPoints","max":1024,"min":256,"run":"SectionToEnd","runOn":"ValueChanging","step":256}
%---
