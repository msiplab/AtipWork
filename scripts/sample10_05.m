%[text] # Sample 10-5: $\\ell\_0$-pseudo-norm minimization
%[text] Advanced Topics in Image Processing, Lecture 10 "Redundant Transforms"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Setting of the non-linear approximation
% Number of coefficients
K = 32;

% Orthogonal matching pursuit (OMP) if true, matching pursuit (MP) otherwise
isOmp = true; %[control:checkbox:861b]{"position":[9,13]}
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
%[text] ## Non-linear approximation with $\\ell\_0$-pseudo-norm minimization
%[text] $\\hat{\\mathbf{s}}=\\arg\\min\_{\\mathbf{s}\\in\\mathbb{R}^L}\\|\\mathbf{s}\\|\_0\\ \\mathrm{s.t.}\\ \\mathbf{x}=\\mathbf{D}\\mathbf{s}$
%[text] Analysis process and coefficient selection by a greedy algorithm
%[text] - Matching pursuit (MP)
%[text] - Orthogonal matching pursuit (OMP) \
%[text] For each atom $\\mathbf{d}\_i$, the projection coefficient $a\[i\]=\\langle\\mathbf{d}\_i,\\mathbf{r}\\rangle/\\|\\mathbf{d}\_i\\|\_2^2$
%[text] and the approximation error $e\[i\]=\\|\\mathbf{r}\\|\_2^2-|a\[i\]|^2\\|\\mathbf{d}\_i\\|\_2^2$ are evaluated, and the atom
%[text] with the minimum error is selected.
% Initialization
L = size(D,2);
dnorm2 = sum(D.^2,1).';  % ||d_i||_2^2
s = zeros(L,1);
xhat = zeros(nSamples,1);
r = x - xhat;
supp = [];
k = 0;
while k < K
    % Matching process
    a = (D.'*r)./dnorm2;               % a[i] = <d_i,r>/||d_i||^2
    e = r.'*r - abs(a).^2.*dnorm2;     % e[i] = ||r - a[i] d_i||^2

    % Minimum value search (pursuit)
    [~,imin] = min(e);
    % Update of the support
    supp = union(supp,imin);
    if isOmp % Orthogonal matching pursuit
        Ds = D(:,supp);
        s(supp) = pinv(Ds)*x;
        k = k + 1;
    else % Matching pursuit
        s(imin) = s(imin) + a(imin);
        k = length(supp);
    end
    % Synthesis process
    xhat = D*s;
    % Residual
    r = x - xhat;
end
%[text] Approximation result
xhat = D*s;
%[text] Residual
r = x - xhat;
%%
%[text] ## Graph plot
fig = figure;
tl = tiledlayout(fig,3,1,"TileSpacing","compact");
if isOmp
    method = "(OMP)";
else
    method = "(MP)";
end

% Input
ax = nexttile(tl);
stem(ax,0:nSamples-1,x,"filled")
axis(ax,[0 nSamples -1.5 1.5])
ylabel(ax,"$x[n]$","Interpreter","latex")
title(ax,"$\ell_0$-pseudo-norm minimization " + method,"Interpreter","latex")

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
%[control:checkbox:861b]
%   data: {"defaultValue":true,"label":"isOmp","run":"Section"}
%---
