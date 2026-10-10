%[text] # Sample 7-4: Resizing with a rational factor
%[text] Advanced Topics in Image Processing, Lecture 7 "Geometric Image Processing"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Setting the upsampling ratio
%[text] - $M\_\\mathrm{u}$: upsampling ratio \
% Upsampling ratio
uFactor = 5; %[control:slider:0262]{"position":[11,12]}
%[text] ## Setting the downsampling ratio
%[text] - $M\_\\mathrm{d}$: downsampling ratio \
% Downsampling ratio
dFactor = 3; %[control:slider:8a9a]{"position":[11,12]}
%%
%[text] ## Setting the filter
%[text] Impulse response of the averaging filter (anti-aliasing) with the phase $\\tau\_0=M\_\\mathrm{d}-1$ (\[M\] Exercise "Type-I polyphase filter")
%[text]{"align":"center"} $h\[n\]=\\left\\{\\begin{array}{ll} \\frac{1}{M\_\\mathrm{d}} & 0\\leq n\\leq M\_\\mathrm{d}-1 \\\\ 0 & \\mathrm{otherwise} \\end{array}\\right.$
%[text] - $\\mathsf{h}=\\left(h\[n\]\\right)\_n$: impulse response \
% Impulse response of the averaging filter
h = ones(1,dFactor)/dFactor;
%[text] Impulse response of the linear interpolation filter (anti-imaging)
%[text]{"align":"center"} $f\[n\]=\\left\\{\\begin{array}{ll} \\frac{1}{M\_\\mathrm{u}}(M\_\\mathrm{u}-|n|) & -M\_\\mathrm{u}+1\\leq n\\leq M\_\\mathrm{u}-1 \\\\ 0 & \\mathrm{otherwise} \\end{array}\\right.$
%[text] Note that the filter is non-causal.
%[text] - $\\mathsf{f}=\\left(f\[n\]\\right)\_n$: impulse response \
% Impulse response of the interpolation filter
f = 1-abs(-(uFactor-1):(uFactor-1))/uFactor;
%[text] Impulse response of the cascade filter $\\mathsf{T}\_\\mathrm{g}=\\mathsf{T}\_\\mathrm{h}\\circ\\mathsf{T}\_\\mathrm{f}$
%[text]{"align":"center"} $g\[n\]=(h\\ast f)\[n\]$
% Impulse response of the combination
g = conv(h,f);
%%
%[text] ## Display of the filter characteristics
%[text] The red dotted line is the ideal filter $G\_\\mathrm{I}(\\mathrm{e}^{\\mathrm{j}\\omega})$ with the gain $M\_\\mathrm{u}$ and the cut-off $\\min(\\pi/M\_\\mathrm{u},\\pi/M\_\\mathrm{d})$.
% Impulse response
fig1 = figure;
impz(g)
ax = gca;
ax.XLim = [-1 length(g)];
ax.YLim = [-0.2 1];

% Frequency response
fig2 = figure;
freqz(g)
ax = gca;
hold(ax, 'on')
line(ax, [0 min(1/uFactor,1/dFactor) min(1/uFactor,1/dFactor)],[20*log10(uFactor) 20*log10(uFactor) ax.YLim(1)],...
    'LineStyle',':','LineWidth',2,'Color','red');
hold(ax, 'off')
%%
%[text] ## Application to images
%[text] Resampling with a rational matrix $\\boldsymbol{Q}=\\boldsymbol{M}\_\\mathrm{u}^{-1}\\boldsymbol{M}\_\\mathrm{d}$ (\[M\] Sec. 5.1.3)
%[text]{"align":"center"} $y\[\\boldsymbol{n}\]=\\sum\_{\\boldsymbol{m}\\in\\mathbb{Z}^2}x\[\\boldsymbol{m}\]g\[\\boldsymbol{M}\_\\mathrm{d}\\boldsymbol{n}-\\boldsymbol{M}\_\\mathrm{u}\\boldsymbol{m}\]$
%[text] where
%[text]{"align":"center"} $g\[\\boldsymbol{n}\]=(h\\ast f)\[\\boldsymbol{n}\]$
%[text]{"align":"center"} $h\[\\boldsymbol{n}\]=\\left\\{\\begin{array}{ll} \\frac{1}{|\\det(\\boldsymbol{M}\_\\mathrm{d})|} & \\boldsymbol{n}\\in \\mathcal{N}(\\boldsymbol{M}\_\\mathrm{d})\\\\ 0 & \\mathrm{otherwise} \\end{array}\\right.$
%[text]{"align":"center"} $f\[\\boldsymbol{n}\]=\\left\\{\\begin{array}{ll} \\mathrm{prod}\\left(\\mathbf{1}-\\mathrm{abs}\\left(\\boldsymbol{M}\_\\mathrm{u}^{-1}\\boldsymbol{n}\\right) \\right)& \\boldsymbol{n}\\in \\{\\boldsymbol{M}\_\\mathrm{u}\\mathbf{r}\\in\\mathbb{Z}^2\\ |\\ \\mathbf{r}\\in(-1,1)^2\\} \\\\ 0 & \\mathrm{otherwise} \\end{array}\\right.$
%[text] Note that the filters are non-causal.
%[text] - $\\mathsf{g}=\\left(g\[\\boldsymbol{n}\]\\right)\_{\\boldsymbol{n}}$: impulse response \
% Reading an image
x = imread('cameraman.tif');

% Generating the bilinear interpolation filter
[n1,n2] = ndgrid(-uFactor+1:uFactor-1);
f = (1-abs(n1)/uFactor).*(1-abs(n2)/uFactor);

% Generating the average filter
h = fspecial('average',dFactor);

% Combination of h and f (IMFILTER below centres the combined kernel g; this changes only the phase of the
% resampling grid, not the frequency response)
g = conv2(f,h);
[n1,n2] = ndgrid(-uFactor-floor(dFactor/2)+1:uFactor+floor(dFactor/2)-1);

% Impulse response
fig3 = figure;
stem3(n2,n1,g,'filled')
axis ij
ax = gca;
ax.XLim = ax.XLim + [-1 1];
ax.YLim = ax.YLim + [-1 1];

% Frequency response
fig4 = figure;
freqz2(g)
axis ij

% Bivariate upsampling function
upsample2 = @(x,n) ...
    shiftdim(upsample(...
    shiftdim(upsample(x,...
    n(1)),1),...
    n(2)),1);

% Bivariate downsampling function
downsample2 = @(x,n) ...
    shiftdim(downsample(...
    shiftdim(downsample(x,...
    n(1)),1),...
    n(2)),1);

% Interpolation with upsampling and filtering, then downsampling
xp = padarray(x,[1 1],'replicate','both');
w = imfilter(upsample2(xp,uFactor*[1 1]),g,'conv');
s = ceil(uFactor/2);
yu = w(s+1:s+uFactor*size(x,1),s+1:s+uFactor*size(x,2));
y = downsample2(yu,dFactor*[1 1]);
%%
%[text] ## Display of the images
%[text] Original
fig5 = figure;
imshow(x, 'Parent', axes(fig5))
title('Original')
%[text] Result ($M\_\\mathrm{u}/M\_\\mathrm{d}$ times)
fig6 = figure;
imshow(y, 'Parent', axes(fig6))
title("Result (" + uFactor + "/" + dFactor + ")")
%%
%[text] Comparison with IMRESIZE
fig7 = figure;
z = imresize(x,uFactor/dFactor);
imshow(z, 'Parent', axes(fig7))
title('IMRESIZE')
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:0262]
%   data: {"defaultValue":5,"label":"uFactor","max":8,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:8a9a]
%   data: {"defaultValue":3,"label":"dFactor","max":8,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
