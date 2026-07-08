%[text] # Sample 6-2
%[text] ## 標本化
%[text] 単変量ダウンサンプリング
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Sampling
%[text] Univariate downsampling
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ### 間引き率の設定
%[text] (Setting the downsampling factor)
%[text] - $M$: 間引き率 (downsampling factor) \
% Downsampling factor
dFactor = 2; %[control:slider:022f]{"position":[11,12]}
%%
%[text] ### 入力数列の設定
%[text] (Setting an input sequence)
%[text] - $\\{u\[n\]\\}\_n$: 入力数列 (input sequence) \
% Create a sequence from sound data
startIndex = 256;
nInputSamples = 32;
load gong;
inputSeq = y(startIndex:startIndex+nInputSamples-1);
load chirp;
inputSeq = inputSeq + y(startIndex:startIndex+nInputSamples-1);
%%
%[text] ### 出力数列の計算
%[text] (Computation of the output sequence)
%[text] - $\\{v\[n\]\\}\_n$: 出力数列 (output sequence) \
%[text]  $v\[m\] = u\[Mm\],\\ m\\in\\mathbb{Z}$
% Downsampling
outputSeq = downsample(inputSeq,dFactor);
nOutputSamples = length(outputSeq);
%%
%[text] ###  入出力数列の表示
%[text] (Display of the input and output sequences)
% Plot the input and output sequences
figure(1)
% Input sequence
subplot(2,1,1)
stem(0:nInputSamples-1,inputSeq,'filled')
hold on
plot(0:nInputSamples-1,inputSeq,':')
axis([0 nInputSamples -1 1])
title('Input sequence','FontSize',12)
xlabel('n','FontSize',12)
ylabel('u[n]','FontSize',12)
hold off

% Output sequence
subplot(2,1,2)
stem(0:nOutputSamples-1,outputSeq,'filled')
hold on
plot(0:1/dFactor:(nInputSamples-1)/dFactor,inputSeq,':')
axis([0 nInputSamples/dFactor -1 1])
title(sprintf('Output sequence (M = %d)',dFactor),'FontSize',12)
xlabel('m','FontSize',12)
ylabel('v[m]','FontSize',12)
hold off
%%
%[text] ###  入力数列の設定
%[text] (Setting the input sequence)
% Creation of a modulated Gaussian
w = 0; % Modulation frequency %[control:slider:1db9]{"position":[5,6]}
nInputSamples = 128; 
inputSeq = gausswin(nInputSamples);
inputSeq = inputSeq/sum(inputSeq);
inputSeq = inputSeq.*cos((0:(nInputSamples-1)).'*w);
%%
%[text] ###  出力数列の計算
%[text] (Computation of the output sequence)
%[text]  $V(e^{\\j\\omega})=\\frac{1}{M}\\sum\_{k=0}^{M-1}U\\left(e^{\\frac{\\j(\\omega-2\\pi k)}{M}}\\right)$ 
% Downsampling
outputSeq = downsample(inputSeq,dFactor);
nOutputSamples = length(outputSeq);
%%
%[text] ### 入出力スペクトルの表示
%[text] (Display of the input and output spectrum)
% Display spectra
figure(2)
% Input spectrum
subplot(2,1,1)
[H,W] = freqz(inputSeq);
plot(W/pi,20*log10(abs(H)))
title('Input sequence','FontSize',12)
xlabel('\omega /\pi [rad]','FontSize',12)
ylabel('|U(e^{j\omega})| [dB]','FontSize',12)
axis([ 0 1 -70 30 ])
grid on

% Output spectrum
subplot(2,1,2)
[H,W] = freqz(outputSeq);
plot(W/pi,20*log10(abs(H)))
title(sprintf('Output sequence (M = %d)',dFactor),'FontSize',12)
xlabel('\omega /\pi [rad]','FontSize',12)
ylabel('|V(e^{j\omega})| [dB]','FontSize',12)
axis([ 0 1 -70 30 ])
grid on
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:022f]
%   data: {"defaultValue":2,"label":"dFactor","max":8,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:1db9]
%   data: {"defaultValue":0,"label":"w","max":3.15,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":0.1}
%---
