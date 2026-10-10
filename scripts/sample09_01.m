%[text] # Sample 9-1: FB implementation of block transforms
%[text] Advanced Topics in Image Processing, Lecture 9 "Discrete Wavelet Transforms"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Generation of the input
% Input signal x[n]
x = [ 0 3 1 3 1 5 3 0 ]; % even length
%%
%[text] ## Parallel filter bank implementation
%[text] The analysis filter bank is implemented with decimators and the synthesis filter bank with interpolators.
%[text] Haar filter bank with the sign convention of the reference text (Example "Haar DWT", Sec. 6.4.1), scaled
%[text] by $1/\\sqrt{2}$ (analysis) and $\\sqrt{2}$ (synthesis):
%[text] - Analysis filters: $H\_0(z)=\\frac{1}{2}(1+z^{-1})$, $H\_1(z)=\\frac{1}{2}(-1+z^{-1})$
%[text] - Synthesis filters (causal, delayed by $z^{-2}$): $F\_0(z)=z^{-1}(1+z^{-1})$, $F\_1(z)=z^{-1}(1-z^{-1})$ \
%[text] The output is the input delayed by two samples, $\\hat{x}\[n\]=x\[n-2\]$.
% Number of channels (= decimation factor M)
nChs = 2;

% Analysis filters (n = 0,1)
h0 = [  1 1 ]/2;
h1 = [ -1 1 ]/2;

% Synthesis filters (n = 0,1,2)
f0 = [ 0 1  1 ];
f1 = [ 0 1 -1 ];

% Analysis process (filtering and decimation)
y0 = downsample(conv(h0,x),nChs);
y1 = downsample(conv(h1,x),nChs);

% Synthesis process (zero insertion and filtering)
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
%[text] ## Impulse responses of the synthesis filters (basis vectors)
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
plot(W/pi,abs(F))
axis([0 1 0 ceil(sqrt(nChs))])
xlabel("Normalized frequency (\times\pi rad/sample)")
ylabel("Magnitude")
legend(["F_0","F_1"])
grid on
%%
%[text] ## Polyphase matrix implementation
%[text] The filter bank is decomposed into polyphase filters and implemented with polyphase matrices
%[text] (reference text, Sec. 6.3.2): $\\mathbf{h}(z)=\\mathbf{E}(z^2)\\mathbf{d}\_2(z)$ and $\\mathbf{f}^\\top(z)=\\mathbf{d}\_2^\\top(z^{-1})\\mathbf{R}(z^2)$
%[text] with the delay chain $\\mathbf{d}\_2(z)=(1\\ \\ z^{-1})^\\top$:
%[text]  $\\mathbf{E}=\\begin{pmatrix}  h\_0\[0\] & h\_0\[1\] \\\\ h\_1\[0\] & h\_1\[1\] \\end{pmatrix}=\\frac{1}{2}\\begin{pmatrix} 1 & 1 \\\\ -1 & 1 \\end{pmatrix}$,
%[text]  $\\mathbf{R}(z)=z^{-1}\\mathbf{R}\_0$, $\\mathbf{R}\_0=\\begin{pmatrix}  f\_0\[2\] & f\_1\[2\] \\\\ f\_0\[1\] & f\_1\[1\] \\end{pmatrix}=\\begin{pmatrix} 1 & -1 \\\\ 1 & 1 \\end{pmatrix}$
%[text] The PR condition $\\mathbf{R}(z)\\mathbf{E}(z)=z^{-c}\\mathbf{I}$ holds with $c=1$, so that $\\hat{x}\[n\]=x\[n-Mc\]=x\[n-2\]$.
% Type-I polyphase matrix of the analyzer
E = [ h0(1) h0(2) ;
      h1(1) h1(2) ];
disp(E)
% Type-II polyphase matrix of the synthesizer (without the delay z^{-1})
R0 = [ f0(3) f1(3) ;
       f0(2) f1(2) ];
disp(R0)
disp(R0*E)

%[text] Analysis and synthesis process
% Serial-to-parallel conversion with the delay chain: x0[m] = x[2m], x1[m] = x[2m-1]
x0 = x(1:nChs:end);
x1 = [0 x(2:nChs:end-1)];
xp = [ x0 ;
       x1 ];
disp(xp)
% Analysis process with the polyphase matrix
y = E*xp;
disp(y)
% Synthesis process with the polyphase matrix R(z) = z^{-1} R0 (one-sample delay at the low rate)
xhatp = [ zeros(nChs,1) R0*y ];
disp(xhatp)
% Parallel-to-serial conversion: xhat[2m] = xhat0[m], xhat[2m-1] = xhat1[m]
xhat = zeros(1,nChs*size(xhatp,2));
xhat(1:nChs:end) = xhatp(1,:);
xhat(2:nChs:end-nChs) = xhatp(2,2:end);
disp(xhat)
% Check: delay of two samples
disp(isequal(xhat(3:numel(x)+2), x))
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
