%[text] # Sample 10-6: $\\ell\_1$-norm minimization
%[text] Advanced Topics in Image Processing, Lecture 10 "Redundant Transforms"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Setting of the non-linear approximation
% Number of coefficients
K = 32;
%%
%[text] ## Generation of the input sequence
%[text] Random process of the AR(1) model with an impulse in the middle.
% Number of input samples
nSamples = 128;

% Random process of the AR(1) model
rng("default");
w = 0.1*randn(nSamples,1);
w(floor(end/2)) = 1;
x = filter(1,[1 -0.95],w);
%%
%[text] ## Synthesis dictionary
%[text] Undecimated 2-channel Haar synthesis filter bank, $F\_0(z)=\\frac{1}{2}(1+z^{-1})$, $F\_1(z)=\\frac{1}{2}(1-z^{-1})$.
% Synthesis filters
f0 = [  1 1 ]/2;
f1 = [ 1 -1 ]/2;

% (Circular) convolution matrix
nF = max(length(f0),length(f1));
Ext = [zeros(nF-1,nSamples-nF+1) eye(nF-1); eye(nSamples)];     % Circular extension matrix
Clp = [zeros(nSamples,nF-1) eye(nSamples) zeros(nSamples,nF-1)]; % Clipping matrix

% Atoms in the (circular) convolution matrices
d0 = Clp*convmtx(f0.',nSamples+nF-1)*Ext;
d1 = Clp*convmtx(f1.',nSamples+nF-1)*Ext;
%[text] Dictionary $\\mathbf{D}$ (global matrix representation of the synthesis filter bank)
D = zeros(nSamples,2*nSamples);
D(:,1:2:end) = d0;
D(:,2:2:end) = d1;
%%
%[text] ## Non-linear approximation with $\\ell\_1$-norm minimization
%[text] $\\hat{\\mathbf{s}}=\\arg\\min\_{\\mathbf{s}\\in\\mathbb{R}^L}\\|\\mathbf{s}\\|\_1\\ \\mathrm{s.t.}\\ \\mathbf{x}=\\mathbf{D}\\mathbf{s}$
%[text] Analysis process and coefficient selection by a convex relaxation
%[text] - Basis pursuit (BP) \
%[text] The problem is reduced to linear programming:
%[text] $\\hat{\\mathbf{z}}=\\arg\\min\_{\\mathbf{z}\\in\\mathbb{R}^{2L}}\\mathbf{1}^\\top\\mathbf{z}\\ \\mathrm{s.t.}\\ \\mathbf{x}=\\mathbf{D}\\left(\\begin{array}{cc}\\mathbf{I} & -\\mathbf{I}\\end{array}\\right)\\mathbf{z},\\ \\mathbf{z}\\in\[0,\\infty)^{2L}$
%[text] where
%[text] $\\mathbf{s}=\\mathbf{s}\_{+}-\\mathbf{s}\_{-}\\in\\mathbb{R}^L$, $\\mathbf{z}=\\left(\\begin{array}{c}\\mathbf{s}\_{+} \\\\ \\mathbf{s}\_{-}\\end{array}\\right)\\in\\mathbb{R}^{2L}$.
%[text] `linprog` requires the Optimization Toolbox.
% Initialization
L = size(D,2);
c = ones(2*L,1);
lb = zeros(2*L,1);
% Linear programming
opts = optimoptions("linprog","Display","final");
z = linprog(c,[],[],[D -D],x,lb,[],opts);
s = z(1:L) - z(L+1:end);
%[text] Coefficient selection ($K$ coefficients of the largest magnitudes)
[~,ix] = sort(abs(s),"descend");
s(ix(K+1:end)) = 0;
%[text] Approximation result
xhat = D*s;
%[text] Residual
r = x - xhat;
%%
%[text] ## Graph plot
fig = figure;
tl = tiledlayout(fig,3,1,"TileSpacing","compact");

% Input
ax = nexttile(tl);
stem(ax,0:nSamples-1,x,"filled")
axis(ax,[0 nSamples -1.5 1.5])
ylabel(ax,"$x[n]$","Interpreter","latex")
title(ax,"$\ell_1$-norm minimization (BP)","Interpreter","latex")

% NLA
ax = nexttile(tl);
stem(ax,0:nSamples-1,xhat,"filled")
axis(ax,[0 nSamples -1.5 1.5])
ylabel(ax,"$\check{x}[n]$","Interpreter","latex")

% Residual
ax = nexttile(tl);
stem(ax,0:nSamples-1,r,"filled")
axis(ax,[0 nSamples -1.5 1.5])
xlabel(ax,"$n$","Interpreter","latex")
ylabel(ax,"$r[n]$","Interpreter","latex")
%[text] MSE evaluation
disp("MSE = " + immse(x,xhat))
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
