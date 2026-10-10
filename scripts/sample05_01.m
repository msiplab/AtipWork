%[text] # Sample 5-1: Univariate convolution
%[text] Advanced Topics in Image Processing, Lecture 5 "Fourier Analysis"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Input signal $(x\[n\])\_n$
x = [1 2 3];
%%
%[text] ## Impulse response $(h\[n\])\_n$ of a linear shift-invariant system
h = [1 1 1]/3;
%%
%[text] ## Output $(y\[n\])\_n$ of the linear shift-invariant system
%[text] Convolution
%[text]{"align":"center"} $(y\[n\])\_n=(h\[n\])\_n \\ast (x\[n\])\_n = \\sum\_{m=-\\infty}^{\\infty}x\[m\](h\[n-m\])\_n$
y = conv(h,x);
%%
%[text] ## Spectrum of the input signal $(x\[n\])\_n$
%[text]{"align":"center"} $X(\\mathrm{e}^{\\mathrm{j}\\omega})= \\sum\_{n=-\\infty}^{\\infty}x\[n\]\\mathrm{e}^{-\\mathrm{j}\\omega n},\\ \\omega\\in\\mathbb{R}$
%[text] Frequency sampling of the DSFT by the DFT (FFT)
%[text]{"align":"center"} $X\[k\] = \\left.X(\\mathrm{e}^{\\mathrm{j}\\omega})\\right|\_{\\omega=\\frac{2\\pi }{N}k},\\ k\\in\\{0,1,2,\\ldots,N-1\\}$
% Number of frequency sample points in [0,2pi)
nPoints = 128; %[control:slider:9966]{"position":[11,14]}

% Spectrum of x[n]
X = fft(x,nPoints);
%%
%[text] ## Frequency response of the filter $(h\[n\])\_n$
%[text]{"align":"center"} $H(\\mathrm{e}^{\\mathrm{j}\\omega})= \\sum\_{n=-\\infty}^{\\infty}h\[n\]\\mathrm{e}^{-\\mathrm{j}\\omega n},\\ \\omega\\in\\mathbb{R}$
%[text] Frequency sampling of the DSFT by the DFT (FFT)
%[text]{"align":"center"} $H\[k\] = \\left.H(\\mathrm{e}^{\\mathrm{j}\\omega})\\right|\_{\\omega=\\frac{2\\pi }{N}k},\\ k\\in\\{0,1,2,\\ldots,N-1\\}$
H = fft(h,nPoints);
%%
%[text] ## Spectrum of the output signal $(y\[n\])\_n$
%[text]{"align":"center"} $Y(\\mathrm{e}^{\\mathrm{j}\\omega})= \\sum\_{n=-\\infty}^{\\infty}y\[n\]\\mathrm{e}^{-\\mathrm{j}\\omega n},\\ \\omega\\in\\mathbb{R}$
%[text] Frequency sampling of the DSFT by the DFT (FFT)
%[text]{"align":"center"} $Y\[k\] = \\left.Y(\\mathrm{e}^{\\mathrm{j}\\omega})\\right|\_{\\omega=\\frac{2\\pi }{N}k},\\ k\\in\\{0,1,2,\\ldots,N-1\\}$
Y = fft(y,nPoints);
%%
%[text] ## Display of the spectra and the frequency response
%[text]{"align":"center"} $Y(\\mathrm{e}^{\\mathrm{j}\\omega})=H(\\mathrm{e}^{\\mathrm{j}\\omega})X(\\mathrm{e}^{\\mathrm{j}\\omega})$
% Frequency sample points
w = 2*pi*(0:nPoints-1)/nPoints;

figure
ax = gca;
plot(ax,w,abs(X),'b',w,abs(H),'k:',w,abs(Y),'r-.')
grid(ax,'on')
xlabel(ax,'Normalized angular frequency \omega [rad]')
ylabel(ax,'Magnitude')
legend(ax,'|X(e^{j\omega})|','|H(e^{j\omega})|','|Y(e^{j\omega})|')
ax.XLim = [0 2*pi];
ax.XTick = [0 pi 2*pi];
ax.XTickLabel = {'0', '\pi', '2\pi'};
%%
%[text] ## Analysis of the linear shift-invariant system
%[text] ### Impulse response
%[text]{"align":"center"} $h\[n\],\\ n\\in\\mathbb{Z}$
figure
impz(h)
%[text] ### Transfer function
%[text]{"align":"center"} $H(z)= \\sum\_{n=-\\infty}^{\\infty}h\[n\]z^{-n},\\ z\\in\\mathbb{C}$
figure
zplane(h)
%[text] ### Frequency response
%[text]{"align":"center"} $H(\\mathrm{e}^{\\mathrm{j}\\omega})= \\left.H(z)\\right|\_{z=\\mathrm{e}^{\\mathrm{j}\\omega}},\\ \\omega\\in \\mathbb{R}$
%[text] - Magnitude response: $|H(\\mathrm{e}^{\\mathrm{j}\\omega})|$
%[text] - Phase response: $\\angle H(\\mathrm{e}^{\\mathrm{j}\\omega})$ \
figure
freqz(h)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:9966]
%   data: {"defaultValue":128,"label":"nPoints","max":512,"min":16,"run":"SectionToEnd","runOn":"ValueChanging","step":16}
%---
