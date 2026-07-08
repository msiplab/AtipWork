%[text] # Sample 12-2
%[text] ## 画像復元
%[text] フィルタ補正逆投影法 (FBP)
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Image restoration
%[text] Filtered backprojection (FBP)
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
clear 
close all
%%
%[text] ### パラメータ設定
%[text] (Parameter settings)
nSlices = 180; %[control:slider:7db1]{"position":[11,14]}
lambda = 10^-5 %[control:slider:63e8]{"position":[13,15]}
%%
%[text] ## 断層スライス画像の生成
%[text] (Creation of tomographic slice images)
%[text] - $u(\\mathbf{p}), \\mathbf{p}\\in\\mathbb{R}^2$: 原画像 (Original image) \
%[text] PHANTOM関数を利用して改良型シェップ ローガン頭部ファントム画像 $\\mathbf{u}$ を作成して表示 (Create the modified Shepp-Logan head phantom image by using function PHATOM and display it.)
u = phantom(128); 
figure(1)
imshow(u)
title('Original image u')
%%
%[text] #### 2変量DFT 
%[text] (Bivariate DFT)
%[text]  $U\[\\mathbf{k}\]=U(e^{j\\mathbf{\\omega}^T})|\_{\\mathbf{\\omega}=2\\pi\\mathbf{Q}^{-T}\\mathbf{k}$
nPointsQ = 2.^nextpow2(size(u));
U = fftn(u,nPointsQ);
figure(2)
w0 = linspace(-pi,pi-2*pi/nPointsQ(2),nPointsQ(2));
w1 = linspace(-pi,pi-2*pi/nPointsQ(1),nPointsQ(1));
imagesc(w1,w0,fftshift(20*log10(abs(U))));
axis square
ylabel('\omega_0 [rad/sample]')
xlabel('\omega_1 [rad/sample]')
title('20log_{10}|U(e^{j{\bf\omega}^T})|')
ax = gca;
ax.YLim = [-pi pi];
ax.XLim = [-pi pi];
ax.YTick = [-pi 0 pi];
ax.YTickLabel = { '-\pi', '0', '\pi'};
ax.XTick = [-pi 0 pi];
ax.XTickLabel = { '-\pi', '0', '\pi'};
%%
%[text] ### ラドン変換
%[text] (Radon transform)
%[text]  $\\mathrm{r}\_{u}(x, \\theta)=\\int\_{\\mathbb{R}} u\\left(x {\\bf \\theta}+y {\\bf \\theta}^{\\perp}\\right) d y$
%[text] ただし，(where)
%[text] - $\\mathbf{\\theta}=(\\cos \\theta, \\sin \\theta)^{T}$
%[text] - $\\mathbf{\\theta}^{\\perp}=(-\\sin \\theta, \\cos \\theta)^{T}$ \
%[text] RADON関数を利用 (Use function RADON)
thetaset = linspace(0,180-180/nSlices,nSlices);
[r,p] = radon(u,thetaset);
%[text] サイノグラムの表示 (Show sinogram)
figure(3)
imshow(r,[],'Xdata',thetaset,'Ydata',p,'InitialMagnification','fit')
xlabel('\theta (degrees)')
ylabel('x')
title('Sinogram r_u(x,\theta)')
colormap(gca,hot), colorbar
iptsetpref('ImshowAxesVisible','off')
%%
%[text] ### スライスの単変量DFT
%[text] (Univariate DFT of each slice)
%[text] 中央スライス定理(Central slice theorem)
%[text]  $R\_u(j\\Omega\_x,\\theta)=U(j(\\sin\\theta\\ \\cos\\theta)^T\\Omega\_x)$
%[text] ※座標を垂直, 水平の順序で表示していることに注意 (NOTE that  the coordinates are shown in vertical and horizontal order.)
%[text] DFTでの解釈 (Interpretation as DFT)
%[text]  $R\_{u,\\theta}\[k\]=R\_u(e^{j\\omega},\\theta)|\_{\\omega=2\\pi k/N}=U(e^{j\\mathbf{\\omega}^T})|\_{\\mathbf{\\omega}=\\left(\\begin{array}{c}\\sin\\theta \\\\ \\cos\\theta\\end{array}\\right)2\\pi k/N$
nPoints = 2^nextpow2(max([size(U,1) length(p)]));
rc = circshift(padarray(r,nPoints-size(r,1),'post'),p(1));
R = fft(rc,nPoints,1);
%[text] スライス毎のスペクトルの表示 (Display of spectra for each slice)
figure(4)
wx = linspace(-pi,pi-2*pi/nPoints,nPoints);
imagesc(thetaset,wx,fftshift(20*log10(abs(R)),1))
ylabel('\omega_x [rad/sample]')
xlabel('\theta (degrees)')
title('20log_{10}|R(e^{j\omega_x},\theta)|')
ax = gca;
ax.YLim = [-pi pi];
ax.YTick = [-pi 0 pi];
ax.YTickLabel = { '-\pi', '0', '\pi'};
iptsetpref('ImshowAxesVisible','off')
%%
%[text] ### 逆ラドン変換
%[text] (Inverse radon transform)
%[text] #### 問題設定 (Problem setting)
%[text]  $\\hat{\\mathbf{u}}=\\arg\\min\_\\mathbf{u}\\frac{1}{2}\\left\\|\n\\left(\\begin{array}{c}\\mathbf{r}\_{\\theta\_0} \\\\\n\\mathbf{r}\_{\\theta\_1} \\\\\n\\vdots \\\\\n\\mathbf{r}\_{\\theta\_{I-1}} \n\\end{array}\\right)\n-\n\\left(\\begin{array}{c}\n\\mathbf{W}\_1^{-1}\\mathbf{S}\_{\\downarrow\\theta\_0} \\\\\n\\mathbf{W}\_1^{-1}\\mathbf{S}\_{\\downarrow\\theta\_1}  \\\\\n\\vdots \\\\\n\\mathbf{W}\_1^{-1}\\mathbf{S}\_{\\downarrow\\theta\_{I-1}} \n\\end{array}\\right)\n\\mathbf{W}\_2\\mathbf{u}\n\\right\\|\_2^2\n+\n\\frac{\\lambda}{2}\\|\\mathbf{\\nabla}\\mathbf{u}\\|\_2^2$
%[text] ただし，(where)
%[text] - $\\mathbf{u}\\in\\mathbb{R}^N$: Vectorized expression of discretized array of $u(\\mathbf{p})$ 
%[text] - $\\mathbf{r}\_{\\theta\_i}\\in\\mathbb{R}^m$: Vectorized expression of discretized slice line of $r\_u(x,\\theta)$
%[text] - $\\mathbf{W}\_d$: $d$-dimensional DFT matrix
%[text] - $\\mathbf{S}\_{\\downarrow\\theta\_i}$: Slice operator for direction $\\theta\_i$
%[text] - $\\mathbf{\\nabla}$: Gradient operator \
%[text] #### 解 (Solution)
%[text]  $\\widehat{\\mathbf{u}}=\\mathbf{W}\_{2}^{-1}\\left(\\left(\\sum\_{i=0}^{I-1} \\mathbf{S}\_{\\downarrow \\theta\_{i}}^{T} \\mathbf{S}\_{\\downarrow \\theta\_{i}}\\right)+\\frac{m}{N} \\lambda \\mathbf{W}\_{2} \\mathbf{\\nabla}^{T} \\mathbf{\\nabla W}\_{2}^{-1}\\right)^{-1}\\left(\\sum\_{i=0}^{I-1} \\mathbf{S}\_{\\downarrow \\theta\_{i}}^{T} \\mathbf{W}\_{1} \\mathbf{r}\_{\\theta\_{i}}\\right)$
%[text]  $\\stackrel{\\mathrm{DFT}}{\\longleftrightarrow} \\mathrm{U}\[\\mathbf{k}\]=\\left(S\_{\\uparrow \\downarrow}\[\\mathbf{k}\]+\\frac{m}{N} \\lambda\\left(\\left|\\mathrm{G}\_{0}\[\\mathbf{k}\]\\right|^{2}+\\left|\\mathrm{G}\_{1}\[\\mathbf{k}\]\\right|^{2}\\right)\\right)^{-1}\\left(\\sum\_{i=0}^{I-1} \\mathrm{R}\_{\\theta\_{i}}\[\\mathbf{k}\]\\right)$
%[text] - $G\_0\[\\mathbf{k}\]$: DFT of 1st-order difference filter in vertical direction
%[text] - $G\_1\[\\mathbf{k}\]$: DFT of 1st-order difference filter in horizontal direction \
% Accumuration of backprojected spectrum Rθi[k]
SR = zeros(nPoints+1);
% Accumuration of slice lines in frequency domain
SS = zeros(nPoints+1);
% Zero array
S0 = zeros(nPoints+1);
S1 = S0;
S1(1,:) = 1;
for iSlice = 1:length(thetaset)
    theta = thetaset(iSlice);
    Si = S0;
    Si(1,:) = [R(:,iSlice).' 0];
    SR = SR + imrotate(fftshift(Si),theta,'crop');
    SS = SS + imrotate(fftshift(S1,1),theta,'crop');
end
SR = ifftshift(SR(1:end-1,1:end-1));
SS = ifftshift(SS(1:end-1,1:end-1));
%[text] 累積スライスラインの表示 (Display accumulated slice lines)
figure(5)
[k0,k1] = ndgrid(linspace(-pi,pi-2*pi/nPoints,nPoints));
surf(k0,k1,fftshift(SS),'EdgeColor','none')
ylabel('\omega_0 [rad/sample]')
xlabel('\omega_1 [rad/sample]')
title('S_{\uparrow\downarrow}[{\bfk}]')
ax = gca;
ax.YDir = 'reverse';
ax.YLim = [-pi pi];
ax.XLim = [-pi pi];
ax.YTick = [-pi 0 pi];
ax.YTickLabel = { '-\pi', '0', '\pi'};
ax.XTick = [-pi 0 pi];
ax.XTickLabel = { '-\pi', '0', '\pi'};
%[text] 逆投影スペクトルの表示 (Display of backprojected spectrum)
figure(6)
imagesc(w0,w1,fftshift(20*log10(abs(SR))))
axis square
ylabel('\omega_0 [rad/sample]')
xlabel('\omega_1 [rad/sample]')
title('S_{\uparrow\downarrow}[{\bfk}]')
ax = gca;
ax.YDir = 'reverse';
ax.YLim = [-pi pi];
ax.XLim = [-pi pi];
ax.YTick = [-pi 0 pi];
ax.YTickLabel = { '-\pi', '0', '\pi'};
ax.XTick = [-pi 0 pi];
ax.XTickLabel = { '-\pi', '0', '\pi'};
iptsetpref('ImshowAxesVisible','off')
%%
%[text] #### 勾配フィルタのパワースペクトル 
%[text] (Power spectrum of gradient filter)
%[text]  $\\mathbf{\\nabla}^T\\mathbf{\\nabla}\\stackrel{\\mathrm{DFT}}{\\longleftrightarrow} \\left|\\mathrm{G}\_{0}\[\\mathbf{k}\]\\right|^{2}+\\left|\\mathrm{G}\_{1}\[\\mathbf{k}\]\\right|^{2}$
%[text] ソーベルフィルタを利用 (Adopt Sobel filter)
g0 = fspecial('sobel');
g1 = g0.';
GG = abs(fftn(g0,nPoints*[1 1])).^2+abs(fftn(g1,nPoints*[1 1])).^2;
LL = nPoints*GG;
%[text] パワースペクトルの表示 (Display the power spectrum)
figure(7)
mesh(k1,k0,fftshift(GG))
ylabel('\omega_0 [rad/sample]')
xlabel('\omega_1 [rad/sample]')
title('|G_0|^2+|G_1|^2')
ax = gca;
ax.YDir = 'reverse';
ax.YLim = [-pi pi];
ax.XLim = [-pi pi];
ax.YTick = [-pi 0 pi];
ax.YTickLabel = { '-\pi', '0', '\pi'};
ax.XTick = [-pi 0 pi];
ax.XTickLabel = { '-\pi', '0', '\pi'};
%%
%[text] ### 画像再構成
%[text] (Image reconstuction)
%[text] 零割を避けるために分母に EPS を加算 (Add EPS to the denominator to avoid dividing by zero.)
figure(8)
% FBP w/ regulalization
Ur = SR./(SS+lambda*LL+eps);
ur = circshift(real(ifft2(Ur)),size(u)/2);
ur = ur(1:size(u,1),1:size(u,2));
subplot(1,3,1)
imshow(ur,[])
title('FBP w/ regulalization')

% FBP w/o regulalization
Uo = SR./(SS+eps);
uo = circshift(real(ifft2(Uo)),size(u)/2);
uo = uo(1:size(u,1),1:size(u,2));
subplot(1,3,2)
imshow(uo,[])
title('FBP w/o regularization')

% BP w/o filtering
ub = circshift(real(ifft2(SR)),size(u)/2);
ub = ub(1:size(u,1),1:size(u,2));
subplot(1,3,3)
imshow(ub,[])
title('BP w/o filtering')
%%
%[text] ### IRADON関数
%[text] (Functon IRADON)
%[text] 逆ラドン変換を行うMATLAB関数IRADONの利用例 (An example of using the MATLAB function IRADON to perform the inverse radon transformation)
%[text] Perform filtered backprojection.
I1 = iradon(r,thetaset);
%[text] Perform unfiltered backprojection.
I2 = iradon(r,thetaset,'linear','none');
%[text] Display the reconstructed images.
figure(9)
subplot(1,2,1)
imshow(I1,[])
title('Filtered Backprojection')
subplot(1,2,2)
imshow(I2,[])
title('Unfiltered Backprojection')
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:7db1]
%   data: {"defaultValue":180,"label":"nSlices","max":180,"min":2,"run":"SectionToEnd","runOn":"ValueChanged","step":1}
%---
%[control:slider:63e8]
%   data: {"defaultValue":-5,"label":"lambdapow","max":2,"min":-8,"run":"SectionToEnd","runOn":"ValueChanged","step":0.5}
%---
