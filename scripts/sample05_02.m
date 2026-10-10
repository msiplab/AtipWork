%[text] # Sample 5-2: Univariate circular convolution
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
%[text] ## Output $(y\[n\])\_n$ of the circular convolution with period $N$
%[text]{"align":"center"} $(y\[n\])\_n = \\left(\\sum\_{m=0}^{N-1}h\[m\]x\[(\\!(n-m)\\!)\_N\]\\right)\_n$
% Setting the period N
nZeroPadding = 0; %[control:slider:1d3c]{"position":[16,17]}
nPeriod = max(length(x),length(h)) + nZeroPadding;

% Output y[n]
y = cconv(h,x,nPeriod);
%%
%[text] ## Comparison with the linear convolution
% Linear convolution
yl = conv(h,x);

% Lengths of x, h, y and yl
nx = length(x);
nh = length(h);
ny = length(y);
nl = length(yl);

% Display the sequences
figure
tiledlayout(4,1)
nmax = max(ny,nl);
amax = max(max(abs(x)),max(abs(y)));
% x[n]
nexttile
stem(0:nx-1,x,'filled')
axis([0 nmax -amax amax])
xlabel('n')
ylabel('x[n]')
title('Input')
% h[n]
nexttile
stem(0:nh-1,h,'filled')
axis([0 nmax -amax amax])
xlabel('n')
ylabel('h[n]')
title('Impulse response')
% y[n]
nexttile
stem(0:ny-1,y,'filled')
axis([0 nmax -amax amax])
xlabel('n')
ylabel('y[n]')
title('Circular convolution')
% yl[n]
nexttile
stem(0:nl-1,yl)
axis([0 nmax -amax amax])
xlabel('n')
ylabel('y_l[n]')
title('Linear convolution')
%[text] ### Condition for the linear and circular convolutions to agree
%[text]{"align":"center"} $L\_\\mathrm{y}=L\_\\mathrm{h}+L\_\\mathrm{x}-1\\leq N$
%[text] where
%[text] - $L\_\\mathrm{y}$: output length
%[text] - $L\_\\mathrm{h}$: length of the impulse response
%[text] - $L\_\\mathrm{x}$: input length \
% Adjusting the lengths
mymse = @(a,b) mean((double(a)-double(b)).^2,'all');
if ny > nl
    ylc = [yl(:); zeros(ny-nl,1)];
    yc = y(:);
else
    yc = [y(:); zeros(nl-ny,1)];
    ylc = yl(:);
end
% Check the condition
if nl <= nPeriod
    msg = "TRUE";
else
    msg = "FALSE (increase the number of zeros for padding)";
end
fprintf("Condition for CCONV to match CONV: %s\n", msg)
% MSE
fprintf("MSE: %f\n", mymse(yc,ylc))
%%
%[text] ## DFT of the input signal $(x\[n\])\_n$
%[text]{"align":"center"} $X\[k\]=\\sum\_{n=0}^{N-1} x\[n\] W\_{N}^{k n},\\ k\\in\\{0,1,2,\\ldots,N-1\\}$
%[text] where
%[text]{"align":"center"} $W\_N=\\mathrm{e}^{-\\mathrm{j}\\frac{2\\pi}{N}}$
X = fft(x,nPeriod);
%%
%[text] ## DFT of the impulse response $(h\[n\])\_n$
%[text]{"align":"center"} $H\[k\]=\\sum\_{n=0}^{N-1} h\[n\] W\_{N}^{k n},\\ k\\in\\{0,1,2,\\ldots,N-1\\}$
H = fft(h,nPeriod);
%%
%[text] ## DFT of the output signal $(y\[n\])\_n$
%[text]{"align":"center"} $Y\[k\]=\\sum\_{n=0}^{N-1} y\[n\] W\_{N}^{k n},\\ k\\in\\{0,1,2,\\ldots,N-1\\}$
Y = fft(y,nPeriod);
%%
%[text] ## Display of the DFTs
k = 0:nPeriod-1;
figure
tiledlayout(3,1)
nexttile
stem(k,abs(X),'filled')
xlabel('k')
ylabel('|X[k]|')
nexttile
stem(k,abs(H),'filled')
xlabel('k')
ylabel('|H[k]|')
nexttile
stem(k,abs(Y),'filled')
xlabel('k')
ylabel('|Y[k]|')
%%
%[text] ## DFT product
%[text]{"align":"center"} $Y\[k\]=H\[k\]X\[k\],\\ k\\in\\{0,1,2,\\ldots,N-1\\}$
%[text] Comparison with the circular convolution
% IDFT of the DFT product
yd = ifft(H.*X);
% MSE with the result of cconv
fprintf("MSE: %f\n", mymse(y,yd))
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:1d3c]
%   data: {"defaultValue":0,"label":"nZeroPadding","max":16,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
