%[text] # Sample 4-1: Univariate convolution
%[text] Advanced Topics in Image Processing, Lecture 4 "Linear Shift-Invariant Systems"
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
y = conv(h,x)
%%
%[text] ## Plot of the input and output
% Lengths of x, h and y
nx = length(x);
nh = length(h);
ny = length(y);

amax = max(max(abs(x)),max(abs(y)));
figure
tiledlayout(3,1)
% x[n]
nexttile
stem(0:nx-1,x,'filled')
axis([0 ny -amax amax])
xlabel('n')
ylabel('x[n]')
% h[n]
nexttile
stem(0:nh-1,h,'filled')
axis([0 ny -amax amax])
xlabel('n')
ylabel('h[n]')
% y[n]
nexttile
stem(0:ny-1,y,'filled')
axis([0 ny -amax amax])
xlabel('n')
ylabel('y[n]')
%%
%[text] ## Decomposition into weighted impulses and synthesis of weighted impulse responses
%[text]{"align":"center"} $(y\[n\])\_n = \\sum\_{m=-\\infty}^{\\infty} (y\_m\[n\])\_n,\\quad (x\[n\])\_n = \\sum\_{m=-\\infty}^{\\infty} (x\_m\[n\])\_n,$
%[text] where
%[text]{"align":"center"} $(y\_m\[n\])\_n = (h\[n\])\_n \\ast (x\_m\[n\])\_n,\\quad (x\_m\[n\])\_n = x\[m\](\\delta\[n-m\])\_n.$
figure
tiledlayout(nx+1,2)
xx = 0;
yy = 0;
for m = 1:nx
    % Shifted impulse delta[n-m]
    ds = zeros(size(x),'like',x);
    ds(m) = 1;
    % Weighted impulse x_m[n] = x[m] delta[n-m]
    xm = x(m)*ds;
    % Response to the shifted impulse, weighted: y_m[n] = h[n] * x_m[n]
    ym = x(m)*conv(h,ds);
    % Plot x_m[n]
    nexttile
    stem(0:nx-1,xm)
    axis([0 ny -amax amax])
    xlabel('n')
    ylabel(sprintf('x_%d[n]',m-1))
    % Plot y_m[n]
    nexttile
    stem(0:ny-1,ym)
    axis([0 ny -amax amax])
    xlabel('n')
    ylabel(sprintf('y_%d[n]',m-1))
    % Accumulate x_m[n] and y_m[n]
    xx = xx + xm;
    yy = yy + ym;
end
% Plot the sum of x_m[n]
nexttile
stem(0:nx-1,xx,'filled')
axis([0 ny -amax amax])
xlabel('n')
ylabel('\Sigma_m x_m[n]')
% Plot the sum of y_m[n]
nexttile
stem(0:ny-1,yy,'filled')
axis([0 ny -amax amax])
xlabel('n')
ylabel('\Sigma_m y_m[n]')
%%
%[text] ## Evaluation by the mean squared error (MSE)
%[text]{"align":"center"} $\\mathrm{MSE}((x\[n\])\_n,(y\[n\])\_n) \\coloneqq \\frac{1}{\\left|\\Omega\\right|}\\sum\_{n\\in\\Omega}\\left|x\[n\]-y\[n\]\\right|^2,$
%[text] where $\\Omega$ denotes the index set and $|\\Omega|$ its cardinality.
mymse = @(a,b) mean((double(a)-double(b)).^2,'all');
% Evaluation of xx
mymse(x,xx)
% Evaluation of yy
mymse(y,yy)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
