%[text] # Sample 6-1: Sinc function
%[text] Advanced Topics in Image Processing, Lecture 6 "Sampling"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Setting the sampling interval
%[text] - $\\Delta\_\\mathrm{t}$: sampling interval \
deltat = 1 %[control:slider:402e]{"position":[10,11]}
%%
%[text] ## Sinc function
%[text] Interpolation kernel of Shannon's sampling theorem (\[M\] Example "Shannon's sampling theorem", Sec. 1.4.1):
%[text]{"align":"center"} $\\varphi(t)=\\mathrm{sinc}(\\Delta\_\\mathrm{t}^{-1}t),\\quad \\mathrm{sinc}(t)\\coloneqq\\frac{\\sin(\\pi t)}{\\pi t}\\ (t\\neq0),\\ \\mathrm{sinc}(0)\\coloneqq1$
%[text] The function `msinc` below works without the Signal Processing Toolbox.
msinc = @(t) (t == 0) + (t ~= 0).*sin(pi*t)./(pi*t + (t == 0));
fig1 = figure;
ax1 = axes(fig1);
fplot(ax1, @(t) msinc(t/deltat), [-15 15])
xlabel(ax1, 'Time t')
ylabel(ax1, 'sinc(t/\Delta_t)')
axis(ax1, [-15 15 -0.5 1.5])
%%
%[text] ## Setting the input signal
%[text] A waveform in the shift-invariant subspace $\\mathcal{V}\_\\varphi$:
%[text]{"align":"center"} $u(t) = \\sum\_{k\\in\\mathbb{Z}} c\[k\]\\,\\mathrm{sinc}(\\Delta\_\\mathrm{t}^{-1}t-k)$
%[text] Shannon's sampling theorem is for band-limited signals, i.e. $u\\in \\mathcal{V}\_\\varphi=\\mathrm{span}\\{\\mathrm{sinc}(\\Delta\_\\mathrm{t}^{-1}\\cdot-k)\\}\_k$.
% Configuration
ts = -10;
te = 20;
k = 0:floor(10/deltat);
td = linspace(ts,te,(te-ts)*floor(1e3/deltat));
[Ts,K] = ndgrid(td,k);

% Generation of the signal
c = rand(size(k));
u = msinc(Ts/deltat - K)*c(:);

% Plot the signal
fig2 = figure;
ax2 = axes(fig2);
plot(ax2, td, u)
xlabel(ax2, 'Time t')
ylabel(ax2, 'Signal u(t)')
axis(ax2, [ts te -0.5 1.5])
%%
%[text] ## Sampling with the sinc function
%[text] Sampling kernel $\\breve{\\varphi}(t)=\\Delta\_\\mathrm{t}^{-1}\\mathrm{sinc}(-\\Delta\_\\mathrm{t}^{-1}t)$:
%[text]{"align":"center"} $x\[n\] = \\int\_{-\\infty}^{\\infty}\\breve{\\varphi}(\\Delta\_\\mathrm{t}n-t)u(t)\\,\\mathrm{d}t=\\Delta\_\\mathrm{t}^{-1}\\int\_{-\\infty}^{\\infty}u(t)\\,\\mathrm{sinc}(\\Delta\_\\mathrm{t}^{-1}t-n)\\,\\mathrm{d}t$
%[text] Note that the integral is approximated on a finite support with the trapezoidal rule.
% Trapezoidal numerical integration
x = (1/deltat)*trapz(td, u.*msinc(Ts/deltat - K));

% Plot the samples on the signal
fig3 = figure;
ax3 = axes(fig3);
plot(ax3, td, u, ':')
hold(ax3, 'on')
stem(ax3, deltat*k, x, 'filled')
hold(ax3, 'off')
xlabel(ax3, 'Time t = \Delta_t n')
ylabel(ax3, 'Sequence x[n]')
axis(ax3, [ts te -0.5 1.5])
%%
%[text] ## Signal reconstruction
%[text]{"align":"center"} $\\hat{u}(t) = \\sum\_{n\\in\\mathbb{Z}} x\[n\]\\,\\varphi(t-\\Delta\_\\mathrm{t}n)=\\sum\_{n\\in\\mathbb{Z}} x\[n\]\\,\\mathrm{sinc}(\\Delta\_\\mathrm{t}^{-1}t-n)$
% Reconstruct the signal from the samples
uhat = msinc(Ts/deltat - K)*x(:);

% Plot the signals
fig4 = figure;
ax4 = axes(fig4);
plot(ax4, td, u, 'b', td, uhat, '--r', deltat*k, x, 'or')
xlabel(ax4, 'Time t')
ylabel(ax4, '$u(t)$, $\hat{u}(t)$', 'Interpreter', 'latex')
axis(ax4, [ts te -0.5 1.5])
legend(ax4, 'Original', 'Reconstructed', 'Samples')
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:402e]
%   data: {"defaultValue":1,"label":"deltat","max":2,"min":0.5,"run":"SectionToEnd","runOn":"ValueChanging","step":0.1}
%---
