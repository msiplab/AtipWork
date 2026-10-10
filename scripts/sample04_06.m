%[text] # Sample 4-6: Circular convolution matrix
%[text] Advanced Topics in Image Processing, Lecture 4 "Linear Shift-Invariant Systems"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Univariate circular convolution
%[text] Assume a linear shift-invariant system $\\mathsf{T}(\\cdot)$ with a finite impulse response (FIR) $(h\[n\])\_{n\\in\\mathcal{N}\_\\mathrm{h}}$, $\\mathcal{N}\_\\mathrm{h}\\subset\\mathbb{Z}$.
%[text] With periodic extension, the response $(y\[n\])\_n$ of $\\mathsf{T}(\\cdot)$ to a sequence $(x\[n\])\_n$ is the univariate circular convolution with period $N\\in\\mathbb{N}$
%[text]{"align":"center"} $(y\[n\])\_n =\\mathsf{T}\\left((x\[n\])\_n\\right) = \\sum\_{m\\in\\mathcal{N}\_\\mathrm{h}}h\[m\]\\left(x\\left\[(\\!(n-m)\\!)\_N\\right\]\\right)\_n,$
%[text] where
%[text]{"align":"center"} $(\\!(n)\\!)\_N = n - N\\left\\lfloor N^{-1}n\\right\\rfloor$
%[text] denotes $n$ modulo $N$.
%[text] ### Signal generation
% Input sequence x[n] with a finite region of support
N = 6; %[control:slider:75f6]{"position":[5,6]}
xgen = "ramp"; %[control:dropdown:6784]{"position":[8,14]}
switch xgen
    case "ramp"
        x = 1:N
    otherwise
        x = randn(1,N)
end
%[text] ### Impulse response
h = [1 0 -1];
%[text] ### Definition of the map
% Map T as the circular convolution with h[n] (period N)
mapT = @(u) cconv(u,h,N);
%[text] ### Result of the mapping
y = mapT(x)
%%
%[text] ## Matrix representation of the univariate circular convolution
%[text] The univariate circular convolution is also represented by a matrix as
%[text]{"align":"center"} $\\mathbf{y}=\\mathbf{T}\\mathbf{x}.$
%[text] When the support $\\mathcal{N}\_\\mathrm{h}=\\{0,1,2\\}$ of the impulse response $(h\[n\])\_n$ is shorter than the support $\\Omega\_\\mathsf{x}=\\{0,1,2,3,4,5\\}$
%[text] of the input $(x\[n\])\_n$ and the period is $N=|\\Omega\_\\mathsf{x}|$, the output $(y\[n\])\_n$ has the support $\\Omega\_\\mathsf{y}=\\Omega\_\\mathsf{x}$, and
%[text]{"align":"center"} $\\mathbf{y}=\\mathrm{vec}\\left((y\[n\])\_n\\right)=\\begin{pmatrix}y\[0\]\\\\y\[1\]\\\\y\[2\]\\\\y\[3\]\\\\y\[4\]\\\\y\[5\]\\end{pmatrix},\\quad \\mathbf{x}=\\mathrm{vec}\\left((x\[n\])\_n\\right)=\\begin{pmatrix}x\[0\]\\\\x\[1\]\\\\x\[2\]\\\\x\[3\]\\\\x\[4\]\\\\x\[5\]\\end{pmatrix},$
%[text]{"align":"center"} $\\mathbf{T}=\\begin{pmatrix}h\[0\] & 0 & 0 & 0 & h\[2\] & h\[1\] \\\\ h\[1\] & h\[0\] & 0 & 0 & 0 & h\[2\] \\\\ h\[2\] & h\[1\] & h\[0\] & 0 & 0 & 0 \\\\ 0 & h\[2\] & h\[1\] & h\[0\] & 0 & 0 \\\\ 0 & 0 & h\[2\] & h\[1\] & h\[0\] & 0 \\\\ 0 & 0 & 0 & h\[2\] & h\[1\] & h\[0\]\\end{pmatrix}.$
%[text] ### Generation of the univariate circular convolution matrix
T = zeros(length(x));
for idx = 1:length(x)
    % Standard basis vector
    e = zeros(size(x),'like',x);
    e(idx) = 1;
    % Response to the standard basis vector
    T(:,idx) = mapT(e);
end
% Matrix representation of the univariate circular convolution
T
%%
%[text] ## Univariate circular convolution by a matrix operation
%[text] Along the commutative diagram, the circular convolution is computed as
%[text]{"align":"center"} $(y\[n\])\_n=\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}^{-1}\\left(\\mathbf{y}\\right)=\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}^{-1}\\left(\\mathbf{T}\\mathbf{x}\\right)=\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}^{-1}\\circ\\mathbf{T}\\,\\mathrm{vec}\_{\\Omega\_\\mathsf{x}}\\left((x\[n\])\_n\\right),$
%[text] that is,
%[text]{"align":"center"} $\\mathsf{T}=\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}^{-1}\\circ\\mathbf{T}\\,\\mathrm{vec}\_{\\Omega\_\\mathsf{x}}.$
% Column vectorization of x[n]
vecx = x(:);
% Matrix operation
vecy = T*vecx;
% Reshape the result into a row sequence
recy = reshape(vecy,[1 N])
%[text] ### Evaluation of the univariate circular convolution by the matrix operation
% Comparison between the map and the matrix operation
mymse = @(a,b) mean((double(a)-double(b)).^2,'all');
mymse(y,recy)
%%
%[text] ## Bivariate circular convolution
%[text] Assume a linear shift-invariant system $\\mathsf{T}(\\cdot)$ with a bivariate FIR $(h\[\\boldsymbol{n}\])\_{\\boldsymbol{n}\\in\\mathcal{N}\_\\mathrm{h}}$, $\\mathcal{N}\_\\mathrm{h}\\subset\\mathbb{Z}^2$.
%[text] With periodic extension, the response $(y\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}$ of $\\mathsf{T}(\\cdot)$ to an array $(x\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}$ is the bivariate circular convolution
%[text] with the periodic structure matrix $\\boldsymbol{N}\\in\\mathbb{Z}^{2\\times 2}$ ($\\det\\boldsymbol{N}\\neq 0$)
%[text]{"align":"center"} $(y\[\\boldsymbol{n}\])\_{\\boldsymbol{n}} =\\mathsf{T}\\left((x\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}\\right) = \\sum\_{\\boldsymbol{m}\\in\\mathcal{N}\_\\mathrm{h}}h\[\\boldsymbol{m}\]\\left(x\\left\[(\\!(\\boldsymbol{n}-\\boldsymbol{m})\\!)\_{\\boldsymbol{N}}\\right\]\\right)\_{\\boldsymbol{n}},$
%[text] where
%[text]{"align":"center"} $(\\!(\\boldsymbol{n})\\!)\_{\\boldsymbol{N}} = \\boldsymbol{n} - \\boldsymbol{N}\\left\\lfloor \\boldsymbol{N}^{-1}\\boldsymbol{n}\\right\\rfloor$
%[text] denotes $\\boldsymbol{n}$ modulo $\\boldsymbol{N}$.  Each term is a circular shift of $\\mathsf{x}$ by $\\boldsymbol{m}$ weighted by $h\[\\boldsymbol{m}\]$
%[text] (see the local function `cconv2` at the end).
%[text] ### Signal generation
% Input array x[n1,n2] with a finite region of support
N1 = 2; % # of rows %[control:slider:1cd8]{"position":[6,7]}
N2 = 3; % # of columns %[control:slider:5f9f]{"position":[6,7]}
xgen = "ramp"; %[control:dropdown:9b11]{"position":[8,14]}
switch xgen
    case "ramp"
        x = reshape(0:N1*N2-1,[N1 N2])
    otherwise
        x = randn(N1,N2)
end
%[text] ### Impulse response
h = [1 -1 ; 1 -1]
figure
stem3(h,'filled')
axis ij
title('Impulse response')
%[text] ### Definition of the map
% Map T as the circular convolution with h[n] (N = diag(N1,N2))
mapT = @(u) cconv2(u,h);
%[text] ### Result of the mapping
y = mapT(x)
%[text] `imfilter` with the option `'conv'` rotates the kernel by $180^\\circ$ and puts the origin at the element
%[text] `floor((size(h)+1)/2)` of the rotated kernel, i.e., at `h(2,2)` ($h\[1,1\]$) for the $2\\times 2$ kernel.
%[text] With `'circular'`, its output is therefore $\\mathsf{y}$ circularly shifted by $(-1,-1)$.
yimf = imfilter(x,h,'conv','circular')
mymse(yimf,circshift(y,[-1 -1]))
%%
%[text] ## Matrix representation of the bivariate circular convolution
%[text] The bivariate circular convolution is also represented by a matrix as
%[text]{"align":"center"} $\\mathbf{y}=\\mathbf{T}\\mathbf{x}.$
%[text] When the support $\\mathcal{N}\_\\mathrm{h}=\\{0,1\\}\\times \\{0,1\\}$ of the impulse response $(h\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}$ is narrower than the support
%[text] $\\Omega\_\\mathsf{x}=\\{0,1\\}\\times \\{0,1,2\\}$ of the input $(x\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}$ and the periodic structure matrix is
%[text] $\\boldsymbol{N}=\\begin{bmatrix}N\_1 & 0 \\\\ 0 & N\_2\\end{bmatrix}=\\begin{bmatrix}2 & 0 \\\\ 0 & 3\\end{bmatrix}$, the output $(y\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}$ has the support $\\Omega\_\\mathsf{y}=\\Omega\_\\mathsf{x}$, and
%[text]{"align":"center"} $\\mathbf{y}=\\mathrm{vec}\\left((y\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}\\right)=\\begin{pmatrix}y\[0,0\]\\\\y\[1,0\]\\\\y\[0,1\]\\\\y\[1,1\]\\\\y\[0,2\]\\\\y\[1,2\]\\end{pmatrix},\\quad \\mathbf{x}=\\mathrm{vec}\\left((x\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}\\right)=\\begin{pmatrix}x\[0,0\]\\\\x\[1,0\]\\\\x\[0,1\]\\\\x\[1,1\]\\\\x\[0,2\]\\\\x\[1,2\]\\end{pmatrix},$
%[text]{"align":"center"} $\\mathbf{T}=\\begin{pmatrix}h\[0,0\] & h\[1,0\] & 0 & 0 & h\[0,1\] & h\[1,1\] \\\\ h\[1,0\] & h\[0,0\] & 0 & 0 & h\[1,1\] & h\[0,1\] \\\\ h\[0,1\] & h\[1,1\] & h\[0,0\] & h\[1,0\] & 0 & 0 \\\\ h\[1,1\] & h\[0,1\] & h\[1,0\] & h\[0,0\] & 0 & 0 \\\\ 0 & 0 & h\[0,1\] & h\[1,1\] & h\[0,0\] & h\[1,0\] \\\\ 0 & 0 & h\[1,1\] & h\[0,1\] & h\[1,0\] & h\[0,0\]\\end{pmatrix}.$
%[text] ### Generation of the bivariate circular convolution matrix
T = zeros(numel(x),numel(x));
for idx = 1:numel(x)
    % Standard basis array
    e = zeros(size(x),'like',x);
    e(idx) = 1;
    % Response to the standard basis array
    T(:,idx) = reshape(mapT(e),[size(T,1) 1]);
end
% Matrix representation of the circular convolution
T
%%
%[text] ## Bivariate circular convolution by a matrix operation
%[text] Along the commutative diagram, the circular convolution is computed as
%[text]{"align":"center"} $(y\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}=\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}^{-1}\\left(\\mathbf{y}\\right)=\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}^{-1}\\left(\\mathbf{T}\\mathbf{x}\\right)=\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}^{-1}\\circ\\mathbf{T}\\,\\mathrm{vec}\_{\\Omega\_\\mathsf{x}}\\left((x\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}\\right),$
%[text] that is,
%[text]{"align":"center"} $\\mathsf{T}=\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}^{-1}\\circ\\mathbf{T}\\,\\mathrm{vec}\_{\\Omega\_\\mathsf{x}}.$
% Column vectorization of x[n]
vecx = x(:);
% Matrix operation
vecy = T*vecx;
% Reshape the result into the output array
recy = reshape(vecy,[N1 N2])
%[text] ### Evaluation of the bivariate circular convolution by the matrix operation
% Comparison between the map and the matrix operation
mymse(y,recy)
%%
%[text] ## Local function
%[text] Bivariate circular convolution with $\\boldsymbol{N}=\\mathrm{diag}(N\_1,N\_2)$ given by the size of `x`:
%[text] $\\mathsf{y}=\\sum\_{\\boldsymbol{m}}h\[\\boldsymbol{m}\]\\left(x\[(\\!(\\boldsymbol{n}-\\boldsymbol{m})\\!)\_{\\boldsymbol{N}}\]\\right)\_{\\boldsymbol{n}}$, where `circshift(x,m)` gives $\\left(x\[(\\!(\\boldsymbol{n}-\\boldsymbol{m})\\!)\_{\\boldsymbol{N}}\]\\right)\_{\\boldsymbol{n}}$.
function y = cconv2(x,h)
y = zeros(size(x),'like',x);
for m2 = 0:size(h,2)-1
    for m1 = 0:size(h,1)-1
        y = y + h(m1+1,m2+1)*circshift(x,[m1 m2]);
    end
end
end
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:75f6]
%   data: {"defaultValue":6,"label":"N","max":16,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:dropdown:6784]
%   data: {"defaultValue":"\"ramp\"","itemLabels":["1:N","randn(1,N)"],"items":["\"ramp\"","\"random\""],"label":"Input","run":"SectionToEnd"}
%---
%[control:slider:1cd8]
%   data: {"defaultValue":2,"label":"N1","max":6,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:5f9f]
%   data: {"defaultValue":3,"label":"N2","max":6,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:dropdown:9b11]
%   data: {"defaultValue":"\"ramp\"","itemLabels":["reshape(0:N1*N2-1,[N1 N2])","randn(N1,N2)"],"items":["\"ramp\"","\"random\""],"label":"Input","run":"SectionToEnd"}
%---
