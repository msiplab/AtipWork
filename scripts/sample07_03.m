%[text] # Sample 7-3: Interpolation
%[text] Advanced Topics in Image Processing, Lecture 7 "Geometric Image Processing"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Setting the upsampling ratio
%[text] - $M$: upsampling ratio \
% Upsampling ratio
uFactor = 2; %[control:slider:6af5]{"position":[11,12]}

% Upsampling phase
uPhase = 0; %[control:slider:05f3]{"position":[10,11]}
%[text] Impulse response of the nearest-neighbour (zero-order hold) filter with the phase $\\tau\_0=0$ (\[M\] Example "Nearest-neighbour interpolation")
%[text]{"align":"center"} $f\[n\]=\\left\\{\\begin{array}{ll} 1& 0\\leq n\\leq M-1 \\\\ 0 & \\mathrm{otherwise} \\end{array}\\right.$
%[text] Impulse response of the linear interpolation filter
%[text]{"align":"center"} $f\[n\]=\\left\\{\\begin{array}{ll} \\frac{1}{M}(M-|n|) & -M+1\\leq n\\leq M-1 \\\\ 0 & \\mathrm{otherwise} \\end{array}\\right.$
%[text] When considering the offset
%[text]{"align":"center"} $f\[n\]=\\left\\{\\begin{array}{ll} \\frac{1}{M}\\left(M-\\left|n-\\frac{1}{2}\\right|\\right) & -M+1\\leq n\\leq M \\\\ 0 & \\mathrm{otherwise} \\end{array}\\right.$
%[text] Note that these filters are non-causal.
%[text] - $\\mathsf{f}=\\left(f\[n\]\\right)\_n$: impulse response \
% Filter selection
ftype = "Nearest neighbor"; %[control:dropdown:8e2a]{"position":[9,27]}
offset = false; % Set TRUE for even M, FALSE for odd M to make the handmade bilinear interpolation similar to IMRESIZE %[control:dropdown:116e]{"position":[10,15]}

% Impulse response of the interpolation filter
if strcmp(ftype,'Nearest neighbor')
    f = ones(1,uFactor);
    offset = false;
elseif strcmp(ftype, 'Bilinear interpolation')
    if ~offset
         f = 1-abs((-uFactor+1):(uFactor-1))/uFactor;
    else
        f = 1-abs(((-uFactor+1):uFactor)-0.5)/uFactor;
    end
else
    error('Invalid ftype')
end
%%
%[text] ## Display of the filter characteristics
%[text] The red dotted line is the ideal anti-imaging filter $F\_\\mathrm{I}(\\mathrm{e}^{\\mathrm{j}\\omega})$ with the gain $M$ and the cut-off $\\pi/M$.
% Impulse response
fig1 = figure;
impz(f)
ax = gca;
ax.XLim = [-1 length(f)];
ax.YLim = [-0.2 1.2];
% Frequency response
fig2 = figure;
freqz(f)
ax = gca;
hold(ax, 'on')
line(ax, [0 1/uFactor 1/uFactor],[20*log10(uFactor) 20*log10(uFactor) ax.YLim(1)],...
    'LineStyle',':','LineWidth',2,'Color','red');
hold(ax, 'off')
%%
%[text] ## Application to images
%[text] Interpolation (transposed convolution, \[M\] Sec. 5.1.2)
%[text]{"align":"center"} $v\[\\boldsymbol{n}\]=\\sum\_{\\boldsymbol{m}\\in\\mathbb{Z}^2}x\[\\boldsymbol{m}\]f\[\\boldsymbol{n}-\\boldsymbol{M}\\boldsymbol{m}\]$
%[text] Impulse response of the nearest-neighbour filter
%[text]{"align":"center"} $f\[\\boldsymbol{n}\]=\\left\\{\\begin{array}{ll} 1 & \\boldsymbol{n}\\in \\mathcal{N}(\\boldsymbol{M})\\\\ 0 & \\mathrm{otherwise} \\end{array}\\right.$
%[text] Impulse response of the bilinear interpolation filter
%[text]{"align":"center"} $f\[\\boldsymbol{n}\]=\\left\\{\\begin{array}{ll} \\mathrm{prod}\\left(\\mathbf{1}-\\mathrm{abs}\\left(\\boldsymbol{M}^{-1}\\boldsymbol{n}\\right) \\right)& \\boldsymbol{n}\\in \\{\\boldsymbol{M}\\mathbf{r}\\in\\mathbb{Z}^2\\ |\\ \\mathbf{r}\\in(-1,1)^2\\} \\\\ 0 & \\mathrm{otherwise} \\end{array}\\right.$
%[text] When considering the offset
%[text]{"align":"center"} $f\[\\boldsymbol{n}\]=\\left\\{\\begin{array}{ll} \\mathrm{prod}\\left(\\mathbf{1}-\\mathrm{abs}\\left(\\boldsymbol{M}^{-1}\\boldsymbol{n}-\\frac{1}{2}\\mathbf{1}\\right) \\right)& \\boldsymbol{n}\\in \\{\\boldsymbol{M}\\mathbf{r}\\in\\mathbb{Z}^2\\ |\\ \\mathbf{r}\\in(-1,1\]^2\\} \\\\ 0 & \\mathrm{otherwise} \\end{array}\\right.$
%[text] where $\\mathrm{prod}(\\cdot)$ denotes the product of the array elements.  Note that the filters are non-causal.
%[text] If $\\boldsymbol{M}=\\mathrm{diag}(M,M)$, then $\\mathrm{prod}(\\mathbf{1}-\\mathrm{abs}(\\boldsymbol{M}^{-1}\\boldsymbol{n}-\\alpha\\mathbf{1}))=\\frac{1}{M^2}(M-|n\_1-\\alpha|)(M-|n\_2-\\alpha|)$, $\\{\\boldsymbol{M}\\mathbf{r}\\in\\mathbb{Z}^2\\ |\\ \\mathbf{r}\\in(-1,1)^2\\}=\\{-M+1,-M+2,\\cdots,M-1\\}^2$ and $\\{\\boldsymbol{M}\\mathbf{r}\\in\\mathbb{Z}^2\\ |\\ \\mathbf{r}\\in(-1,1\]^2\\}=\\{-M+1,-M+2,\\cdots,M\\}^2$.
% Reading an image
x = imread('cameraman.tif');

% Generating an interpolation filter
if strcmp(ftype,'Nearest neighbor')
    [n1,n2] = ndgrid(0:uFactor-1);
    f = ones(uFactor,uFactor);
elseif strcmp(ftype,'Bilinear interpolation')
    if ~offset
        [n1,n2] = ndgrid(-uFactor+1:uFactor-1);
        f = (1-abs(n1)/uFactor).*(1-abs(n2)/uFactor);
    else
        [n1,n2] = ndgrid(-uFactor+1:uFactor);
        f = (1-abs(n1-0.5)/uFactor).*(1-abs(n2-0.5)/uFactor);
    end
else
    error('Invalid ftype')
end
fig3 = figure;
stem3(n2,n1,f,'filled')
axis ij
ax = gca;
ax.XLim = ax.XLim + [-1 1];
ax.YLim = ax.YLim + [-1 1];
fig4 = figure;
freqz2(f)
axis ij
%%
%[text] ## Interpolation with zero insertion and filtering
% Bivariate upsampling function
upsample2 = @(x,n,phase) ...
    shiftdim(upsample(...
    shiftdim(upsample(x,...
    n(1),phase(1)),1),...
    n(2),phase(2)),1);

% Interpolation with upsampling and filtering (the phase must be less than M)
uPhase = mod(uPhase,uFactor);
xp = padarray(x,[1 1],'replicate','both');
w = imfilter(upsample2(xp,uFactor*[1 1],uPhase*[1 1]),f,'conv');
s = ceil(uFactor/2);
v = w(s+1:s+uFactor*size(x,1),s+1:s+uFactor*size(x,2));

% Interpolation with IMRESIZE
if strcmp(ftype,'Nearest neighbor')
    y = imresize(x,uFactor,'nearest');
elseif strcmp(ftype, 'Bilinear interpolation')
    y = imresize(x,uFactor,'bilinear');
else
    error('Invalid ftype')
end
%%
%[text] ## Display of the images
%[text] Original
fig5 = figure;
imshow(x, 'Parent', axes(fig5))
title('Original')
%[text] Interpolated images
% Definition of MSE (computed in double precision)
mymse = @(x,y) mean((double(x)-double(y)).^2,'all');

% Display results
fig6 = figure;
imshow(v, 'Parent', axes(fig6))
title('Interpolation w/o IMRESIZE')
fig7 = figure;
imshow(y, 'Parent', axes(fig7))
title('Interpolation w/ IMRESIZE')
fig8 = figure;
imshow(imabsdiff(v,y), 'Parent', axes(fig8))
title("Absolute difference (MSE = " + mymse(v,y) + ")")
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:6af5]
%   data: {"defaultValue":2,"label":"uFactor","max":8,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:05f3]
%   data: {"defaultValue":0,"label":"uPhase","max":7,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:dropdown:8e2a]
%   data: {"defaultValue":"\"Nearest neighbor\"","itemLabels":["Nearest neighbor","Bilinear interpolation"],"items":["\"Nearest neighbor\"","\"Bilinear interpolation\""],"label":"Filter type","run":"SectionToEnd"}
%---
%[control:dropdown:116e]
%   data: {"defaultValue":"false","itemLabels":["true","false"],"items":["true","false"],"label":"Offset","run":"SectionToEnd"}
%---
