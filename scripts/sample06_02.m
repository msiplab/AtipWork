%[text] # Sample 6-2: Univariate downsampling
%[text] Advanced Topics in Image Processing, Lecture 6 "Sampling"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Setting the downsampling ratio
%[text] - $M$: downsampling ratio \
% Downsampling ratio
dFactor = 2; %[control:slider:85ef]{"position":[11,12]}
%%
%[text] ## Setting an input sequence
%[text] - $\\mathsf{x}=\\left(x\[m\]\\right)\_m$: input sequence (a part of the sound data `gong` and `chirp`) \
% Create a sequence from sound data
startIndex = 256;
nInputSamples = 32;
gong = load("gong");
chirpData = load("chirp");
inputSeq = gong.y(startIndex:startIndex+nInputSamples-1) ...
    + chirpData.y(startIndex:startIndex+nInputSamples-1);
%%
%[text] ## Computation of the output sequence
%[text] - $\\mathsf{y}=\\left(y\[n\]\\right)\_n$: output sequence \
%[text]{"align":"center"} $y\[n\] = x\[Mn\],\\ n\\in\\mathbb{Z}$
% Downsampling
outputSeq = downsample(inputSeq,dFactor);
nOutputSamples = length(outputSeq);
%%
%[text] ## Display of the input and output sequences
fig1 = figure;
tl1 = tiledlayout(fig1, 2, 1);
% Input sequence
ax = nexttile(tl1);
stem(ax, 0:nInputSamples-1, inputSeq, 'filled')
hold(ax, 'on')
plot(ax, 0:nInputSamples-1, inputSeq, ':')
hold(ax, 'off')
axis(ax, [0 nInputSamples -1 1])
title(ax, 'Input sequence')
xlabel(ax, 'm')
ylabel(ax, 'x[m]')
% Output sequence
ax = nexttile(tl1);
stem(ax, 0:nOutputSamples-1, outputSeq, 'filled')
hold(ax, 'on')
plot(ax, 0:1/dFactor:(nInputSamples-1)/dFactor, inputSeq, ':')
hold(ax, 'off')
axis(ax, [0 nInputSamples/dFactor -1 1])
title(ax, "Output sequence (M = " + dFactor + ")")
xlabel(ax, 'n')
ylabel(ax, 'y[n]')
%%
%[text] ## Setting the input sequence
%[text] A Gaussian window modulated by a cosine wave of the angular frequency $\\omega\_0$ (slider `w`).
% Creation of a modulated Gaussian
w = 0; % Modulation frequency %[control:slider:9765]{"position":[5,6]}
nInputSamples = 128;
inputSeq = gausswin(nInputSamples);
inputSeq = inputSeq/sum(inputSeq);
inputSeq = inputSeq.*cos((0:(nInputSamples-1)).'*w);
%%
%[text] ## Computation of the output sequence
%[text] The spectrum after downsampling (\[M\] Sec. 5.1.1):
%[text]{"align":"center"} $Y(\\mathrm{e}^{\\mathrm{j}\\omega})=\\frac{1}{M}\\sum\_{k=0}^{M-1}X\\left(\\mathrm{e}^{\\mathrm{j}(\\omega-2\\pi k)/M}\\right)$
% Downsampling
outputSeq = downsample(inputSeq,dFactor);
%%
%[text] ## Display of the input and output spectra
%[text] The terms with $k\\neq0$ are the aliasing components.
fig2 = figure;
tl2 = tiledlayout(fig2, 2, 1);
% Input spectrum
ax = nexttile(tl2);
[H,W] = freqz(inputSeq);
plot(ax, W/pi, 20*log10(abs(H)))
title(ax, 'Input sequence')
xlabel(ax, '\omega /\pi [rad]')
ylabel(ax, '|X(e^{j\omega})| [dB]')
axis(ax, [0 1 -70 30])
grid(ax, 'on')
% Output spectrum
ax = nexttile(tl2);
[H,W] = freqz(outputSeq);
plot(ax, W/pi, 20*log10(abs(H)))
title(ax, "Output sequence (M = " + dFactor + ")")
xlabel(ax, '\omega /\pi [rad]')
ylabel(ax, '|Y(e^{j\omega})| [dB]')
axis(ax, [0 1 -70 30])
grid(ax, 'on')
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:85ef]
%   data: {"defaultValue":2,"label":"dFactor","max":8,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:9765]
%   data: {"defaultValue":0,"label":"w","max":3.15,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":0.1}
%---
