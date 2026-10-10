%[text] # Sample 13-5: Image restoration with a learned dictionary
%[text] Advanced Topics in Image Processing, Lecture 13 "Dictionary Learning"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Preparation
%[text] SaivDr (NSOLT layers `saivdr.dcnn.*`) is downloaded into the folder `code` of the project by `msip.saivdr_setup`.
datfolder = atip.prjfolders();
msip.saivdr_setup(false)
atip.download_img(false)
%%
%[text] ## Original image
xorg = im2single(im2gray(imread(fullfile(datfolder,"kodim23.png"))));
figure
imshow(xorg)
title("Original x")
%%
%[text] ## Observed image
%[text] Let us consider the single-image super-resolution problem with the observation
%[text]  $\\mathbf{v}=\\mathbf{H}\\mathbf{x}+\\mathbf{w}$,
%[text] which originates from $\\mathbf{x}$ through the downscaling measurement process $\\mathbf{H}$ (low-pass filter and downsampling)
%[text] and is contaminated by the additive white Gaussian noise $\\mathbf{w}$.
% Measurement process H
sigmah = 2;
h = fspecial("gaussian",9,sigmah);
downsample2 = @(x,m) ipermute(downsample(permute(downsample(x,m),[2 1 3]),m),[2 1 3]);
linproc = @(x) downsample2(imfilter(x,h,"conv","circ"),2);
Ht = fftn(h,2.^nextpow2([size(xorg,1) size(xorg,2)]));
kappa = max(abs(Ht(:)).^2); % lambda_max(H*H.') (upper bound)

% Observation
sigmaw = 5/255;
v = imnoise(linproc(xorg),"gaussian",0,sigmaw^2);
figure
imshow(v)
title("Observation v");
%%
%[text] ## Bicubic interpolation
%[text] For reference, the result of the bicubic interpolation is shown.
% Bicubic
y = imresize(v,2,"bicubic");
figure
imshow(y)
title("Bicubic y: PSNR = " + num2str(psnr(y,xorg)) + " dB");
%%
%[text] ## Single-image super-resolution
%[text] The above super-resolution problem can be formulated as the $\\ell\_1$-norm regularized least squares problem with a redundant dictionary $\\mathbf{D}$:
%[text]  $\\hat{\\mathbf{s}}=\\arg\\min\_\\mathbf{s}\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{H}\\mathbf{D}\\mathbf{s}\\|\_2^2+\\lambda\\|\\mathbf{s}\\|\_1$.
%[text] The solution is obtained by the proximal gradient algorithm (ISTA)
%[text]  $\\mathbf{s}^{(t+1)}\\leftarrow\\mathrm{prox}\_{\\eta\\lambda\\|\\cdot\\|\_1}(\\mathbf{s}^{(t)}-\\eta\\nabla f(\\mathbf{s}^{(t)}))$
%[text]  $\\nabla f(\\mathbf{s})=\\mathbf{D}^\\top\\mathbf{H}^\\top(\\mathbf{H}\\mathbf{D}\\mathbf{s}-\\mathbf{v})$
%[text]  $\[\\mathrm{prox}\_{\\eta\\lambda\\|\\cdot\\|\_1}(\\mathbf{s})\]\_i=\\phi\_\\mathrm{ST}(\[\\mathbf{s}\]\_i;\\eta\\lambda)=\\mathrm{sign}(\[\\mathbf{s}\]\_i)\\cdot\\max(|\[\\mathbf{s}\]\_i|-\\eta\\lambda,0)$,
%[text] where $0\<\\eta\<2/\\kappa$ and $\\kappa$ is the Lipschitz constant of $\\nabla f$.
%[text] In the following, let us perform single-image super-resolution (SISR) by the proximal gradient method with the non-separable oversampled lapped transform (NSOLT) trained by Sample 13-4 as the dictionary.
%[text] For the Parseval tight frame $\\mathbf{D}$ ($\\mathbf{D}\\mathbf{D}^\\top=\\mathbf{I}$),
%[text]  $\\kappa=\\lambda\_\\mathrm{max}(\\mathbf{D}^\\top\\mathbf{H}^\\top\\mathbf{H}\\mathbf{D})=\\lambda\_\\mathrm{max}(\\mathbf{H}\\mathbf{D}\\mathbf{D}^\\top\\mathbf{H}^\\top)=\\lambda\_\\mathrm{max}(\\mathbf{H}\\mathbf{H}^\\top)=\\sigma\_\\mathrm{max}^2(\\mathbf{H})$.
%[text] The NSOLT dictionary is stored in the data folder.
%[text] ### Loading the NSOLT dictionary
dic = load(fullfile(datfolder,"nsoltdictionary_20230705164652136.mat"));
analysisnet = dic.analysisnet;
synthesisnet = dic.synthesisnet;
nLevels = dic.nLevels;

figure
subplot(1,2,1)
plot(analysisnet)
title("Analysis NSOLT")
subplot(1,2,2)
plot(synthesisnet)
title("Synthesis NSOLT")
%[text] Show the atomic images
figure
saivdr.dcnn.atomicimshow(synthesisnet,[],2^(nLevels-1))
title("Atomic images of the trained NSOLT")
%%
%[text] ### Networks for the whole image
%[text] The input layers of the `dlnetwork` objects are replaced for the size of the whole image.
nLevels = extractnumlevels(analysisnet);
decFactor = extractdecfactor(analysisnet);
nChannels = extractnumchannels(analysisnet);
szOrg = size(xorg);

% Analyzer D^T
analysisnet4predict = analysisnet;
analysisnet4predict = replaceLayer(analysisnet4predict,"Image input",...
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
%%
%[text] ### Confirmation of the adjoint relation (perfect reconstruction)
x = dlarray(rand(szOrg,"single"),"SSCB");
[s{1:nLevels+1}] = predict(analysisnet4predict,x);
r = predict(synthesisnet4predict,s{1:nLevels+1});
display("MSE: " + num2str(mean((extractdata(x)-extractdata(r)).^2,"all")))
%%
%[text] ### Adjoint operator of the measurement process
% Adjoint process H.'
upsample2 = @(x,m) ipermute(upsample(permute(upsample(x,m),[2 1 3]),m),[2 1 3]);
adjproc = @(x) imfilter(upsample2(x,2),h,"corr","circ");
%%
%[text] ### Execution of the proximal gradient method (ISTA)
%[text] - `synthesisnet4predict` and `analysisnet4predict` are `dlnetwork` objects, which take `dlarray` inputs.
%[text] - `extractdata` extracts ordinary array data from a `dlarray`. \
% Parameter settings
lambda = 0.001;
eta = 2./(kappa+1e-2);
nIters = 100;
isDcSkip = true;
%%
% Initialization
z = dlarray(zeros(szOrg,"like",xorg),"SSCB");
[coefs{1:nLevels+1}] = predict(analysisnet4predict,z);

for itr = 1:nIters
    u = linproc(extractdata(predict(synthesisnet4predict,coefs{1:nLevels+1})));
    [g{1:nLevels+1}] = predict(analysisnet4predict,dlarray(adjproc(u-v),"SSCB"));
    % Gradient descent
    for iOutput = 1:nLevels+1
        coefs{iOutput} = coefs{iOutput}-eta*g{iOutput};
        if ~isDcSkip || iOutput < nLevels+1
            % Soft thresholding for the details (not applied to the approximation components)
            coefs{iOutput} = sign(coefs{iOutput}).*max(abs(coefs{iOutput})-eta*lambda,0);
        end
    end
end
%%
% Reconstruction
r = extractdata(predict(synthesisnet4predict,coefs{1:nLevels+1}));
%[text] ### Display the result
figure
imshow(r)
title("Restoration r: PSNR = " + num2str(psnr(r,xorg)) + " dB")
%%
%[text] ## Functions
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
