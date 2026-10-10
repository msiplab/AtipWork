%[text] # Sample 7-2: Decimation
%[text] Advanced Topics in Image Processing, Lecture 7 "Geometric Image Processing"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Setting the downsampling ratio
%[text] - $M$: downsampling ratio \
% Downsampling ratio
dFactor = 2; %[control:slider:7cc0]{"position":[11,12]}

% Downsampling phase
dPhase = 1; %[control:slider:9f21]{"position":[10,11]}
%[text] Impulse response of the averaging filter with the phase $\\tau\_0=M-1$ (\[M\] Example "Block average" and Exercise "Type-I polyphase filter")
%[text]{"align":"center"} $h\[n\]=\\left\\{\\begin{array}{ll} \\frac{1}{M} & n\\in\\mathcal{N}\_\\mathrm{h}=\\tau\_0-\\mathcal{N}(M)=\\{0,1,\\ldots,M-1\\} \\\\ 0 & \\mathrm{otherwise} \\end{array}\\right.$
%[text] - $\\mathsf{h}=\\left(h\[n\]\\right)\_n$: impulse response \
% Impulse response of the averaging filter
h = ones(1,dFactor)/dFactor;
%%
%[text] ## Display of the filter characteristics
%[text] The red dotted line is the ideal anti-aliasing filter $H\_\\mathrm{I}(\\mathrm{e}^{\\mathrm{j}\\omega})$ with the cut-off $\\pi/M$.
% Impulse response
fig1 = figure;
impz(h)
ax = gca;
ax.XLim = [-1 length(h)];
ax.YLim = [-0.2 1];

% Frequency response
fig2 = figure;
freqz(h)
ax = gca;
hold(ax, 'on')
line(ax, [0 1/dFactor 1/dFactor],[0 0 ax.YLim(1)],...
    'LineStyle',':','LineWidth',2,'Color','red');
hold(ax, 'off')
%%
%[text] ## Application to images
%[text] Decimation (strided convolution, \[M\] Sec. 5.1.1)
%[text]{"align":"center"} $v\[\\boldsymbol{n}\]=\\sum\_{\\boldsymbol{m}\\in\\mathcal{N}\_\\mathrm{h}}h\[\\boldsymbol{m}\]x\[\\boldsymbol{M}\\boldsymbol{n}-\\boldsymbol{m}\]=\\frac{1}{|\\det(\\boldsymbol{M})|}\\sum\_{\\boldsymbol{m}\\in\\mathcal{N}(\\boldsymbol{M})}x\[\\boldsymbol{M}\\boldsymbol{n}-\\boldsymbol{m}\]$
%[text]{"align":"center"} $h\[\\boldsymbol{m}\]=\\left\\{\\begin{array}{ll} \\frac{1}{|\\det(\\boldsymbol{M})|} & \\boldsymbol{m}\\in \\mathcal{N}\_\\mathrm{h}=\\boldsymbol{\\tau}\_0-\\mathcal{N}(\\boldsymbol{M})=\\mathcal{N}(\\boldsymbol{M})\\\\ 0 & \\mathrm{otherwise} \\end{array}\\right.$, $\\boldsymbol{\\tau}\_0=(\\boldsymbol{M}-\\mathbf{I})\\mathbf{1}$
%[text] Note that $\\boldsymbol{M}=\\mathrm{diag}(M,M)\\Rightarrow |\\det(\\boldsymbol{M})|=M^2$ and $\\mathcal{N}(\\boldsymbol{M})=\\{0,1,\\cdots,M-1\\}^2$.
%[text] The filter is applied as a causal convolution (symmetric extension before the first sample).  The slider `dPhase` $=p$ picks
%[text] $v\[\\boldsymbol{M}\\boldsymbol{n}+p\\mathbf{1}\]$; with $p=M-1$ the averaged blocks $\\{Mn,\\ldots,Mn+M-1\\}^2$ are those of `imresize` with `'box'`.
% Reading an image
x = imread('cameraman.tif');

% Generating the average filter
h = fspecial('average',dFactor);
fig3 = figure;
stem3(0:(dFactor-1),0:dFactor-1,h,'filled')
axis ij
ax = gca;
ax.XLim = [-1 dFactor];
ax.YLim = [-1 dFactor];
fig4 = figure;
freqz2(h)
axis ij

% Bivariate downsampling function
downsample2 = @(x,n,phase) ...
    shiftdim(downsample(...
    shiftdim(downsample(x,...
    n(1),phase(1)),1),...
    n(2),phase(2)),1);

% Box averaging with causal filtering and downsampling (the phase must be less than M)
dPhase = mod(dPhase,dFactor);
xp = padarray(double(x),(dFactor-1)*[1 1],'symmetric','pre');
w = conv2(xp,h,'valid');                 % w[n] = sum_{m in N(M)} h[m] x[n-m]
v = uint8(downsample2(w,dFactor*[1 1],dPhase*[1 1]));

% Box averaging with IMRESIZE
y = imresize(x,1/dFactor,'box');
%%
%[text] ## Display of the images
%[text] Original
fig5 = figure;
imshow(x, 'Parent', axes(fig5))
title('Original')
%[text] Decimated images
% Definition of MSE (computed in double precision)
mymse = @(x,y) mean((double(x)-double(y)).^2,'all');

% Display results
fig6 = figure;
tl6 = tiledlayout(fig6, 1, 3, 'TileSpacing', 'compact');
ax = nexttile(tl6);
imshow(v, 'Parent', ax)
title(ax, 'Decimation w/o IMRESIZE')
ax = nexttile(tl6);
imshow(y, 'Parent', ax)
title(ax, 'Decimation w/ IMRESIZE')
ax = nexttile(tl6);
imshow(imabsdiff(v,y), 'Parent', ax)
title(ax, "Absolute difference (MSE = " + mymse(v,y) + ")")
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:7cc0]
%   data: {"defaultValue":2,"label":"dFactor","max":8,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:9f21]
%   data: {"defaultValue":1,"label":"dPhase","max":7,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
