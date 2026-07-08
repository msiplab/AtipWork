%[text] # Sample 8-5
%[text] ## 離散コサイン変換
%[text] DFTとの関係
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Discrete cosine transform
%[text] Relation to DFT
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ### DCT 行列
%[text] (DCT matrix)
%[text]  $\[\\mathbf{C}\_M\]\_{k,n}=\\sqrt{\\frac{2}{M}} \\alpha\_k\\cos\\frac{k(n+1∕2)\\pi}{M},\\ k,n=0,1,\\cdots,M-1$
%[text]  $\\alpha\_k=\\left\\{\\begin{array}{ll} \\frac{1}{\\sqrt{2}} & k=0 \\\\1 & k=1,2,\\cdots,M-1\\end{array}\\right.$
% DCT points
nPoints = 4; %[control:slider:71dc]{"position":[11,12]}
C = dctmtx(nPoints)
%%
%[text] ### OTDFT行列
%[text] (OTDFT matrix)
%[text] OTDFTはDCTと深い関係にある。(OTDFT is closely related to DCT.)
%[text] OTDFT: Odd-time discrete Fourier transform (GDFT w/ $a=0,b=1/2$)
%[text] - 一般化DFT (GDFT: generalized DFT) \
%[text]  $X\_{N}^{(a, b)}\[k\]=\\sum\_{n=0}^{N-1} x\[n\] W\_{N}^{(k+a)(n+b)},\\ k=0,1,\\cdots,N-1$
%[text] - OTDFT行列 (OTDFT matrix) \
%[text]  $\[\\mathbf{W}\_N^{\\left(0,\\frac{1}{2}\\right)}\]\_{k,n}=e^{-\\j\\frac{\\pi}{N}k}e^{-\\j\\frac{2\\pi}{N}kn}$
% DFT points
nPointsDft = 2 * nPoints;

% OTDFT matrix
k=0:nPointsDft-1;
Wdft = dftmtx(nPointsDft);
Lambda = diag(exp(-1j*pi/nPointsDft*k));
Wotdft = Lambda * Wdft
%%
%[text] ### OTDFT によるDCT
%[text] (DCT through OTDFT)
%[text] OTDFTとDCTの関係 (Relation between OTDFT and DCT)
%[text]  $\\left\[\\mathbf{C}\_{M}\\right\]\_{k, n}=\\frac{\\alpha\_{k}}{\\sqrt{2 M}}\\left\[\\mathbf{W}\_{2 M}^{\\left(0, \\frac{1}{2}\\right)} \\mathbf{E}\_{M}\\right\]\_{k, n},\\ k,n=0,1,\\cdots,M-1$
%[text] ただし、 $\\mathbf{E}\_{M}$ は対称拡張行列 (where $\\mathbf{E}\_{M}$is the symmetric extension matrix defined by )
%[text]  $\\mathbf{E}\_{M}=\\left(\\begin{array}{cccc}1 & 0 & \\cdots & 0 \\\\0 & 1 & \\cdots & 0 \\\\\\vdots & \\vdots & \\ddots & \\vdots \\\\0 & 0 & \\cdots & 1 \\\\0 & 0 & \\cdots & 1 \\\\\\vdots & \\vdots & \\ddots & \\vdots \\\\0 & 1 & \\cdots & 0 \\\\1 & 0 & \\cdots & 0\\end{array}\\right).$
%[text] である。
% Symmetric extension matrix
E = [ eye(nPoints) ; fliplr(eye(nPoints)) ]

% DCT matrix through OTDFT
D = 1/sqrt(2*nPoints)*...
    diag([1/sqrt(2) ones(1,nPoints-1) ])*...
    Wotdft(1:nPoints,:)*E
%[text] 誤差の評価 (Evaluation of error)
norm(D-C,'Fro')
%[text] Wdft による変換(DFT)には、高速フーリエ変換(FFT)を適用できる。(The Fast Fourier Transform (FFT) can be applied to the  transform with Wdft (DFT).)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:71dc]
%   data: {"defaultValue":4,"label":"nPoints","max":8,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
