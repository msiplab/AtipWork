%[text] # Sample 9-3
%[text] ## 離散ウェーブレット変換
%[text] 重複変換のフィルタバンク実装
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Discrete wavelet transform
%[text] Filter bank implementation of lapped transforms
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ## 入力信号の生成
%[text] (Generation of input)
% Input signal
u = [ 0 3 1 3 1 5 3 0 ]; % Set to even length
%%
%[text] ### 並列フィルタバンク実装
%[text] (Parallel filter bank implementation)
%[text] 分析フィルタバンクをデシメータで、合成フィルタバンクをインタポレータで実装 (Analysis filter banks are implemented with decimetors and synthesis filter banks are implemented with interpolators.)
% # of channels
nChs = 2;

% Analysis filters (Daubiches 2 wavelet filter)
h0 = [   (1-sqrt(3)) (3-sqrt(3))  (3+sqrt(3)) (1+sqrt(3)) ]/(4*sqrt(2));
h1 = [  -(1+sqrt(3)) (3+sqrt(3)) -(3-sqrt(3)) (1-sqrt(3)) ]/(4*sqrt(2));

% Synthesis filters (Daubiches 2 wavelet filter)
f0 = fliplr(h0);
f1 = fliplr(h1);

% Or the function WFILTERS from Wavelet Toolbox as
% [h0,h1,f0,f1] = wfilters('db2');

% Analysis process
s0 = downsample(conv(h0,u),nChs);
s1 = downsample(conv(h1,u),nChs);

% Synthesis process
v0 = conv(f0,upsample(s0,nChs));
v1 = conv(f1,upsample(s1,nChs));
v = v0 + v1;
%%
%[text] ## 信号表示
%[text] (Signal display)
figure(1)
% Input
subplot(3,2,[1,2])
stem(0:length(u)-1,u,'filled')
title('Input u[n]')
xlabel('n')
ax = gca;
ax.XLim =[ 0 length(v)];

% Subband 0
subplot(3,2,3)
stem(0:length(s0)-1,s0,'filled')
title('Subbnad s_0[m]')
xlabel('m')
ax = gca;
ax.YLim =[ min([s0(:);s1(:)]) max([s0(:);s1(:)]) ];

% Subband 1
subplot(3,2,4)
stem(0:length(s1)-1,s1,'filled')
title('Subbnad s_1[m]')
xlabel('m')
ax = gca;
ax.YLim =[ min([s0(:);s1(:)]) max([s0(:);s1(:)]) ];

% Output
subplot(3,2,[5,6])
stem(0:length(v)-1,v,'filled')
title('Outut v[n]')
xlabel('n')
ax = gca;
ax.XLim =[ 0 length(v)];
%%
%[text] ### インパルス応答（局所基底ベクトル）
%[text] (Impluse responses of synthesis filters; local basis vectors)
figure(2)
% Low-pass filter
subplot(1,2,1)
impz(f0)
title('f_0[n]')
ax = gca;
ax.YLim =[ min([f0(:);f1(:)]) max([f0(:);f1(:)]) ];

% High-pass filter
subplot(1,2,2)
impz(f1)
title('f_1[n]')
ax = gca;
ax.YLim =[ min([f0(:);f1(:)]) max([f0(:);f1(:)]) ];
%%
%[text] ### 周波数応答
%[text] (Frequency responses)
figure(3)
fftPoints = 512;
F = zeros(fftPoints,nChs);
% Low-pass filter
[F(:,1),W] = freqz(f0,1,fftPoints);
% High-pass filter
F(:,2)     = freqz(f1,1,fftPoints);
plot(W/pi, abs(F)) %20*log10(abs(F)))
axis([0 1 0 ceil(sqrt(nChs))]) %-70 10])
xlabel('Normalized Frequency (x\pi rad/sample)')
ylabel('Magnitude') % (dB)')
title('Frequency response of synthesis filters')
legend({ 'F_0', 'F_1'})
grid on
%%
%[text] ### ポリフェーズ行列実装
%[text] (Polyphase matrix implemenation)
%[text] フィルタバンクをポリフェーズフィルタに分解して、ポリフェーズ行列として実装 (Decompose the filter bank into polyphase filters and implement them in a polyphase matrix.)
%[text]  $\\mathbf{E}(z)=\\left(\\begin{array}{cc}  h\_0\[0\] &h\_0\[1\]\\\\ h\_1\[0\]& h\_1\[1\]\\end{array}\\right)\n+\\left(\\begin{array}{cc}  h\_0\[2\] &h\_0\[3\]\\\\ h\_1\[2\]& h\_1\[3\]\\end{array}\\right)z^{-1}\n=\\left(\\begin{array}{cc}  h\_0\[0\]+h\_0\[2\]z^{-1} &h\_0\[1\]+h\_0\[3\]z^{-1} \\\\ h\_1\[0\]+h\_1\[2\]z^{-1}& h\_1\[1\]+h\_1\[3\]z^{-1}\\end{array}\\right)$
%[text]  $\\mathbf{R}(z)=\\left(\\begin{array}{cc}  f\_0\[1\] &f\_1\[1\]\\\\ f\_0\[0\]& f\_1\[0\]\\end{array}\\right)\n+\\left(\\begin{array}{cc}  f\_0\[3\] &f\_1\[3\]\\\\ f\_0\[2\]& f\_1\[2\]\\end{array}\\right)z^{-1}\n=\\left(\\begin{array}{cc}  f\_0\[1\]+f\_0\[3\]z^{-1} &f\_1\[1\]+f\_1\[3\]z^{-1} \\\\ f\_0\[0\]+f\_0\[2\]z^{-1}& f\_1\[0\]+f\_1\[2\]z^{-1}\\end{array}\\right)$
% Type-I polyphase filters of analyzer
e00 = h0(1:nChs:end);
e01 = h0(2:nChs:end);
e10 = h1(1:nChs:end);
e11 = h1(2:nChs:end);

% Type-II polyphase filters of synthesizer
r00 = f0(2:nChs:end);
r10 = f0(1:nChs:end);
r01 = f1(2:nChs:end);
r11 = f1(1:nChs:end);
%[text] 分析合成処理 (Analysis and synthesis process)
% Input Signal
uadj = [zeros(1,nChs-1) u 0]; % Adjust delay for downsampling
disp(uadj)
% Serial/Pallalel conversion
phase = 0;
u0 = downsample(uadj,nChs,mod(nChs-1-phase,nChs)); 
phase = 1;
u1 = downsample(uadj,nChs,mod(nChs-1-phase,nChs));
x = [ u0 ; 
      u1 ];
disp(x)
%[text] （補足）z-変換の定義 (Definition of z-transform)
%[text]  $X(z) = \\sum\_{n=-\\infty}^{\\infty}x\[n\]z^{-n}$
%[text] 畳み込みとの関係 (Relation to convolution)
%[text]  $y\[n\]=h\[n\]\\ast x\[n\] \\leftrightarrow Y(z)=H(z)X(z)$
% Analysis process w/ the polyphase matrix
% s = E*x
s0 = conv(e00,u0) + conv(e01,u1);
s1 = conv(e10,u0) + conv(e11,u1);
disp([s0;s1])
% Synthesis process w/ the polyphase matrix
% v = R*s
v0 = conv(r00,s0) + conv(r01,s1);
v1 = conv(r10,s0) + conv(r11,s1);
disp([v0;v1])
% Parallel/Serial conversion
v = upsample(v0,nChs,1) + upsample(v1,nChs,0);
disp(v)
%%
%[text] ### ポリフェーズ行列実装（PPMATRIXオブジェクト利用）
%[text] (Polyphase matrix implemenation with PPMATRIX object)
%[text] ポリフェーズ行列演算が簡便となるよう以下のクラスを定義した。インスタンス化の際、3番目の添え字が遅延を示す3次元配列を渡す。(In order to make polyphase matrix operations easier, the following classe is defined. At instantiation, plase pass a three-dimensional array where the third subscript indicates a delay.)
%[text] - PPMATRIX： Polyphase Matrix Class (originally from saivdr.dictionary.utility.PolyPhaseMatrix1D in [SaivDr package](https://github.com/msiplab/SaivDr) ) \
%[text] 分析合成処理 (Analysis and synthesis process)
import msip.ppmatrix
% Polyphase matrix of analysis bank
e00 = reshape(e00,1,1,length(e00));
e01 = reshape(e01,1,1,length(e01));
e10 = reshape(e10,1,1,length(e10));
e11 = reshape(e11,1,1,length(e11));
E = ppmatrix(cat(1,cat(2,e00,e01),cat(2,e10,e11)))
% Polyphase matrix of synthesis bank
r00 = reshape(r00,1,1,length(r00));
r10 = reshape(r10,1,1,length(r10));
r01 = reshape(r01,1,1,length(r01));
r11 = reshape(r11,1,1,length(r11));
R = ppmatrix(cat(1,cat(2,r00,r01),cat(2,r10,r11)))
%[text] 完全再構成条件の確認 (Confirmation of perfect reconstruction)
%[text]  $\\mathbf{R}(z)\\mathbf{E}(z)=(\\mathbf{R}\_0 +\\mathbf{R}\_1 z^{-1} )(\\mathbf{E}\_0 + \\mathbf{E}\_1 z^{-1} )=\\mathbf{R}\_0 \\mathbf{E}\_0 + (\\mathbf{R}\_1 \\mathbf{E}\_0 +\\mathbf{R}\_0 \\mathbf{E}\_1 )z^{-1}+\\mathbf{R}\_1\\mathbf{E}\_1 z^{-2}=z^{-1}\\mathbf{I} $ 
disp(R*E)
% Define delaychain
clear delaychain
delaychain(1,1,1) = 1;
delaychain(2,1,2) = 1;
delaychain = ppmatrix(delaychain)
% Z-transform of input
u = ppmatrix(reshape(u,1,1,length(u)));
disp(u)
% Polyphase decomposition of input
x = downsample(delaychain*u,nChs);
disp(x)
% Analysis process w/ the polyphase matrix
s = E*x;
disp(s)
% Synthesis process w/ the polyphase matrix
y = R*s;
disp(y)
% Parallel/Serial conversion
v = delaychain.'*upsample(y,nChs);
disp(v)
disp(squeeze(double(v)).')
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
