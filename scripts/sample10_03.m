%[text] # Sample 10-3: Moore-Penrose pseudo-inverse
%[text] Advanced Topics in Image Processing, Lecture 10 "Redundant Transforms"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Global matrix representation of the synthesis filter bank
%[text] The undecimated 2-channel synthesis filter bank with $F\_0(z)=\\frac{1}{2}(1+z^{-1})$ and
%[text] $F\_1(z)=\\frac{1}{2}(1-z^{-1})$ is represented by the dictionary $\\mathbf{D}\\in\\mathbb{R}^{N\\times 2N}$
%[text] (circular convolution).
% Number of input samples
nSamples = 4;

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
disp(D)
%%
%[text] ## Moore-Penrose pseudo-inverse
%[text] $\\mathbf{T}=\\mathbf{D}^\\top(\\mathbf{D}\\mathbf{D}^\\top)^{-1}=\\mathbf{D}^{+}$
T = pinv(D);
disp(T)
%%
%[text] ## Analysis-synthesis process
% Signal generation
x = rand(nSamples,1);
disp(x)
% Analysis process
s = T*x;
disp(s)
% Energy of the sub-band coefficient vector s
disp("||s||_2^2 = " + norm(s,2).^2)
% Synthesis process
xhat = D*s;
disp(xhat)
% MSE evaluation
disp("MSE = " + immse(x, xhat))
%%
%[text] ## Another generalized inverse
%[text] Analysis filters $H\_0(z)=\\gamma+\\delta z^{-1}$, $H\_1(z)=-\\gamma+\\delta z^{-1}$ with $\\delta=1-\\gamma$.
% Coefficients of the analysis filters
gamma = -0.5; %[control:slider:4b97]{"position":[9,13]}
delta = 1 - gamma;

% Analysis filters
h0 = [ gamma  delta ];
h1 = [ -gamma delta ];

% (Circular) convolution matrix
nH = max(length(h0),length(h1));
Ext = [eye(nSamples) ; eye(nH-1) zeros(nH-1,nSamples-nH+1) ];   % Circular extension matrix
Clp = [zeros(nSamples,nH-1) eye(nSamples) zeros(nSamples,nH-1)]; % Clipping matrix

% Global matrix representation of the analysis filter bank
t0 = Clp*convmtx(h0.',nSamples+nH-1)*Ext;
t1 = Clp*convmtx(h1.',nSamples+nH-1)*Ext;
T = zeros(2*nSamples,nSamples);
T(1:2:end,:) = t0;
T(2:2:end,:) = t1;
disp(T)
% Analysis process
s = T*x;
disp(s)
% Energy of the sub-band coefficient vector s
disp("||s||_2^2 = " + norm(s,2).^2)
% Synthesis process
xhat = D*s;
disp(xhat)
% MSE evaluation
disp("MSE = " + immse(x, xhat))
%%
%[text] ## Energy of the sub-band coefficient vector versus $\\gamma$
% Sweep gamma and evaluate the energy of the sub-band coefficient vectors
gammas = linspace(-1.0,2.0,32);
engs = zeros(length(gammas),1);
mses = zeros(length(gammas),1);
for idx = 1:length(gammas)
    % Analysis filters
    gamma = gammas(idx);
    delta = 1 - gamma;
    h0 = [ gamma  delta ];
    h1 = [ -gamma delta ];

    % Global matrix representation of the analysis filter bank
    t0 = Clp*convmtx(h0.',nSamples+nH-1)*Ext;
    t1 = Clp*convmtx(h1.',nSamples+nH-1)*Ext;
    T = zeros(2*nSamples,nSamples);
    T(1:2:end,:) = t0;
    T(2:2:end,:) = t1;

    % Analysis process
    s = T*x;

    % Energy of the sub-band coefficient vector s
    engs(idx) = norm(s,2).^2;

    % MSE evaluation
    xhat = D*s;
    mses(idx) = immse(x, xhat);
end
%%
%[text] Plot
fig = figure;
ax = axes(fig);
yyaxis(ax,"left")
plot(ax,gammas,engs)
xlabel(ax,"$\gamma$","Interpreter","latex")
ylabel(ax,"$\|\mathbf{s}\|_2^2$","Interpreter","latex")
grid(ax,"on")
yyaxis(ax,"right")
plot(ax,gammas,mses,":")
ylabel(ax,"MSE")
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:4b97]
%   data: {"defaultValue":-0.5,"label":"gamma","max":2,"min":-1,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
