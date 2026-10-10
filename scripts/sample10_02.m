%[text] # Sample 10-2: Analysis problem
%[text] Advanced Topics in Image Processing, Lecture 10 "Redundant Transforms"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Filter coefficients and input
%[text] Flexible analysis filters $H\_0(z)=\\gamma+\\delta z^{-1}$, $H\_1(z)=-\\gamma+\\delta z^{-1}$ with the
%[text] perfect reconstruction (PR) condition $\\gamma+\\delta=1$.  Change $\\gamma$ with the slider.
% Coefficients of the analysis filters
gamma = 0.5; %[control:slider:9502]{"position":[9,12]}
delta = 1 - gamma;

% Input signal (even length)
x = [ 0 3 1 3 1 5 3 0 ];
%%
%[text] ## Parallel filter bank implementation
%[text] Undecimated 2-channel filter bank (no down- and up-samplers) with the fixed synthesis filters
%[text] $F\_0(z)=\\frac{1}{2}(1+z^{-1})$ and $F\_1(z)=\\frac{1}{2}(1-z^{-1})$.
% Number of channels
nChs = 2;

% Analysis filters
h0 = [ gamma  delta ];
h1 = [ -gamma delta ];

% Synthesis filters
f0 = [  1 1 ]/2;
f1 = [ 1 -1 ]/2;

% Analysis process
s0 = conv(h0,x);
s1 = conv(h1,x);

% Synthesis process
y0 = conv(f0,s0);
y1 = conv(f1,s1);
xhat = y0 + y1;
%[text] Energy of the sub-band coefficients $\\|\\mathbf{s}\\|\_2^2$
disp("||s||_2^2 = " + norm([s0(:);s1(:)],2)^2)
%%
%[text] ## Signal display
fig1 = figure;
tl = tiledlayout(fig1,3,2,"TileSpacing","compact");
ylims = [ min([s0(:);s1(:)]) max([s0(:);s1(:)]) ];

% Input
ax = nexttile(tl,1);
stem(ax,0:length(x)-1,x,"filled")
title(ax,"Input $x[n]$","Interpreter","latex")
xlabel(ax,"$n$","Interpreter","latex")
ax.XLim = [ 0 length(xhat) ];

% Subband 0
ax = nexttile(tl,3);
stem(ax,0:length(s0)-1,s0,"filled")
title(ax,"Subband $s_0[n]$","Interpreter","latex")
xlabel(ax,"$n$","Interpreter","latex")
ax.XLim = [ 0 length(xhat) ];
ax.YLim = ylims;

% Subband 1
ax = nexttile(tl,4);
stem(ax,0:length(s1)-1,s1,"filled")
title(ax,"Subband $s_1[n]$","Interpreter","latex")
xlabel(ax,"$n$","Interpreter","latex")
ax.XLim = [ 0 length(xhat) ];
ax.YLim = ylims;

% Output
ax = nexttile(tl,5);
stem(ax,0:length(xhat)-1,xhat,"filled")
title(ax,"Output $\hat{x}[n]$","Interpreter","latex")
xlabel(ax,"$n$","Interpreter","latex")
ax.XLim = [ 0 length(xhat) ];
%[text] MSE evaluation (the output is delayed by one sample)
disp("MSE = " + immse(x, xhat(2:end-1)))
%%
%[text] ## Impulse responses
fig2 = figure;
tl = tiledlayout(fig2,2,2,"TileSpacing","compact");
filters = {h0, h1, f0, f1};
fnames = ["$h_0[n]$", "$h_1[n]$", "$f_0[n]$", "$f_1[n]$"];
for idx = 1:4
    ax = nexttile(tl);
    stem(ax,0:length(filters{idx})-1,filters{idx},"filled")
    title(ax,fnames(idx),"Interpreter","latex")
    xlabel(ax,"$n$","Interpreter","latex")
    ax.XLim = [ -0.5 1.5 ];
end
%%
%[text] ## Frequency responses
fig3 = figure;
tl = tiledlayout(fig3,2,1,"TileSpacing","compact");
fftPoints = 512;

% Analysis filters
ax = nexttile(tl);
H = zeros(fftPoints,nChs);
[H(:,1),w] = freqz(h0,1,fftPoints);   % Low-pass filter
H(:,2)     = freqz(h1,1,fftPoints);   % High-pass filter
plot(ax,w/pi,abs(H))
xlabel(ax,"Normalized frequency $\omega/\pi$","Interpreter","latex")
ylabel(ax,"Magnitude")
title(ax,"Analysis filters")
legend(ax,["$|H_0|$","$|H_1|$"],"Interpreter","latex")
grid(ax,"on")

% Synthesis filters
ax = nexttile(tl);
F = zeros(fftPoints,nChs);
[F(:,1),w] = freqz(f0,1,fftPoints);   % Low-pass filter
F(:,2)     = freqz(f1,1,fftPoints);   % High-pass filter
plot(ax,w/pi,abs(F))
axis(ax,[0 1 0 1])
xlabel(ax,"Normalized frequency $\omega/\pi$","Interpreter","latex")
ylabel(ax,"Magnitude")
title(ax,"Synthesis filters")
legend(ax,["$|F_0|$","$|F_1|$"],"Interpreter","latex")
grid(ax,"on")
%%
%[text] ## Polyphase matrix implementation with the PPMATRIX object
%[text] The filter bank is decomposed into polyphase filters and implemented as polyphase matrices.
%[text] Since no resampling is applied ($M=1$), the polyphase matrices are the vectors of the transfer functions:
%[text] $\\mathbf{E}(z)=\\left(\\begin{array}{c}  h\_0\[0\] \\\\ h\_1\[0\]\\end{array}\\right)+\\left(\\begin{array}{c}  h\_0\[1\] \\\\ h\_1\[1\]\\end{array}\\right)z^{-1}=\\left(\\begin{array}{c}  h\_0\[0\]+h\_0\[1\]z^{-1}  \\\\ h\_1\[0\]+h\_1\[1\]z^{-1}\\end{array}\\right)$
%[text] $\\mathbf{R}(z)=\\left(\\begin{array}{cc}  f\_0\[0\] &f\_1\[0\]\\end{array}\\right)+\\left(\\begin{array}{cc}  f\_0\[1\] &f\_1\[1\]\\end{array}\\right)z^{-1}=\\left(\\begin{array}{cc}  f\_0\[0\]+f\_0\[1\]z^{-1} &f\_1\[0\]+f\_1\[1\]z^{-1} \\end{array}\\right)$
% Type-I polyphase filters of the analyzer
e00 = h0(1:end);
e10 = h1(1:end);

% Type-II polyphase filters of the synthesizer
r00 = f0(1:end);
r01 = f1(1:end);
%[text] The class below makes polyphase matrix operations easy.  At instantiation, pass a three-dimensional
%[text] array whose third index indicates the delay.
%[text] - PPMATRIX: polyphase matrix class (originally saivdr.dictionary.utility.PolyPhaseMatrix1D in the [SaivDr package](https://github.com/msiplab/SaivDr)) \
%[text] Analysis and synthesis process
import msip.ppmatrix
% Polyphase matrix of the analysis bank
e00 = reshape(e00,1,1,length(e00));
e10 = reshape(e10,1,1,length(e10));
E = ppmatrix(cat(1,e00,e10))
% Polyphase matrix of the synthesis bank
r00 = reshape(r00,1,1,length(r00));
r01 = reshape(r01,1,1,length(r01));
R = ppmatrix(cat(2,r00,r01))
%[text] Check of the perfect reconstruction
%[text] $\\mathbf{R}(z)\\mathbf{E}(z)=(\\mathbf{R}\_0 +\\mathbf{R}\_1 z^{-1} )(\\mathbf{E}\_0 + \\mathbf{E}\_1 z^{-1} )=\\mathbf{R}\_0 \\mathbf{E}\_0 + (\\mathbf{R}\_1 \\mathbf{E}\_0 +\\mathbf{R}\_0 \\mathbf{E}\_1 )z^{-1}+\\mathbf{R}\_1\\mathbf{E}\_1 z^{-2}=z^{-1}\\mathbf{I}$
disp(R*E)
% Delay chain (M = 1)
delaychain = ppmatrix(1)
% Z-transform of the input
xz = ppmatrix(reshape(x,1,1,length(x)));
disp(xz)
% Polyphase decomposition of the input
xp = delaychain*xz;
disp(xp)
% Analysis process with the polyphase matrix
sz = E*xp;
disp(sz)
% Synthesis process with the polyphase matrix
yz = R*sz;
disp(yz)
% Parallel/serial conversion
xhatz = delaychain.'*yz;
disp(xhatz)
disp(squeeze(double(xhatz)).')
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:9502]
%   data: {"defaultValue":0.5,"label":"gamma","max":2,"min":-2,"run":"SectionToEnd","runOn":"ValueChanging","step":0.1}
%---
