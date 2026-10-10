%[text] # Sample 6-5: Univariate upsampling
%[text] Advanced Topics in Image Processing, Lecture 6 "Sampling"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Setting the upsampling ratio
%[text] - $M$: upsampling ratio \
% Upsampling ratio
uFactor = 2; %[control:slider:6e50]{"position":[11,12]}
%%
%[text] ## Setting the input sequence
%[text] - $\\mathsf{x}=\\left(x\[m\]\\right)\_m$: input sequence (a part of the sound data `gong` and `chirp`) \
% Create a sequence from sound data
startIndex = 256;
nInputSamples = 16;
gong = load("gong");
chirpData = load("chirp");
inputSeq = gong.y(startIndex:startIndex+nInputSamples-1) ...
    + chirpData.y(startIndex:startIndex+nInputSamples-1);
%%
%[text] ## Computation of the output sequence
%[text] - $\\mathsf{y}=\\left(y\[n\]\\right)\_n$: output sequence (zero insertion) \
%[text]{"align":"center"} $y\[n\] = \\left\\{\\begin{array}{ll}  x\[n/M\] & n=0,\\pm M, \\pm 2M,\\cdots \\\\ 0 &\\mathrm{otherwise} \\end{array}\\right.$
% Upsampling
outputSeq = upsample(inputSeq,uFactor);
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
plot(ax, 0:uFactor:uFactor*nInputSamples-uFactor+1, inputSeq, ':')
hold(ax, 'off')
axis(ax, [0 uFactor*nInputSamples -1 1])
title(ax, "Output sequence (M = " + uFactor + ")")
xlabel(ax, 'n')
ylabel(ax, 'y[n]')
%%
%[text] ## Setting the input sequence
%[text] A Gaussian window modulated by a cosine wave of the angular frequency $\\omega\_0$ (slider `w`).
% Creation of a modulated Gaussian
w = 0; % Modulation frequency %[control:slider:6f15]{"position":[5,6]}
nInputSamples = 128;
inputSeq = gausswin(nInputSamples);
inputSeq = inputSeq/sum(inputSeq);
inputSeq = inputSeq.*cos((0:(nInputSamples-1)).'*w);
%%
%[text] ## Computation of the output sequence
%[text] The spectrum after upsampling (\[M\] Sec. 5.1.2):
%[text]{"align":"center"} $Y(\\mathrm{e}^{\\mathrm{j}\\omega})=X(\\mathrm{e}^{\\mathrm{j} M\\omega})$
% Upsampling
outputSeq = upsample(inputSeq,uFactor);
%%
%[text] ## Display of the input and output spectra
%[text] The spectrum is compressed to $1/M$ and images appear (imaging).
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
title(ax, "Output sequence (M = " + uFactor + ")")
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
%[control:slider:6e50]
%   data: {"defaultValue":2,"label":"uFactor","max":8,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:6f15]
%   data: {"defaultValue":0,"label":"w","max":3.15,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":0.1}
%---
