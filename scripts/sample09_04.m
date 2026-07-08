%[text] # Sample 9-4
%[text] ## 離散ウェーブレット変換
%[text] 縦続接続フィルタバンク
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Discrete wavelet transform
%[text] Cascade-structure filter banks
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ### リフティング構造フィルタバンク
%[text] (Lifting-structure filter banks)
%[text] 予測ステップと更新ステップで構成されるフィルタバンク (Filter banks consisting of prediction and update steps as follows.)
%[text] - 予測ステップ (Prediction step)： $\\mathbf{L}\_{\\mathrm{p}}(z)=\\left(\\begin{array}{cc} 1 & 0 \\\\ -P(z)  & 1\\end{array}\\right)$,$\\mathbf{L}\_{\\mathrm{p}}^{-1}(z)=\\left(\\begin{array}{cc} 1 & 0 \\\\ P(z)  & 1\\end{array}\\right)$
%[text] - 更新ステップ (Update step)：$\\mathbf{L}\_{\\mathrm{u}}(z)=\\left(\\begin{array}{cc} 1 & U(z) \\\\0& 1\\end{array}\\right)$,$\\mathbf{L}\_{\\mathrm{u}}^{-1}(z)=\\left(\\begin{array}{cc} 1 & -U(z) \\\\0& 1\\end{array}\\right)$
%[text] - 係数シフト(Coefficient delay)：$\\mathbf{\\Lambda}\_\\mathrm{b}(z)=\\left(\\begin{array}{cc} 1 & 0 \\\\0& z^{-1}\\end{array}\\right)$, ${\\mathbf{\\Lambda}}\_\\mathrm{t}(z)=\\left(\\begin{array}{cc} z^{-1} & 0 \\\\0 & 1\\end{array}\\right)$ \
%[text] 予測ステップと更新ステップを縦続接続することで完全再構成フィルタバンクを実現する。(A perfect reconstruction system is realized by connecting the prediction and update steps in cascade.)
%[text] なお、(where) $\\mathbf{\\Lambda}\_\\mathrm{t}(z)\\mathbf{\\Lambda}\_\\mathrm{b}(z)=\\mathbf{\\Lambda}\_\\mathrm{b}(z)\\mathbf{\\Lambda}\_\\mathrm{t}(z)=z^{-1}\\mathbf{I}$ が成立する。(holds.)
%[text] 【Exampe】9/7-transform adopted in JPEG2000
%[text] The length of the analysis filter impluse responses are 9 and 7, respectively.
import msip.ppmatrix

% # of channels
nChs = 2;

% Lifting parameters
alpha = -1.586134342059924;
beta  = -0.052980118572961;
gamma =  0.882911075530934;
delta =  0.443506852043971;
K =  1.230174104914001;

% Delay for low-pass Coefs.
clear topshift
topshift(1,1,2) = 1;
topshift(2,2,1) = 1;
topshift = ppmatrix(topshift);
display(topshift)
% Delay for high-pass Coefs.
clear btmshift
btmshift(1,1,1) = 1;
btmshift(2,2,2) = 1;
btmshift = ppmatrix(btmshift);
display(btmshift)
%[text] 分析フィルタバンクの構築 (Conctruction of analysis filter banks)
%[text]  $\\mathbf{E}(z) = \\left(\\begin{array}{cc}K & 0 \\\\ 0 & 1/K\\end{array}\\right)\\mathbf{L}\_{u,N-1}(z) \\mathbf{\\Lambda}\_\\mathrm{t}(z)\\mathbf{L}\_{p,N-2}(z)\\cdots\\mathbf{\\Lambda}\_\\mathrm{b} (z)\\mathbf{L}\_{u,1}(z) \\mathbf{\\Lambda}\_\\mathrm{t}(z)\\mathbf{L}\_{p,0}(z)$
Gp0 = topshift*predictionstep(alpha);
display(Gp0)
Gu1 = btmshift*updatestep(beta);
display(Gu1)
Gp2 = topshift*predictionstep(gamma);
display(Gp2)
Gu3 = diag([1/K,K])*updatestep(delta);
display(Gu3)
%[text] 
%[text] リフティング構造分析フィルタバンクのType-Iポリフェーズ行列 (Type-I polyphase matrix of the analysis filter bank in lifting structure)
E = Gu3*Gp2*Gu1*Gp0;
display(E)
% Delay chain
dc = delaychain(nChs);
display(dc)
%[text]      分析フィルタ (Analysis filters)
%[text]  $\\mathbf{h}(z) = \\left(\\begin{array}{c} H\_0(z) \\\\ H\_1(z) \\\\ \\vdots \\\\ H\_{M-1}(z) \\end{array}\\right)\n=\\mathbf{E}(z^M)\\mathbf{d}(z)=\\mathbf{E}(z^M)\n \\left(\\begin{array}{c} 1 \\\\ z^{-1} \\\\ \\vdots \\\\ z^{-(M-1)} \\end{array}\\right)$
% Analysis filters
h = upsample(E,nChs)*dc;
H = squeeze(double(h))
%[text] 合成フィルタバンクの構築 (Construction of synthesis filter bank in lifting structure)
%[text]  $\\mathbf{R}(z) = \\mathbf{L}\_{p,0}^{-1}(z) \\mathbf{\\Lambda}\_\\mathrm{b}(z)\\mathbf{L}\_{u,1}^{-1}(z)\\cdots\\mathbf{\\Lambda}\_\\mathrm{t} (z)\\mathbf{L}\_{p,N-2}^{-1}(z) \\mathbf{\\Lambda}\_\\mathrm{b}(z)\\mathbf{L}\_{u,N-1}^{-1}(z) \\left(\\begin{array}{cc}1/K & 0 \\\\ 0 & K\\end{array}\\right)$

Giu3 = updatestep(-delta)*diag([K,1/K]);
display(Giu3)
Gip2 = predictionstep(-gamma)*btmshift;
display(Gip2)
Giu1 = updatestep(-beta)*topshift;
display(Giu1)
Gip0 = predictionstep(-alpha)*btmshift;
display(Gip0)
%[text] リフティング構造合成フィルタバンクのType-IIポリフェーズ行列 (Type-II polyphase matrix of the synthesis filter bank in lifting structure)
R = Gip0*Giu1*Gip2*Giu3;
display(R)
% Delay chain
display(dc.')
%[text]   合成フィルタ (Synthesis filters)
%[text]  $\\mathbf{f}^T(z) = \\left(\\begin{array}{cccc} F\_0(z) & F\_1(z) & \\cdots &F\_{M-1}(z) \\end{array}\\right)\n=\\tilde{\\mathbf{d}}(z)\\mathbf{R}(z^M)=\\left(\\begin{array}{cccc} z^{-(M-1)} & z^{-(M-2)} & \\cdots & 1 \\end{array}\\right)\\mathbf{R}(z^M)\n $
% Synthesis filters
f = dc.'*upsample(R,nChs);
F = squeeze(double(f))
%[text] 完全再構成条件の確認 (Confirmation of perfect reconstruction)
%[text]  $\\mathbf{R}(z)\\mathbf{E}(z)=z^{-N}\\mathbf{I} $ 
display(R*E)
disp(double(R*E))
%[text] インパルス応答 (Impluse responses)
figure(1)
% Low-pass filter
subplot(2,2,1)
impz(H(1,:))
title('h_0[n]')
ax = gca;
ax.YLim =[ min(H(:)) max(H(:)) ];

% High-pass filter
subplot(2,2,3)
impz(H(2,:))
title('h_1[n]')
ax = gca;
ax.YLim =[ min(H(:)) max(H(:)) ];
% Low-pass filter
subplot(2,2,2)
impz(F(1,:))
title('f_0[n]')
ax = gca;
ax.YLim =[ min(F(:)) max(F(:)) ];

% High-pass filter
subplot(2,2,4)
impz(F(2,:))
title('f_1[n]')
ax = gca;
ax.YLim =[ min(F(:)) max(F(:)) ];
%[text] 周波数応答 (Frequency responses)
figure(2)
fftPoints = 512;
subplot(1,2,1)
Hfrq = zeros(fftPoints,nChs);
% Low-pass filter
[Hfrq(:,1),W] = freqz(H(1,:),1,fftPoints);
% High-pass filter
Hfrq(:,2) = freqz(H(2,:),1,fftPoints);
plot(W/pi, abs(Hfrq)) %20*log10(abs(F)))
axis([0 1 0 ceil(K*nChs)]) %-70 10])
xlabel('Normalized Frequency (x\pi rad/sample)')
ylabel('Magnitude') % (dB)')
title('Analysis FB')
legend({ 'H_0', 'H_1' })
grid on
subplot(1,2,2)
Ffrq = zeros(fftPoints,nChs);
% Low-pass filter
[Ffrq(:,1),W] = freqz(F(1,:),1,fftPoints);
% High-pass filter
Ffrq(:,2) = freqz(F(2,:),1,fftPoints);
plot(W/pi, abs(Ffrq)) %20*log10(abs(F)))
axis([0 1 0 ceil(K*nChs)]) %-70 10])
xlabel('Normalized Frequency (x\pi rad/sample)')
ylabel('Magnitude') % (dB)')
title('Synthesis FB')
legend({ 'F_0', 'F_1' })
grid on
%%
%[text] ### ラティス構造フィルタバンク
%[text] (Lattice-structure filter banks)
%[text] 回転行列と係数シフトで構成されるフィルタバンク (Filter banks consisting of rotation matrices and coefficient delay)
%[text] - 回転行列(Rotation matrix)： $\\mathbf{G}\_{\\theta}=\\left(\\begin{array}{cc} \\cos\\theta  & \\sin\\theta \\\\ -\\sin\\theta   & \\cos\\theta \\end{array}\\right)$, $\\mathbf{G}^{-1}\_{\\theta}=\\left(\\begin{array}{cc} \\cos\\theta  & -\\sin\\theta \\\\ \\sin\\theta   & \\cos\\theta \\end{array}\\right)$
%[text] - 係数シフト(Coefficient delay)：$\\mathbf{\\Lambda}\_\\mathrm{b}(z)=\\left(\\begin{array}{cc} 1 & 0 \\\\0& z^{-1}\\end{array}\\right)$, ${\\mathbf{\\Lambda}}\_\\mathrm{t}(z)=\\left(\\begin{array}{cc} z^{-1} & 0 \\\\0 & 1\\end{array}\\right)$ \
%[text] なお、(where) $\\mathbf{\\Lambda}\_\\mathrm{t}(z)\\mathbf{\\Lambda}\_\\mathrm{b}(z)=\\mathbf{\\Lambda}\_\\mathrm{b}(z)\\mathbf{\\Lambda}\_\\mathrm{t}(z)=z^{-1}\\mathbf{I}$ が成立する。(holds.)
%[text] 回転行列と係数シフトを縦続接続とすることで完全再構成フィルタバンクを実現する。(A paraunitary (perfect reconstruction) system is realized by connecting rotation matrices and the coefficient shifts in cascade.)
%[text] 【Example】2-channel orthonormal filter banks (Paraunitary system)
%[text] Reference: Table 6.4.1, p.308 in P.P.Vaidyanathan, "**Multirate Systems and Filter Banks,**" Prentice Hall, 1993
import msip.ppmatrix

% # of channels
nChs = 2;
Gtheta = @(theta) [cos(theta)  sin(theta) ; -sin(theta) cos(theta)];

% Lattice parameters
eta = -1; % ∈{-1,1}
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
%[text] ラティス構造分析フィルタバンクのType-Iポリフェーズ行列 (Type-I polyphase matrix of the analysis filter bank in lattice structure)
%[text]  $\\mathbf{E}(z) = \\mathbf{G}\_{\\theta\_{N-1}} \\mathbf{\\Lambda}\_\\mathrm{b}(z)\\mathbf{G}\_{\\theta\_{N-2}}\\cdots\\mathbf{\\Lambda}\_\\mathrm{b} (z)\\mathbf{G}\_{\\theta\_1} \\mathbf{\\Lambda}\_\\mathrm{b}(z)\\mathbf{G}\_{\\theta\_0} \\left(\\begin{array}{cc}1 & 0 \\\\ 0 & \\eta \\end{array}\\right)$
E = Gtheta(thetas(1))*diag([1,eta]);
for idx = 2:length(thetas)
    E = Gtheta(thetas(idx))*btmshift*E;
end
display(E)
% Delay chain
dc = delaychain(nChs);
display(dc)
%[text]      分析フィルタ (Analysis filters)
%[text]  $\\mathbf{h}(z) = \\left(\\begin{array}{c} H\_0(z) \\\\ H\_1(z) \\\\ \\vdots \\\\ H\_{M-1}(z) \\end{array}\\right)\n=\\mathbf{E}(z^M)\\mathbf{d}(z)=\\mathbf{E}(z^M)\n \\left(\\begin{array}{c} 1 \\\\ z^{-1} \\\\ \\vdots \\\\ z^{-(M-1)} \\end{array}\\right)$
% Analysis filters
h = upsample(E,nChs)*dc;
H = squeeze(double(h))
%[text] ラティス構造合成フィルタバンクのType-IIポリフェーズ行列 (Type-II polyphase matrix of the synthesis filter bank in lattice structure)
%[text]  $\\mathbf{R}(z) = \\left(\\begin{array}{cc}1 & 0 \\\\ 0 & \\eta \\end{array}\\right)\\mathbf{A}\_{\\theta\_{0}}^{-1} \\mathbf{\\Lambda}\_\\mathrm{t}(z)\\mathbf{A}\_{\\theta\_{1}}^{-1}\\cdots\\mathbf{\\Lambda}\_\\mathrm{t} (z)\\mathbf{A}\_{\\theta\_{N-2}}^{-1} \\mathbf{\\Lambda}\_\\mathrm{t}(z)\\mathbf{A}\_{\\theta\_{N-1}}^{-1}$
R = diag([1,eta])*Gtheta(-thetas(1));
for idx = 2:length(thetas)
    R = R*topshift*Gtheta(-thetas(idx));
end
display(R)
% Delay chain
display(dc.')
%[text]   合成フィルタ (Synthesis filters)
%[text]  $\\mathbf{f}^T(z) = \\left(\\begin{array}{cccc} F\_0(z) & F\_1(z) & \\cdots &F\_{M-1}(z) \\end{array}\\right)\n=\\tilde{\\mathbf{d}}(z)\\mathbf{R}(z^M)=\\left(\\begin{array}{cccc} z^{-(M-1)} & z^{-(M-2)} & \\cdots & 1 \\end{array}\\right)\\mathbf{R}(z^M)\n $
% Synthesis filters
f = dc.'*upsample(R,nChs);
F = squeeze(double(f))
%[text] 完全再構成条件の確認 (Confirmation of perfect reconstruction)
%[text]  $\\mathbf{R}(z)\\mathbf{E}(z)=z^{-N}\\mathbf{I} $ 
display(R*E)
disp(double(R*E))
%[text] インパルス応答 (Impluse responses)
figure(3)
% Low-pass filter
subplot(2,2,1)
impz(H(1,:))
title('h_0[n]')
ax = gca;
ax.YLim =[ min(H(:)) max(H(:)) ];

% High-pass filter
subplot(2,2,3)
impz(H(2,:))
title('h_1[n]')
ax = gca;
ax.YLim =[ min(H(:)) max(H(:)) ];
% Low-pass filter
subplot(2,2,2)
impz(F(1,:))
title('f_0[n]')
ax = gca;
ax.YLim =[ min(F(:)) max(F(:)) ];

% High-pass filter
subplot(2,2,4)
impz(F(2,:))
title('f_1[n]')
ax = gca;
ax.YLim =[ min(F(:)) max(F(:)) ];
%[text] 周波数応答 (Frequency responses)
figure(4)
fftPoints = 512;
subplot(1,2,1)
Hfrq = zeros(fftPoints,nChs);
% Low-pass filter
[Hfrq(:,1),W] = freqz(H(1,:),1,fftPoints);
% High-pass filter
Hfrq(:,2) = freqz(H(2,:),1,fftPoints);
plot(W/pi, abs(Hfrq)) %20*log10(abs(F)))
axis([0 1 0 ceil(sqrt(nChs))]) %-70 10])
xlabel('Normalized Frequency (x\pi rad/sample)')
ylabel('Magnitude') % (dB)')
title('Analysis FB')
legend({ 'H_0', 'H_1' })
grid on
subplot(1,2,2)
Ffrq = zeros(fftPoints,nChs);
% Low-pass filter
[Ffrq(:,1),W] = freqz(F(1,:),1,fftPoints);
% High-pass filter
Ffrq(:,2) = freqz(F(2,:),1,fftPoints);
plot(W/pi, abs(Ffrq)) %20*log10(abs(F)))
axis([0 1 0 ceil(sqrt(nChs))]) %-70 10])
xlabel('Normalized Frequency (x\pi rad/sample)')
ylabel('Magnitude') % (dB)')
title('Synthesis FB')
legend({ 'F_0', 'F_1' })
grid on
%%
%[text] ### 関数定義
%[text] (Function definition)
function ppm = predictionstep(theta)
    % Prediction step in polyphase matrix
    import msip.ppmatrix
    p(1,1,1) = 1;
    p(2,1,1) = theta;
    p(2,1,2) = theta;
    p(2,2,1) = 1;
    ppm = ppmatrix(p);
end

function ppm = updatestep(theta)
    % Update step in polyphase matrix
    import msip.ppmatrix
    u(1,1,1) = 1;
    u(1,2,1) = theta;
    u(1,2,2) = theta;
    u(2,2,1) = 1;
    ppm = ppmatrix(u);
end

function ppm = delaychain(m)
    % Delay chain
    import msip.ppmatrix
    d = zeros(m,1,m);
    for idx = 1:m
        d(idx,1,idx) = 1;
    end
    ppm = ppmatrix(d);
end
%[text] 
%[text] ### 
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
