%[text] # Sample 10-1: Undecimated Haar DWT
%[text] Advanced Topics in Image Processing, Lecture 10 "Redundant Transforms"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Generation of the input
%[text] Input signal $\\mathbf{x}\\in\\mathbb{R}^N$ (even length $N$).
x = rand(16,1);
%%
%[text] ## Parallel filter bank implementation
%[text] The analysis filter bank consists of filters only and the synthesis filter bank of filters and an adder.
%[text] Down- and up-samplers are removed (undecimated construction), so the redundancy is $R=2$.
%[text] - Analysis filters: $H\_0(z)=\\frac{1}{2}(1+z^{-1})$, $H\_1(z)=\\frac{1}{2}(-1+z^{-1})$ (adjoint of the synthesis filters)
%[text] - Synthesis filters: $F\_0(z)=\\frac{1}{2}(1+z^{-1})$, $F\_1(z)=\\frac{1}{2}(1-z^{-1})$ (\[M\] Example "Haar DWT", delayed and scaled) \
% Number of channels
nChs = 2;

% Analysis filters
h0 = [ 1  1 ]/2;
h1 = [ -1 1 ]/2;

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
xhat = xhat(:);
disp("MSE = " + immse(x(:), xhat(2:end-1)))
%%
%[text] ## Impulse responses of the synthesis filters (atoms)
fig2 = figure;
tl = tiledlayout(fig2,1,2,"TileSpacing","compact");
ylims = [ min([f0(:);f1(:)]) max([f0(:);f1(:)]) ];
ax = nexttile(tl);
stem(ax,0:length(f0)-1,f0,"filled")
title(ax,"$f_0[n]$","Interpreter","latex")
xlabel(ax,"$n$","Interpreter","latex")
ax.XLim = [ -0.5 1.5 ];
ax.YLim = ylims;
ax = nexttile(tl);
stem(ax,0:length(f1)-1,f1,"filled")
title(ax,"$f_1[n]$","Interpreter","latex")
xlabel(ax,"$n$","Interpreter","latex")
ax.XLim = [ -0.5 1.5 ];
ax.YLim = ylims;
%%
%[text] ## Frequency responses
fig3 = figure;
ax = axes(fig3);
fftPoints = 512;
F = zeros(fftPoints,nChs);
[F(:,1),w] = freqz(f0,1,fftPoints);   % Low-pass filter
F(:,2)     = freqz(f1,1,fftPoints);   % High-pass filter
plot(ax,w/pi,abs(F))
axis(ax,[0 1 0 1])
xlabel(ax,"Normalized frequency $\omega/\pi$","Interpreter","latex")
ylabel(ax,"Magnitude")
legend(ax,["$|F_0(\mathrm{e}^{\mathrm{j}\omega})|$","$|F_1(\mathrm{e}^{\mathrm{j}\omega})|$"],"Interpreter","latex")
grid(ax,"on")
%%
%[text] ## Noble identities
%[text] The following properties hold:
%[text] - $\\rightarrow \[H(z^M)\] \\rightarrow \[\\downarrow M\] \\rightarrow \\ \\Longleftrightarrow\\ \\rightarrow \[\\downarrow M\] \\rightarrow  \[H(z)\] \\rightarrow$
%[text] - $\\rightarrow \[\\uparrow M\] \\rightarrow  \[F(z^M)\] \\rightarrow \\ \\Longleftrightarrow \\ \\rightarrow \[F(z)\] \\rightarrow \[\\uparrow M\] \\rightarrow$ \
%[text] where $H(z^M)$ and $F(z^M)$ have the impulse responses $h\[n\]$ and $f\[n\]$ upsampled by the factor $M$:
%[text] - $H(z^M)=\\sum\_{m=-\\infty}^{\\infty}h\[m\]z^{-Mm}=\\sum\_{n=-\\infty}^{\\infty}h\_{\\uparrow M}\[n\]z^{-n}$
%[text] - $F(z^M)=\\sum\_{m=-\\infty}^{\\infty}f\[m\]z^{-Mm}=\\sum\_{n=-\\infty}^{\\infty}f\_{\\uparrow M}\[n\]z^{-n}$ \
%[text] Hence the 3-level DWT has the equivalent parallel structure with the synthesis filters
%[text] $F\_{3,0}(z)=F\_0(z^4)F\_0(z^2)F\_0(z)$, $F\_{3,1}(z)=F\_1(z^4)F\_0(z^2)F\_0(z)$, $F\_{2,1}(z)=F\_1(z^2)F\_0(z)$ and $F\_{1,1}(z)=F\_1(z)$.
%%
%[text] ## Implementation of the undecimated Haar DWT
%[text] Removing the down- and up-samplers of the parallel structure gives the 3-level undecimated DWT
%[text] with the redundancy $R=J+1=4$.  Circular convolution is used.
% Period of the circular convolution
period = 32;

% 3-level hierarchical analysis filters
h11 = h1;                          % H_{1,1}
h0L = h0;
h21 = conv(h0L,upsample(h1,2));    % H_{2,1}
h0L = conv(h0L,upsample(h0,2));
h31 = conv(h0L,upsample(h1,4));    % H_{3,1}
h30 = conv(h0L,upsample(h0,4));    % H_{3,0}

% 3-level hierarchical synthesis filters
f11 = f1;                          % F_{1,1}
f0L = f0;
f21 = conv(f0L,upsample(f1,2));    % F_{2,1}
f0L = conv(f0L,upsample(f0,2));
f31 = conv(f0L,upsample(f1,4));    % F_{3,1}
f30 = conv(f0L,upsample(f0,4));    % F_{3,0}

% Analysis process
s30 = cconv(h30,x,period);
s31 = cconv(h31,x,period);
s21 = cconv(h21,x,period);
s11 = cconv(h11,x,period);

% Synthesis process
y30 = cconv(f30,s30,period);
y31 = cconv(f31,s31,period);
y21 = cconv(f21,s21,period);
y11 = cconv(f11,s11,period);
xhat = y30 + y31 + circshift(y21,4) + circshift(y11,6); % The delay of each channel is compensated
%%
%[text] ## Signal display
fig4 = figure;
tl = tiledlayout(fig4,3,4,"TileSpacing","compact");

% Input
ax = nexttile(tl,1);
stem(ax,0:length(x)-1,x,"filled")
title(ax,"Input $x[n]$","Interpreter","latex")
xlabel(ax,"$n$","Interpreter","latex")
ax.XLim = [ 0 period ];

% Subbands
sbs = {s30, s31, s21, s11};
sbnames = ["$s_{3,0}[n]$", "$s_{3,1}[n]$", "$s_{2,1}[n]$", "$s_{1,1}[n]$"];
for idx = 1:4
    ax = nexttile(tl,4+idx);
    stem(ax,0:length(sbs{idx})-1,sbs{idx},"filled")
    title(ax,sbnames(idx),"Interpreter","latex")
    ax.YLim = [ -1 1 ];
end

% Output
ax = nexttile(tl,9);
stem(ax,0:length(xhat)-1,xhat,"filled")
title(ax,"Output $\hat{x}[n]$","Interpreter","latex")
xlabel(ax,"$n$","Interpreter","latex")
ax.XLim = [ 0 period ];
%[text] MSE evaluation (the output is delayed by seven samples)
disp("MSE = " + immse([x(:); zeros(length(xhat)-length(x),1)], circshift(xhat(:),-7)))
%%
%[text] ## Impulse responses of the synthesis filters (local atoms)
fig5 = figure;
f = {f30, f31, f21, f11};
fnames = ["$f_{3,0}[n]$", "$f_{3,1}[n]$", "$f_{2,1}[n]$", "$f_{1,1}[n]$"];
tl = tiledlayout(fig5,length(f),1,"TileSpacing","compact");
for idx = 1:length(f)
    ax = nexttile(tl);
    stem(ax,0:length(f{idx})-1,f{idx},"filled")
    title(ax,fnames(idx),"Interpreter","latex")
    xlabel(ax,"$n$","Interpreter","latex")
    ax.XLim = [ 0 7 ];
end
%%
%[text] ## Frequency responses
fig6 = figure;
ax = axes(fig6);
F = zeros(fftPoints,length(f));
for idx = 1:length(f)
    [F(:,idx),w] = freqz(f{idx},1,fftPoints);
end
plot(ax,w/pi,abs(F))
axis(ax,[0 1 0 1])
xlabel(ax,"Normalized frequency $\omega/\pi$","Interpreter","latex")
ylabel(ax,"Magnitude")
title(ax,"Frequency responses of the synthesis filters")
legend(ax,["$F_{3,0}$","$F_{3,1}$","$F_{2,1}$","$F_{1,1}$"],"Interpreter","latex")
grid(ax,"on")
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
