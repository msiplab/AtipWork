%[text] # Sample 13-1: KLT (PCA)
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
%[text] - szBlk: block size \
szBlk = [ 8 8 ];
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
%[text] ## Karhunen-Loeve transform (principal component analysis)
%[text] ### Problem setting
%[text] $\\hat{\\boldsymbol{\\Phi}}=\\arg\\max\_{\\boldsymbol{\\Phi}\\in\\mathcal{U}(M)}\\mathrm{trace}\\left(\\boldsymbol{\\Phi}\_{:,0:K-1}^\\top\\hat{\\boldsymbol{\\Sigma}}\_{\\mathcal{X}}\\boldsymbol{\\Phi}\_{:,0:K-1}\\right),\\quad K\\in\\{1,2,\\ldots,M-1\\}$
%[text] where $\\hat{\\boldsymbol{\\Sigma}}\_{\\mathcal{X}}$ is the sample covariance matrix of the (centered) data $\\{\\mathbf{x}\_i\\}\_i$
%[text] $\\hat{\\boldsymbol{\\Sigma}}\_{\\mathcal{X}}=\\frac{1}{S}\\sum\_{i=1}^{S}\\mathbf{x}\_i\\mathbf{x}\_i^\\top$
%[text] (`cov` uses the factor $1/(S-1)$, which does not change the eigenvectors).
%[text] ### Solution
%[text] Eigendecomposition
%[text] $\\hat{\\boldsymbol{\\Phi}}^\\top\\hat{\\boldsymbol{\\Sigma}}\_{\\mathcal{X}}\\hat{\\boldsymbol{\\Phi}}=\\boldsymbol{\\Lambda}$
%[text] where $\\boldsymbol{\\Lambda}=\\mathrm{diag}(\\lambda\_0,\\lambda\_1,\\ldots,\\lambda\_{M-1})$ and $\\lambda\_0\\geq\\lambda\_1\\geq\\cdots\\geq\\lambda\_{M-1}$ are the eigenvalues of $\\hat{\\boldsymbol{\\Sigma}}\_{\\mathcal{X}}$.
%[text]
%[text] Calculation of the sample covariance matrix $\\hat{\\boldsymbol{\\Sigma}}\_{\\mathcal{X}}$
SigmaX = cov(X.');
%[text] Eigendecomposition of the sample covariance matrix $\\hat{\\boldsymbol{\\Sigma}}\_{\\mathcal{X}}$
[Phi_pca,Lambda] = eig(SigmaX);
%[text] Sorting the column vectors in the descending order of the eigenvalues $\\lambda\_m$
[~,idx] = sort(diag(Lambda),"descend");
Phi_pca = Phi_pca(:,idx);
%[text] Reshape the eigenvectors into basis images
nBases = prod(szBlk);
basisImagesPca = zeros(szBlk(1),szBlk(2),nBases);
for iBasis = 1:nBases
    basisImagesPca(:,:,iBasis) = reshape(Phi_pca(:,iBasis),szBlk(1),szBlk(2));
end
%%
%[text] ### Show the basis images
figure
montage(imresize(basisImagesPca,8,"nearest")+.5,"BorderSize",[2 2])
title("Basis images of KLT (PCA)")
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
