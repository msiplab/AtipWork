%[text] # Sample 9-4: Cascade-structure FBs
%[text] Advanced Topics in Image Processing, Lecture 9 "Discrete Wavelet Transforms"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Lifting-structure filter banks
%[text] Filter banks consisting of prediction and update steps:
%[text] - Prediction step: $\\mathbf{L}\_{\\mathrm{p}}(z)=\\begin{pmatrix} 1 & 0 \\\\ P(z)  & 1\\end{pmatrix}$, $\\mathbf{L}\_{\\mathrm{p}}^{-1}(z)=\\begin{pmatrix} 1 & 0 \\\\ -P(z)  & 1\\end{pmatrix}$
%[text] - Update step: $\\mathbf{L}\_{\\mathrm{u}}(z)=\\begin{pmatrix} 1 & U(z) \\\\0& 1\\end{pmatrix}$, $\\mathbf{L}\_{\\mathrm{u}}^{-1}(z)=\\begin{pmatrix} 1 & -U(z) \\\\0& 1\\end{pmatrix}$
%[text] - Coefficient delay: $\\boldsymbol{\\Lambda}\_\\mathrm{b}(z)=\\begin{pmatrix} 1 & 0 \\\\0& z^{-1}\\end{pmatrix}$, $\\boldsymbol{\\Lambda}\_\\mathrm{t}(z)=\\begin{pmatrix} z^{-1} & 0 \\\\0 & 1\\end{pmatrix}$
%[text] A perfect reconstruction filter bank is realized by the cascade of the prediction and update steps,
%[text] where $\\boldsymbol{\\Lambda}\_\\mathrm{t}(z)\\boldsymbol{\\Lambda}\_\\mathrm{b}(z)=\\boldsymbol{\\Lambda}\_\\mathrm{b}(z)\\boldsymbol{\\Lambda}\_\\mathrm{t}(z)=z^{-1}\\mathbf{I}$ holds.
%[text] **Example**: 9/7-transform adopted in JPEG 2000.
%[text] The lengths of the impulse responses of the analysis filters are 9 and 7, respectively.
% Number of channels
nChs = 2;

% Lifting parameters
alpha = -1.586134342059924;
beta  = -0.052980118572961;
gamma =  0.882911075530934;
delta =  0.443506852043971;
K =  1.230174104914001;

% Delay for the low-pass coefficients
topshift = zeros(2,2,2);
topshift(1,1,2) = 1;
topshift(2,2,1) = 1;
topshift = msip.ppmatrix(topshift);
disp(topshift)
% Delay for the high-pass coefficients
btmshift = zeros(2,2,2);
btmshift(1,1,1) = 1;
btmshift(2,2,2) = 1;
btmshift = msip.ppmatrix(btmshift);
disp(btmshift)
%[text] Construction of the analysis filter bank
%[text]  $\\mathbf{E}(z) = \\begin{pmatrix}K & 0 \\\\ 0 & 1/K\\end{pmatrix}\\mathbf{L}\_{\\mathrm{u},N-1}(z) \\boldsymbol{\\Lambda}\_\\mathrm{t}(z)\\mathbf{L}\_{\\mathrm{p},N-2}(z)\\cdots\\boldsymbol{\\Lambda}\_\\mathrm{b} (z)\\mathbf{L}\_{\\mathrm{u},1}(z) \\boldsymbol{\\Lambda}\_\\mathrm{t}(z)\\mathbf{L}\_{\\mathrm{p},0}(z)$
Gp0 = topshift*predictionstep(alpha);
disp(Gp0)
Gu1 = btmshift*updatestep(beta);
disp(Gu1)
Gp2 = topshift*predictionstep(gamma);
disp(Gp2)
Gu3 = diag([1/K,K])*updatestep(delta);
disp(Gu3)
%[text] Type-I polyphase matrix of the analysis filter bank in the lifting structure
E = Gu3*Gp2*Gu1*Gp0;
disp(E)
% Delay chain
dc = delaychain(nChs);
disp(dc)
%[text] Analysis filters
%[text]  $\\mathbf{h}(z) = \\begin{pmatrix} H\_0(z) \\\\ H\_1(z) \\\\ \\vdots \\\\ H\_{M-1}(z) \\end{pmatrix}=\\mathbf{E}(z^M)\\mathbf{d}\_M(z)=\\mathbf{E}(z^M)\\begin{pmatrix} 1 \\\\ z^{-1} \\\\ \\vdots \\\\ z^{-(M-1)} \\end{pmatrix}$
h = upsample(E,nChs)*dc;
H = squeeze(double(h))
%[text] Construction of the synthesis filter bank in the lifting structure
%[text]  $\\mathbf{R}(z) = \\mathbf{L}\_{\\mathrm{p},0}^{-1}(z) \\boldsymbol{\\Lambda}\_\\mathrm{b}(z)\\mathbf{L}\_{\\mathrm{u},1}^{-1}(z)\\cdots\\boldsymbol{\\Lambda}\_\\mathrm{t} (z)\\mathbf{L}\_{\\mathrm{p},N-2}^{-1}(z) \\boldsymbol{\\Lambda}\_\\mathrm{b}(z)\\mathbf{L}\_{\\mathrm{u},N-1}^{-1}(z) \\begin{pmatrix}1/K & 0 \\\\ 0 & K\\end{pmatrix}$
Giu3 = updatestep(-delta)*diag([K,1/K]);
disp(Giu3)
Gip2 = predictionstep(-gamma)*btmshift;
disp(Gip2)
Giu1 = updatestep(-beta)*topshift;
disp(Giu1)
Gip0 = predictionstep(-alpha)*btmshift;
disp(Gip0)
%[text] Type-II polyphase matrix of the synthesis filter bank in the lifting structure
R = Gip0*Giu1*Gip2*Giu3;
disp(R)
% Delay chain
disp(dc.')
%[text] Synthesis filters (with the reversed delay chain)
%[text]  $\\mathbf{f}^\\top(z) = \\begin{pmatrix} F\_0(z) & F\_1(z) & \\cdots &F\_{M-1}(z) \\end{pmatrix}=\\begin{pmatrix} z^{-(M-1)} & z^{-(M-2)} & \\cdots & 1 \\end{pmatrix}\\mathbf{R}(z^M)$
f = dc.'*upsample(R,nChs);
F = squeeze(double(f))
%[text] Confirmation of the perfect reconstruction
%[text]  $\\mathbf{R}(z)\\mathbf{E}(z)=z^{-c}\\mathbf{I}$
disp(R*E)
disp(double(R*E))
%[text] Impulse responses
figure
tiledlayout(2,2,"TileSpacing","compact")
nexttile, stem(0:size(H,2)-1,H(1,:),"filled"), title("h_0[n]"), xlabel("n"), ylim([min(H(:)) max(H(:))])
nexttile, stem(0:size(F,2)-1,F(1,:),"filled"), title("f_0[n]"), xlabel("n"), ylim([min(F(:)) max(F(:))])
nexttile, stem(0:size(H,2)-1,H(2,:),"filled"), title("h_1[n]"), xlabel("n"), ylim([min(H(:)) max(H(:))])
nexttile, stem(0:size(F,2)-1,F(2,:),"filled"), title("f_1[n]"), xlabel("n"), ylim([min(F(:)) max(F(:))])
%[text] Frequency responses
figure
tiledlayout(1,2,"TileSpacing","compact")
fftPoints = 512;
nexttile
Hfrq = zeros(fftPoints,nChs);
[Hfrq(:,1),W] = freqz(H(1,:),1,fftPoints);   % low-pass filter
Hfrq(:,2) = freqz(H(2,:),1,fftPoints);       % high-pass filter
plot(W/pi, abs(Hfrq))
axis([0 1 0 ceil(K*nChs)])
xlabel("Normalized frequency (\times\pi rad/sample)")
ylabel("Magnitude")
title("Analysis FB")
legend(["H_0","H_1"])
grid on
nexttile
Ffrq = zeros(fftPoints,nChs);
[Ffrq(:,1),W] = freqz(F(1,:),1,fftPoints);   % low-pass filter
Ffrq(:,2) = freqz(F(2,:),1,fftPoints);       % high-pass filter
plot(W/pi, abs(Ffrq))
axis([0 1 0 ceil(K*nChs)])
xlabel("Normalized frequency (\times\pi rad/sample)")
ylabel("Magnitude")
title("Synthesis FB")
legend(["F_0","F_1"])
grid on
%%
%[text] ## Lattice-structure filter banks
%[text] Filter banks consisting of rotation matrices and coefficient delays:
%[text] - Rotation matrix: $\\mathbf{G}\_{\\theta}=\\begin{pmatrix} \\cos\\theta  & \\sin\\theta \\\\ -\\sin\\theta   & \\cos\\theta \\end{pmatrix}$, $\\mathbf{G}^{-1}\_{\\theta}=\\begin{pmatrix} \\cos\\theta  & -\\sin\\theta \\\\ \\sin\\theta   & \\cos\\theta \\end{pmatrix}$
%[text] - Coefficient delay: $\\boldsymbol{\\Lambda}\_\\mathrm{b}(z)=\\begin{pmatrix} 1 & 0 \\\\0& z^{-1}\\end{pmatrix}$, $\\boldsymbol{\\Lambda}\_\\mathrm{t}(z)=\\begin{pmatrix} z^{-1} & 0 \\\\0 & 1\\end{pmatrix}$
%[text] where $\\boldsymbol{\\Lambda}\_\\mathrm{t}(z)\\boldsymbol{\\Lambda}\_\\mathrm{b}(z)=\\boldsymbol{\\Lambda}\_\\mathrm{b}(z)\\boldsymbol{\\Lambda}\_\\mathrm{t}(z)=z^{-1}\\mathbf{I}$ holds.
%[text] A paraunitary (perfect reconstruction) system is realized by the cascade of the rotation matrices and the coefficient delays.
%[text] **Example**: two-channel orthonormal filter bank (paraunitary system).
%[text] Reference: Table 6.4.1, p. 308 in P. P. Vaidyanathan, "**Multirate Systems and Filter Banks**," Prentice Hall, 1993.
% Number of channels
nChs = 2;
Gtheta = @(theta) [cos(theta)  sin(theta) ; -sin(theta) cos(theta)];

% Lattice parameters
eta = -1; % in {-1,1}
thetas = atan([ ...
    -0.2588883e+1 ...
     0.8410785e+0 ...
    -0.4787637e+0 ...
     0.3148984e+0 ...
    -0.2179341e+0 ...
     0.1522899e+0 ...
    -0.1046526e+0 ...
     0.6906427e-1 ...
    -0.4258295e-1 ...
     0.3111448e-1]);
%[text] Type-I polyphase matrix of the analysis filter bank in the lattice structure
%[text]  $\\mathbf{E}(z) = \\mathbf{G}\_{\\theta\_{N-1}} \\boldsymbol{\\Lambda}\_\\mathrm{b}(z)\\mathbf{G}\_{\\theta\_{N-2}}\\cdots\\boldsymbol{\\Lambda}\_\\mathrm{b} (z)\\mathbf{G}\_{\\theta\_1} \\boldsymbol{\\Lambda}\_\\mathrm{b}(z)\\mathbf{G}\_{\\theta\_0} \\begin{pmatrix}1 & 0 \\\\ 0 & \\eta \\end{pmatrix}$
E = Gtheta(thetas(1))*diag([1,eta]);
for idx = 2:length(thetas)
    E = Gtheta(thetas(idx))*btmshift*E;
end
disp(E)
% Delay chain
dc = delaychain(nChs);
disp(dc)
%[text] Analysis filters
%[text]  $\\mathbf{h}(z)=\\mathbf{E}(z^M)\\mathbf{d}\_M(z)$
h = upsample(E,nChs)*dc;
H = squeeze(double(h))
%[text] Type-II polyphase matrix of the synthesis filter bank in the lattice structure
%[text]  $\\mathbf{R}(z) = \\begin{pmatrix}1 & 0 \\\\ 0 & \\eta \\end{pmatrix}\\mathbf{G}\_{\\theta\_{0}}^{-1} \\boldsymbol{\\Lambda}\_\\mathrm{t}(z)\\mathbf{G}\_{\\theta\_{1}}^{-1}\\cdots\\boldsymbol{\\Lambda}\_\\mathrm{t} (z)\\mathbf{G}\_{\\theta\_{N-2}}^{-1} \\boldsymbol{\\Lambda}\_\\mathrm{t}(z)\\mathbf{G}\_{\\theta\_{N-1}}^{-1}$
R = diag([1,eta])*Gtheta(-thetas(1));
for idx = 2:length(thetas)
    R = R*topshift*Gtheta(-thetas(idx));
end
disp(R)
% Delay chain
disp(dc.')
%[text] Synthesis filters
%[text]  $\\mathbf{f}^\\top(z)=\\begin{pmatrix} z^{-(M-1)} & z^{-(M-2)} & \\cdots & 1 \\end{pmatrix}\\mathbf{R}(z^M)$
f = dc.'*upsample(R,nChs);
F = squeeze(double(f))
%[text] Confirmation of the perfect reconstruction
%[text]  $\\mathbf{R}(z)\\mathbf{E}(z)=z^{-c}\\mathbf{I}$
disp(R*E)
disp(double(R*E))
%[text] Impulse responses
figure
tiledlayout(2,2,"TileSpacing","compact")
nexttile, stem(0:size(H,2)-1,H(1,:),"filled"), title("h_0[n]"), xlabel("n"), ylim([min(H(:)) max(H(:))])
nexttile, stem(0:size(F,2)-1,F(1,:),"filled"), title("f_0[n]"), xlabel("n"), ylim([min(F(:)) max(F(:))])
nexttile, stem(0:size(H,2)-1,H(2,:),"filled"), title("h_1[n]"), xlabel("n"), ylim([min(H(:)) max(H(:))])
nexttile, stem(0:size(F,2)-1,F(2,:),"filled"), title("f_1[n]"), xlabel("n"), ylim([min(F(:)) max(F(:))])
%[text] Frequency responses
figure
tiledlayout(1,2,"TileSpacing","compact")
fftPoints = 512;
nexttile
Hfrq = zeros(fftPoints,nChs);
[Hfrq(:,1),W] = freqz(H(1,:),1,fftPoints);   % low-pass filter
Hfrq(:,2) = freqz(H(2,:),1,fftPoints);       % high-pass filter
plot(W/pi, abs(Hfrq))
axis([0 1 0 ceil(sqrt(nChs))])
xlabel("Normalized frequency (\times\pi rad/sample)")
ylabel("Magnitude")
title("Analysis FB")
legend(["H_0","H_1"])
grid on
nexttile
Ffrq = zeros(fftPoints,nChs);
[Ffrq(:,1),W] = freqz(F(1,:),1,fftPoints);   % low-pass filter
Ffrq(:,2) = freqz(F(2,:),1,fftPoints);       % high-pass filter
plot(W/pi, abs(Ffrq))
axis([0 1 0 ceil(sqrt(nChs))])
xlabel("Normalized frequency (\times\pi rad/sample)")
ylabel("Magnitude")
title("Synthesis FB")
legend(["F_0","F_1"])
grid on
%%
%[text] ## Function definitions
function ppm = predictionstep(theta)
    % Prediction step in a polyphase matrix
    p = zeros(2,2,2);
    p(1,1,1) = 1;
    p(2,1,1) = theta;
    p(2,1,2) = theta;
    p(2,2,1) = 1;
    ppm = msip.ppmatrix(p);
end

function ppm = updatestep(theta)
    % Update step in a polyphase matrix
    u = zeros(2,2,2);
    u(1,1,1) = 1;
    u(1,2,1) = theta;
    u(1,2,2) = theta;
    u(2,2,1) = 1;
    ppm = msip.ppmatrix(u);
end

function ppm = delaychain(m)
    % Delay chain
    d = zeros(m,1,m);
    for idx = 1:m
        d(idx,1,idx) = 1;
    end
    ppm = msip.ppmatrix(d);
end
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
