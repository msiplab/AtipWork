%[text] # Lecture 13: Dictionary Learning
%[text] Shogo Muramatsu, "Advanced Topics in Image Processing"
%[text] Verified: MATLAB R2026b
%[text] This script makes all figures and numbers of the slides of lecture 13 (atip2027-13).
%[text] The notation follows the reference text \[M\] (MsipText), Chapter 9 (dictionary learning) and
%[text] Chapter 10 (learned restoration): data $\\{\\mathbf{x}\_i\\}\_{i=1}^S$, dictionary $\\boldsymbol{\\Phi}$,
%[text] coefficients $\\mathbf{y}\_i$, convolutional dictionary $\\mathbf{D}\_{\\boldsymbol{\\theta}}$, step size $\\eta$.
%[text] The NSOLT examples need SaivDr (`msip.saivdr_setup` downloads it into the folder `code`).
%[text:tableOfContents]{"heading":"Contents"}
%%
%[text] ## Preparation
[datfolder,resfolder] = atip.prjfolders();
cmain = [0 136 85]/255;     % main (green) #008855
ccool = [46 117 182]/255;   % cool (blue)  #2E75B6
cwarm = [197 90 17]/255;    % warm (orange) #C55A11
cgray = [0.5 0.5 0.5];
mat2tex = @(A,fmt) "\begin{pmatrix}" + atip.arr2tex(A,fmt) + "\end{pmatrix}";
%%
%[text] ## Block KLT (Exercise "Block KLT" of \[M\] Section 9.2.2)
%[text] The $4\\times 6$ array is divided into $2\\times 2$ non-overlapping blocks $\\{\\mathbf{x}\_b\\}\_{b=1}^6$.
X = [5 5 7 6 7 2; 6 2 3 2 7 2; 2 2 4 4 4 6; 4 4 4 4 1 2];
szBlk = [2 2];
Xb = im2col(X,szBlk,"distinct");          % column b = vec(x_b) (column-major)
mux = mean(Xb,2);
Xc = Xb - mux;                             % centered data
S = size(Xb,2);
SigmaX = (Xc*Xc.')/S                       % sample covariance matrix (1/S)
[Phi,Lambda] = eig(SigmaX);
[lambdas,idx] = sort(diag(Lambda),"descend");
Phi = Phi(:,idx);
% Signs as in the text: u_0 with a negative element (2,1) (= -0.81), u_1 with a positive element (1,1) (= 0.79)
if Phi(2,1) > 0, Phi(:,1) = -Phi(:,1); end
if Phi(1,2) < 0, Phi(:,2) = -Phi(:,2); end
assert(all(abs(lambdas.' - [5.53 4.28 0.57 0.26]) < 0.01))
U0 = reshape(Phi(:,1),szBlk); U1 = reshape(Phi(:,2),szBlk);
assert(norm(U0 - [-0.24 0.54; -0.81 -0.01]) < 0.02)       % values and signs of the text
assert(norm(U1 - [0.79 0.47; 0.08 -0.39]) < 0.02)
K = 2;                                     % zonal coding with two basis images
Ychk = Phi(:,1:K).'*Xc;
Xapprox = col2im(Phi(:,1:K)*Ychk + mux,szBlk,size(X),"distinct")
assert(abs(Xapprox(1,1)-5.82) < 0.01 && abs(Xapprox(4,6)-2.56) < 0.01)
atip.savetex("atip-13-klt-x",       mat2tex(X,"%d"));
atip.savetex("atip-13-klt-lambda",  strjoin(compose("%.2f",lambdas),",\ "));
atip.savetex("atip-13-klt-u0",      mat2tex(U0,"%.2f"));
atip.savetex("atip-13-klt-u1",      mat2tex(U1,"%.2f"));
atip.savetex("atip-13-klt-approx",  mat2tex(Xapprox,"%.2f"));
%%
%[text] ## Block k-SVD (Exercise "Block k-SVD" of \[M\] Section 9.3.2)
%[text] $P=5$ atoms ($M=4$), $K=1$, initial dictionary: $2\\times2$ DCT basis and the first centered block, 10 iterations.
PhiK = zeros(4,5);
k = 0;
for iRow = 1:2                             % DCT basis images in the order of the text
    for iCol = 1:2
        k = k + 1;
        E = zeros(szBlk); E(iRow,iCol) = 1;
        PhiK(:,k) = reshape(idct2(E),[],1);
    end
end
PhiK(:,5) = Xc(:,1);
PhiK0 = PhiK;
nItersK = 10;
for iter = 1:nItersK
    Yk = zeros(5,S);
    for i = 1:S
        Yk(:,i) = omp(Xc(:,i),PhiK,1);     % sparse approximation step
    end
    for p = 1:5                            % dictionary update step (rank-1 approximation)
        Jp = find(Yk(p,:));
        if isempty(Jp), continue, end
        others = setdiff(1:5,p);
        Ep = Xc(:,Jp) - PhiK(:,others)*Yk(others,Jp);
        [Uu,Ss,Vv] = svd(Ep,"econ");
        PhiK(:,p) = Uu(:,1);
        Yk(p,Jp) = Ss(1,1)*Vv(:,1).';
    end
end
PhiK
Yk
XapproxK = col2im(PhiK*Yk + mux,szBlk,size(X),"distinct")
assert(abs(XapproxK(1,3)-7.05) < 0.02 && abs(XapproxK(4,6)-2.70) < 0.02)
assert(norm(PhiK(:,2)-[-0.39;-0.76;0.51;0.01]) < 0.02)   % learned atom of the text
mseKsvd = mean((XapproxK-X).^2,"all");
mseKlt  = mean((Xapprox-X).^2,"all");
atip.savetex("atip-13-ksvd-phi",    mat2tex(PhiK,"%.2f"));
atip.savetex("atip-13-ksvd-mse",    sprintf("%.2f",mseKsvd));
atip.savetex("atip-13-klt-mse",     sprintf("%.2f",mseKlt));
%%
%[text] ## Contrast function of RICA
%[text] $\\frac{1}{2}\\log\\circ\\cosh(2y)$ is a differentiable surrogate of $|y|$.
fig = figure(Units="centimeters", Position=[2 2 5.0 4.0], Color="w");
ax = axes(fig);
yy = linspace(-3,3,601);
plot(ax,yy,abs(yy),":","Color",cgray,"LineWidth",1.2), hold(ax,"on")
plot(ax,yy,log(cosh(2*yy))/2,"-","Color",cwarm,"LineWidth",1.2), hold(ax,"off")
grid(ax,"on"), set(ax,"FontSize",8), axis(ax,[-3 3 0 3])
xlabel(ax,"$y$","Interpreter","latex")
lg = legend(ax,["$|y|$","$\frac{1}{2}\log\cosh(2y)$"],"Interpreter","latex","Location","northoutside", ...
    "NumColumns",2,"Box","off","FontSize",7);    % outside the axes: no overlap with the curves
lg.ItemTokenSize = [12 8];
drawnow                                          % close the gap MATLAB leaves below a northoutside legend
lp = lg.Position; ap = ax.Position;
lg.Location = "none";
ax.Position = [ap(1) ap(2) ap(3) lp(2)-ap(2)-0.02];
lg.Position = lp;
exportgraphics(fig, fullfile(resfolder,"atip-13-logcosh.png"), "Resolution", 300)
close(fig)
%%
%[text] ## Hard thresholding
%[text] $\\phi\_\\mathrm{HT}(\\mathbf{s}';\\tau\_K)$ keeps the entries with $|s'\_i|>\\tau\_K$, where $\\tau\_K$ is the $(K+1)$-th largest absolute value
%[text] (equivalently, the $K$ entries of the largest magnitudes are kept).
sv = [0.3 -1.2 0.5 2.0 -0.1];
Kht = 2;
srt = sort(abs(sv),"descend");
tauK = srt(Kht+1);
sht = sv.*(abs(sv) > tauK)
assert(nnz(sht) == Kht && isequal(sht,[0 -1.2 0 2.0 0]))
atip.savetex("atip-13-ht-s",   "\tr{(" + strjoin(compose("%.1f",sv),"\ \ ") + ")}");
atip.savetex("atip-13-ht-tau", sprintf("%.1f",tauK));
sht(sht == 0) = 0;                         % avoid "-0.0"
atip.savetex("atip-13-ht-out", "\tr{(" + strjoin(compose("%.1f",sht),"\ \ ") + ")}");
%%
%[text] ## Back propagation for a cascaded dictionary
%[text] $\\mathbf{D}\_{\\boldsymbol{\\theta}}=\\mathbf{F}\_1\\mathbf{F}\_2$ with rotations $\\mathbf{F}\_i=\\mathbf{R}\_{\\theta\_i}$ and $\\partial\\mathbf{R}\_\\theta/\\partial\\theta=\\mathbf{R}\_{\\theta+\\pi/2}$:
%[text] $\[\\nabla\\mathfrak{L}\]\_1=-\\langle\\mathbf{r},(\\partial\\mathbf{F}\_1)\\mathbf{F}\_2\\hat{\\mathbf{y}}\\rangle$,
%[text] $\[\\nabla\\mathfrak{L}\]\_2=-\\langle\\mathbf{F}\_1^\\top\\mathbf{r},(\\partial\\mathbf{F}\_2)\\hat{\\mathbf{y}}\\rangle$ (back propagation), compared with finite differences.
R = @(t) [cos(t) -sin(t); sin(t) cos(t)];
theta = [0.3 -0.5];
xt = [0.2; 0.9];
yh = [1; 0.5];
lossfcn = @(th) 0.5*norm(xt - R(th(1))*R(th(2))*yh)^2;
r = xt - R(theta(1))*R(theta(2))*yh;
gbp = [-dot(r, R(theta(1)+pi/2)*R(theta(2))*yh), ...
       -dot(R(theta(1)).'*r, R(theta(2)+pi/2)*yh)];
h = 1e-6;
gfd = [(lossfcn(theta+[h 0])-lossfcn(theta-[h 0]))/(2*h), ...
       (lossfcn(theta+[0 h])-lossfcn(theta-[0 h]))/(2*h)];
errBp = max(abs(gbp-gfd))
assert(errBp < 1e-8)
atip.savetex("atip-13-bp-grad", "\tr{(" + strjoin(compose("%.4f",gbp),"\ \ ") + ")}");
atip.savetex("atip-13-bp-err",  sci2tex(errBp));
%%
%[text] ## GD and SGD
%[text] Linear regression $\\mathfrak{L}(\\boldsymbol{\\theta})=\\frac{1}{S}\\sum\_{n=1}^S\\frac{1}{2}(x^{\[n\]}-\\mathbf{a}\_n^\\top\\boldsymbol{\\theta})^2$ with $S=200$ samples.
%[text] GD uses all samples in each step; SGD uses mini-batches of 5 samples (the same number of epochs).
rng(1)
Sd = 200;
A = randn(Sd,2)*[1.0 0; 0.6 0.35];
thetaTrue = [1.2; -0.8];
xd = A*thetaTrue + 0.1*randn(Sd,1);
lossd = @(th) 0.5*mean((xd - A*th).^2);
thetaLs = A\xd;
etaG = 0.5; nEpochs = 10; batch = 5;
th0 = [-1.5; 1.5];
pathGD = th0; th = th0;
for ep = 1:nEpochs
    th = th - etaG*(-A.'*(xd - A*th)/Sd);
    pathGD(:,end+1) = th; %#ok<AGROW>
end
pathSGD = th0; th = th0;
etaS = 0.1;
for ep = 1:nEpochs
    perm = randperm(Sd);
    for b = 1:batch:Sd
        nb = perm(b:b+batch-1);
        th = th - etaS*(-A(nb,:).'*(xd(nb) - A(nb,:)*th)/batch);
        pathSGD(:,end+1) = th; %#ok<AGROW>
    end
end
lossGD = lossd(pathGD(:,end)) - lossd(thetaLs)
lossSGD = lossd(pathSGD(:,end)) - lossd(thetaLs)
atip.savetex("atip-13-gd-gap",  sci2tex(lossGD));
atip.savetex("atip-13-sgd-gap", sci2tex(lossSGD));
atip.savetex("atip-13-sgd-steps", sprintf("%d",size(pathSGD,2)-1));
[T1,T2] = meshgrid(linspace(-2,2.5,181),linspace(-2.5,2,181));
Lg = arrayfun(@(a,b) lossd([a;b]),T1,T2);
fig = figure(Units="centimeters", Position=[2 2 8.4 3.9], Color="w");
tl = tiledlayout(fig,1,2,"TileSpacing","compact","Padding","compact");
paths = {pathGD, pathSGD}; names = ["GD (10 steps)","SGD (mini-batch 5)"]; cols = {cwarm, ccool};
for k = 1:2
    ax = nexttile(tl);
    contour(ax,T1,T2,Lg,logspace(-2,0.6,9),"Color",[0.75 0.75 0.75]), hold(ax,"on")
    plot(ax,paths{k}(1,:),paths{k}(2,:),"-","Color",cols{k},"LineWidth",0.8)
    plot(ax,paths{k}(1,:),paths{k}(2,:),".","Color",cols{k},"MarkerSize",4)
    plot(ax,thetaLs(1),thetaLs(2),"p","Color",cmain,"MarkerFaceColor",cmain,"MarkerSize",6)
    hold(ax,"off"), axis(ax,"equal"), axis(ax,[-2 2.5 -2.5 2]), set(ax,"FontSize",7)
    xlabel(ax,"$\theta_1$","Interpreter","latex"), ylabel(ax,"$\theta_2$","Interpreter","latex")
    title(ax,names(k),"FontSize",8,"FontWeight","normal")
end
exportgraphics(fig, fullfile(resfolder,"atip-13-sgd.png"), "Resolution", 300)
close(fig)
%%
%[text] ## NSOLT dictionary learned in 2023 (SaivDr)
%[text] The dictionary `nsoltdictionary_20230705164652136.mat` in the data folder was learned by sample13\_04
%[text] (type-I NSOLT, $\\tau$-level tree, convolutional dictionary learning with IHT and SGD).
msip.saivdr_setup(false);
dic = load(fullfile(datfolder,"nsoltdictionary_20230705164652136.mat"));
analysisnet = dic.analysisnet;
synthesisnet = dic.synthesisnet;
nLevels = dic.nLevels;
[decFactor,nChannels] = nsoltconfig(synthesisnet);
%[text] Atomic images: a unit impulse is put at the centre of each channel of each level and synthesized.
%[text] Each row is a tree level (level 1 at the top); each atom is cropped to the support of its level
%[text] and scaled to $\[-1,1\]\\to\[0,1\]$.
szAt = [256 256];
snetA = resizenet(synthesisnet,szAt,decFactor,nChannels,nLevels,"synthesis");
inNames = string(snetA.InputNames);
nAc = sum(nChannels)-1;
szTile = 48; gap = 4;
canvas = ones(nLevels*(szTile+gap)-gap, 8*(szTile+gap)-gap);
for lv = 1:nLevels
    targets = struct("name",{},"ch",{});
    if lv == nLevels
        targets(end+1) = struct("name","Lv"+lv+"_Dc feature input","ch",1); %#ok<AGROW>
    end
    for ch = 1:nAc
        targets(end+1) = struct("name","Lv"+lv+"_Ac feature input","ch",ch); %#ok<AGROW>
    end
    atoms = cell(1,numel(targets));
    for t = 1:numel(targets)
        c = cell(1,numel(inNames));
        for k = 1:numel(inNames)
            lvk = sscanf(extractAfter(inNames(k),"Lv"),"%d");
            szk = szAt./decFactor.^lvk;
            nch = 1 + (nAc-1)*contains(inNames(k),"Ac");
            z = zeros([szk nch],"single");
            if inNames(k) == targets(t).name
                z(szk(1)/2,szk(2)/2,targets(t).ch) = 1;
            end
            c{k} = dlarray(z,"SSCB");
        end
        atoms{t} = extractdata(predict(snetA,c{:}));
    end
    mx = max(abs(cat(3,atoms{:})),[],3);
    [ri,ci] = find(mx > 1e-3*max(mx(:)));
    for t = 1:numel(targets)
        a = atoms{t}(min(ri):max(ri),min(ci):max(ci));
        a = imresize(a/max(abs(a(:)))/2+0.5,[szTile szTile],"nearest");
        col0 = 8 - numel(targets) + t;     % right aligned (the DC atom is first)
        canvas((lv-1)*(szTile+gap)+(1:szTile),(col0-1)*(szTile+gap)+(1:szTile)) = a;
    end
end
imwrite(canvas, fullfile(resfolder,"atip-13-nsolt-atoms.png"))
atip.savetex("atip-13-nsolt-levels", sprintf("%d",nLevels));
atip.savetex("atip-13-nsolt-dec",    sprintf("%d\\times %d",decFactor));
atip.savetex("atip-13-nsolt-ch",     sprintf("%d+%d",nChannels));
%%
%[text] ## Single-image super-resolution with the NSOLT dictionary (as sample13\_05)
%[text] $\\mathbf{v}=\\mathbf{H}\\mathbf{x}+\\mathbf{w}$ with the Gaussian blur ($\\sigma\_\\mathrm{h}=2$) and $2\\times2$ downsampling,
%[text] AWGN $\\sigma\_\\mathrm{w}=5/255$.  ISTA: $\\lambda=10^{-3}$, 100 iterations, approximation (DC) coefficients not thresholded.
x = im2single(im2gray(imread(fullfile(datfolder,"kodim23.png"))));
szOrg = size(x);
hg = fspecial("gaussian",9,2);
linproc = @(u) downsamp(imfilter(u,hg,"conv","circ"));
adjproc = @(u) imfilter(upsamp(u),hg,"corr","circ");
Ht = fftn(hg,2.^nextpow2(szOrg));
kappa = max(abs(Ht(:)).^2);                % ||H||_S^2 (upper bound)
rng(0)
v = imnoise(linproc(x),"gaussian",0,(5/255)^2);
xbic = imresize(v,2,"bicubic");
psnrBic = psnr(xbic,x)
% Networks for the whole image (dlnetwork with replaced input layers)
anet = resizenet(analysisnet,szOrg,decFactor,nChannels,nLevels,"analysis");
snet = resizenet(synthesisnet,szOrg,decFactor,nChannels,nLevels,"synthesis");
nOut = nLevels+1;
c = cell(1,nOut); g = cell(1,nOut);       % subband coefficients and gradients
xt = dlarray(rand(szOrg,"single"),"SSCB");
[c{1:nOut}] = predict(anet,xt);
errPr = mean((extractdata(predict(snet,c{:}))-extractdata(xt)).^2,"all")
assert(errPr < 1e-8)                       % Parseval tight frame (perfect reconstruction)
lambda = 1e-3; eta = 2/(kappa+1e-2); nIters = 100;
[c{1:nOut}] = predict(anet,dlarray(zeros(szOrg,"single"),"SSCB"));
for iter = 1:nIters
    u = extractdata(predict(snet,c{:}));
    [g{1:nOut}] = predict(anet,dlarray(adjproc(linproc(u)-v),"SSCB"));
    for k = 1:nOut
        c{k} = c{k} - eta*g{k};
        if k < nOut                        % soft thresholding except the DC coefficients
            c{k} = sign(c{k}).*max(abs(c{k})-eta*lambda,0);
        end
    end
end
xsr = extractdata(predict(snet,c{:}));
psnrNsolt = psnr(xsr,x)
rr = 81:336; cc = 257:512;                 % 256x256 region for the slide
imwrite(imresize(v(ceil(rr(1)/2):rr(end)/2,ceil(cc(1)/2):cc(end)/2),2,"nearest"), fullfile(resfolder,"atip-13-sr-obs.png"))
imwrite(x(rr,cc),     fullfile(resfolder,"atip-13-sr-org.png"))
imwrite(xbic(rr,cc),  fullfile(resfolder,"atip-13-sr-bic.png"))
imwrite(min(max(xsr(rr,cc),0),1), fullfile(resfolder,"atip-13-sr-nsolt.png"))
atip.savetex("atip-13-sr-psnr-bic",   sprintf("%.2f",psnrBic));
atip.savetex("atip-13-sr-psnr-nsolt", sprintf("%.2f",psnrNsolt));
atip.savetex("atip-13-sr-size",       sprintf("%d\\times %d",szOrg));
%%
%[text] ## Functions
function x = omp(y,Phi,nCoefs)
% Orthogonal matching pursuit (atoms need not be normalized)
nAtoms = size(Phi,2);
x = zeros(nAtoms,1);
r = y;
supp = [];
for k = 1:nCoefs
    rest = setdiff(1:nAtoms,supp);
    g = Phi(:,rest).'*r;
    e = r.'*r - g.^2./sum(Phi(:,rest).^2,1).';   % residual energy after adding each atom
    [~,imin] = min(e);
    supp = union(supp,rest(imin));
    x(supp) = pinv(Phi(:,supp))*y;
    r = y - Phi*x;
end
end

function y = downsamp(x)
y = x(1:2:end,1:2:end,:);
end

function y = upsamp(x)
y = zeros(2*size(x,1),2*size(x,2),size(x,3),"like",x);
y(1:2:end,1:2:end,:) = x;
end

function [decFactor,nChannels] = nsoltconfig(net)
% Decimation factor and numbers of channels from the final rotation layer of level 1
decFactor = []; nChannels = [];
for iLayer = 1:numel(net.Layers)
    layer = net.Layers(iLayer);
    if ~isempty(regexp(layer.Name,'^Lv1_Cmp1+_V0~?$','once'))
        decFactor = layer.DecimationFactor;
        nChannels = layer.NumberOfChannels;
    end
end
end

function net = resizenet(net,szOrg,decFactor,nChannels,nLevels,mode)
% Replace the input layers of an NSOLT dlnetwork for the image size szOrg
for iLayer = 1:numel(net.Layers)
    name = string(net.Layers(iLayer).Name);
    if mode == "analysis" && name == "Image input"
        net = replaceLayer(net,name,imageInputLayer([szOrg 1],"Name",name,"Normalization","none"));
    elseif mode == "synthesis" && contains(name,"Ac feature input")
        iLv = sscanf(extractAfter(name,"Lv"),"%d");
        net = replaceLayer(net,name,imageInputLayer([szOrg./decFactor.^iLv sum(nChannels)-1], ...
            "Name",name,"Normalization","none"));
    elseif mode == "synthesis" && contains(name,"Lv"+nLevels+"_Dc feature input")
        net = replaceLayer(net,name,imageInputLayer([szOrg./decFactor.^nLevels 1], ...
            "Name",name,"Normalization","none"));
    end
end
net = initialize(net);
end

function s = sci2tex(v)
% Number in the form a\times10^{b} for LaTeX (math mode)
e = floor(log10(abs(v)));
m = v/10^e;
if e == 0
    s = sprintf("%.2f",v);
else
    s = sprintf("%.1f\\times10^{%d}",m,e);
end
end
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
