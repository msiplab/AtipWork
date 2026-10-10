%[text] # Sample 9-3: Daubechies-2 wavelet filters
%[text] Advanced Topics in Image Processing, Lecture 9 "Discrete Wavelet Transforms"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%[text] Filter bank implementation of a lapped transform with the Daubechies-2 (DB2) filters.
%%
%[text] ## Generation of the input
% Input signal x[n]
x = [ 0 3 1 3 1 5 3 0 ]; % even length
%%
%[text] ## Parallel filter bank implementation
%[text] The analysis filter bank is implemented with decimators and the synthesis filter bank with interpolators.
%[text] - Analysis filters: $h\_0\[n\]=2^{-5/2}(1-\\sqrt{3},\\ 3-\\sqrt{3},\\ 3+\\sqrt{3},\\ 1+\\sqrt{3})$,
%[text]   $h\_1\[n\]=2^{-5/2}(-1-\\sqrt{3},\\ 3+\\sqrt{3},\\ -3+\\sqrt{3},\\ 1-\\sqrt{3})$
%[text] - Synthesis filters: time reversal $f\_p\[n\]=h\_p\[3-n\]$
% Number of channels
nChs = 2;

% Analysis filters (Daubechies-2 wavelet filters)
h0 = [   (1-sqrt(3)) (3-sqrt(3))  (3+sqrt(3)) (1+sqrt(3)) ]/(4*sqrt(2));
h1 = [  -(1+sqrt(3)) (3+sqrt(3)) -(3-sqrt(3)) (1-sqrt(3)) ]/(4*sqrt(2));

% Synthesis filters (Daubechies-2 wavelet filters)
f0 = fliplr(h0);
f1 = fliplr(h1);

% Or the function WFILTERS of Wavelet Toolbox as
% [h0,h1,f0,f1] = wfilters("db2");

% Analysis process
y0 = downsample(conv(h0,x),nChs);
y1 = downsample(conv(h1,x),nChs);

% Synthesis process
xhat0 = conv(f0,upsample(y0,nChs));
xhat1 = conv(f1,upsample(y1,nChs));
xhat = xhat0 + xhat1;
%%
%[text] ## Signal display
figure
tiledlayout(3,2,"TileSpacing","compact")
% Input
nexttile([1 2])
stem(0:length(x)-1,x,"filled")
title("Input x[n]")
xlabel("n")
xlim([0 length(xhat)])

% Subband 0
ylims = [min([y0(:);y1(:)]) max([y0(:);y1(:)])];
nexttile
stem(0:length(y0)-1,y0,"filled")
title("Subband y_0[m]")
xlabel("m")
ylim(ylims)

% Subband 1
nexttile
stem(0:length(y1)-1,y1,"filled")
title("Subband y_1[m]")
xlabel("m")
ylim(ylims)

% Output
nexttile([1 2])
stem(0:length(xhat)-1,xhat,"filled")
title("Output x\_hat[n]")
xlabel("n")
xlim([0 length(xhat)])
%%
%[text] ## Impulse responses of the synthesis filters (local basis vectors)
figure
tiledlayout(1,2,"TileSpacing","compact")
ylims = [min([f0(:);f1(:)]) max([f0(:);f1(:)])];
% Low-pass filter
nexttile
stem(0:length(f0)-1,f0,"filled")
title("f_0[n]"), xlabel("n")
ylim(ylims)
% High-pass filter
nexttile
stem(0:length(f1)-1,f1,"filled")
title("f_1[n]"), xlabel("n")
ylim(ylims)
%%
%[text] ## Frequency responses
figure
fftPoints = 512;
F = zeros(fftPoints,nChs);
% Low-pass filter
[F(:,1),W] = freqz(f0,1,fftPoints);
% High-pass filter
F(:,2)     = freqz(f1,1,fftPoints);
plot(W/pi, abs(F))
axis([0 1 0 ceil(sqrt(nChs))])
xlabel("Normalized frequency (\times\pi rad/sample)")
ylabel("Magnitude")
title("Frequency responses of the synthesis filters")
legend(["F_0","F_1"])
grid on
%%
%[text] ## Polyphase matrix implementation
%[text] The filter bank is decomposed into polyphase filters and implemented with polyphase matrices.
%[text]  $\\mathbf{E}(z)=\\begin{pmatrix}  h\_0\[0\] & h\_0\[1\] \\\\ h\_1\[0\] & h\_1\[1\] \\end{pmatrix}+\\begin{pmatrix}  h\_0\[2\] & h\_0\[3\] \\\\ h\_1\[2\] & h\_1\[3\] \\end{pmatrix}z^{-1}=\\begin{pmatrix}  h\_0\[0\]+h\_0\[2\]z^{-1} & h\_0\[1\]+h\_0\[3\]z^{-1} \\\\ h\_1\[0\]+h\_1\[2\]z^{-1} & h\_1\[1\]+h\_1\[3\]z^{-1} \\end{pmatrix}$
%[text]  $\\mathbf{R}(z)=\\begin{pmatrix}  f\_0\[1\] & f\_1\[1\] \\\\ f\_0\[0\] & f\_1\[0\] \\end{pmatrix}+\\begin{pmatrix}  f\_0\[3\] & f\_1\[3\] \\\\ f\_0\[2\] & f\_1\[2\] \\end{pmatrix}z^{-1}=\\begin{pmatrix}  f\_0\[1\]+f\_0\[3\]z^{-1} & f\_1\[1\]+f\_1\[3\]z^{-1} \\\\ f\_0\[0\]+f\_0\[2\]z^{-1} & f\_1\[0\]+f\_1\[2\]z^{-1} \\end{pmatrix}$
% Type-I polyphase filters of the analyzer
e00 = h0(1:nChs:end);
e01 = h0(2:nChs:end);
e10 = h1(1:nChs:end);
e11 = h1(2:nChs:end);

% Type-II polyphase filters of the synthesizer
r00 = f0(2:nChs:end);
r10 = f0(1:nChs:end);
r01 = f1(2:nChs:end);
r11 = f1(1:nChs:end);
%[text] Analysis and synthesis process
% Input signal
xadj = [zeros(1,nChs-1) x 0]; % adjust the delay for downsampling
disp(xadj)
% Serial-to-parallel conversion
phase = 0;
x0 = downsample(xadj,nChs,mod(nChs-1-phase,nChs));
phase = 1;
x1 = downsample(xadj,nChs,mod(nChs-1-phase,nChs));
disp([x0; x1])
%[text] (Note) Definition of the $z$-transform
%[text]  $X(z)=\\sum\_{n=-\\infty}^{\\infty}x\[n\]z^{-n}$
%[text] Relation to the convolution
%[text]  $y\[n\]=(h\\ast x)\[n\] \\leftrightarrow Y(z)=H(z)X(z)$
% Analysis process with the polyphase matrix: y = E*x
y0 = conv(e00,x0) + conv(e01,x1);
y1 = conv(e10,x0) + conv(e11,x1);
disp([y0;y1])
% Synthesis process with the polyphase matrix: xhat = R*y
xhat0 = conv(r00,y0) + conv(r01,y1);
xhat1 = conv(r10,y0) + conv(r11,y1);
disp([xhat0;xhat1])
% Parallel-to-serial conversion
xhat = upsample(xhat0,nChs,1) + upsample(xhat1,nChs,0);
disp(xhat)
%%
%[text] ## Polyphase matrix implementation with the PPMATRIX class
%[text] To make the polyphase matrix operations easy, the following class is defined.  At instantiation, pass a
%[text] three-dimensional array whose third index indicates the delay (power of $z^{-1}$).
%[text] - `msip.ppmatrix`: polyphase matrix class (originally `saivdr.dictionary.utility.PolyPhaseMatrix1D` of the [SaivDr package](https://github.com/msiplab/SaivDr))
%[text] Analysis and synthesis process
% Polyphase matrix of the analysis bank
e00 = reshape(e00,1,1,length(e00));
e01 = reshape(e01,1,1,length(e01));
e10 = reshape(e10,1,1,length(e10));
e11 = reshape(e11,1,1,length(e11));
E = msip.ppmatrix(cat(1,cat(2,e00,e01),cat(2,e10,e11)))
% Polyphase matrix of the synthesis bank
r00 = reshape(r00,1,1,length(r00));
r10 = reshape(r10,1,1,length(r10));
r01 = reshape(r01,1,1,length(r01));
r11 = reshape(r11,1,1,length(r11));
R = msip.ppmatrix(cat(1,cat(2,r00,r01),cat(2,r10,r11)))
%[text] Confirmation of the perfect reconstruction
%[text]  $\\mathbf{R}(z)\\mathbf{E}(z)=(\\mathbf{R}\_0 +\\mathbf{R}\_1 z^{-1} )(\\mathbf{E}\_0 + \\mathbf{E}\_1 z^{-1} )=\\mathbf{R}\_0 \\mathbf{E}\_0 + (\\mathbf{R}\_1 \\mathbf{E}\_0 +\\mathbf{R}\_0 \\mathbf{E}\_1 )z^{-1}+\\mathbf{R}\_1\\mathbf{E}\_1 z^{-2}=z^{-c}\\mathbf{I}$
disp(R*E)
% Delay chain
delaychain = zeros(2,1,2);
delaychain(1,1,1) = 1;
delaychain(2,1,2) = 1;
delaychain = msip.ppmatrix(delaychain)
% z-transform of the input
x = msip.ppmatrix(reshape(x,1,1,length(x)));
disp(x)
% Polyphase decomposition of the input
xp = downsample(delaychain*x,nChs);
disp(xp)
% Analysis process with the polyphase matrix
y = E*xp;
disp(y)
% Synthesis process with the polyphase matrix
xhatp = R*y;
disp(xhatp)
% Parallel-to-serial conversion
xhat = delaychain.'*upsample(xhatp,nChs);
disp(xhat)
disp(squeeze(double(xhat)).')
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
