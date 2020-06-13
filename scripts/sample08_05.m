%% Sample 8-5
%% 離散コサイン変換
% DFTとの関係
% 
% 画像処理特論
% 
% 村松 正吾 
% 
% 動作確認: MATLAB R2020a
%% Discrete cosine transform
% Relation to DFT
% 
% Advanced Topics in Image Processing
% 
% Shogo MURAMATSU
% 
% Verified: MATLAB R2020a
% 準備
% (Preparation)

close all
% DCT 行列
% (DCT matrix)
% 
% $$[\mathbf{C}_M]_{k,n}=\sqrt{\frac{2}{M}} \alpha_k\cos\frac{k(n+1∕2)\pi}{M},\ 
% k,n=0,1,\cdots,M-1$$
% 
% $$\alpha_k=\left\{\begin{array}{ll} \frac{1}{\sqrt{2}} & k=0 \\1 & k=1,2,\cdots,M-1\end{array}\right.$$

% DCT points
nPoints = 4;
C = dctmtx(nPoints)
% OTDFT行列
% (OTDFT matrix)
% 
% OTDFTはDCTと深い関係にある。(OTDFT is closely related to DCT.)
% 
% OTDFT: Odd-time discrete Fourier transform (GDFT w/ $a=0,b=1/2$)
%% 
% * 一般化DFT (GDFT: generalized DFT)
%% 
% $$X_{N}^{(a, b)}[k]=\sum_{n=0}^{N-1} x[n] W_{N}^{(k+a)(n+b)},\ k=0,1,\cdots,N-1$$
%% 
% * OTDFT行列 (OTDFT matrix)
%% 
% $$[\mathbf{W}_N^{\left(0,\frac{1}{2}\right)}]_{k,n}=e^{-\j\frac{\pi}{N}k}e^{-\j\frac{2\pi}{N}kn}$$

% DFT points
nPointsDft = 2 * nPoints;

% OTDFT matrix
k=0:nPointsDft-1;
Wdft = dftmtx(nPointsDft);
Lambda = diag(exp(-1j*pi/nPointsDft*k));
Wotdft = Lambda * Wdft
% OTDFT によるDCT
% (DCT through OTDFT)
% 
% OTDFTとDCTの関係 (Relation between OTDFT and DCT)
% 
% $$\left[\mathbf{C}_{M}\right]_{k, n}=\frac{\alpha_{k}}{\sqrt{2 M}}\left[\mathbf{W}_{2 
% M}^{\left(0, \frac{1}{2}\right)} \mathbf{E}_{M}\right]_{k, n},\ k,n=0,1,\cdots,M-1$$
% 
% ただし、 $\mathbf{E}_{M}$ は対称拡張行列 (where $\mathbf{E}_{M}$is the symmetric extension 
% matrix defined by )
% 
% $$\mathbf{E}_{M}=\left(\begin{array}{cccc}1 & 0 & \cdots & 0 \\0 & 1 & \cdots 
% & 0 \\\vdots & \vdots & \ddots & \vdots \\0 & 0 & \cdots & 1 \\0 & 0 & \cdots 
% & 1 \\\vdots & \vdots & \ddots & \vdots \\0 & 1 & \cdots & 0 \\1 & 0 & \cdots 
% & 0\end{array}\right).$$
% 
% である。

% Symmetric extension matrix
E = [ eye(nPoints) ; fliplr(eye(nPoints)) ]

% DCT matrix through OTDFT
D = 1/sqrt(2*nPoints)*...
    diag([1/sqrt(2) ones(1,nPoints-1) ])*...
    Wotdft(1:nPoints,:)*E
%% 
% 誤差の評価 (Evaluation of error)

norm(D-C,'Fro')
%% 
% Wdft による変換(DFT)には、高速フーリエ変換(FFT)を適用できる。(The Fast Fourier Transform (FFT) can 
% be applied to the  transform with Wdft (DFT).)
%% 
% © Copyright, Shogo MURAMATSU, All rights reserved.