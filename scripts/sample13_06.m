%[text] # Sample 13-6: Comparison of dictionaries (sparse approximation)
%[text] Advanced Topics in Image Processing, Lecture 13 "Dictionary Learning"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Preparation
%[text] SaivDr (NSOLT layers `saivdr.dcnn.*`) is downloaded into the folder `code` of the project by `msip.saivdr_setup`.
%[text] - nsoltDic: name of a learned NSOLT dictionary (.mat).  It is searched in the results folder and then in the data folder.
%[text]   Set "" to train a new dictionary (it is saved in the results folder with a time stamp).
%[text] - isQuick: true for a quick check of the whole script with few iterations (RICA, k-SVD, NSOLT training and IHT).
%[text]   The default settings take a long time (in particular, k-SVD). \
[datfolder,resfolder] = atip.prjfolders();

nsoltDic = "nsoltdictionary_20230705164652136"; % Set "" to train a new dictionary.
isQuick = false;

isCodegen = false; % code generation %[control:checkbox:8096]{"position":[13,18]}
msip.saivdr_setup(isCodegen)
%%
%[text] ## Parameter settings
%[text] - szBlk: block size
%[text] - redundancyRatio: redundancy ratio
%[text] - sparsityRatio: sparsity ratio \
% Block size
szBlk = [ 8 8 ];

% Redundancy ratio for RICA/K-SVD
redundancyRatio = 7/3; 

% Sparsity ratio 
sparsityRatio = 3/64;
%%
%[text] ## Read image
%[text] - $\\mathbf{y}\\in\\mathbb{R}^{N}$ \
%[text] Note: in this sample, $\\mathbf{y}$ denotes the image (data) and $\\mathbf{x}$ the coefficients
%[text] (the reference text writes $\\mathbf{x}$ for the data and $\\mathbf{y}$ for the coefficients in Chapter 9).
%[text] The image is a crop of "barbara512.bmp" (Kanagawa Institute of Technology standard image database), downloaded once into the results folder.
% Preparation of the original image
file_yorg = fullfile(resfolder,"sample13_06_yorg.png");
if ~isfile(file_yorg)
    tmpfolder = fullfile(resfolder,"tmp");
    unzip("http://www.ess.ic.kanagawa-it.ac.jp/std_img/monoimage2/Mono-Image2.zip",tmpfolder)
    yfull = imread(fullfile(tmpfolder,"Mono-Image2","512X512","barbara512.bmp"));
    ycrop = yfull(1:192,end-255:end);
    imwrite(ycrop,file_yorg)
end

% Read the original image
yorg = im2double(imread(file_yorg));
szOrg = size(yorg);
%[text] Show the image
figure
imshow(yorg);
title('Original image y')
%[text] Centering
%ymean = mean(y,"all");
%y = yorg - ymean;
meansubtract = @(x) x-mean(x,"all");
y = meansubtract(yorg);
%%
%[text] ## Discrete cosine transform (DCT)
%[text]  $\[\\mathbf{C}\_M\]\_{k,n}=\\sqrt{\\frac{2}{M}} \\alpha\_k\\cos\\frac{k(n+1/2)\\pi}{M},\\ k,n=0,1,\\cdots,M-1$
%[text]  $\\alpha\_k=\\left\\{\\begin{array}{ll} \\frac{1}{\\sqrt{2}} & k=0 \\\\1 & k=1,2,\\cdots,M-1\\end{array}\\right.$
%[text] #### Basis images
%[text]  $\\mathbf{B}\_{k,\\ell}=\\mathbf{C}\_M^{-1}\\mathbf{E}\_{k,\\ell}\\mathbf{C}\_M^{-T},\\ k,\\ell=0,1,\\cdots,M-1$
%[text]  $\\mathbf{E}\_{k,\\ell}= \\mathbf{e}\_k\\mathbf{e}\_\\ell^T$
basisImagesDct = zeros(szBlk(1),szBlk(2),prod(szBlk));
iBasis = 1;
for iRow=1:szBlk(1)
    for iCol=1:szBlk(2)
        E = zeros(szBlk);
        E(iRow,iCol) = 1;
        basisImagesDct(:,:,iBasis) = idct2(E,szBlk(1),szBlk(2));
        iBasis = iBasis + 1;
    end
end
%[text] #### Show the basis images
figure
montage(imresize(basisImagesDct,8,'nearest')+.5,'BorderSize',[2 2])
title('Basis images of DCT')
%[text] #### Synthesis process by the block DCT and its adjoint
syn_blkdct = @(x) blockproc(x,szBlk,@(block_struct) idct2(block_struct.data));
adj_blkdct = @(y) blockproc(y,szBlk,@(block_struct) dct2(block_struct.data));
%[text] Check of the adjoint relation
x = adj_blkdct(y);
v = randn(size(x));
u = syn_blkdct(v);
assert(abs(dot(y(:),u(:))-dot(x(:),v(:)))<1e-9)
%%
%[text] ## Principal component analysis (PCA)
%[text] 
%[text] #### Problem setting
%[text] The least squares problem with the orthonormality and the dimension reduction
%[text]  $\\mathbf{\\Phi}^\\textsf{T} \\mathbf{\\Phi}=\\mathbf{I}\_{M}, \\forall b, \\forall p,\\Vert{\\mathbf{x}\_b}\\Vert\_0\\le p\<M$
%[text] as the constraints
%[text]  $\\{\\hat{\\mathbf{\\Phi}},\\{ \\hat{\\mathbf{x}}\_b \\}\_b\\}=\\arg\\min\_{\\{\\mathbf{\\Phi},\\{\\mathbf{x}\_b\\}\_b\\}}\\frac{1}{2S}\\sum\_{b=1}^{S}\\|\\mathbf{y}\_b-\\mathbf{\\Phi}{\\mathbf{x}}\_b\\|\_2^2$
%[text] is solved.  It is equivalently expressed as
%[text]  $\\hat{\\mathbf{\\Phi}}=\\arg \\max \_{\\mathbf{\\Phi}} \\mathrm{tr}\\left(\\mathbf{\\Phi}\_{:, 0:p-1}^\\textsf{T}\\hat{\\mathbf{\\Sigma}}\_{y} \\mathbf{\\Phi}\_{:,0:p-1}\\right)\\ \\mathrm{ s.t. }\\ \\mathbf{\\Phi}^\\textsf{T} \\mathbf{\\Phi}=\\mathbf{I}\_{M}$
%[text] where $\\widehat{\\mathbf{\\Sigma}}\_{y}$ is the sample covariance matrix of the observation vectors $\\{\\mathbf{y}\_b\\}\_b$ (assumed to be zero mean).
%[text] 
%[text] #### Solution
%[text] Eigendecomposition
%[text]  $\\widehat{\\mathbf{\\Phi}}^\\textsf{T}\\widehat{\\mathbf{\\Sigma}\_y}\\widehat{\\mathbf{\\Phi}}=\\mathbf{\\Lambda}\n$
%[text] where $\\mathbf{\\Lambda}=\\mathrm{diag}(\\lambda\_1,\\lambda\_2,\\cdots,\\lambda\_M)$, and $\\lambda\_1\\geq\\lambda\_2\\geq\\cdots\\lambda\_M$ are the eigenvalues of $\\widehat{\\mathbf{\\Sigma}}\_{y}$.
%[text] 
%[text] #### Generation of the data matrix $\\mathbf{Y}$ from the image $\\mathbf{y}$
%[text] Instead of subtracting the sample mean block, the image is centered beforehand.
nPatches = 20*prod(szOrg./szBlk); % random patches for the training of PCA/RICA/k-SVD
npos = randsample(prod(szOrg-szBlk),nPatches);
ybs = zeros(szBlk(1),szBlk(2),nPatches,'like',y);
szSrchy = szOrg(1)-szBlk(1);
for iPatch = 1:nPatches
    ny_ = mod(npos(iPatch)-1,szSrchy)+1;
    nx_ = floor((npos(iPatch)-1)/szSrchy)+1;
    ybs(:,:,iPatch) = y(ny_:ny_+szBlk(1)-1,nx_:nx_+szBlk(2)-1);
end
figure
montage(ybs+0.5,'Size',[8 8]);
drawnow

Y = reshape(ybs,prod(szBlk),[]);

%[text] Calculation of the sample covariance matrix $\\widehat{\\mathbf{\\Sigma}}\_{y}$
SigmaY = cov(Y.');
%[text] Eigendecomposition of the sample covariance matrix $\\widehat{\\mathbf{\\Sigma}}\_{y}$
[Phi_pca,Lambda] = eig(SigmaY);
%[text] Sorting the column vectors in the descending order of the eigenvalues $\\lambda$
[~,idx] = sort(diag(Lambda),'descend');
Phi_pca = Phi_pca(:,idx);
%[text] Reshape the eigenvectors into basis images
nBases = prod(szBlk);
basisImagesPca = zeros(szBlk(1),szBlk(2),nBases);
for iBasis = 1:nBases
    basisImagesPca(:,:,iBasis) = reshape(Phi_pca(:,iBasis),szBlk(1),szBlk(2));
end
%[text] #### Show the basis images (dictionary)
figure
montage(imresize(basisImagesPca,8,'nearest')+.5,'BorderSize',[2 2])
title('Basis images of PCA(KLT)')
%[text] #### Synthesis process by the block PCA and its adjoint
syn_blkpca = @(x) col2im(Phi_pca*x,szBlk,szOrg,"distinct");
adj_blkpca = @(y) Phi_pca.'*im2col(y,szBlk,"distinct");
%[text] Check of the adjoint relation
x = adj_blkpca(y);
v = randn(size(x));
u = syn_blkpca(v);
assert(abs(dot(y(:),u(:))-dot(x(:),v(:)))<1e-9)
%%
%[text] ## Reconstruction independent component analysis (RICA)
%[text] 
%[text] #### Problem setting
%[text]  $\\widehat{\\mathbf{\\Phi}}=\\arg \\min \_{\\mathbf{\\Phi}} \\frac{1}{2S}\\sum\_{b=1}^S\\|\\mathbf{y}\_b-\\mathbf{\\Phi}\\mathbf{\\Phi}^\\textsf{T}\\mathbf{y}\_b\\|\_2^2+\\frac{\\alpha}{S}\\sum\_{b=1}^{S}\\rho(\\mathbf{\\Phi}^\\textsf{T}\\mathbf{y}\_b)\n$
%[text]  $=\\arg \\min \_{\\mathbf{\\Phi}} \\frac{(2\\alpha)^{-1}}{S}\\sum\_{b=1}^S\\|\\mathbf{y}\_b-\\mathbf{\\Phi}\\mathbf{\\Phi}^\\textsf{T}\\mathbf{y}\_b\\|\_2^2+\\frac{1}{S}\\sum\_{b=1}^{S}\\rho(\\mathbf{\\Phi}^\\textsf{T}\\mathbf{y}\_b)$
%[text] where $\\{\\mathbf{y}\_n\\}\_n\\subset\\mathbb{R}^{M}$,  $\\mathbf{\\Phi}=(\\mathbf{\\phi}\_1,\\mathbf{\\phi}\_2,\\cdots,\\mathbf{\\phi}\_P)\\in\\mathbb{R}^{M\\times P}$, $M\\leq P$ (redundant).
%[text] 
%[text] #### Reference
%[text] Le, Quoc V., Alexandre Karpenko, Jiquan Ngiam, and Andrew Y. Ng. "ICA with Reconstruction Cost for Efficient Overcomplete Feature Learning." Advances in Neural Information Processing Systems. Vol. 24, 2011, pp. 1017-1025. https://papers.nips.cc/paper/4467-ica-with-reconstruction-cost-for-efficient-overcomplete-feature-learning.pdf. 
%[text] 
%[text] Parameter settings
%[text] - nItersRica: maximum number of iterations
%[text] - alpha: regularization parameter \
% Number of iterations
nItersRica = 1e5; 
if isQuick, nItersRica = 1e3; end
% Regularization parameter
alpha = 2e-3;
%[text] Example of the contrast function
%[text]  $\\rho(\\mathbf{\\Phi}^\\textsf{T}\\mathbf{y})\\colon = \\frac{1}{2}\\sum\_{p=1}^{P}\\log\\circ\\cosh(2\\mathbf{\\phi}\_p^\\textsf{T}\\mathbf{y})$
figure
fplot(@(x) abs(x),[-5 5],':','LineWidth',2,'DisplayName','|\cdot|')
hold on
fplot(@(x) log(cosh(2*x))/2,[-5 5],'-','LineWidth',2,'DisplayName','1/2log(cosh(2\cdot))')
xlabel('x')
legend
grid on
axis equal
hold off
%[text] Number of atomic images
nDims = prod(szBlk);
nAtoms = ceil(redundancyRatio*nDims);
%[text] Initialization of the dictionary $\\mathbf{\\Phi}$
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
montage(imresize(atomicImagesRica,8,'nearest')+.5,'BorderSize',[2 2],'Size',[ceil(nAtoms/8) 8])
title('Atomic images of initial dictionary (DCT & random)')
%[text] #### Creation of the reconstruction ICA object
%[text] Training with the centered data as for PCA
model = rica(Y.',nAtoms,...
    'IterationLimit',nItersRica,...
    'ContrastFcn','logcosh',...
    'InitialTransformWeight',Phi_rica,...
    'Lambda',1/(2*alpha));
%[text] Graph of the cost
info = model.FitInfo;
figure
plot(info.Iteration,info.Objective)
xlabel('Number of iteration')
ylabel('Cost')
grid on
%[text] Reshape the atoms into atomic images
Phi_rica = model.TransformWeights;
atomicImagesRica = zeros(szBlk(1),szBlk(2),nAtoms);
for iAtom = 1:nAtoms
    atomicImagesRica(:,:,iAtom) = reshape(Phi_rica(:,iAtom),szBlk(1),szBlk(2));
end
%[text] #### Show the atomic images (dictionary)
figure
montage(imresize(atomicImagesRica,8,'nearest')+.5,'BorderSize',[2 2],'Size',[ceil(nAtoms/8) 8])
title('Atomic images of RICA')
%[text] #### Synthesis process by the block RICA and its adjoint
syn_blkrica = @(x) col2im(Phi_rica*x,szBlk,szOrg,"distinct");
adj_blkrica = @(y) Phi_rica.'*im2col(y,szBlk,"distinct");
%[text] Check of the adjoint relation
x = adj_blkrica(y);
v = randn(size(x));
u = syn_blkrica(v);
assert(abs(dot(y(:),u(:))-dot(x(:),v(:)))<1e-9)
%%
%[text] ## k-singular value decomposition (k-SVD)
%[text] Parameter settings
%[text] - nItersKsvd: number of iterations \
% Number of iterations
nItersKsvd = 5e3;
if isQuick, nItersKsvd = 2; end
%[text] #### Problem setting
%[text]  $\\{\\hat{\\mathbf{\\Phi}},\\{ \\hat{\\mathbf{x}}\_b \\}\\}=\\arg\\min\_{\\{\\mathbf{\\Phi},\\{\\mathbf{x}\_b\\}\\}}\\frac{1}{2S}\\sum\_{b=1}^{S}\\|\\mathbf{y}\_b-\\mathbf{\\Phi}\\hat{\\mathbf{x}}\_b\\|\_2^2,\\ \\quad\\mathrm{s.t.}\\ \\forall b, \\|\\mathbf{x}\_b\\|\_0\\leq K$
%[text] #### Algorithm
%[text] Repeat the sparse approximation step and the dictionary update step.
%[text] - Sparse approximation step \
%[text]  $\\hat{\\mathbf{x}}\_b=\\arg\\min\_{\\mathbf{x}} \\frac{1}{2}\\|\\mathbf{y}\_b-\\hat{\\mathbf{\\Phi}}\\mathbf{x}\\|\_2^2\\ \\quad \\mathrm{s.t.}\\ \\|\\mathbf{x}\\|\_0\\leq K$
%[text] - Dictionary update step \
%[text]  $\\hat{\\mathbf{\\Phi}}=\\arg\\min\_{\\mathbf{\\Phi}}\\frac{1}{2S}\\sum\_{b=1}^{S}\\|\\mathbf{y}\_b-\\mathbf{\\Phi}\\hat{\\mathbf{x}}\_b\\|\_2^2=\\arg\\min\_{\\mathbf{\\Phi}}\\frac{1}{2S}\\left\\|\\left(\\mathbf{Y}-\\sum\_{p\\neq k}\\mathbf{\\phi}\_p\\hat{\\mathbf{X}}\_{p,\\colon}\\right)-\\mathbf{\\phi}\_k\\hat{\\mathbf{X}}\_{k,\\colon}\\right\\|\_F^2$
%[text] 
%[text] Number of coefficients
nCoefsKsvd = max(floor(sparsityRatio*nDims),1);
%[text] Initialization of the dictionary $\\mathbf{\\Phi}$
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
montage(imresize(atomicImagesKsvd,8,'nearest')+.5,'BorderSize',[2 2],'Size',[ceil(nAtoms/8) 8])
title('Atomic images of initial dictionary (DCT & random)')
%[text] #### Iteration of the sparse approximation step and the dictionary update step
%[text] - Sparse approximation: orthogonal matching pursuit (OMP)
%[text] - Dictionary update: singular value decomposition (SVD) and rank-1 approximation \
%[text] Procedure of the dictionary update
%[text] 1. $k\\leftarrow 1$
%[text] 2. Define the error matrix $\\mathbf{E}\_k\\colon = \\mathbf{Y}-\\sum\_{p\\neq k}\\mathbf{\\phi}\_p\\hat{\\mathbf{X}}\_{p,\\colon}$
%[text] 3. Define the matrix $\\mathbf{\\Omega}\_k$ that extracts the non-zero entries of the row $\\hat{\\mathbf{X}}\_{k,\\colon}$: $\\hat{\\mathbf{X}}\_{k,\\colon}^R=\\hat{\\mathbf{X}}\_{k,\\colon}\\mathbf{\\Omega}\_k$
%[text] 4. Reduce the error matrix $\\mathbf{E}\_k$ by the matrix $\\mathbf{\\Omega}\_k$: $\\mathbf{E}\_k^R \\colon=\\mathbf{E}\_k\\mathbf{\\Omega}\_k$
%[text] 5. Singular value decomposition of the reduced error matrix: $\\mathbf{E}\_k^R =\\mathbf{U}\\mathbf{S}\\mathbf{V}^\\top=\\left(\\mathbf{u}\_1,\\mathbf{u}\_2,\\cdots,\\mathbf{u}\_r\\right)\\mathrm{diag}(\\sigma\_1,\\sigma\_2,\\cdots,\\sigma\_r)\\left(\\mathbf{v}\_1,\\mathbf{v}\_2,\\cdots,\\mathbf{v}\_r\\right)^\\top$
%[text] 6. Update the atom $\\mathbf{\\phi}\_k$: $\\mathbf{\\phi}\_k\\leftarrow \\mathbf{u}\_1$
%[text] 7. Update the row $\\hat{\\mathbf{X}}\_{k,\\colon}^R$: $\\hat{\\mathbf{X}}\_{k,\\colon}^R\\leftarrow \\sigma\_1\\mathbf{v}\_{1}^\\top$
%[text] 8. $k\\leftarrow k+1$
%[text] 9. If $k\\leq P$ go to 2, otherwise finish. \
%[text] where $\\sigma\_1$ is the largest singular value.
%[text] #### Iterative calculation of the alternating steps
%[text] Training with the centered data as for PCA
cost = zeros(1,nItersKsvd);
nSamples = size(Y,2);
for iIter = 1:nItersKsvd
    X = zeros(nAtoms,nSamples);
    % Sparse approximation
    for iSample = 1:nSamples
        y_ = Y(:,iSample);
        x = omp(y_,Phi_ksvd,nCoefsKsvd);
        X(:,iSample) = x;
    end
    % Dictionary update
    for iAtom = 1:nAtoms
        idxset = setdiff(1:nAtoms,iAtom);
        xk = X(iAtom,:);
        suppk = find(xk);
        %
        Ekred = Y(:,suppk)-Phi_ksvd(:,idxset)*X(idxset,suppk);
        %
        if ~isempty(suppk)
            [U,S,V] = svd(Ekred,'econ');
            ak = U(:,1);
            xkred = S(1,1)*V(:,1)';
            %
            Phi_ksvd(:,iAtom) = ak;
            X(iAtom,suppk) = xkred;
        end
    end
    cost(iIter) = (norm(Y-Phi_ksvd*X,'fro')^2)/(2*nSamples);
end
%[text] Graph of the cost
figure
plot(cost)
xlabel('Number of iteration')
ylabel('Cost')
grid on
%[text] Reshape the atoms into atomic images
atomicImagesKsvd = zeros(szBlk(1),szBlk(2),nAtoms);
for iAtom = 1:nAtoms
    atomicImagesKsvd(:,:,iAtom) = reshape(Phi_ksvd(:,iAtom),szBlk(1),szBlk(2));
end
figure
montage(imresize(atomicImagesKsvd,8,'nearest')+.5,'BorderSize',[2 2],'Size',[ceil(nAtoms/8) 8])
title('Atomic images of K-SVD')
%[text] #### Synthesis process by the block k-SVD and its adjoint
syn_blkksvd = @(x) col2im(Phi_ksvd*x,szBlk,szOrg,"distinct");
adj_blkksvd = @(y) Phi_ksvd.'*im2col(y,szBlk,"distinct");
%[text] Check of the adjoint relation
x = adj_blkksvd(y);
v = randn(size(x));
u = syn_blkksvd(v);
assert(abs(dot(y(:),u(:))-dot(x(:),v(:)))<1e-9)
%%
%[text] ## Bivariate lattice-structure oversampled filter banks
%[text] As an example, let us adopt a type-I non-separable oversampled lapped transform (NSOLT) with an even number of channels (the numbers of even- and odd-symmetric channels are identical) and even polyphase orders:
%[text]  $\\mathbf{E}(z\_\\mathrm{v},z\_\\mathrm{h})\n=\n\\left(\\prod\_{n\_\\mathrm{h}=1}^{\\nu\_\\mathrm{h}/2}\n{\\mathbf{V}\_{2n\_\\mathrm{h}}^{\\{\\mathrm{h}\\}}}\\bar{\\mathbf{Q}}(z\_\\mathrm{h}){\\mathbf{V}\_{2k\_\\mathrm{h}-1}^{\\{\\mathrm{h}\\}}}{\\mathbf{Q}}(z\_\\mathrm{h})\\right)\n%\n\\left(\\prod\_{n\_{\\mathrm{v}}=1}^{\\nu\_\\mathrm{v}/2}{\\mathbf{V}\_{2n\_\\mathrm{v}}^{\\{\\mathrm{v}\\}}}\\bar{\\mathbf{Q}}(z\_\\mathrm{v}){\\mathbf{V}\_{2n\_\\mathrm{v}-1}^{\\{\\mathrm{v}\\}}}{\\mathbf{Q}}(z\_\\mathrm{v})\\right)\n%\n\\mathbf{V}\_0\\mathbf{E}\_0,$
%[text]  $\\mathbf{R}(z\_\\mathrm{v},z\_\\mathrm{h})\n=\\mathbf{E}^\\textsf{T}(z\_\\mathrm{v}^{-1},z\_\\mathrm{h}^{-1}),$
%[text] where
%[text] - $\\mathbf{E}(z\_\\mathrm{v},z\_\\mathrm{h})$: type-I polyphase matrix of the analysis filter bank
%[text] - $\\mathbf{R}(z\_\\mathrm{v},z\_\\mathrm{h})$: type-II polyphase matrix of the synthesis filter bank
%[text] - $z\_d\\in\\mathbb{C}, d\\in\\{\\mathrm{v},\\mathrm{h}\\}$: variable of the Z-transform
%[text] - $\\nu\_d\\in \\mathbb{N}, d\\in\\{\\mathrm{v},\\mathrm{h}\\}$: polyphase order in direction $d$ (number of overlapping blocks)
%[text] - $\\mathbf{V}\_0=\\left(\\begin{array}{cc}\\mathbf{W}\_{0} & \\mathbf{O} \\\\\\mathbf{O} & \\mathbf{U}\_0\\end{array}\\right)\n%\n\\left(\\begin{array}{c}\\mathbf{I}\_{M/2} \\\\ \n\\mathbf{O} \\\\\n\\mathbf{I}\_{M/2} \\\\\n\\mathbf{O}\n\\end{array}\\right)\\in\\mathbb{R}^{P\\times M}$,$\\mathbf{V}\_n^{\\{d\\}}=\\left(\\begin{array}{cc}\\mathbf{I}\_{P/2} & \\mathbf{O} \\\\\\mathbf{O} & \\mathbf{U}\_n^{\\{d\\}}\\end{array}\\right)\\in\\mathbb{R}^{P\\times P}, d\\in\\{\\mathrm{v},\\mathrm{h}\\}$, where $\\mathbf{W}\_0, \\mathbf{U}\_0,\\mathbf{U}\_n^{\\{d\\}}\\in\\mathbb{R}^{P/2\\times P/2}$ are orthonormal matrices.
%[text] - $\\mathbf{Q}(z)=\\mathbf{B}\_{P}\\left(\\begin{array}{cc} \\mathbf{I}\_{P/2} &  \\mathbf{O} \\\\ \\mathbf{O} &  z^{-1}\\mathbf{I}\_{P/2}\\end{array}\\right)\\mathbf{B}\_{P}$, $\\bar{\\mathbf{Q}}(z)=\\mathbf{B}\_{P}\\left(\\begin{array}{cc} z\\mathbf{I}\_{P/2} &  \\mathbf{O} \\\\ \\mathbf{O} &  \\mathbf{I}\_{P/2}\\end{array}\\right)\\mathbf{B}\_{P}$, $\\mathbf{B}\_{P}=\\frac{1}{\\sqrt{2}}\\left(\\begin{array}{cc} \\mathbf{I}\_{P/2} &  \\mathbf{I}\_{P/2} \\\\ \\mathbf{I}\_{P/2} &  -\\mathbf{I}\_{P/2}\\end{array}\\right)$ \
%[text] References
%[text] - [Overview of Filter Banks - MATLAB & Simulink - MathWorks](https://www.mathworks.com/help/dsp/ug/overview-of-filter-banks.html)
%[text] - MATLAB SaivDr Package: [https://github.com/msiplab/SaivDr](https://github.com/msiplab/SaivDr)
%[text] - S. Muramatsu, K. Furuya and N. Yuki, "Multidimensional Nonseparable Oversampled Lapped Transforms: Theory and Design," in IEEE Transactions on Signal Processing, vol. 65, no. 5, pp. 1251-1264, 1 March1, 2017, doi: 10.1109/TSP.2016.2633240.
%[text] - S. Muramatsu, T. Kobayashi, M. Hiki and H. Kikuchi, "Boundary Operation of 2-D Nonseparable Linear-Phase Paraunitary Filter Banks," in IEEE Transactions on Image Processing, vol. 21, no. 4, pp. 2314-2318, April 2012, doi: 10.1109/TIP.2011.2181527.
%[text] - S. Muramatsu, M. Ishii and Z. Chen, "Efficient parameter optimization for example-based design of nonseparable oversampled lapped transform," 2016 IEEE International Conference on Image Processing (ICIP), Phoenix, AZ, 2016, pp. 3618-3622, doi: 10.1109/ICIP.2016.7533034.
%[text] - Furuya, K., Hara, S., Seino, K., & Muramatsu, S. (2016). Boundary operation of 2D non-separable oversampled lapped transforms. *APSIPA Transactions on Signal and Information Processing, 5*, E9. doi:10.1017/ATSIP.2016.3. \
%[text] ### Hierarchical decomposition of a two-dimensional image
%[text] Let $R\_M^P(\\tau)$ be the redundancy of the $\\tau$-level tree-structured filter bank; then
%[text]  $R\_M^P(\\tau)=\\left\\{\\begin{array}{ll} (P-1)\\tau + 1, & M=1, \\\\ \\frac{P-1}{M-1}-\\frac{P-M}{(M-1)M^\\tau}, & M\\geq 2.\\end{array}\\right.$
%[text] #### 
%[text] #### Configuration parameters
%%{
% Decimation factor (Strides)
decFactor = [2 2]; % [Mv Mh] 

% Number of channels ( sum(nChannels) >= prod(decFactors) )
nChannels = [4 4]; % [Ps Pa] (Ps=Pa)

% Number of tree levels
nLevels = 4; 

% Polyphase Order
ppOrder = [4 4]; 
%%}

%{
% Decimation factor (Strides)
decFactor =  [4 4]; % [Mv Mh] 

% Number of channels ( sum(nChannels) >= prod(decFactors) )
nChannels = [13 13]; % [Ps Pa] (Ps=Pa)

% Number of tree levels
nLevels = 2; 

% Polyphase Order
ppOrder = [2 2];
%}

%{
% Decimation factor (Strides)
decFactor =  [8 8]; % [Mv Mh] 

% Number of channels ( sum(nChannels) >= prod(decFactors) )
nChannels = [53 53]; % [Ps Pa] (Ps=Pa)

% Number of tree levels
nLevels = 1; 

% Polyphase Order
ppOrder = [2 2];
%}

% Redundancy
P = sum(nChannels);
M = prod(decFactor);
redundancyNsolt = ...
    (prod(decFactor)==1)*((P-1)*nLevels+1) + ...
    (prod(decFactor)>1)*((P-1)/(M-1)-(P-M)/((M-1)*M^nLevels))
assert(redundancyNsolt<redundancyRatio)

%[text] $L\_\\mathrm{v}\\times L\_\\mathrm{h}=\\left(\\mu\_\\mathrm{v}^{\\tau}+{\\nu}\_\\mathrm{v}\\frac{\\mu\_\\mathrm{v}(\\mu\_\\mathrm{v}^{\\tau}-1)}{\\mu\_\\mathrm{v}-1}\\right) \\times\\left(\\mu\_\\mathrm{h}^{\\tau}+\\nu\_\\mathrm{h}\\frac{\\mu\_\\mathrm{h}(\\mu\_\\mathrm{h}^{\\tau}-1)}{\\mu\_\\mathrm{h}-1}\\right)$ 
% Filter size [ Ly Lx ]
maxDecFactor = decFactor.^nLevels;
szFilters = maxDecFactor + ppOrder.*decFactor.*(maxDecFactor-1)./(decFactor-1)

% Patch size for training
szPatchTrn = maxDecFactor.*ceil(szFilters./maxDecFactor) % > [ Ly Lx ]
%szPatchTrn = 2.^nextpow2(szFilters) % > [ Ly Lx ]
assert(all(szPatchTrn>szFilters))

% Number of patchs per image
nSubImgs = floor(nPatches*prod(szBlk./szPatchTrn))
assert(nSubImgs > 0)

% No DC-leakage
noDcLeakage = true %[control:checkbox:7783]{"position":[15,19]}
%%
%[text] #### Setting of the dictionary
dicfiles = [fullfile(resfolder,nsoltDic+".mat") fullfile(datfolder,nsoltDic+".mat")];
idxDic = find(strlength(nsoltDic) > 0 & isfile(dicfiles),1);
if ~isempty(idxDic)
    S = load(dicfiles(idxDic));
    analysisnet = S.analysisnet;
    synthesisnet = S.synthesisnet;
    nLevels_ = extractnumlevels(analysisnet);
    decFactor_ = extractdecfactor(analysisnet);
    nChannels_ = extractnumchannels(analysisnet);

    assert(nLevels==nLevels_)
    assert(all(decFactor==decFactor_))
    assert(all(nChannels==nChannels_))
else
    % Number of iterations
    nItersNsolt = 10;
    if isQuick, nItersNsolt = 1; end

    % Standard deviation of initial angles
    stdInitAng = 1e-1; %pi/6;

    % Mini batch size
    miniBatchSize = 10;

    % Number of Epochs (1 Epoch = nSubImgs/miniBachSize iterlations)
    maxEpochs = 30;
    if isQuick, maxEpochs = 1; end

    % Number of iterations
    maxIters = nSubImgs/miniBatchSize * maxEpochs

    % Training options for trainnet
    opts = trainingOptions("sgdm", ... % stochastic gradient descent with momentum
        InitialLearnRate=5.0e-03, ...
        L2Regularization=0.0, ...
        MaxEpochs=maxEpochs, ...
        MiniBatchSize=miniBatchSize, ...
        Verbose=true, ...
        Plots="none");
%[text] #### Construction of the layers
    import saivdr.dcnn.*
    analysislgraph = fcn_creatensoltlgraph2d([],...
        'InputSize',szPatchTrn,...
        'NumberOfChannels',nChannels,...
        'DecimationFactor',decFactor,...
        'PolyPhaseOrder',ppOrder,...
        'NumberOfLevels',nLevels,...
        'NumberOfVanishingMoments',noDcLeakage,...
        'Mode','Analyzer');
    synthesislgraph = fcn_creatensoltlgraph2d([],...
        'InputSize',szPatchTrn,...
        'NumberOfChannels',nChannels,...
        'DecimationFactor',decFactor,...
        'PolyPhaseOrder',ppOrder,...
        'NumberOfLevels',nLevels,...
        'NumberOfVanishingMoments',noDcLeakage,...
        'Mode','Synthesizer');

    figure
    subplot(1,2,1)
    plot(analysislgraph)
    title('Analysis NSOLT')
    subplot(1,2,2)
    plot(synthesislgraph)
    title('Synthesis NSOLT')

    % Construction of deep learning network.
    synthesisnet = dlnetwork(synthesislgraph);

    % Initialize
    nLearnables = height(synthesisnet.Learnables);
    for iLearnable = 1:nLearnables
        if synthesisnet.Learnables.Parameter(iLearnable)=="Angles"
            synthesisnet.Learnables.Value(iLearnable) = ...
                cellfun(@(x) x+stdInitAng*randn(size(x)), ...
                synthesisnet.Learnables.Value(iLearnable),'UniformOutput',false);
        end
    end

    % Copy the synthesizer's parameters to the analyzer
    analysisnet = dlnetwork(fcn_cpparamssyn2ana(analysislgraph,synthesisnet));
%[text] #### Confirmation of the adjoint relation (perfect reconstruction)
%[text] NSOLT satisfies the Parseval tight property.
    nOutputs = nLevels+1;
    x = rand(szPatchTrn,'single');
    s = cell(1,nOutputs);
    dlx = dlarray(x,'SSCB'); % Deep learning array (SSCB: Spatial,Spatial,Channel,Batch)
    [s{1:nOutputs}] = analysisnet.predict(dlx);
    dly = synthesisnet.predict(s{:});
    display("MSE: " + num2str(mse(dlx,dly)))
%[text] #### Initial state of the atomic images
    import saivdr.dcnn.*
    figure
    atomicimshow(synthesisnet,[],2^(nLevels-1))
    title('Atomic images of initial NSOLT')
%[text] ### Preparation of the training images
%[text] Patches are randomly extracted from the image datastore.
%[text] Training with the centered data as for PCA
    imds = imageDatastore(file_yorg,"ReadFcn",@(x) meansubtract(im2single(imread(x))));
    patchds = randomPatchExtractionDatastore(imds,imds,szPatchTrn,'PatchesPerImage',nSubImgs);
    minibatch = preview(patchds);
    responses = minibatch.ResponseImage;
    responses = cellfun(@(x) x + 0.5,responses,'UniformOutput',false);
    figure
    montage(responses,'Size',[2 4]);
    drawnow
%[text] ### Convolutional dictionary learning
%[text] #### Problem setting
%[text]  $\\{\\hat{\\mathbf{\\theta}},\\{ \\hat{\\mathbf{x}}\_n \\}\\}=\\arg\\min\_{\\{\\mathbf{\\theta},\\{\\mathbf{x}\_n\\}\\}}\\frac{1}{2S}\\sum\_{n=1}^{S}\\|\\mathbf{y}\_n-\\mathbf{D}\_{\\mathbf{\\theta}}\\hat{\\mathbf{x}}\_n\\|\_2^2,\\ \\quad\\mathrm{s.t.}\\ \\forall n, \\|\\mathbf{x}\_n\\|\_0\\leq K,$
%[text] where $\\mathbf{D}\_{\\mathbf{\\theta}}$ is a convolutional dictionary with the design parameter vector $\\mathbf{\\theta}$.
%[text] 
%[text] #### Algorithm
%[text] Repeat the sparse approximation step and the dictionary update step.
%[text] - Sparse approximation step \
%[text]  $\\hat{\\mathbf{x}}\_n=\\arg\\min\_{\\mathbf{x}\_n}\\frac{1}{2} \\|\\mathbf{y}\_n-\\hat{\\mathbf{D}}\\mathbf{x}\_n\\|\_2^2\\ \\quad \\mathrm{s.t.}\\ \\|\\mathbf{x}\_n\\|\_0\\leq K$
%[text] - Dictionary update step \
%[text]  $\\hat{\\mathbf{\\theta}}=\\arg\\min\_{\\mathbf{\\theta}}\\frac{1}{2S}\\sum\_{n=1}^{S}\\|\\mathbf{y}\_n-\\mathbf{D}\_{\\mathbf{\\theta}}\\hat{\\mathbf{x}}\_n\\|\_2^2$
%[text]  $\\hat{\\mathbf{D}}=\\mathbf{D}\_{\\hat{\\mathbf{\\theta}}$
%[text] #### Methods adopted
%[text] - Sparse approximation: iterative hard thresholding (IHT) without normalization
%[text] - Dictionary update: stochastic gradient descent with momentum (SGDM) by `trainnet` \
    % Check if IHT works for dlarray
    %x = dlarray(randn(szPatchTrn,'single'),'SSCB');
    %[y,coefs{1:nOutputs}] = iht(x,analysisnet,synthesisnet,sparsityRatio);
%[text] #### Iterative calculation of the dictionary learning
    for iIter = 1:nItersNsolt

        % Sparse approximation (applied to produce a TransformedDatastore)
        coefimgds = transform(patchds, @(x) iht4patchds(x,analysisnet,synthesisnet,sparsityRatio));

        % Synthesis dictionary update (mean squared error between the synthesized and original patches)
        synthesisnet = trainnet(coefimgds,synthesisnet,"mse",opts);

        % Analysis dictionary update (copy the parameters from the synthesizer to the analyzer)
        analysisnet = dlnetwork(fcn_cpparamssyn2ana(analysislgraph,synthesisnet));

        % Check the adjoint relation (perfect reconstruction)
        checkadjointrelation(analysisnet,synthesisnet,nLevels,szPatchTrn);

    end
%[text] #### Save the trained network (results folder)
    save(fullfile(resfolder,"nsoltdictionary_"+string(datetime("now","Format","yyyyMMddHHmmssSSS"))+".mat"), ...
        'analysisnet','synthesisnet','nLevels')
end
%%

figure
subplot(1,2,1)
plot(analysisnet)
title('Analysis NSOLT')
subplot(1,2,2)
plot(synthesisnet)
title('Synthesis NSOLT')
%[text] #### Show the atomic images

figure

saivdr.dcnn.atomicimshow(synthesisnet,[],2^(nLevels-1))
title('Atomic images of trained NSOLT')
%[text] ### Construction of the NSOLT networks for the whole image
%[text] The input layers of the `dlnetwork` objects are replaced for the size of the whole image.
% Analyzer D^T
analysisnet4predict = replaceLayer(analysisnet,"Image input",...
    imageInputLayer([szOrg 1],"Name","Image input","Normalization","none"));
analysisnet4predict = initialize(analysisnet4predict);

% Synthesizer D
synthesisnet4predict = synthesisnet;
for iLayer = 1:numel(synthesisnet4predict.Layers)
    layer = synthesisnet4predict.Layers(iLayer);
    if contains(layer.Name,"Ac feature input")
        iLv = str2double(layer.Name(3));
        sbSize = szOrg.*(decFactor.^(-iLv));
        newlayer = imageInputLayer([sbSize (sum(nChannels)-1)],"Name",layer.Name,"Normalization","none");
        synthesisnet4predict = replaceLayer(synthesisnet4predict,layer.Name,newlayer);
    elseif contains(layer.Name,sprintf("Lv%0d_Dc feature input",nLevels))
        iLv = str2double(layer.Name(3));
        sbSize = szOrg.*(decFactor.^(-iLv));
        newlayer = imageInputLayer([sbSize 1],"Name",layer.Name,"Normalization","none");
        synthesisnet4predict = replaceLayer(synthesisnet4predict,layer.Name,newlayer);
    end
end
synthesisnet4predict = initialize(synthesisnet4predict);
%[text] #### Confirmation of the adjoint relation (perfect reconstruction)
%[text] NSOLT satisfies the Parseval tight property.
u = dlarray(rand(szOrg,'single'),'SSCB');
[s{1:nLevels+1}] = predict(analysisnet4predict,u);
v = predict(synthesisnet4predict,s{1:nLevels+1});
assert(mean((extractdata(u)-extractdata(v)).^2,"all")<1e-9)
%[text] #### Synthesis process by NSOLT and its adjoint
nsoltconfig.nLevels = nLevels;
szCoefs = zeros(nLevels+1,3);
for iLevel = 1:nLevels+1
    s_iLevel = s{iLevel};
    szCoefs(iLevel,1) = size(s_iLevel,1);
    szCoefs(iLevel,2) = size(s_iLevel,2);
    szCoefs(iLevel,3) = size(s_iLevel,3);
end
nsoltconfig.szCoefs = szCoefs;
syn_nsolt = @(x) synthesisnsolt(x,synthesisnet4predict,nsoltconfig);
adj_nsolt = @(y) analysisnsolt(y,analysisnet4predict,nsoltconfig);
%[text] #### Check of the adjoint relation
x = adj_nsolt(y);
v = randn(size(x));
u = syn_nsolt(v);
assert(abs(dot(y(:),u(:))-dot(x(:),v(:)))<1e-3)
%%
%[text] ## Comparison of the sparse approximation by iterative hard thresholding (IHT)
%[text] #### Preparation of the dictionaries
blkdctwon  = { syn_blkdct,  adj_blkdct,  "Block DCTwoN", false };
blkdct  = { syn_blkdct,  adj_blkdct,  "Block DCT", true };
blkpcawon  = { syn_blkpca,  adj_blkpca,  "Block PCAwoN", false };
blkpca  = { syn_blkpca,  adj_blkpca,  "Block PCA", true };
blkrica = { syn_blkrica, adj_blkrica, "Block RICA", true };
blkksvd = { syn_blkksvd, adj_blkksvd, "Block K-SVD", true };
nsoltwon   = { syn_nsolt,   adj_nsolt,   "NSOLTwoN", false };
nsolt = { syn_nsolt,   adj_nsolt,   "NSOLT", true };
dicset  = { blkdctwon, blkdct, blkpcawon, blkpca, blkrica, blkksvd, nsoltwon, nsolt };
nDics   = length(dicset);
%[text] #### IHT
%[text]  $\\mathbf{x}^{(t+1)}\\leftarrow \\mathcal{H}\_{BK}\\left(\\mathbf{x}^{(t)}+\\mu^{(t)}\\hat{\\mathbf{D}}^\\textsf{T}\\left(\\mathbf{y}-\\hat{\\mathbf{D}}\\mathbf{x}^{(t)}\\right)\\right)$
%[text]  $t\\leftarrow t+1$
%[text] -  T. Blumensath and M. E. Davies, "Normalized Iterative Hard Thresholding: Guaranteed Stability and Performance," in IEEE Journal of Selected Topics in Signal Processing, vol. 4, no. 2, pp. 298-309, April 2010, doi: 10.1109/JSTSP.2010.2042411. \
nItersIht = 2000;
if isQuick, nItersIht = 20; end

% Centered image (the mean is added after the approximation)
ymean = mean(yorg,"all");
y = yorg - ymean;
% Preparation
c = 1e-3;
kappa = 1.1/(1-c);
nCoefs = floor(sparsityRatio*prod(szOrg));
psnrs = zeros(nItersIht,nDics);
ssims = zeros(nItersIht,nDics);
yaprxs = cell(1,nDics);
% Iterations
for iDic = 1:nDics
    dic_ = dicset{iDic};
    synproc = dic_{1};
    adjproc = dic_{2};
    dicname = dic_{3};
    isStepSizeNormalized = dic_{4};
    % IHT
    display(dicname)
    s = adjproc(y); % D^Ty
    xt = zeros(size(s),'like',s); % x1 = 0;
    if isStepSizeNormalized % with normalization (NIHT)
        suppt = find(hardthresh(s,nCoefs)); % G1 = supp(H_K(D^Ty))
        maskt = (abs(s)~=0);
    end
    for iIter=1:nItersIht
        % Gradient descent
        gt = adjproc(y-synproc(xt)); % g = D^T(y-Dxn)
        if ~isStepSizeNormalized % without normalization
            mu = (1-c);
            xtp1 = hardthresh(xt+mu*gt,nCoefs);
        else % with normalization (NIHT)
            ggt = gt(suppt); % g_Gn
            ugt = synproc(maskt.*gt); % D_Gn g_Gn
            mu = (ggt.'*ggt)/(ugt(:).'*ugt(:));
            ttp1 = hardthresh(xt+mu*gt,nCoefs); % ~xn+1 = H_K(xn + mun gn)
            supptp1 = find(ttp1); % Gn+1 = supp(~xn+1)
            if length(supptp1)==length(suppt) && all(supptp1==suppt)
                xtp1 = ttp1; % xn+1 = ~xn+1
            else
                dxt = ttp1-xt; % ~xn+1 - xn
                omega = (1-c)*(norm(dxt,'fro')/norm(synproc(dxt),'fro'))^2;
                if mu <= omega
                    xtp1 = ttp1; % xn+1 = ~xn+1
                else
                    while mu > omega
                        mu = mu/(kappa*(1-c));
                        ttp1 = hardthresh(xt+mu*gt,nCoefs); % ~xn+1 = H_K(xn + mun gn)
                        dxt = ttp1-xt; % ~xn+1 - xn
                        omega = (1-c)*(norm(dxt,'fro')/norm(synproc(dxt),'fro'))^2;
                    end
                    supptp1 = find(ttp1);  % Gn+1 = supp(~xn+1)
                    xtp1 = ttp1; % xn+1 = ~xn+1
                end
            end
            % Update
            suppt = supptp1;
            maskt = zeros(size(maskt),'like',maskt);
            maskt(suppt) = 1;
        end
        xt = xtp1;
        % Monitoring
        checkSparsity = nnz(xt)/prod(szOrg)<=sparsityRatio;
        assert(checkSparsity)
        yaprx_ = synproc(xt);
        psnr_ = psnr(cast(yaprx_,'like',y),y);
        ssim_ = ssim(cast(yaprx_,'like',y),y);
        psnrs(iIter,iDic) = psnr_;
        ssims(iIter,iDic) = ssim_;
        %fprintf("IHT(%d) PSNR: %6.4f\n",iIter,psnr_);
    end
    yaprxs{iDic} = yaprx_ + ymean;
end
%%
%[text] ## Display of the approximation results
dicnames = [blkdctwon{3},blkdct{3},blkpcawon{3},blkpca{3},blkrica{3},blkksvd{3},nsoltwon{3},nsolt{3}];
psnrtbl = array2table(psnrs,'VariableNames',dicnames);
psnrtbl = horzcat(table((1:nItersIht).','VariableNames',"Iterations"),psnrtbl);
ssimtbl = array2table(ssims,'VariableNames',dicnames);
ssimtbl = horzcat(table((1:nItersIht).','VariableNames',"Iterations"),ssimtbl);

% Graph of PSNR
figure
plot(psnrtbl,"Iterations",dicnames,'LineWidth',2)
ylabel('PSNR [dB]')
legend('Location','best')
% Graph of SSIM
figure
plot(ssimtbl,"Iterations",dicnames,'LineWidth',2)
ylabel('SSIM')
legend('Location','best')


%%
% Show the original image
figure
tiledlayout(2,ceil((nDics+1)/2))
nexttile
imshow(yorg)
title("Original image")
% Show the approximated images
for idx = 1:nDics
    yaprx = yaprxs{idx};
    dicname = dicnames(idx);
    file_yaprx = fullfile(resfolder,"sample13_06_yaprx_" + replace(lower(dicname)," ","_") + ".png");
    imwrite(yaprx,file_yaprx)
    %
    nexttile
    imshow(yaprxs{idx})
    title(dicname+" "+num2str(psnrs(end,idx))+" dB")
end
%%
%[text] ## Functions
%[text] #### NSOLT synthesis function
function y = synthesisnsolt(x,synthesisnet4predict,config)
nLevels = config.nLevels;
szCoefs = config.szCoefs;
s = cell(1,nLevels+1);
sidx = 1;
for iLevel = 1:nLevels+1
    sz_iLevel = szCoefs(iLevel,:);
    eidx = sidx+prod(sz_iLevel)-1;
    x_iLevel = x(sidx:eidx);
    s{iLevel} = dlarray(single(reshape(x_iLevel,sz_iLevel)),'SSCB');
    sidx = eidx+1;
end
y = extractdata(predict(synthesisnet4predict,s{1:nLevels+1}));
end

%[text] #### NSOLT analysis function
function x = analysisnsolt(y,analysisnet4predict,config)
nLevels = config.nLevels;
szCoefs = config.szCoefs;
[s{1:nLevels+1}] = predict(analysisnet4predict,dlarray(single(y),'SSCB'));
nCoefs = sum(prod(szCoefs,2),1);
%x = [];
x = zeros(nCoefs,1);
sidx = 1;
for iLevel = 1:nLevels+1
    %x = [x; s{iLevel}(:)];
    eidx = sidx - 1 + prod(szCoefs(iLevel,:));
    x(sidx:eidx) = extractdata(s{iLevel}(:));
    sidx = eidx + 1;
end
end
%[text] #### Hard thresholding (keeps the K coefficients of the largest magnitudes)
function y = hardthresh(x,K)
v = sort(abs(x(:)),'descend');
thk = v(K+1);
y = (abs(x)>thk).*x;
end
%[text] #### Batch processing of IHT for deep learning arrays
function newdata = iht4patchds(oldtbl,analyzer,synthesizer,sparsityRatio)
% IHT for InputImage in randomPatchExtractionDatastore
%
nInputs = length(synthesizer.InputNames);

% Apply IHT process for every input patch
restbl = removevars(oldtbl,'InputImage');
dlv = dlarray(cat(4,oldtbl.InputImage{:}),'SSCB');
[~,dlcoefs{1:nInputs}] = iht4dlarray(dlv,analyzer,synthesizer,sparsityRatio);
coefs = cellfun(@(x) permute(num2cell(extractdata(x),1:3),[4 1 2 3]),dlcoefs,'UniformOutput',false);
%
nImgs = length(oldtbl.InputImage);
coefarray = cell(nImgs,nInputs);
for iImg = 1:nImgs
    for iInput = 1:nInputs
        coefarray{iImg,iInput} = coefs{iInput}{iImg};
    end
end
% Output as a cell in order to make multiple-input datastore
newdata = [ coefarray table2cell(restbl) ];
end
%[text] #### Iterative hard thresholding (IHT) for deep learning arrays
function [dly,varargout] = iht4dlarray(dlx,analyzer,synthesizer,sparsityRatio)
% IHT Iterative hard thresholding
%
nInputs = length(synthesizer.InputNames);
szBatch = size(dlx,4);

% Iterative hard thresholding w/o normalization
% (A Parseval tight frame is assumed)
eta = (1.-1e-3);
nIters = 10;
nCoefs = floor(sparsityRatio*numel(dlx(:,:,:,1)));
[dlcoefs{1:nInputs}] = analyzer.predict(dlarray(zeros(size(dlx),'like',dlx),'SSCB'));
% IHT
for iter=1:nIters
    % Gradient descent
    dly = synthesizer.predict(dlcoefs{1:nInputs});
    [grad{1:nInputs}] = analyzer.predict(dlx-dly);
    dlcoefs = cellfun(@(x,y) x+eta*y,dlcoefs,grad,'UniformOutput',false);
    % Hard thresholding
    coefvecs = cellfun(@(x) extractdata(reshape(x,[],szBatch)),dlcoefs,'UniformOutput',false);
    srtdabscoefs = sort(abs(cell2mat(coefvecs.')),1,'descend');
    thk = reshape(srtdabscoefs(nCoefs,:),1,1,1,szBatch);
    dlcoefs = cellfun(@(x) (abs(x)>=thk).*x,dlcoefs,'UniformOutput',false);
    % Monitoring
    %checkSparsity =...
    %nnz(srtdabscoefs>srtdabscoefs(nCoefs,:))/numel(dlx)<=sparsityRatio;
    %assert(checkSparsity)
    %fprintf("IHT(%d) MSE: %6.4f\n",iter,mse(dlx,dly));
end
varargout = dlcoefs;
end
%[text] #### Confirmation of the adjoint relation of the NSOLT networks
function checkadjointrelation(analysisnet,synthesisnet,nLevels,szInput)
x = dlarray(rand(szInput,'single'),'SSCB');
% Analysis and synthesis process
[s{1:nLevels+1}] = analysisnet.predict(x);
y = synthesisnet.predict(s{:});
% Evaluation
display("MSE: " + num2str(mean((extractdata(x)-extractdata(y)).^2,"all")))
end
%[text] #### Orthogonal matching pursuit (OMP)
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
%[text] #### Extraction of the number of tree levels from an NSOLT network
function nLevels = extractnumlevels(nsoltnet)

% Extraction of information
expidctlayer = '^Lv\d+_E0~?$';
nLevels = 0;
nLayers = height(nsoltnet.Layers);
for iLayer = 1:nLayers
    layer = nsoltnet.Layers(iLayer);
    if ~isempty(regexp(layer.Name,expidctlayer,'once'))
        nLevels = nLevels + 1;
    end
end
end
%[text] #### Extraction of the decimation factor from an NSOLT network
function decFactor = extractdecfactor(nsoltnet)

% Extraction of information
expfinallayer = '^Lv1_Cmp1+_V0~?$';
nLayers = height(nsoltnet.Layers);
for iLayer = 1:nLayers
    layer = nsoltnet.Layers(iLayer);
    if ~isempty(regexp(layer.Name,expfinallayer,'once'))
        decFactor = layer.DecimationFactor;
    end
end
end
%[text] #### Extraction of the numbers of channels from an NSOLT network
function nChannels = extractnumchannels(nsoltnet)

% Extraction of information
expfinallayer = '^Lv1_Cmp1+_V0~?$';
nLayers = height(nsoltnet.Layers);
for iLayer = 1:nLayers
    layer = nsoltnet.Layers(iLayer);
    if ~isempty(regexp(layer.Name,expfinallayer,'once'))
        nChannels = layer.NumberOfChannels;
    end
end
end
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:checkbox:8096]
%   data: {"defaultValue":false,"label":"isCodegen","run":"Section"}
%---
%[control:checkbox:7783]
%   data: {"defaultValue":true,"label":"noDcLeakage","run":"Section"}
%---
