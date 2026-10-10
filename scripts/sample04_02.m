%[text] # Sample 4-2: Correlation and convolution
%[text] Advanced Topics in Image Processing, Lecture 4 "Linear Shift-Invariant Systems"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Input signal $(x\[n\])\_n$
x = [1 2 3];
%%
%[text] ## Filter kernel $(f\[n\])\_n$
f = [-1 0 1];
%%
%[text] ## Cross-correlation $(y\_\\mathrm{c}\[n\])\_n$
%[text]{"align":"center"} $(y\_\\mathrm{c}\[n\])\_n=\\left(\\sum\_{m=-\\infty}^{\\infty}f\[m\]x\[n+m\]\\right)\_n$
yc = xcorr(x,f);
ndiff = length(x)-length(f);
% Extract the significant subsequence
if ndiff <= 0
    yc = yc(1:end+ndiff)
else
    yc = yc(ndiff+1:end)
end
%%
%[text] ## Output $(y\[n\])\_n$ of the linear shift-invariant system
%[text] Convolution
%[text]{"align":"center"} $(y\[n\])\_n=(h\[n\])\_n \\ast (x\[n\])\_n = \\sum\_{m=-\\infty}^{\\infty}x\[m\](h\[n-m\])\_n$
%[text] Reverse the filter kernel $(f\[n\])\_n$:
%[text]{"align":"center"} $(h\[n\])\_n=(f\[-n\])\_n$
h = flip(f)
%[text] Convolution with $(h\[n\])\_n$ as the impulse response
y = conv(h,x)
%%
%[text] ## Plot of the input and output
nx = length(x);
nf = length(f);
nc = length(yc);
ny = length(y);

amax = max(max(abs(x)),max(abs(yc)));
figure
tiledlayout(4,1)
% x[n]
nexttile
stem(0:nx-1,x,'filled')
axis([0 nc -amax amax])
xlabel('n')
ylabel('x[n]')
% f[n]
nexttile
stem(0:nf-1,f,'filled')
axis([0 nc -amax amax])
xlabel('n')
ylabel('f[n]')
% yc[n]
nexttile
stem(0:nc-1,yc,'filled')
axis([0 nc -amax amax])
xlabel('n')
ylabel('y_c[n]')
% y[n]
nexttile
stem(0:ny-1,y,'filled')
axis([0 nc -amax amax])
xlabel('n')
ylabel('y[n]')
%%
%[text] ## Evaluation by the mean squared error (MSE)
%[text]{"align":"center"} $\\mathrm{MSE}((y\_\\mathrm{c}\[n\])\_n,(y\[n\])\_n) \\coloneqq \\frac{1}{\\left|\\Omega\\right|}\\sum\_{n\\in\\Omega}\\left|y\_\\mathrm{c}\[n\]-y\[n\]\\right|^2,$
%[text] where $\\Omega$ denotes the index set and $|\\Omega|$ its cardinality.
mymse = @(a,b) mean((double(a)-double(b)).^2,'all');
mymse(yc,y)
%%
%[text] ## Bivariate filtering and convolution
%[text] Unit impulse
%[text]{"align":"center"} $\\delta\[\\boldsymbol{n}\] = \\left\\{\\begin{array}{ll} 1 & \\boldsymbol{n}=\\mathbf{0} \\\\ 0 & \\mathrm{otherwise}\\end{array}\\right.$
% Bivariate unit impulse
D = 1
%[text] Filter kernel $(f\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}$
f = reshape(1:9,[3 3])
%[text] The impulse response of `imfilter` is the filter kernel $(f\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}$ flipped on each axis.
%[text] The option `'full'` returns the output without clipping.
% Impulse response of imfilter
imfilter(D,f,'full')
%[text] Flip the filter kernel $(f\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}$ on each axis.
h = rot90(f,2)
%[text] The option `'conv'` of `imfilter` performs convolution with the second argument as the impulse response $(h\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}$.
% imfilter with the options 'conv' and 'full'
imfilter(D,h,'conv','full')
%[text] The result is the same as with the option `'full'` only.
%[text] `imfilter` with `'conv'` and `'full'` is equivalent to `conv2`.
conv2(D,h)
%%
%[text] ## Example of image filtering
%[text] Read a sample image as type double.
I = im2double(imread('cameraman.tif'));
figure
tiledlayout(2,2)
nexttile
imshow(I)
title('(a) Original')
%[text] Horizontal Prewitt kernel
f = fspecial('prewitt').'
%[text] `imfilter` without options
J = imfilter(I,f);
nexttile
imshow(J+.5)
title('(b) Prewitt without options')
%[text] `imfilter` with the option `'corr'`
K = imfilter(I,f,'corr');
nexttile
imshow(K+.5)
title(sprintf('(c) Prewitt with "corr" (MSE to (b): %4.2f)',mymse(J,K)))
%[text] Flip the filter kernel $(f\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}$ on each axis.
h = rot90(f,2)
%[text] `imfilter` with the option `'conv'`
L = imfilter(I,h,'conv');
nexttile
imshow(L+.5)
title(sprintf('(d) Prewitt with "conv" (MSE to (b): %4.2f)',mymse(J,L)))
%[text] The results (b), (c) and (d) are all the same.
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
