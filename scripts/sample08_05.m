%[text] # Sample 8-5: Relation to DFT
%[text] Advanced Topics in Image Processing, Lecture 8 "Discrete Cosine Transforms"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## DCT matrix
%[text]  $\[\\mathbf{C}\_M\]\_{m,n}=\\alpha\_m\\cos\\frac{m(2n+1)\\pi}{2M},\\ m,n\\in\\{0,1,\\ldots,M-1\\}$
%[text]  $\\alpha\_m=\\left\\{\\begin{array}{ll} 1/\\sqrt{M} & m=0 \\\\ \\sqrt{2/M} & m\\in\\{1,2,\\ldots,M-1\\}\\end{array}\\right.$
% Number of DCT points
nPoints = 4; %[control:slider:5fb5]{"position":[11,12]}
C = dctmtx(nPoints)
%%
%[text] ## OTDFT matrix
%[text] The odd-time DFT (OTDFT) is closely related to the DCT.
%[text] OTDFT: the generalized DFT (GDFT) with $a=0$, $b=1/2$
%[text] - GDFT matrix \
%[text]  $\[\\mathbf{W}\_N^{(a,b)}\]\_{k,n}=e^{-\\mathrm{j}2\\pi(k+a)(n+b)/N},\\ k,n\\in\\{0,1,\\ldots,N-1\\}$
%[text] - OTDFT matrix \
%[text]  $\\mathbf{W}\_N^{(0,1/2)}=\\boldsymbol{\\Lambda}\_N\\mathbf{W}\_N$, $\[\\boldsymbol{\\Lambda}\_N\]\_{k,k}=e^{-\\mathrm{j}\\pi k/N}$
% Number of DFT points
nPointsDft = 2 * nPoints;

% OTDFT matrix
k = 0:nPointsDft-1;
Wdft = dftmtx(nPointsDft);
Lambda = diag(exp(-1j*pi/nPointsDft*k));
Wotdft = Lambda * Wdft
%%
%[text] ## DCT through OTDFT
%[text] Relation between the OTDFT and the DCT
%[text]  $\\left\[\\mathbf{C}\_{M}\\right\]\_{m,n}=\\frac{\\alpha\_{m}}{2}\\left\[\\mathbf{W}\_{2M}^{(0,1/2)}\\mathbf{E}\_{M}\\right\]\_{m,n},\\ m,n\\in\\{0,1,\\ldots,M-1\\}$
%[text] where $\\mathbf{E}\_{M}$ is the $2M\\times M$ symmetric extension matrix
%[text]  $\\mathbf{E}\_{M}=\\begin{pmatrix}\\mathbf{I}\_M \\\\ \\mathbf{J}\_M\\end{pmatrix}=\\left(\\begin{array}{cccc}1 & 0 & \\cdots & 0 \\\\0 & 1 & \\cdots & 0 \\\\\\vdots & \\vdots & \\ddots & \\vdots \\\\0 & 0 & \\cdots & 1 \\\\0 & 0 & \\cdots & 1 \\\\\\vdots & \\vdots & \\ddots & \\vdots \\\\0 & 1 & \\cdots & 0 \\\\1 & 0 & \\cdots & 0\\end{array}\\right)$
%[text] ($\\mathbf{I}\_M$: identity matrix, $\\mathbf{J}\_M$: reversal matrix).
% Symmetric extension matrix
E = [ eye(nPoints) ; fliplr(eye(nPoints)) ]

% DCT matrix through OTDFT (alpha_m/2 = 1/sqrt(2M) * [1/sqrt(2) 1 ... 1])
D = 1/sqrt(2*nPoints)*...
    diag([1/sqrt(2) ones(1,nPoints-1) ])*...
    Wotdft(1:nPoints,:)*E
%[text] Evaluation of the error
norm(D-C,"fro")
%[text] The fast Fourier transform (FFT) can be applied to the transform with `Wdft` (DFT).
%[text] Hence the DCT has fast algorithms.
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:5fb5]
%   data: {"defaultValue":4,"label":"nPoints","max":8,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
