%[text] # Sample 13-3: k-SVD
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
%[text] - sparsityRatio: sparsity ratio $K/M$
%[text] - nItersKsvd: number of iterations (one iteration takes several seconds, i.e., about 1.5 hours for 1000 iterations; set, e.g., 10 for a quick check) \
% Block size
szBlk = [ 8 8 ];

% Redundancy ratio
redundancyRatio = 7/3;

% Sparsity ratio
sparsityRatio = 3/64;

% Number of iterations
nItersKsvd = 1e3;
%%
%[text] ## Read image
%[text] - $\\mathbf{x}\\in\\mathbb{R}^{N}$ \
xorg = im2gray(im2double(imread(fullfile(datfolder,"kodim23.png"))));
szOrg = size(xorg)
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
%[text] ## k-singular value decomposition (k-SVD)
%[text] ### Problem setting
%[text] $\\{\\hat{\\boldsymbol{\\Phi}},\\{\\hat{\\mathbf{y}}\_i\\}\_i\\}=\\arg\\min\_{\\{\\boldsymbol{\\Phi},\\{\\mathbf{y}\_i\\}\_i\\}}\\frac{1}{2S}\\sum\_{i=1}^{S}\\|\\mathbf{x}\_i-\\boldsymbol{\\Phi}\\mathbf{y}\_i\\|\_2^2,\\quad\\mathrm{s.t.}\\ \\|\\mathbf{y}\_i\\|\_0\\leq K,\\ \\forall i$
%[text] ### Algorithm
%[text] Repeat the sparse approximation step and the dictionary update step.
%[text] - Sparse approximation step \
%[text] $\\hat{\\mathbf{y}}\_i=\\arg\\min\_{\\mathbf{y}}\\frac{1}{2}\\|\\mathbf{x}\_i-\\hat{\\boldsymbol{\\Phi}}\\mathbf{y}\\|\_2^2\\quad\\mathrm{s.t.}\\ \\|\\mathbf{y}\\|\_0\\leq K$
%[text] - Dictionary update step \
%[text] $\\hat{\\boldsymbol{\\Phi}}=\\arg\\min\_{\\boldsymbol{\\Phi}}\\frac{1}{2S}\\sum\_{i=1}^{S}\\|\\mathbf{x}\_i-\\boldsymbol{\\Phi}\\hat{\\mathbf{y}}\_i\\|\_2^2=\\arg\\min\_{\\boldsymbol{\\Phi}}\\frac{1}{2S}\\left\\|\\left(\\mathbf{X}-\\sum\_{q\\neq p}\\boldsymbol{\\phi}\_q\\hat{\\mathbf{Y}}\_{q,:}\\right)-\\boldsymbol{\\phi}\_p\\hat{\\mathbf{Y}}\_{p,:}\\right\\|\_\\mathrm{F}^2$
%[text]
%[text] Number of coefficients
nDims = prod(szBlk);
nAtoms = ceil(redundancyRatio*nDims);
nCoefsKsvd = max(floor(sparsityRatio*nDims),1);
%%
%[text] Initialization of the dictionary $\\boldsymbol{\\Phi}$
%[text] - two-dimensional DCT
%[text] - random \
Phi_ksvd = randn(nDims,nAtoms);
Phi_ksvd = Phi_ksvd/norm(Phi_ksvd,'fro');
for iAtom = 1:nDims
    delta = zeros(szBlk);
    delta(iAtom) = 1;
    Phi_ksvd(:,iAtom) = reshape(idct2(delta),nDims,1);
end
%[text] Reshape the atoms into atomic images
atomicImagesKsvd = zeros(szBlk(1),szBlk(2),nAtoms);
for iAtom = 1:nAtoms
    atomicImagesKsvd(:,:,iAtom) = reshape(Phi_ksvd(:,iAtom),szBlk(1),szBlk(2));
end
figure
montage(imresize(atomicImagesKsvd,8,"nearest")+.5,"BorderSize",[2 2],"Size",[ceil(nAtoms/8) 8])
title("Atomic images of the initial dictionary (DCT & random)")
%%
%[text] ### Iteration of the sparse approximation step and the dictionary update step
%[text] - Sparse approximation: orthogonal matching pursuit (OMP)
%[text] - Dictionary update: SVD and rank-1 approximation \
%[text] Procedure of the dictionary update
%[text] 1. $p\\leftarrow 0$
%[text] 2. Define the error matrix $\\boldsymbol{\\mathcal{E}}\_p=\\mathbf{X}-\\sum\_{q\\neq p}\\boldsymbol{\\phi}\_q\\hat{\\mathbf{Y}}\_{q,:}$
%[text] 3. Define the selection matrix $\\mathbf{S}\_{\\mathcal{J}\_p}$ that extracts the non-zero entries of the row $\\hat{\\mathbf{Y}}\_{p,:}$: $\\hat{\\mathbf{Y}}\_{p,:}^\\mathrm{R}=\\hat{\\mathbf{Y}}\_{p,:}\\mathbf{S}\_{\\mathcal{J}\_p}^\\top$
%[text] 4. Reduce the error matrix: $\\boldsymbol{\\mathcal{E}}\_p^\\mathrm{R}=\\boldsymbol{\\mathcal{E}}\_p\\mathbf{S}\_{\\mathcal{J}\_p}^\\top$
%[text] 5. Singular value decomposition: $\\boldsymbol{\\mathcal{E}}\_p^\\mathrm{R}=\\mathbf{U}\\boldsymbol{\\Sigma}\\mathbf{V}^\\top=(\\mathbf{u}\_0\\ \\cdots\\ \\mathbf{u}\_{r-1})\\mathrm{diag}(\\sigma\_0,\\ldots,\\sigma\_{r-1})(\\mathbf{v}\_0\\ \\cdots\\ \\mathbf{v}\_{r-1})^\\top$
%[text] 6. Update the atom: $\\boldsymbol{\\phi}\_p\\leftarrow\\mathbf{u}\_0$
%[text] 7. Update the row: $\\hat{\\mathbf{Y}}\_{p,:}^\\mathrm{R}\\leftarrow\\sigma\_0\\mathbf{v}\_0^\\top$
%[text] 8. $p\\leftarrow p+1$
%[text] 9. If $p<P$ go to 2, otherwise finish. \
%[text] where $\\sigma\_0$ is the largest singular value.
%[text] ### Iterative calculation of the alternating steps
cost = zeros(1,nItersKsvd);
nSamples = size(X,2);
for iIter = 1:nItersKsvd
    Y = zeros(nAtoms,nSamples);
    % Sparse approximation
    for iSample = 1:nSamples
        Y(:,iSample) = omp(X(:,iSample),Phi_ksvd,nCoefsKsvd);
    end
    % Dictionary update
    for iAtom = 1:nAtoms
        idxset = setdiff(1:nAtoms,iAtom);
        yp = Y(iAtom,:);
        suppp = find(yp);
        %
        Epred = X(:,suppp)-Phi_ksvd(:,idxset)*Y(idxset,suppp);
        %
        if ~isempty(suppp)
            [U,S,V] = svd(Epred,'econ');
            Phi_ksvd(:,iAtom) = U(:,1);
            Y(iAtom,suppp) = S(1,1)*V(:,1)';
        end
    end
    cost(iIter) = (norm(X-Phi_ksvd*Y,'fro')^2)/(2*nSamples);
end
%[text] Graph of the cost
figure
plot(cost)
xlabel("Number of iterations")
ylabel("Cost")
grid on
%[text] Reshape the atoms into atomic images
atomicImagesKsvd = zeros(szBlk(1),szBlk(2),nAtoms);
for iAtom = 1:nAtoms
    atomicImagesKsvd(:,:,iAtom) = reshape(Phi_ksvd(:,iAtom),szBlk(1),szBlk(2));
end
figure
montage(imresize(atomicImagesKsvd,8,"nearest")+.5,"BorderSize",[2 2],"Size",[ceil(nAtoms/8) 8])
title("Atomic images of k-SVD")
%%
%[text] ## Function of orthogonal matching pursuit (OMP)
%[text] The matching process is computed for all candidate atoms at once.
function x = omp(y,Phi,nCoefs)
% Initialization
nAtoms = size(Phi,2);
x = zeros(nAtoms,1);
r = y;
supp = [];
k = 0;
while k < nCoefs
    % Matching process for the atoms not selected yet
    rest = setdiff(1:nAtoms,supp);
    D = Phi(:,rest);
    g = D.'*r;                       % gamma_m = <d_m,r>
    a = g./sum(D.^2,1).';            % alpha_m = gamma_m/||d_m||^2
    e = r.'*r - g.*a;                % ||r - alpha_m d_m||^2
    % Minimum value search (pursuit)
    [~,mmin] = min(e);
    % Update the support
    supp = union(supp,rest(mmin));
    x(supp) = pinv(Phi(:,supp)) * y;
    % Residual
    r = y - Phi*x;
    % Update
    k = k + 1;
end
end
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
