%[text] # Sample 5-1
%[text] ## 周波数解析
%[text] 単変量畳み込み
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Fourier analysis
%[text] Univariate convolution
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ### 入力信号 $\\{u\[n\]\\}\_n\n$ 
%[text] (Input signal $\\{u\[n\]\\}\_n\n$)
% Input u[n]
u = [1 2 3];
%%
%[text] ### 線形シフト不変システムのインパルス応答 $\\{h\[n\]\\}\_n\n$ 
%[text] (Impulse response of a linear shift-invariant system $\\{h\[n\]\\}\_n\n$)
% Impulse response h[n]
h = [1 1 1]/3;
%%
%[text] ### 線形シフト不変システムの出力応答$\\{v\[n\]\\}\_n\n$ 
%[text] (The linear shift-invariant system response $\\{v\[n\]\\}\_n\n$)
%[text] 畳み込み演算 (Convolution)
%[text]  $\\{v\[n\]\\}\_n=\\{h\[n\]\\}\_n \\ast \\{u\[n\]\\}\_n = \\sum\_{k=-\\infty}^{\\infty}u\[k\]\\{h\[n-k\]\\}\_n\n$
% Output v[n]
v = conv(h,u);
%%
%[text] ### 入力信号 $\\{u\[n\]\\}\_n\n$ のスペクトル
%[text] (Spectrum of input signal $\\{u\[n\]\\}\_n\n$)
%[text]  $U(e^{\\j\\omega})= \\sum\_{n=-\\infty}^{\\infty}u\[n\]e^{-\\j\\omega n},\\ \\omega\\in\\mathbb{R}$
%[text] DFT(FFT)によるDTFTの周波数サンプル計算 (Frequency sampling of DTFT by DFT (FFT))
%[text]  $U\[k\] = \\left.U(e^{j\\omega})\\right|\_{\\omega=\\frac{2\\pi }{N}k},\\ k\\in\\{0,1,2,\\cdots,N-1\\}$
% Setting the number of frequency sample points in [0,2π)
nPoints = 128; %[control:slider:5824]{"position":[11,14]}

% Spectrum of u[n]
U = fft(u,nPoints);
%%
%[text] ### フィルタ $\\{h\[n\]\\}\_n\n$ の周波数応答
%[text] (Frequency response of filter$\\{h\[n\]\\}\_n\n$)
%[text]  $H(e^{\\j\\omega})= \\sum\_{n=-\\infty}^{\\infty}h\[n\]e^{-\\j\\omega n},\\ \\omega\\in\\mathbb{R}$
%[text] DFT(FFT)によるDTFTの周波数サンプル計算 (Frequency sampling of DTFT by DFT (FFT))
%[text]  $H\[k\] = \\left.H(e^{j\\omega})\\right|\_{\\omega=\\frac{2\\pi }{N}k},\\ k\\in\\{0,1,2,\\cdots,N-1\\}$
% Frequency response of h[n]
H = fft(h,nPoints);
%%
%[text] ### 出力信号 $\\{v\[n\]\\}\_n\n$ のスペクトル
%[text] (Spectrum of input signal $\\{v\[n\]\\}\_n\n$)
%[text]  $V(e^{\\j\\omega})= \\sum\_{n=-\\infty}^{\\infty}v\[n\]e^{-\\j\\omega n},\\ \\omega\\in\\mathbb{R}$
%[text] DFT(FFT)によるDTFTの周波数サンプル計算 (Frequency sampling of DTFT by DFT (FFT))
%[text]  $V\[k\] = \\left.V(e^{\\j\\omega})\\right|\_{\\omega=\\frac{2\\pi }{N}k},\\ k\\in\\{0,1,2,\\cdots,N-1\\}$
% Frequency response of v[n]
V = fft(v,nPoints);
%%
%[text] ### スペクトルと周波数応答の表示
%[text] (Display of spectra and frequency response)
%[text]  $V(e^{\\j\\omega})=H(e^{\\j\\omega})U(e^{\\j\\omega})$
% Frequency sample points 
w = 0:2*pi/nPoints:2*pi-1/nPoints;

% Display of spectra and frequency response
figure(1)
ax = gca;
plot(ax,w,abs(U),'b',w,abs(H),'k:',w,abs(V),'r-.')
grid(ax,'on')
xlabel(ax,'Normalized angular frequency \omega [rad]')
ylabel(ax,'Magnitude [-]')
legend(ax,'|U(e^{j\omega})|','|H(e^{j\omega})|','|V(e^{j\omega})|')
ax.XLim = [0 2*pi];
ax.XTick = [0 pi 2*pi];
ax.XTickLabel = {'0', '\pi', '2\pi' };
%%
%[text] ### 線形シフト不変システムの解析
%[text] (Analysis of linear shift-invariant systems)
%[text] #### インパルス応答
%[text] (Impulse respone)
%[text]  $h\[n\],\\ n\\in\\mathbb{Z}\n$ 
figure(2)
impz(h)
%[text] #### 伝達関数
%[text] (Transfer function)
%[text]  $H(z)= \\sum\_{n=-\\infty}^{\\infty}h\[n\]z^{-n},\\ z\\in\\mathbb{C}$
figure(3)
zplane(h)
%[text] #### 周波数応答
%[text] (Frequency response)
%[text]  $H(e^{\\j\\omega})= \\left.H(z)\\right|\_{z=e^{\\j\\omega}},\\ \\omega\\in \\mathbb{R}$
%[text] - 振幅応答 (Magnitude response): $|H(e^{\\j\\omega})|$
%[text] - 位相応答 (Phase response): $\\angle H(e^{\\j\\omega})$ \
figure(4)
freqz(h)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:5824]
%   data: {"defaultValue":128,"label":"nPoints","max":512,"min":16,"run":"SectionToEnd","runOn":"ValueChanging","step":16}
%---
