%[text] # Sample 12-6: ADMM (robust PCA)
%[text] Advanced Topics in Image Processing, Lecture 12 "Image Restoration"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Preparation
[~,resfolder] = atip.prjfolders();
%%
%[text] ## Parameter settings
%[text] - lambda: weight $\\lambda$ of the sparse component
%[text] - rho: penalty parameter $\\rho$ of ADMM
%[text] - niters: number of iterations \
lambda = 10^-2; %[control:slider:1a8d]{"position":[13,15]}
rho = 1;
niters = 100;
%%
%[text] ## Read images
T = 0.3*im2double(imread("text.png"));
B = 0.7*imresize(checkerboard,size(T));
%[text] ## Observation image
%[text] Mixture $\\mathbf{M}$ of a low-rank image (checkerboard) and a sparse image (text)
M = T + B;
figure
imshow(M)
title("Observation M")
imwrite(M,fullfile(resfolder,"sample12_06_admmm.png"))
%%
%[text] ## Alternating direction method of multipliers
%[text] ### Problem setting
%[text] $\\min\_{\\mathbf{x},\\mathbf{y}} f(\\mathbf{x})+g(\\mathbf{y}),\\quad \\mathrm{s.t.}\\ \\mathbf{y}=\\mathbf{G}\\mathbf{x}$
%[text] - $f(\\cdot),g(\\cdot)$: convex functions
%[text] - $\\mathbf{G}$: full column rank matrix \
%[text] ### Algorithm
%[text] 1. Initialization: $\\mathbf{d}^{(0)}$, $\\mathbf{y}^{(0)}$, $t\\leftarrow 0$
%[text] 2. $\\mathbf{x}^{(t+1)}\\leftarrow\\arg\\min\_{\\mathbf{x}} f(\\mathbf{x})+\\frac{\\rho}{2}\\left\\|\\mathbf{y}^{(t)}-\\mathbf{G}\\mathbf{x}-\\mathbf{d}^{(t)}\\right\\|\_{2}^{2}$
%[text] 3. $\\mathbf{y}^{(t+1)}\\leftarrow\\mathrm{prox}\_{\\rho^{-1} g}\\left(\\mathbf{G}\\mathbf{x}^{(t+1)}+\\mathbf{d}^{(t)}\\right)$
%[text] 4. $\\mathbf{d}^{(t+1)}\\leftarrow\\mathbf{d}^{(t)}+\\mathbf{G}\\mathbf{x}^{(t+1)}-\\mathbf{y}^{(t+1)}$
%[text] 5. If a stopping criterion is satisfied then finish, otherwise $t\\leftarrow t+1$ and go to Step 2. \
%[text] where $\\rho\>0$.
%[text] ### Example: robust principal component analysis (robust PCA)
%[text] $\\mathbf{M}=\\mathbf{L}+\\mathbf{S}$
%[text] Problem setting
%[text] $\\min\_{\\mathbf{L},\\mathbf{S}}\\|\\mathbf{L}\\|\_{\*}+\\lambda\\|\\mathbf{S}\\|\_{1},\\quad\\mathrm{s.t.}\\ \\mathbf{M}=\\mathbf{L}+\\mathbf{S}$
%[text] $\\Updownarrow$
%[text] $\\min\_{\\mathbf{x},\\mathbf{y}} f(\\mathbf{x})+g(\\mathbf{y}),\\quad\\mathrm{s.t.}\\ \\mathbf{y}=\\mathbf{G}\\mathbf{x}$
%[text] where
%[text] - $\\|\\cdot\\|\_{\*}$: nuclear norm (sum of the singular values $\\{\\sigma\_n\\}$)
%[text] - $\\|\\cdot\\|\_{1}$: 1-norm as a vector (sum of the absolute values of the elements)
%[text] - $f(\\mathbf{x})=0$
%[text] - $g(\\mathbf{y})=\\|\\mathbf{Y}\_1\\|\_\\ast+\\lambda\\|\\mathbf{Y}\_2\\|\_1+\\iota\_{\\{\\mathbf{M}\\}}(\\mathbf{Y}\_3)$ for $\\mathbf{y}=\\begin{pmatrix}\\mathrm{vec}(\\mathbf{Y}\_1)\\\\ \\mathrm{vec}(\\mathbf{Y}\_2)\\\\ \\mathrm{vec}(\\mathbf{Y}\_3)\\end{pmatrix}$
%[text] - $\\mathbf{y}=\\mathbf{G}\\mathbf{x}=\\begin{pmatrix}\\boldsymbol{\\ell}\\\\ \\mathbf{s}\\\\ \\boldsymbol{\\ell}+\\mathbf{s}\\end{pmatrix}$, $\\mathbf{x}=\\begin{pmatrix}\\boldsymbol{\\ell}\\\\ \\mathbf{s}\\end{pmatrix}$, $\\mathbf{G}=\\begin{pmatrix}\\mathbf{I} & \\mathbf{O}\\\\ \\mathbf{O} & \\mathbf{I}\\\\ \\mathbf{I} & \\mathbf{I}\\end{pmatrix}$
%[text] - $\\boldsymbol{\\ell}=\\mathrm{vec}(\\mathbf{L})$, $\\mathbf{s}=\\mathrm{vec}(\\mathbf{S})$ \
%[text] Algorithm
% Step 1: Initialization
imgY1 = M;
imgY2 = zeros(size(M),'like',M);
imgY3 = M;
imgD1 = zeros(size(M),'like',M);
imgD2 = zeros(size(M),'like',M);
imgD3 = zeros(size(M),'like',M);

for idx = 1:niters
    % Set state variables
    Y1 = imgY1;
    Y2 = imgY2;
    Y3 = imgY3;
    D1 = imgD1;
    D2 = imgD2;
    D3 = imgD3;

    % Step 2: Update L and S (least squares with G^T G = [2 1; 1 2])
    L = (2*(Y1-D1) - (Y2-D2) + (Y3-D3))/3;
    S = (Y1-D1) + (Y3-D3) - 2*L;

    % Step 3-1: Update Y1 (singular value thresholding)
    Y1 = proxnuclearnorm(L + D1, 1/rho);
    % Step 3-2: Update Y2 (soft thresholding)
    Y2 = softthresholding(S + D2, lambda/rho);
    % Step 3-3: Update Y3 (projection onto {M})
    Y3 = M;

    % Step 4: Update dual variables
    D1 = D1 + L - Y1;
    D2 = D2 + S - Y2;
    D3 = D3 + L + S - Y3;

    % Update state variables
    imgY1 = Y1;
    imgY2 = Y2;
    imgY3 = Y3;
    imgD1 = D1;
    imgD2 = D2;
    imgD3 = D3;
end
%%
%[text] ## Results
figure
imshow(L)
title("Low-rank component L")
figure
imshow(S,[])
title("Sparse component S")
%%
%[text] ## Functions
%[text] Soft thresholding $\\phi\_\\mathrm{ST}(\\cdot;\\lambda)$
function y = softthresholding(x,lambda)
    y = sign(x).*max(abs(x)-lambda,0);
end
%[text] Proximal map of the nuclear norm (singular value thresholding)
function y = proxnuclearnorm(x,lambda)
    [U,S,V] = svd(x,'econ');
    T = softthresholding(S,lambda);
    S(1:size(T,1),1:size(T,2)) = T;
    y = U*S*V';
end
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:1a8d]
%   data: {"defaultValue":-2,"label":"log10(lambda)","max":5,"min":-5,"run":"SectionToEnd","runOn":"ValueChanging","step":0.5}
%---
