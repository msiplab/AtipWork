%[text] # Sample 13-4: Convolutional dictionary learning (NSOLT)
%[text] Advanced Topics in Image Processing, Lecture 13 "Dictionary Learning"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Preparation
%[text] SaivDr (NSOLT layers `saivdr.dcnn.*`) is downloaded into the folder `code` of the project by `msip.saivdr_setup`.
%[text] - nsoltDic: name of a learned dictionary (.mat).  It is searched in the results folder and then in the data folder.
%[text]   Set "" to train a new dictionary (it is saved in the results folder with a time stamp).
%[text] - isQuick: true for a quick check of the training (one outer iteration and one epoch).
%[text]   The default training (10 outer iterations of 60 epochs) takes a long time. \
[datfolder,resfolder] = atip.prjfolders();

nsoltDic = "nsoltdictionary_20230705164652136"; % Set "" to train a new dictionary.
isQuick = false;

isCodegen = false; % code generation %[control:checkbox:2dab]{"position":[13,18]}
msip.saivdr_setup(isCodegen)

atip.download_img(false)
%%
%[text] ## Parameter settings
%[text] - szBlk: block size
%[text] - redundancyRatio: redundancy ratio (upper bound)
%[text] - sparsityRatio: sparsity ratio \
% Block size
szBlk = [ 8 8 ];

% Redundancy ratio
redundancyRatio = 7/3;

% Sparsity ratio
sparsityRatio = 3/64;
%%
%[text] ## Read image
%[text] - $\\mathbf{x}\\in\\mathbb{R}^{N}$ \
file_xorg = fullfile(datfolder,"kodim23.png");
xorg = im2gray(im2double(imread(file_xorg)));
szOrg = size(xorg);
figure
imshow(xorg)
title("Original image x")
meansubtract = @(u) u-mean(u,"all");

% Number of patches
nPatches = prod(szOrg./szBlk);
%%
%[text] ## Bivariate lattice-structure oversampled filter banks
%[text] As an example, let us adopt a non-separable oversampled lapped transform (NSOLT) of type-I with an even number of channels (the numbers of even- and odd-symmetric channels are identical to each other) and even polyphase orders:
%[text]  $\\mathbf{E}(z\_\\mathrm{v},z\_\\mathrm{h})\n=\n\\left(\\prod\_{k\_\\mathrm{h}=1}^{N\_\\mathrm{h}/2}\n{\\mathbf{V}\_{2k\_\\mathrm{h}}^{\\{\\mathrm{h}\\}}}\\bar{\\mathbf{Q}}(z\_\\mathrm{h}){\\mathbf{V}\_{2k\_\\mathrm{h}-1}^{\\{\\mathrm{h}\\}}}{\\mathbf{Q}}(z\_\\mathrm{h})\\right)\n%\n\\left(\\prod\_{k\_{\\mathrm{v}}=1}^{N\_\\mathrm{v}/2}{\\mathbf{V}\_{2k\_\\mathrm{v}}^{\\{\\mathrm{v}\\}}}\\bar{\\mathbf{Q}}(z\_\\mathrm{v}){\\mathbf{V}\_{2k\_\\mathrm{v}-1}^{\\{\\mathrm{v}\\}}}{\\mathbf{Q}}(z\_\\mathrm{v})\\right)\n%\n\\mathbf{V}\_0\\mathbf{E}\_0,$
%[text]  $\\mathbf{R}(z\_\\mathrm{v},z\_\\mathrm{h})\n=\\mathbf{E}^\\top(z\_\\mathrm{v}^{-1},z\_\\mathrm{h}^{-1}),$
%[text] where
%[text] - $\\mathbf{E}(z\_\\mathrm{v},z\_\\mathrm{h})$: type-I polyphase matrix of the analysis filter bank
%[text] - $\\mathbf{R}(z\_\\mathrm{v},z\_\\mathrm{h})$: type-II polyphase matrix of the synthesis filter bank
%[text] - $z\_d\\in\\mathbb{C}, d\\in\\{\\mathrm{v},\\mathrm{h}\\}$: variable of the Z-transform in direction $d$
%[text] - $N\_d\\in \\mathbb{N}, d\\in\\{\\mathrm{v},\\mathrm{h}\\}$: polyphase order in direction $d$ (number of overlapping blocks)
%[text] - $\\mathbf{V}\_0=\\left(\\begin{array}{cc}\\mathbf{W}\_{0} & \\mathbf{O} \\\\\\mathbf{O} & \\mathbf{U}\_0\\end{array}\\right)\n%\n\\left(\\begin{array}{c}\\mathbf{I}\_{M/2} \\\\ \n\\mathbf{O} \\\\\n\\mathbf{I}\_{M/2} \\\\\n\\mathbf{O}\n\\end{array}\\right)\\in\\mathbb{R}^{P\\times M}$, $\\mathbf{V}\_n^{\\{d\\}}=\\left(\\begin{array}{cc}\\mathbf{I}\_{P/2} & \\mathbf{O} \\\\\\mathbf{O} & \\mathbf{U}\_n^{\\{d\\}}\\end{array}\\right)\\in\\mathbb{R}^{P\\times P}, d\\in\\{\\mathrm{v},\\mathrm{h}\\}$, where $\\mathbf{W}\_0, \\mathbf{U}\_0,\\mathbf{U}\_n^{\\{d\\}}\\in\\mathbb{R}^{P/2\\times P/2}$ are orthonormal matrices.
%[text] - $\\mathbf{Q}(z)=\\mathbf{B}\_{P}\\left(\\begin{array}{cc} \\mathbf{I}\_{P/2} &  \\mathbf{O} \\\\ \\mathbf{O} &  z^{-1}\\mathbf{I}\_{P/2}\\end{array}\\right)\\mathbf{B}\_{P}$, $\\bar{\\mathbf{Q}}(z)=\\mathbf{B}\_{P}\\left(\\begin{array}{cc} z\\mathbf{I}\_{P/2} &  \\mathbf{O} \\\\ \\mathbf{O} &  \\mathbf{I}\_{P/2}\\end{array}\\right)\\mathbf{B}\_{P}$, $\\mathbf{B}\_{P}=\\frac{1}{\\sqrt{2}}\\left(\\begin{array}{cc} \\mathbf{I}\_{P/2} &  \\mathbf{I}\_{P/2} \\\\ \\mathbf{I}\_{P/2} &  -\\mathbf{I}\_{P/2}\\end{array}\\right)$ \
%[text] References
%[text] - [Overview of Filter Banks - MATLAB & Simulink - MathWorks](https://www.mathworks.com/help/dsp/ug/overview-of-filter-banks.html)
%[text] - MATLAB SaivDr Package: [https://github.com/msiplab/SaivDr](https://github.com/msiplab/SaivDr)
%[text] - S. Muramatsu, K. Furuya and N. Yuki, "Multidimensional Nonseparable Oversampled Lapped Transforms: Theory and Design," in IEEE Transactions on Signal Processing, vol. 65, no. 5, pp. 1251-1264, 1 March1, 2017, doi: 10.1109/TSP.2016.2633240.
%[text] - S. Muramatsu, T. Kobayashi, M. Hiki and H. Kikuchi, "Boundary Operation of 2-D Nonseparable Linear-Phase Paraunitary Filter Banks," in IEEE Transactions on Image Processing, vol. 21, no. 4, pp. 2314-2318, April 2012, doi: 10.1109/TIP.2011.2181527.
%[text] - S. Muramatsu, M. Ishii and Z. Chen, "Efficient parameter optimization for example-based design of nonseparable oversampled lapped transform," 2016 IEEE International Conference on Image Processing (ICIP), Phoenix, AZ, 2016, pp. 3618-3622, doi: 10.1109/ICIP.2016.7533034.
%[text] - Furuya, K., Hara, S., Seino, K., & Muramatsu, S. (2016). Boundary operation of 2D non-separable oversampled lapped transforms. *APSIPA Transactions on Signal and Information Processing, 5*, E9. doi:10.1017/ATSIP.2016.3. \
%%
%[text] ## Hierarchical decomposition of a two-dimensional grayscale image
%[text] Let $R\_M^P(\\tau)$ be the redundancy of the $\\tau$-level tree-structured filter bank; then we have the relation
%[text]  $R\_M^P(\\tau)=\\left\\{\\begin{array}{ll} (P-1)\\tau + 1, & M=1, \\\\ \\frac{P-1}{M-1}-\\frac{P-M}{(M-1)M^\\tau}, & M\\geq 2.\\end{array}\\right.$
%[text]
%[text] ### Configuration parameters
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

%[text] Filter size $L\_\\mathrm{v}\\times L\_\\mathrm{h}=\\left(\\mu\_\\mathrm{v}^{\\tau}+{\\nu}\_\\mathrm{v}\\frac{\\mu\_\\mathrm{v}(\\mu\_\\mathrm{v}^{\\tau}-1)}{\\mu\_\\mathrm{v}-1}\\right) \\times\\left(\\mu\_\\mathrm{h}^{\\tau}+\\nu\_\\mathrm{h}\\frac{\\mu\_\\mathrm{h}(\\mu\_\\mathrm{h}^{\\tau}-1)}{\\mu\_\\mathrm{h}-1}\\right)$, where $\\mu\_d$ is the decimation factor and $\\nu\_d$ the polyphase order
% Filter size [ Ly Lx ]
maxDecFactor = decFactor.^nLevels;
szFilters = maxDecFactor + ppOrder.*decFactor.*(maxDecFactor-1)./(decFactor-1)

% Patch size for training
szPatchTrn = maxDecFactor.*ceil(szFilters./maxDecFactor) % > [ Ly Lx ]
assert(all(szPatchTrn>szFilters))

% Number of patches per image
nSubImgs = floor(nPatches*prod(szBlk./szPatchTrn))
assert(nSubImgs > 0)

% No DC-leakage
noDcLeakage = true %[control:checkbox:0378]{"position":[15,19]}
%%
%[text] ## Dictionary
%[text] A learned dictionary is loaded if it exists; otherwise a new dictionary is trained.
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
    % Number of outer iterations
    nItersNsolt = 10;

    % Standard deviation of the initial angles
    stdInitAng = 1e-1;

    % Mini-batch size
    miniBatchSize = 5;

    % Number of epochs (1 epoch = nSubImgs/miniBatchSize iterations)
    maxEpochs = 60;

    % Quick check of the training
    if isQuick
        nItersNsolt = 1;
        maxEpochs = 1;
    end

    % Number of iterations
    maxIters = nSubImgs/miniBatchSize * maxEpochs

    % Training options for trainnet
    opts = trainingOptions("sgdm", ... % stochastic gradient descent with momentum
        InitialLearnRate=1e-03, ...
        L2Regularization=0.0, ...
        MaxEpochs=maxEpochs, ...
        MiniBatchSize=miniBatchSize, ...
        Verbose=true, ...
        Plots="none");
%[text] ### Construction of the layers
%[text] SaivDr returns layer graphs, which are converted into `dlnetwork` objects.
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
    title("Analysis NSOLT")
    subplot(1,2,2)
    plot(synthesislgraph)
    title("Synthesis NSOLT")

    % Construction of the deep learning network
    synthesisnet = dlnetwork(synthesislgraph);

    % Initialization of the angles
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
%%
%[text] ### Confirmation of the adjoint relation (perfect reconstruction)
    nOutputs = nLevels+1;
    x = rand(szPatchTrn,'single');
    s = cell(1,nOutputs);
    dlx = dlarray(x,'SSCB'); % deep learning array (SSCB: spatial, spatial, channel, batch)
    [s{1:nOutputs}] = analysisnet.predict(dlx);
    dly = synthesisnet.predict(s{:});
    display("MSE: " + num2str(mse(dlx,dly)))
%%
%[text] ### Initial state of the atomic images
    figure
    atomicimshow(synthesisnet,[],2^(nLevels-1))
    title("Atomic images of the initial NSOLT")
%%
%[text] ### Preparation of the training images
%[text] Patches are randomly extracted from the image datastore.
    imds = imageDatastore(file_xorg,"ReadFcn",@(f) meansubtract(im2gray(im2single(imread(f)))));
    patchds = randomPatchExtractionDatastore(imds,imds,szPatchTrn,'PatchesPerImage',nSubImgs);
    minibatch = preview(patchds);
    responses = minibatch.ResponseImage;
    responses = cellfun(@(x) x + 0.5,responses,'UniformOutput',false);
    figure
    montage(responses,'Size',[2 4]);
    drawnow
%%
%[text] ## Convolutional dictionary learning
%[text] ### Problem setting
%[text]  $\\{\\hat{\\boldsymbol{\\theta}},\\{\\hat{\\mathbf{y}}^{\[n\]}\\}\_n\\}=\\arg\\min\_{\\{\\boldsymbol{\\theta},\\{\\mathbf{y}^{\[n\]}\\}\_n\\}}\\frac{1}{2S}\\sum\_{n=1}^{S}\\|\\mathbf{x}^{\[n\]}-\\mathbf{D}\_{\\boldsymbol{\\theta}}\\mathbf{y}^{\[n\]}\\|\_2^2,\\quad\\mathrm{s.t.}\\ \\|\\mathbf{y}^{\[n\]}\\|\_0\\leq K,\\ \\forall n,$
%[text] where $\\mathbf{D}\_{\\boldsymbol{\\theta}}$ is a convolutional dictionary with the design parameter vector $\\boldsymbol{\\theta}$.
%[text] ### Algorithm
%[text] Iterate the sparse approximation step and the dictionary update step.
%[text] - Sparse approximation step \
%[text]  $\\hat{\\mathbf{y}}^{\[n\]}=\\arg\\min\_{\\mathbf{y}}\\frac{1}{2}\\|\\mathbf{x}^{\[n\]}-\\hat{\\mathbf{D}}\\mathbf{y}\\|\_2^2\\quad\\mathrm{s.t.}\\ \\|\\mathbf{y}\\|\_0\\leq K$
%[text] - Dictionary update step \
%[text]  $\\hat{\\boldsymbol{\\theta}}=\\arg\\min\_{\\boldsymbol{\\theta}}\\frac{1}{2S}\\sum\_{n=1}^{S}\\|\\mathbf{x}^{\[n\]}-\\mathbf{D}\_{\\boldsymbol{\\theta}}\\hat{\\mathbf{y}}^{\[n\]}\\|\_2^2$
%[text]  $\\hat{\\mathbf{D}}=\\mathbf{D}\_{\\hat{\\boldsymbol{\\theta}}}$
%[text] ### Methods adopted
%[text] - Sparse approximation: iterative hard thresholding (IHT)
%[text] - Dictionary update: stochastic gradient descent with momentum (SGDM) by `trainnet` \
%%
%[text] ### Iterative calculation of the alternating steps
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
%[text] ### Save the designed network
%[text] The dictionary is saved in the results folder with a time stamp.
    save(fullfile(resfolder,"nsoltdictionary_"+string(datetime("now","Format","yyyyMMddHHmmssSSS"))+".mat"), ...
        'analysisnet','synthesisnet','nLevels')
end
%%
%[text] ## Atomic images of the trained dictionary
figure
subplot(1,2,1)
plot(analysisnet)
title("Analysis NSOLT")
subplot(1,2,2)
plot(synthesisnet)
title("Synthesis NSOLT")

figure
saivdr.dcnn.atomicimshow(synthesisnet,[],2^(nLevels-1))
title("Atomic images of the trained NSOLT")
%%
%[text] ## Function of iterative hard thresholding
%[text] The input images of the patch pairs are replaced with the sparse coefficients obtained by IHT, where the normalization is omitted because of the Parseval tight property of NSOLT ( $\\mathbf{D}\\mathbf{D}^\\top=\\mathbf{I}$ ).
%[text]  $\\mathbf{y}^{(t+1)}\\leftarrow \\phi\_\\mathrm{HT}\\left(\\mathbf{y}^{(t)}-\\eta \\hat{\\mathbf{D}}^\\top\\left(\\hat{\\mathbf{D}}\\mathbf{y}^{(t)}-\\mathbf{x}\\right);\\tau\_K\\right)$
%[text]  $t\\leftarrow t+1$
%[text] where
%[text]  $\[\\phi\_\\mathrm{HT}(\\mathbf{u};\\tau\_K)\]\_i=\\left\\{\\begin{array}{ll} 0 , & |\[\\mathbf{u}\]\_i| \\leq \\tau\_K \\\\ \[\\mathbf{u}\]\_i, & |\[\\mathbf{u}\]\_i|\> \\tau\_K \\end{array}\\right.$
%[text] and $\\tau\_K$ is chosen so that the $K$ coefficients of the largest magnitudes are kept.
%[text] -  T. Blumensath and M. E. Davies, "Normalized Iterative Hard Thresholding: Guaranteed Stability and Performance," in IEEE Journal of Selected Topics in Signal Processing, vol. 4, no. 2, pp. 298-309, April 2010, doi: 10.1109/JSTSP.2010.2042411. \
%[text] Iterative hard thresholding (IHT) batch processing for deep learning arrays
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
% Output as a cell in order to make a multiple-input datastore
newdata = [ coefarray table2cell(restbl) ];
end
%[text] Iterative hard thresholding (IHT) for deep learning arrays
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
end
varargout = dlcoefs;
end
%[text] Confirmation of the adjoint relation of the NSOLT networks
function checkadjointrelation(analysisnet,synthesisnet,nLevels,szInput)
x = dlarray(rand(szInput,'single'),'SSCB');
% Analysis and synthesis process
[s{1:nLevels+1}] = analysisnet.predict(x);
y = synthesisnet.predict(s{:});
% Evaluation
display("MSE: " + num2str(mean((extractdata(x)-extractdata(y)).^2,"all")))
end
%[text] Extraction of the number of tree levels from an NSOLT network
function nLevels = extractnumlevels(nsoltnet)
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
%[text] Extraction of the decimation factor from an NSOLT network
function decFactor = extractdecfactor(nsoltnet)
expfinallayer = '^Lv1_Cmp1+_V0~?$';
nLayers = height(nsoltnet.Layers);
for iLayer = 1:nLayers
    layer = nsoltnet.Layers(iLayer);
    if ~isempty(regexp(layer.Name,expfinallayer,'once'))
        decFactor = layer.DecimationFactor;
    end
end
end
%[text] Extraction of the numbers of channels from an NSOLT network
function nChannels = extractnumchannels(nsoltnet)
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
%[control:checkbox:2dab]
%   data: {"defaultValue":false,"label":"isCodegen","run":"Section"}
%---
%[control:checkbox:0378]
%   data: {"defaultValue":true,"label":"noDcLeakage","run":"Section"}
%---
