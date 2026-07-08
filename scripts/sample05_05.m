%[text] # Sample 5-5
%[text] ## 周波数解析
%[text] 多変量畳み込み
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Fourier analysis
%[text] Multivariate convolution
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ### サンプル画像$\\{u\[\\mathbf{n}\]\\}\_\\mathbf{n}\n$の準備
%[text] (Preparation of sample image $\\{u\[\\mathbf{n}\]\\}\_\\mathbf{n}\n$)
% Reading original image
u = im2double(imread('cameraman.tif'));
figure(1)
imshow(u)
title('Original')
%%
%[text] ### 線形シフト不変システムのインパルス応答 $\\{h\[\\mathbf{n}\]\\}\_\\mathbf{n}\n$ 
%[text] (Impulse response of a linear shift-invariant system $\\{h\[\\mathbf{n}\]\\}\_\\mathbf{n}\n$
% Impulse response h[n]
ftype = "gaussian"; %[control:dropdown:1899]{"position":[9,19]}
h = rot90(fspecial(ftype),2);
%%
%[text] ### 線形シフト不変システムの出力応答$\\{v\[\\mathbf{n}\]\\}\_\\mathbf{n}\n$ 
%[text] (The linear shift-invariant system response $\\{v\[\\mathbf{n}\]\\}\_\\mathbf{n}\n$)
%[text] 畳み込み演算 (Convolution)
%[text]  $\\{v\[\\mathbf{n}\]\\}\_\\mathbf{n}=\\{h\[\\mathbf{n}\]\\}\_\\mathbf{n} \\ast \\{u\[\\mathbf{n}\]\\}\_\\mathbf{n} = \\sum\_{\\mathbf{k}\\in\\Omega\\subset\\mathbb{Z}^2}u\[\\mathbf{k}\]\\{h\[\\mathbf{n}-\\mathbf{k}\]\\}\_\\mathbf{n}\n$
% Output v[n]
v = imfilter(u,h,'conv','full');
%%
%[text] ### 入力信号 $\\{u\[\\mathbf{n}\]\\}\_{\\mathbf{n}}\n$ のスペクトル
%[text] (Spectrum of input signal $\\{u\[\\mathbf{n}\]\\}\_{\\mathbf{n}}\n$)
%[text]  $U\\left(e^{\\j\\mathbf{\\omega}^T}\\right)= \\sum\_{\\mathbf{n}\\in\\mathbb{Z}^2}u\[\\mathbf{n}\]e^{-\\j\\mathbf{\\omega}^T n},\\ \\mathbf{\\omega}\\in\\mathbb{R}^2$
%[text] DFT(FFT)によるDSFTの周波数サンプル計算 (Frequency sampling of DSFT by DFT (FFT))
%[text]  $U\[\\mathbf{k}\] = \\left.U\\left(e^{j\\mathbf{\\omega}^T}\\right)\\right|\_{\\mathbf{\\omega}=2\\pi \\mathbf{Q}^{-T}\\mathbf{k}},\\ \\mathbf{k}\\in\\mathcal{N}(\\mathbf{Q}^T)$
%[text] 関数FFTNを利用．(The function FFTN is used.)
% Setting the number of frequency sample points in [0,2π)^2
nPoints = pow2(nextpow2(size(u)+size(h)-1)); % The least power of two that matches the normal convolution

% Spectrum of u[n]
U = fftn(u,nPoints);
%%
%[text] ### フィルタ $\\{h\[\\mathbf{n}\]\\}\_\\mathbf{n}\n$ の周波数応答
%[text] (Frequency response of filter$\\{h\[\\mathbf{n}\]\\}\_\\mathbf{n}\n$)
%[text]  $H\\left(e^{\\j\\mathbf{\\omega}^T}\\right)= \\sum\_{\\mathbf{n}\\in\\mathbb{Z}^2}h\[\\mathbf{n}\]e^{-\\j\\mathbf{\\omega}^T n},\\ \\mathbf{\\omega}\\in\\mathbb{R}^2$
%[text] DFT(FFT)によるDSFTの周波数サンプル計算 (Frequency sampling of DSFT by DFT (FFT))
%[text]  $H\[\\mathbf{k}\] = \\left.H\\left(e^{j\\mathbf{\\omega}^T}\\right)\\right|\_{\\mathbf{\\omega}=2\\pi \\mathbf{Q}^{-T}\\mathbf{k}},\\ \\mathbf{k}\\in\\mathcal{N}(\\mathbf{Q}^T)$
% Frequency response of h[n]
H = fftn(h,nPoints);
%%
%[text] ### 出力信号 $\\{v\[\\mathbf{n}\]\\}\_\\mathbf{n}\n$ のスペクトル
%[text] (Spectrum of input signal $\\{v\[\\mathbf{n}\]\\}\_\\mathbf{n}\n$)
%[text]  $V\\left(e^{\\j\\mathbf{\\omega}^T}\\right)= \\sum\_{\\mathbf{n}\\in\\mathbb{Z}^2}v\[\\mathbf{n}\]e^{-\\j\\mathbf{\\omega}^T n},\\ \\mathbf{\\omega}\\in\\mathbb{R}^2$
%[text] DFT(FFT)によるDSFTの周波数サンプル計算 (Frequency sampling of DSFT by DFT (FFT))
%[text]  $V\[\\mathbf{k}\] = \\left.V\\left(e^{j\\mathbf{\\omega}^T}\\right)\\right|\_{\\mathbf{\\omega}=2\\pi \\mathbf{Q}^{-T}\\mathbf{k}},\\ \\mathbf{k}\\in\\mathcal{N}(\\mathbf{Q}^T)$
% Frequency response of v[n]
V = fftn(v,nPoints);
%%
%[text] ### スペクトルと周波数応答の表示
%[text] (Display of spectra and frequency response)
%[text]  $V\\left(e^{\\j\\mathbf{\\omega}^T}\\right)=H\\left(e^{\\j\\mathbf{\\omega}^T}\\right)U\\left(e^{\\j\\mathbf{\\omega}^T}\\right)$
% Frequency sample points 
[w1,w2] = meshgrid(-pi:2*pi/nPoints(1):pi-2*pi/nPoints(1),-pi:2*pi/nPoints(2):pi-2*pi/nPoints(2));

% Display of spectrum U
figure(2)
mesh(w1,w2,10*log10(abs(fftshift(U))))
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
% Display of Freq. response H
figure(3)
mesh(w1,w2,10*log10(abs(fftshift(H))))
ax = gca;
xlabel('\omega_2 [rad]')
ylabel('\omega_1 [rad]')
zlabel('Magnitude 10log_{10} |H(e^{-j\omega^T})| [dB]')
axis ij
ax.XLim = [-pi pi];
ax.XTick = [ -pi 0 pi ];
ax.XTickLabel = { '-\pi', '0', '\pi'};
ax.YLim = [-pi pi];
ax.YTick = [ -pi 0 pi ];
ax.YTickLabel = { '-\pi', '0', '\pi'};
colorbar(ax)
% Display of Freq. response V
figure(4)
mesh(w1,w2,10*log10(abs(fftshift(V))))
ax = gca;
xlabel('\omega_2 [rad]')
ylabel('\omega_1 [rad]')
zlabel('Magnitude 10log_{10} |V(e^{-j\omega^T})| [dB]')
axis ij
ax.XLim = [-pi pi];
ax.XTick = [ -pi 0 pi ];
ax.XTickLabel = { '-\pi', '0', '\pi'};
ax.YLim = [-pi pi];
ax.YTick = [ -pi 0 pi ];
ax.YTickLabel = { '-\pi', '0', '\pi'};
colorbar(ax)
%%
%[text] ### 線形シフト不変システムの解析
%[text] (Analysis of linear shift-invariant systems)
%[text] 周波数応答(Frequency response)の表示
%[text]  $H\\left(e^{\\j\\mathbf{\\omega}^T}\\right)= \\left.H(\\mathbf{z})\\right|\_{\\mathbf{z}=e^{\\j\\mathbf{\\omega}^T}},\\ \\mathbf{\\omega}\\in \\mathbb{R}^2$
%[text] - 振幅応答 (Magnitude response): $|H\\left(e^{\\j\\mathbf{\\omega}^T}\\right)|$
%[text] - 位相応答 (Phase response): $\\angle H\\left(e^{\\j\\mathbf{\\omega}^T}\\right)$ \
%[text] 2変量周波数振幅応答の表示関数FREQZ2を利用．(Using FREQZ2, a display function for bivariate frequency magnitude responses.)
figure(5)
freqz2(h)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:dropdown:1899]
%   data: {"defaultValue":"\"gaussian\"","itemLabels":["average","disk","gaussian","log","laplacian","unsharp","prewitt","sobel"],"items":["\"average\"","\"disk\"","\"gaussian\"","\"log\"","\"laplacian\"","\"unsharp\"","\"prewitt\"","\"sobel\""],"label":"ドロップ ダウン","run":"SectionToEnd"}
%---
