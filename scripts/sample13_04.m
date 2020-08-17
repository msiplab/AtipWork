%% Sample 13-4
%% 辞書学習
% 畳込み辞書学習
% 
% 画像処理特論
% 
% 村松 正吾 
% 
% 動作確認: MATLAB R2020a
%% Dictionary learning
% Convolutional dictionary learning
% 
% Advanced Topics in Image Processing
% 
% Shogo MURAMATSU
% 
% Verified: MATLAB R2020a
% 準備
% (Preparation)

clear 
close all
import msip.download_img
msip.download_img
% パラメータ設定
% (Parameter settings)
%% 
% * 間引き率 (Decimation factor)
% * チャンネル数 (Number of channels)
% * スパース率 (Sparsity ratio)
% * 繰返し回数 (Number of iterations)
% * 初期回転角乱数の標準偏差 (Standard deviation of initial angles)
% * 訓練用パッチサイズ(Patch size for training)
% * 訓練用パッチ数 (Number of patches)

% Decimation factor (Strides)
decFactors = [4 4]; % [My Mx]
nDecs = prod(decFactors);

% Number of channels ( sum(nChannels) >= prod(decFactors) )
nChannels = [10 10]; % [Ps Pa]
redundancyRatio = sum(nChannels)/nDecs
% Sparsity ratio
sparsityRatio = 1/8;

% Number of iterations
nIters = 8;

% Standard deviation of initial angles
stdInitAng = pi/6; % 1e-1;

% Patch size for training
szPatchTrn = [32 32]; % > [ (Ny+1)My (Nx+1)Mx ]

% Number of patchs per image
nSubImgs = 128;
%% 
% 辞書更新パラメータの設定 (Setting of dictionary update step)

opts = trainingOptions('sgdm', ... % Stochastic gradient descent w/ momentum
    ...'Momentum', 0.9000,...
    ...'InitialLearnRate',0.0100,...
    ...'LearnRateScheduleSettings','none',...
    'L2Regularization',0.0,...1.0000e-04,...
    ...'GradientThresholdMethod','l2norm',...
    ...'GradientThreshold',Inf,...
    'MaxEpochs',16,...30,...
    'MiniBatchSize',16,...128,...
    ...'Verbose',1,...
    'VerboseFrequency',32,...50,...
    ...'ValidationData',[],...
    ...'ValidationFrequency',50,...
    ...'ValidationPatience',Inf,...
    ...'Shuffle','once',...
    ...'CheckpointPath','',...
    ...'ExecutionEnvironment','auto',...
    ...'WorkerLoad',[],...
    ...'OutputFcn',[],...
    'Plots','none',...'training-progress',...
    ...'SequenceLength','longest',...
    ...'SequencePaddingValue',0,...
    ...'SequencePaddingDirection','right',...
    ...'DispatchInBackground',0,...
    'ResetInputNormalization',0);...1
% 畳込み辞書学習
% (Convolutional dictionary learning)
% 問題設定 (Problem setting):
% $$\{\hat{\mathbf{\theta}},\{ \hat{\mathbf{s}}_n \}\}=\arg\min_{\{\mathbf{\theta},\{\mathbf{s}_n\}\}}\frac{1}{2S}\sum_{n=1}^{S}\|\mathbf{v}_n-\mathbf{D}_{\mathbf{\theta}}\hat{\mathbf{s}}_n\|_2^2,\ 
% \quad\mathrm{s.t.}\ \forall n, \|\mathbf{s}_n\|_0\leq K,$$$
% 
% ただし， $\mathbf{D}_{\mathbf{\theta}}$ は $\mathbf{\theta}}$を設計パラメータとする畳込み辞書とする．(where 
% $\mathbf{D}_{\mathbf{\theta}}$ is a convolutional dictionary with the design 
% parameter vector $\mathbf{\theta}}$.)
% 
% 
% アルゴリズム (Algorithm):
% スパース近似ステップと辞書更新ステップを繰返す．(Iterate the sparse approximation step and the dictionary 
% update step.)
%% 
% * スパース近似ステップ (Sparse approximation step)
%% 
% $$\hat{\mathbf{s}}_n=\arg\min_{\mathbf{s}_n}\frac{1}{2} \|\mathbf{v}_n-\hat{\mathbf{D}}\mathbf{s}_n\|_2^2\ 
% \quad \mathrm{s.t.}\ \|\mathbf{s}_n\|_0\leq K$$
%% 
% * 辞書更新ステップ (Dictionary update step)
%% 
% $$\hat{\mathbf{\theta}}=\arg\min_{\mathbf{\theta}}\frac{1}{2S}\sum_{n=1}^{S}\|\mathbf{v}_n-\mathbf{D}_{\mathbf{\theta}}\hat{\mathbf{s}}_n\|_2^2$$
% 
% $$\hat{\mathbf{D}}=\mathbf{D}_{\hat{\mathbf{\theta}}$$
% 二変量ラティス構造冗長フィルタバンク
% (Bivariate lattice-structure oversampled filter banks )
% 
% 例としてチャンネル数 $P=P_\mathrm{s}+P_\mathrm{a}$ （偶対称チャンネル $P_\mathrm{s}$=奇対称チャンネル 
% $P_\mathrm{a}$）, ポリフェーズ次数 $(N_\mathrm{v},N_\mathrm{h})$ （偶数）のタイプI の非分離冗長重複変換(NSOLT) 
% (As an example, let us adopt a non-separable oversampled lapped transform (NSOLT) 
% of  type-I with the number of channels (the numbers of even and odd symmetric 
% channels are identical to each other) and polyphase order (even):
% 
% $$\mathbf{E}(z_\mathrm{v},z_\mathbf{h})=\left(\prod_{k_\mathrm{h}=1}^{N_\mathrm{h}/2}{\mathbf{V}_{2k_\mathrm{h}}^{\{\mathrm{h}\}}}\bar{\mathbf{Q}}(z_\mathrm{h}){\mathbf{V}_{2k_\mathrm{h}-1}^{\{\mathrm{h}\}}}{\mathbf{Q}}(z_\mathrm{h})\right)%\left(\prod_{k_{\mathrm{v}}=1}^{N_\mathrm{v}/2}{\mathbf{V}_{2k_\mathrm{v}}^{\{\mathrm{v}\}}}\bar{\mathbf{Q}}(z_\mathrm{v}){\mathbf{V}_{2k_\mathrm{v}-1}^{\{\mathrm{v}\}}}{\mathbf{Q}}(z_\mathrm{v})\right)%\mathbf{V}_0\mathbf{E}_0,$$
% 
% $$\mathbf{R}(z_\mathrm{v},z_\mathbf{h})=\mathbf{E}^T(z_\mathrm{v}^{-1},z_\mathrm{h}^{-1}),$$
% 
% を採用する．ここで，(where)
%% 
% * $\mathbf{E}(z_\mathrm{v},z_\mathrm{h})$:  分析フィルタバンクの$P\times M$タイプⅠポリフェーズ行列 
% (Type-I polyphase matrix of the analysis filter bank)
% * $\mathbf{R}(z_\mathrm{v},z_\mathrm{h})$: 合成フィルタバンクの $M\times P$タイプⅡポリフェーズ行列 
% (Type-II polyphase matrix in the synthesis filter bank)
% * $z_d\in\mathbb{C}, d\in\{\mathrm{v},\mathrm{h}\}$: Z-変換の方向 $d$の変数 (The parameter 
% of Z-transformation direction)
% * $N_d\in \mathbb{N}, d\in\{\mathrm{v},\mathrm{h}\}$: 方向 $d$ のポリフェーズ次数（重複ブロック数）(Polyphase 
% order in direction $d$ (number of overlapping blocks))
% * $\mathbf{V}_0=\left(\begin{array}{cc}\mathbf{W}_{0} & \mathbf{O} \\\mathbf{O} 
% & \mathbf{U}_0\end{array}\right)%\left(\begin{array}{c}\mathbf{I}_{M/2} \\ \mathbf{O} 
% \\\mathbf{I}_{M/2} \\\mathbf{O}\end{array}\right)\in\mathbb{R}^{P\times M}$,$\mathbf{V}_n^{\{d\}}=\left(\begin{array}{cc}\mathbf{I}_{P/2} 
% & \mathbf{O} \\\mathbf{O} & \mathbf{U}_n^{\{d\}}\end{array}\right)\in\mathbb{R}^{P\times 
% P}, d\in\{\mathrm{v},\mathrm{h}\}$, ただし， $\mathbf{W}_0, \mathbf{U}_0,\mathbf{U}_n^{\{d\}}\in\mathbb{R}^{P/2\times 
% P/2}$は直交行列．(where$\mathbf{W}_0, \mathbf{U}_0,\mathbf{U}_n^{\{d\}}\in\mathbb{R}^{P/2\times 
% P/2}$are orthonromal matrices.)
% * $\mathbf{Q}(z)=\mathbf{B}_{P}\left(\begin{array}{cc} \mathbf{I}_{P/2} &  
% \mathbf{O} \\ \mathbf{O} &  z^{-1}\mathbf{I}_{P/2}\end{array}\right)\mathbf{B}_{P}$, 
% $\bar{\mathbf{Q}}(z)=\mathbf{B}_{P}\left(\begin{array}{cc} z\mathbf{I}_{P/2} 
% &  \mathbf{O} \\ \mathbf{O} &  \mathbf{I}_{P/2}\end{array}\right)\mathbf{B}_{P}$, 
% $\mathbf{B}_{P}=\frac{1}{\sqrt{2}}\left(\begin{array}{cc} \mathbf{I}_{P/2} &  
% \mathbf{I}_{P/2} \\ \mathbf{I}_{P/2} &  -\mathbf{I}_{P/2}\end{array}\right)$
%% 
% 【Example】For $P/2=3$, a parametric orthonormal matrix $\mathbf{U}(\mathbf{\theta},\mathbf{\mu})$ 
% can be constructed by 
% 
% $$\mathbf{U}(\mathbf{\theta},\mathbf{\mu}) \colon = \left(\begin{array}{cc} 
% \mu_1 & 0& 0\\ 0 & \mu_1 & 0 \\ 0 & 0 & \mu_2 \end{array}\right)%\left(\begin{array}{ccc}  
% 1 & 0 & 0 \\0 & \cos\theta_2& -\sin\theta_2 \\ 0 & \sin\theta_2 & \cos\theta_2 
% \end{array}\right)%\left(\begin{array}{ccc} \cos\theta_1& 0 & -\sin\theta_1  
% \\  0 & 1 & 0 \\\sin\theta_1 & 0 &  \cos\theta_1  \end{array}\right)%\left(\begin{array}{ccc} 
% \cos\theta_0& -\sin\theta_0 & 0 \\ \sin\theta_0 & \cos\theta_0 & 0 \\ 0 & 0 
% & 1 \end{array}\right),$$
% 
% $${\mathbf{U}(\mathbf{\theta},\mathbf{\mu})}^T = %\left(\begin{array}{ccc} 
% \cos\theta_0& \sin\theta_0 & 0 \\ -\sin\theta_0 & \cos\theta_0 & 0 \\ 0 & 0 
% & 1 \end{array}\right)%\left(\begin{array}{ccc} \cos\theta_1& 0 & \sin\theta_1  
% \\  0 & 1 & 0 \\-\sin\theta_1 & 0 &  \cos\theta_1  \end{array}\right)%\left(\begin{array}{ccc} 
% 1 & 0 & 0 \\0 & \cos\theta_2& \sin\theta_2 \\ 0 & -\sin\theta_2 & \cos\theta_2 
% \end{array}\right)%\left(\begin{array}{cc} \mu_0 & 0& 0\\ 0 & \mu_1 & 0 \\ 0 
% & 0 & \mu_2 \end{array}\right),$$
% 
% where $\mathbf{\theta}\in\mathbb{R}^{(P-2)P/8}$ and $\mathbf{\mu}=\{-1,1\}^{P/2}$. 
% For the sake of simplification, the sign parameters $\mu_k$ are fixed to $-1$for 
% $\mathbf{U}_n^{\{d\}}$ witn odd $n$, otherwise they are fixed to $+1$.
% 
% 
% カスタムレイヤとネットワークの定義
% (Definition of cunsom layers and networks)
% 
% 合成NSOLT (Synthesis NSOLT)の実装にDeep Learning Toolbox のカスタムレイヤを利用．(Use a custom 
% layer of Deep Learning Toolbox to implement Synthesis NSOLT (Synthesis NSOLT).)
% 
% 学習レイヤの定義 (Definition of layers w/ Learnable properties)
%% 
% * Final rotation: $\mathbf{V}_0^T$ (msip.nsoltFinalRotation2dLayer)
% * Intermediate rotation: ${\mathbf{V}_n^{\{d\}}}^T$ (msip.nsoltIntermediateRotation2dLayer)
%% 
% 非学習レイヤの定義 (Definition of layers w/o Learnable properties)
%% 
% * Bivariate inverese DCT (2-D IDCT): $\mathbf{E}_0^T=\mathbf{E}_0^{-1}$ (msip.nsoltBlockDctLayer)
% * Vertical up extension: $\mathbf{Q}^T(z_\mathrm{v}^{-1})$ (msip.nsoltAtomExtension2dLayer)
% * Vertical down extension: $\bar{\mathbf{Q}}^T(z_\mathrm{v}^{-1})$  (msip.nsoltAtomExtension2dLayer)
% * Horizontal left extension: $\mathbf{Q}^T(z_\mathrm{h}^{-1})$ (msip.nsoltAtomExtension2dLayer)
% * Horizontal right extension: $\bar{\mathbf{Q}}^T(z_\mathrm{h}^{-1})$ (msip.nsoltAtomExtension2dLayer)
%% 
% 【References】 
%% 
% * MATLAB SaivDr Package: <https://github.com/msiplab/SaivDr https://github.com/msiplab/SaivDr>
% * S. Muramatsu, K. Furuya and N. Yuki, "Multidimensional Nonseparable Oversampled 
% Lapped Transforms: Theory and Design," in IEEE Transactions on Signal Processing, 
% vol. 65, no. 5, pp. 1251-1264, 1 March1, 2017, doi: 10.1109/TSP.2016.2633240.
% * S. Muramatsu, T. Kobayashi, M. Hiki and H. Kikuchi, "Boundary Operation 
% of 2-D Nonseparable Linear-Phase Paraunitary Filter Banks," in IEEE Transactions 
% on Image Processing, vol. 21, no. 4, pp. 2314-2318, April 2012, doi: 10.1109/TIP.2011.2181527.
% * S. Muramatsu, M. Ishii and Z. Chen, "Efficient parameter optimization for 
% example-based design of nonseparable oversampled lapped transform," 2016 IEEE 
% International Conference on Image Processing (ICIP), Phoenix, AZ, 2016, pp. 
% 3618-3622, doi: 10.1109/ICIP.2016.7533034.
% * Furuya, K., Hara, S., Seino, K., & Muramatsu, S. (2016). Boundary operation 
% of 2D non-separable oversampled lapped transforms. _APSIPA Transactions on Signal 
% and Information Processing, 5_, E9. doi:10.1017/ATSIP.2016.3.

% Construction of layers
import msip.*
analysisNsoltLayers = [
    imageInputLayer(szPatchTrn,...
        'Name','input','Normalization','none')
        
    nsoltBlockDct2dLayer('Name','E0',...
        'DecimationFactor',decFactors)
    nsoltInitialRotation2dLayer('Name','V0',...
        'NumberOfChannels',nChannels,'DecimationFactor',decFactors,...
        'NoDcLeakage',true)
        
    nsoltAtomExtension2dLayer('Name','Qh1rl',...
        'NumberOfChannels',nChannels,'Direction','Right','TargetChannels','Lower')
    nsoltIntermediateRotation2dLayer('Name','Vh1',...
        'NumberOfChannels',nChannels,'Mode','Analysis','Mus',-1)
    nsoltAtomExtension2dLayer('Name','Qh2lu',...
        'NumberOfChannels',nChannels,'Direction','Left','TargetChannels','Upper')
    nsoltIntermediateRotation2dLayer('Name','Vh2',...
        'NumberOfChannels',nChannels,'Mode','Analysis')
    %{    
    nsoltAtomExtension2dLayer('Name','Qh3rl',...
        'NumberOfChannels',nChannels,'Direction','Right','TargetChannels','Lower')
    nsoltIntermediateRotation2dLayer('Name','Vh3',...
        'NumberOfChannels',nChannels,'Mode','Analysis','Mus',-1)
    nsoltAtomExtension2dLayer('Name','Qh4lu',...
        'NumberOfChannels',nChannels,'Direction','Left','TargetChannels','Upper')
    nsoltIntermediateRotation2dLayer('Name','Vh4',...
        'NumberOfChannels',nChannels,'Mode','Analysis')        
    %}    
    nsoltAtomExtension2dLayer('Name','Qv1dl',...
        'NumberOfChannels',nChannels,'Direction','Down','TargetChannels','Lower')
    nsoltIntermediateRotation2dLayer('Name','Vv1',...
        'NumberOfChannels',nChannels,'Mode','Analysis','Mus',-1)
    nsoltAtomExtension2dLayer('Name','Qv2uu',...
        'NumberOfChannels',nChannels,'Direction','Up','TargetChannels','Upper')
    nsoltIntermediateRotation2dLayer('Name','Vv2',...
        'NumberOfChannels',nChannels,'Mode','Analysis')
    %{    
    nsoltAtomExtension2dLayer('Name','Qv3dl',...
        'NumberOfChannels',nChannels,'Direction','Down','TargetChannels','Lower')
    nsoltIntermediateRotation2dLayer('Name','Vv3',...
        'NumberOfChannels',nChannels,'Mode','Analysis','Mus',-1)
    nsoltAtomExtension2dLayer('Name','Qv4uu',...
        'NumberOfChannels',nChannels,'Direction','Up','TargetChannels','Upper')
    nsoltIntermediateRotation2dLayer('Name','Vv4',...
        'NumberOfChannels',nChannels,'Mode','Analysis')        
    %}    
    ]
synthesisNsoltLayers = [
    imageInputLayer([szPatchTrn./decFactors sum(nChannels)],...
        'Name','subband images','Normalization','none')
    %{    
    nsoltIntermediateRotation2dLayer('Name','Vv4~',...
        'NumberOfChannels',nChannels,'Mode','Synthesis')
    nsoltAtomExtension2dLayer('Name','Qv4uu~',...
        'NumberOfChannels',nChannels,'Direction','Down','TargetChannels','Upper')
    nsoltIntermediateRotation2dLayer('Name','Vv3~',...
        'NumberOfChannels',nChannels,'Mode','Synthesis','Mus',-1)
    nsoltAtomExtension2dLayer('Name','Qv3dl~',...
        'NumberOfChannels',nChannels,'Direction','Up','TargetChannels','Lower')        
    %}    
    nsoltIntermediateRotation2dLayer('Name','Vv2~',...
        'NumberOfChannels',nChannels,'Mode','Synthesis')
    nsoltAtomExtension2dLayer('Name','Qv2uu~',...
        'NumberOfChannels',nChannels,'Direction','Down','TargetChannels','Upper')
    nsoltIntermediateRotation2dLayer('Name','Vv1~',...
        'NumberOfChannels',nChannels,'Mode','Synthesis','Mus',-1)
    nsoltAtomExtension2dLayer('Name','Qv1dl~',...
        'NumberOfChannels',nChannels,'Direction','Up','TargetChannels','Lower')
    %{
    nsoltIntermediateRotation2dLayer('Name','Vh4~',...
        'NumberOfChannels',nChannels,'Mode','Synthesis')
    nsoltAtomExtension2dLayer('Name','Qh4lu~',...
        'NumberOfChannels',nChannels,'Direction','Right','TargetChannels','Upper')
    nsoltIntermediateRotation2dLayer('Name','Vh3~',...
        'NumberOfChannels',nChannels,'Mode','Synthesis','Mus',-1)
    nsoltAtomExtension2dLayer('Name','Qh3rl~',...
        'NumberOfChannels',nChannels,'Direction','Left','TargetChannels','Lower')        
    %}    
    nsoltIntermediateRotation2dLayer('Name','Vh2~',...
        'NumberOfChannels',nChannels,'Mode','Synthesis')
    nsoltAtomExtension2dLayer('Name','Qh2lu~',...
        'NumberOfChannels',nChannels,'Direction','Right','TargetChannels','Upper')
    nsoltIntermediateRotation2dLayer('Name','Vh1~',...
        'NumberOfChannels',nChannels,'Mode','Synthesis','Mus',-1)
    nsoltAtomExtension2dLayer('Name','Qh1rl~',...
        'NumberOfChannels',nChannels,'Direction','Left','TargetChannels','Lower') 
        
    nsoltFinalRotation2dLayer('Name','V0~',...
        'NumberOfChannels',nChannels,'DecimationFactor',decFactors,...
        'NoDcLeakage',true)        
    nsoltBlockIdct2dLayer('Name','E0~',...
        'DecimationFactor',decFactors) 
    ]
% Layer graph
analysislgraph = layerGraph(analysisNsoltLayers);
synthesislgraph = layerGraph(synthesisNsoltLayers);
figure(1)
subplot(1,2,1)
plot(analysislgraph)
title('Analysis NSOLT')
subplot(1,2,2)
plot(synthesislgraph)
title('Synthesis NSOLT')
% Construction of deep learning network.
analysisnet = dlnetwork(analysislgraph);
synthesisnet = dlnetwork(synthesislgraph);
nLearnables = height(synthesisnet.Learnables);
for iLearnable = 1:nLearnables
    synthesisnet.Learnables.Value(iLearnable) = ...
    cellfun(@(x) x+stdInitAng*randn(), ...
    synthesisnet.Learnables.Value(iLearnable),'UniformOutput',false);
end
analysisnet = copyparameters(synthesisnet,analysisnet);
% 完全再構成の確認
% (Confirmation of perfect reconstruction)

x = rand(szPatchTrn,'single');
dlx = dlarray(x,'SSC'); % Deep learning array (SSC: Spatial,Spatial,Channel)
dls = analysisnet.predict(dlx);
dly = synthesisnet.predict(dls);
display("MSE: " + num2str(mse(dlx,dly)))
% 要素画像の初期状態
% (Initial state of the atomic images)

subbandImages = dlarray(zeros([szPatchTrn./decFactors sum(nChannels)],'single'),'SSC');
atomicImages = zeros([szPatchTrn 1 sum(nChannels)]);
for iAtom = 1:sum(nChannels)
    deltaImage = subbandImages;
    deltaImage(round(end/2),round(end/2),iAtom)  = 1;
    atomicImages(:,:,1,iAtom) = extractdata(synthesisnet.predict(deltaImage));
end
figure(2)
montage(circshift(imresize(atomicImages,8,'nearest'),[20 20 0])+.5,'BorderSize',[2 2])
title('Atomic images of initial NSOLT')
% 教師画像の準備 
% (Preparation of traning image)
% 
% 画像データストアからパッチをランダム抽出 (Randomly extracting patches from the image data store)

imds = imageDatastore("./data/barbara.png","ReadFcn",@(x) im2single(imread(x)));
patchds = randomPatchExtractionDatastore(imds,imds,szPatchTrn,'PatchesPerImage',nSubImgs);
figure(3)
minibatch = preview(patchds);
responses = minibatch.ResponseImage;
montage(responses,'Size',[2 4]);
% スパース近似ステップと辞書更新ステップの繰り返し
% (Alternative iteration of sparse approximation step and dictioary update step)
%% 
% * スパース近似 (Sparse approximation)： 繰返しハード閾値処理 (Iterative hard thresholding)
% * 辞書更新 (Dictionary update)： 確率的勾配降下法 (Stochastic gradient descent)
%% 
% 交互ステップの繰返し計算 (Iterative calculation of alternative steps)

for iIter = 1:nIters
    
    % Sparse approximation (Applied to produce an object of TransformedDatastore)
    coefimgds = transform(patchds,@(x) iht4inputimage(x,analysisnet,synthesisnet,sparsityRatio));
    
    % Synthesis dictionary update
    trainlgraph = synthesislgraph.addLayers(regressionLayer('Name','regression output'));
    trainlgraph = trainlgraph.connectLayers('E0~','regression output');
    synthesisdagnet = trainNetwork(coefimgds,trainlgraph,opts);

    % Analysis dictionary update (Copy parameters from synthesizer to
    % analyzer)
    synthesislgraph = layerGraph(synthesisdagnet); 
    synthesislgraph = removeLayers(synthesislgraph,'regression output');
    synthesisnet = dlnetwork(synthesislgraph);
    analysisnet = copyparameters(synthesisnet,analysisnet);
    
    % Check the adjoint relation (perfect reconstruction)
    x = rand(szPatchTrn,'single');
    dlx = dlarray(x,'SSC'); % Deep learning array (SSC: Spatial,Spatial,Channel)
    dls = analysisnet.predict(dlx);
    dly = synthesisnet.predict(dls);
    display("MSE: " + num2str(mse(dlx,dly)))
    
end
%% 
% 要素ベクトルを要素画像に変換 (Reshape the atoms into atomic images)

for iAtom = 1:sum(nChannels)
    deltaImage = subbandImages;
    deltaImage(round(end/2),round(end/2),iAtom)  = 1;
    atomicImages(:,:,1,iAtom) = extractdata(synthesisnet.predict(deltaImage));
end
figure(4)
montage(circshift(imresize(atomicImages,8,'nearest'),[20 20 0])+.5,'BorderSize',[2 2])
title('Atomic images of trained NSOLT')
% 設計データの保存
% (Save the designed network)

save('./data/nsoltdictionary','analysisnet','synthesisnet')
% 繰返しハード閾値処理 
% (Function of iterative hard thresholding)
% 
% パッチペアの入力側をIHTによりスパース係数に置換．NSOLTはパーセバルタイト性 ($\mathbf{DD}^T=\mathbf{I}$) を満たすため正規化を省略．(The 
% input images of the patch pairs are replaced with sparse coefficients obtained 
% by IHT, where normalization is omitted for the Parseval tight property of NSOLT.)
% 
% $$\mathbf{s}^{(t+1)}\leftarrow \mathcal{H}_{T_K}\left(\mathbf{s}^{(t)}-\gamma 
% \hat{\mathbf{D}}^T\left(\hat{\mathbf{D}}\mathbf{s}^{(t)}-\mathbf{v}\right)\right)$$
% 
% $$t\leftarrow t+1$$
% 
% ただし，(where)
% 
% $$\mathcal{H}_{T_K}(\mathbf{x})=\mathrm{sgn}(\mathbf{x})\odot\max(\mathrm{abs}(\mathbf{x}),T_K\mathbf{1})$$
% 
% 【Reference】
%% 
% * T. Blumensath and M. E. Davies, "Normalized Iterative Hard Thresholding: 
% Guaranteed Stability and Performance," in IEEE Journal of Selected Topics in 
% Signal Processing, vol. 4, no. 2, pp. 298-309, April 2010, doi: 10.1109/JSTSP.2010.2042411.

function newds = iht4inputimage(oldds,analyzer,synthesizer,sparsityRatio)
% Loop to apply IHT process for every input patch
newds = oldds;
nImgs = length(oldds.InputImage);
for iImg = 1:nImgs
    v = dlarray(oldds.InputImage{iImg},'SSC');
    [~,coefs] = iht(v,analyzer,synthesizer,sparsityRatio);
    newds.InputImage{iImg} = coefs;
end
end

function [y,coefs] = iht(x,analyzer,synthesizer,sparsityRatio)
% Iterative hard thresholding w/o normalization
% (A Parseval tight frame is assumed)
gamma = (1.-1e-3);
nIters = 20;
nCoefs = floor(sparsityRatio*numel(x));
coefs = 0*analyzer.predict(x);
% IHT
for iter=1:nIters
    % Gradient descent
    y = synthesizer.predict(coefs);
    coefs = coefs - gamma*analyzer.predict(y-x);
    % Hard thresholding
    [~, idxsort ] = sort(abs(extractdata(coefs(:))),1,'descend');
    indexSet = idxsort(1:nCoefs);
    mask = zeros(size(coefs),'like',coefs);
    mask(indexSet) = 1;
    coefs = mask.*coefs;
    %
    %fprintf("IHT(%d) MSE: %6.4f",iter,mse(x,y));
end
end
% 分析辞書（随伴作用素）の設定
% (Setting up the analytical dictionary (adjoint operator))
% 
% 合成辞書パラメータの分析辞書（随伴作用素）へのコピー (Copying synthesis dictionary parameters to the 
% analyisis dictionary (the adjoint operator))

function newanalysisnet = copyparameters(synthesisnet,oldanalysisnet)
newanalysisnet = oldanalysisnet;
analysisLearnables = oldanalysisnet.Learnables;
synthesisLearnables = synthesisnet.Learnables;
nLearnables = height(analysisLearnables);
for iLearnable = 1:nLearnables
    t = synthesisLearnables.Value(nLearnables-iLearnable+1);
    newanalysisnet.Learnables.Value(iLearnable) = t; 
end
end
%% 
% © Copyright, Shogo MURAMATSU, All rights reserved.