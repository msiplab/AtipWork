%[text] # Sample 13-2: Reconstruction ICA (RICA)
%[text] Advanced Topics in Image Processing, Lecture 13 "Dictionary Learning"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Preparation
%[text] The Kodak images are downloaded to the data folder once.
datfolder = atip.prjfolders();
atip.download_img(false)
%%
%[text] ## Parameter settings
%[text] - szBlk: block size
%[text] - redundancyRatio: redundancy ratio $P/M$
%[text] - nItersRica: maximum number of iterations
%[text] - lambda: regularization parameter $\\lambda$ \
% Block size
szBlk = [ 8 8 ];

% Redundancy ratio
redundancyRatio = 7/3;

% Maximum number of iterations (rica stops earlier when it converges)
nItersRica = 1e5;

% Regularization parameter
lambda = 2e-3;
%%
%[text] ## Read image
%[text] - $\\mathbf{x}\\in\\mathbb{R}^{N}$ \
xorg = im2gray(im2double(imread(fullfile(datfolder,"kodim23.png"))));
szOrg = size(xorg);
figure
imshow(xorg)
title("Original image x")
%%
%[text] ### Generation of the data matrix from the image
%[text] Instead of subtracting the sample mean block, the image is centered beforehand,
%[text] and blocks (patches) $\\{\\mathbf{x}\_i\\}\_{i=1}^S$ are extracted at random positions.
meansubtract = @(u) u-mean(u,"all");
xc = meansubtract(xorg);

% Number of patches
nPatches = prod(szOrg./szBlk);

npos = randsample(prod(szOrg-szBlk),nPatches);
xbs = zeros(szBlk(1),szBlk(2),nPatches,'like',xc);
szSrchy = szOrg(1)-szBlk(1);
for iPatch = 1:nPatches
    ny_ = mod(npos(iPatch)-1,szSrchy)+1;
    nx_ = floor((npos(iPatch)-1)/szSrchy)+1;
    xbs(:,:,iPatch) = xc(ny_:ny_+szBlk(1)-1,nx_:nx_+szBlk(2)-1);
end
figure
montage(xbs+0.5,"Size",[8 8]);
drawnow

X = reshape(xbs,prod(szBlk),[]);
%%
%[text] ## Reconstruction ICA
%[text] ### Problem setting
%[text] $\\hat{\\boldsymbol{\\Phi}}=\\arg\\min\_{\\boldsymbol{\\Phi}}\\frac{1}{2S}\\sum\_{i=1}^S\\|\\mathbf{x}\_i-\\boldsymbol{\\Phi}\\boldsymbol{\\Phi}^\\top\\mathbf{x}\_i\\|\_2^2+\\frac{1}{S}\\sum\_{i=1}^{S}\\mathfrak{R}(\\boldsymbol{\\Phi}^\\top\\mathbf{x}\_i)$
%[text] $=\\arg\\min\_{\\boldsymbol{\\Phi}}\\frac{(2\\lambda)^{-1}}{S}\\sum\_{i=1}^S\\|\\mathbf{x}\_i-\\boldsymbol{\\Phi}\\boldsymbol{\\Phi}^\\top\\mathbf{x}\_i\\|\_2^2+\\frac{1}{S}\\sum\_{i=1}^{S}\\frac{1}{\\lambda}\\mathfrak{R}(\\boldsymbol{\\Phi}^\\top\\mathbf{x}\_i)$
%[text] where $\\{\\mathbf{x}\_i\\}\_i\\subset\\mathbb{R}^{M}$ and $\\boldsymbol{\\Phi}=(\\boldsymbol{\\phi}\_0\\ \\ \\boldsymbol{\\phi}\_1\\ \\cdots\\ \\boldsymbol{\\phi}\_{P-1})\\in\\mathbb{R}^{M\\times P}$, $M\\leq P$ (redundant).
%[text] The weight of the reconstruction term of `rica` ('Lambda') is $(2\\lambda)^{-1}$.
%[text]
%[text] ### Reference
%[text] Le, Quoc V., Alexandre Karpenko, Jiquan Ngiam, and Andrew Y. Ng. "ICA with Reconstruction Cost for Efficient Overcomplete Feature Learning." Advances in Neural Information Processing Systems. Vol. 24, 2011, pp. 1017-1025. https://papers.nips.cc/paper/4467-ica-with-reconstruction-cost-for-efficient-overcomplete-feature-learning.pdf
%[text]
%[text] Example of the contrast function
%[text] $\\mathfrak{R}(\\boldsymbol{\\Phi}^\\top\\mathbf{x})=\\frac{\\lambda}{2}\\sum\_{p=0}^{P-1}\\log\\circ\\cosh(2\\boldsymbol{\\phi}\_p^\\top\\mathbf{x})$
figure
fplot(@(u) abs(u),[-5 5],':','LineWidth',2,'DisplayName','|\cdot|')
hold on
fplot(@(u) log(cosh(2*u))/2,[-5 5],'-','LineWidth',2,'DisplayName','1/2log(cosh(2\cdot))')
xlabel('y')
legend
grid on
axis equal
hold off
%[text] Number of atomic images
nDims = prod(szBlk);
nAtoms = ceil(redundancyRatio*nDims);
%%
%[text] Initialization of the dictionary $\\boldsymbol{\\Phi}$
%[text] - two-dimensional DCT
%[text] - random \
Phi_rica = randn(nDims,nAtoms);
Phi_rica = Phi_rica/norm(Phi_rica,'fro');
for iAtom = 1:nDims
    delta = zeros(szBlk);
    delta(iAtom) = 1;
    Phi_rica(:,iAtom) = reshape(idct2(delta),nDims,1);
end
%[text] Reshape the atoms into atomic images
atomicImagesRica = zeros(szBlk(1),szBlk(2),nAtoms);
for iAtom = 1:nAtoms
    atomicImagesRica(:,:,iAtom) = reshape(Phi_rica(:,iAtom),szBlk(1),szBlk(2));
end
figure
montage(imresize(atomicImagesRica,8,"nearest")+.5,"BorderSize",[2 2],"Size",[ceil(nAtoms/8) 8])
title("Atomic images of the initial dictionary (DCT & random)")
%%
%[text] ### Creation of the reconstruction ICA object
model = rica(X.',nAtoms,...
    'IterationLimit',nItersRica,...
    'ContrastFcn','logcosh',...
    'InitialTransformWeight',Phi_rica,...
    'Lambda',1/(2*lambda));
%[text] Graph of the cost
info = model.FitInfo;
figure
plot(info.Iteration,info.Objective)
xlabel("Number of iterations")
ylabel("Cost")
grid on
%[text] Reshape the atoms into atomic images
Phi_rica = model.TransformWeights;
atomicImagesRica = zeros(szBlk(1),szBlk(2),nAtoms);
for iAtom = 1:nAtoms
    atomicImagesRica(:,:,iAtom) = reshape(Phi_rica(:,iAtom),szBlk(1),szBlk(2));
end
%%
%[text] ### Show the atomic images
figure
montage(imresize(atomicImagesRica,8,"nearest")+.5,"BorderSize",[2 2],"Size",[ceil(nAtoms/8) 8])
title("Atomic images of RICA")
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
