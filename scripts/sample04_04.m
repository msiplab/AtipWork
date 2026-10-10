%[text] # Sample 4-4: Circular shift
%[text] Advanced Topics in Image Processing, Lecture 4 "Linear Shift-Invariant Systems"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Univariate circular shift
%[text] The circular shift of a sequence $(x\[n\])\_{n\\in\\Omega\_\\mathsf{x}}$ with a finite region of support $\\Omega\_\\mathsf{x}\\subset\\mathbb{Z}$ is
%[text]{"align":"center"} $(y\[n\])\_n =\\mathsf{T}\\left((x\[n\])\_n\\right) = \\left(x\\left\[ (\\!(n-k)\\!)\_N\\right\]\\right)\_n,$
%[text] where $N\\in\\mathbb{N}$ is the period, $(y\[n\])\_{n\\in\\Omega\_\\mathsf{y}}$ is the output sequence and
%[text]{"align":"center"} $(\\!(n)\\!)\_N = n - N\\left\\lfloor N^{-1}n\\right\\rfloor$
%[text] denotes $n$ modulo $N$.
%[text] Example: for $N=6$ and $k=1$,
%[text]{"align":"center"} $\\begin{pmatrix}y\[0\] & y\[1\] & y\[2\] & y\[3\] & y\[4\] & y\[5\]\\end{pmatrix}=\\mathsf{T}\\left(\\begin{pmatrix}x\[0\] & x\[1\] & x\[2\] & x\[3\] & x\[4\] & x\[5\]\\end{pmatrix}\\right)=\\begin{pmatrix}x\[5\] & x\[0\] & x\[1\] & x\[2\] & x\[3\] & x\[4\]\\end{pmatrix}$
%[text] ### Signal generation
% Input sequence x[n] with a finite region of support
N = 6; %[control:slider:026f]{"position":[5,6]}
xgen = "ramp"; %[control:dropdown:737d]{"position":[8,14]}
switch xgen
    case "ramp"
        x = 0:N-1
    otherwise
        x = randn(1,N)
end
%[text] ### Shift amount
k = 1; %[control:slider:1ee7]{"position":[5,6]}
%[text] ### Definition of the map
% Map T as a circular shift
mapT = @(u) circshift(u,k);
%[text] ### Mapping
y = mapT(x)
%%
%[text] ## Matrix representation of the circular shift
%[text] The circular shift with $N=6$ and $k=1$ is represented by a matrix as
%[text]{"align":"center"} $\\mathbf{y}=\\mathbf{T}\\mathbf{x},$
%[text] where
%[text]{"align":"center"} $\\mathbf{y}=\\mathrm{vec}\\left((y\[n\])\_n\\right)=\\begin{pmatrix}y\[0\]\\\\y\[1\]\\\\y\[2\]\\\\y\[3\]\\\\y\[4\]\\\\y\[5\]\\end{pmatrix},\\quad \\mathbf{x}=\\mathrm{vec}\\left((x\[n\])\_n\\right)=\\begin{pmatrix}x\[0\]\\\\x\[1\]\\\\x\[2\]\\\\x\[3\]\\\\x\[4\]\\\\x\[5\]\\end{pmatrix},$
%[text]{"align":"center"} $\\mathbf{T}=\\begin{pmatrix}0 & 0 & 0 & 0 & 0 & 1 \\\\ 1 & 0 & 0 & 0 & 0 & 0 \\\\ 0 & 1 & 0 & 0 & 0 & 0 \\\\ 0 & 0 & 1 & 0 & 0 & 0 \\\\ 0 & 0 & 0 & 1 & 0 & 0 \\\\ 0 & 0 & 0 & 0 & 1 & 0\\end{pmatrix}.$
%[text] ### Generation of the circular shift matrix
T = zeros(length(x));
for idx = 1:length(x)
    % Standard basis vector
    e = zeros(size(x),'like',x);
    e(idx) = 1;
    % Response to the standard basis vector
    T(:,idx) = mapT(e);
end
% Matrix representation of the circular shift
T
%%
%[text] ## Univariate circular shift by a matrix operation
%[text] Along the commutative diagram, the circular shift is computed as
%[text]{"align":"center"} $(y\[n\])\_n=\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}^{-1}\\left(\\mathbf{y}\\right)=\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}^{-1}\\left(\\mathbf{T}\\mathbf{x}\\right)=\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}^{-1}\\circ\\mathbf{T}\\,\\mathrm{vec}\_{\\Omega\_\\mathsf{x}}\\left((x\[n\])\_n\\right),$
%[text] that is,
%[text]{"align":"center"} $\\mathsf{T}=\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}^{-1}\\circ\\mathbf{T}\\,\\mathrm{vec}\_{\\Omega\_\\mathsf{x}}.$
% Column vectorization of x[n]
vecx = x(:);
% Matrix operation
vecy = T*vecx;
% Reshape the result into the original form
recy = reshape(vecy,[1 N])
%[text] ### Evaluation of the univariate circular shift by the matrix operation
% Comparison between the map and the matrix operation
mymse = @(a,b) mean((double(a)-double(b)).^2,'all');
mymse(y,recy)
%%
%[text] ## Bivariate circular shift
%[text] The circular shift of an array $(x\[\\boldsymbol{n}\])\_{\\boldsymbol{n}\\in\\Omega\_\\mathsf{x}}$ with a finite region of support $\\Omega\_\\mathsf{x}\\subset\\mathbb{Z}^2$ is
%[text]{"align":"center"} $(y\[\\boldsymbol{n}\])\_{\\boldsymbol{n}} =\\mathsf{T}\\left((x\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}\\right) = \\left(x\\left\[ (\\!(\\boldsymbol{n}-\\boldsymbol{k})\\!)\_{\\boldsymbol{N}}\\right\]\\right)\_{\\boldsymbol{n}},$
%[text] where $\\boldsymbol{N}\\in\\mathbb{Z}^{2\\times2}$ ($\\det\\boldsymbol{N}\\neq 0$) is the periodic structure matrix, $(y\[\\boldsymbol{n}\])\_{\\boldsymbol{n}\\in\\Omega\_\\mathsf{y}}$ is the output array and
%[text]{"align":"center"} $(\\!(\\boldsymbol{n})\\!)\_{\\boldsymbol{N}} = \\boldsymbol{n} - \\boldsymbol{N}\\left\\lfloor \\boldsymbol{N}^{-1}\\boldsymbol{n}\\right\\rfloor$
%[text] denotes $\\boldsymbol{n}$ modulo $\\boldsymbol{N}$.
%[text] Example: for $\\boldsymbol{N}=\\begin{bmatrix} 2 & 0 \\\\ 0 & 3\\end{bmatrix}$ and $\\boldsymbol{k}=\\begin{bmatrix}k\_1 & k\_2\\end{bmatrix}^\\top=\\begin{bmatrix} 1 & 2 \\end{bmatrix}^\\top$,
%[text]{"align":"center"} $\\begin{pmatrix}y\[0,0\] & y\[0,1\] & y\[0,2\] \\\\ y\[1,0\] & y\[1,1\] & y\[1,2\]\\end{pmatrix}=\\mathsf{T}\\left(\\begin{pmatrix}x\[0,0\] & x\[0,1\] & x\[0,2\] \\\\ x\[1,0\] & x\[1,1\] & x\[1,2\]\\end{pmatrix}\\right)=\\begin{pmatrix}x\[1,1\] & x\[1,2\] & x\[1,0\] \\\\ x\[0,1\] & x\[0,2\] & x\[0,0\]\\end{pmatrix}$
%[text] ### Signal generation
% Input array x[n1,n2] with a finite region of support
N1 = 2; % # of rows %[control:slider:79e4]{"position":[6,7]}
N2 = 3; % # of columns %[control:slider:2bb5]{"position":[6,7]}
xgen = "ramp"; %[control:dropdown:16a8]{"position":[8,14]}
switch xgen
    case "ramp"
        x = reshape(0:N1*N2-1,[N1 N2])
    otherwise
        x = randn(N1,N2)
end
%[text] ### Shift amount
k1 = 1; % # of shifts in the vertical direction %[control:slider:0ed6]{"position":[6,7]}
k2 = 2; % # of shifts in the horizontal direction %[control:slider:281c]{"position":[6,7]}
%[text] ### Definition of the map
% Map T as a circular shift
mapT = @(u) circshift(u,[k1,k2]);
%[text] ### Mapping
y = mapT(x)
%%
%[text] ## Matrix representation of the circular shift
%[text] The circular shift with $\\boldsymbol{N}=\\begin{bmatrix} 2 & 0 \\\\ 0 & 3\\end{bmatrix}$ and $\\boldsymbol{k}=\\begin{bmatrix} 1 & 2 \\end{bmatrix}^\\top$ is represented by a matrix as
%[text]{"align":"center"} $\\mathbf{y}=\\mathbf{T}\\mathbf{x},$
%[text] where
%[text]{"align":"center"} $\\mathbf{y}=\\mathrm{vec}\\left((y\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}\\right)=\\begin{pmatrix}y\[0,0\] \\\\ y\[1,0\] \\\\ y\[0,1\] \\\\ y\[1,1\] \\\\ y\[0,2\] \\\\ y\[1,2\]\\end{pmatrix},\\quad \\mathbf{x}=\\mathrm{vec}\\left((x\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}\\right)=\\begin{pmatrix}x\[0,0\] \\\\ x\[1,0\] \\\\ x\[0,1\] \\\\ x\[1,1\] \\\\ x\[0,2\] \\\\ x\[1,2\]\\end{pmatrix},$
%[text]{"align":"center"} $\\mathbf{T}=\\begin{pmatrix} 0 & 0 & 0 & 1 & 0 & 0 \\\\ 0 & 0 & 1 & 0 & 0 & 0 \\\\ 0 & 0 & 0 & 0 & 0 & 1 \\\\ 0 & 0 & 0 & 0 & 1 & 0 \\\\ 0 & 1 & 0 & 0 & 0 & 0 \\\\ 1 & 0 & 0 & 0 & 0 & 0\\end{pmatrix}.$
%[text] ### Generation of the circular shift matrix
T = zeros(numel(x),numel(x));
for idx = 1:numel(x)
    % Standard basis array
    e = zeros(size(x),'like',x);
    e(idx) = 1;
    % Response to the standard basis array
    T(:,idx) = reshape(mapT(e),[size(T,1) 1]);
end
% Matrix representation of the circular shift
T
%%
%[text] ## Bivariate circular shift by a matrix operation
%[text] Along the commutative diagram, the circular shift is computed as
%[text]{"align":"center"} $(y\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}=\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}^{-1}\\left(\\mathbf{y}\\right)=\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}^{-1}\\left(\\mathbf{T}\\mathbf{x}\\right)=\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}^{-1}\\circ\\mathbf{T}\\,\\mathrm{vec}\_{\\Omega\_\\mathsf{x}}\\left((x\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}\\right),$
%[text] that is,
%[text]{"align":"center"} $\\mathsf{T}=\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}^{-1}\\circ\\mathbf{T}\\,\\mathrm{vec}\_{\\Omega\_\\mathsf{x}}.$
% Column vectorization of x[n]
vecx = x(:);
% Matrix operation
vecy = T*vecx;
% Reshape the result into the original form
recy = reshape(vecy,[N1 N2])
%[text] ### Evaluation of the bivariate circular shift by the matrix operation
% Comparison between the map and the matrix operation
mymse(y,recy)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:026f]
%   data: {"defaultValue":6,"label":"N","max":16,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:dropdown:737d]
%   data: {"defaultValue":"\"ramp\"","itemLabels":["0:N-1","randn(1,N)"],"items":["\"ramp\"","\"random\""],"label":"Input","run":"SectionToEnd"}
%---
%[control:slider:1ee7]
%   data: {"defaultValue":1,"label":"k","max":5,"min":-5,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:79e4]
%   data: {"defaultValue":2,"label":"N1","max":6,"min":1,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:2bb5]
%   data: {"defaultValue":3,"label":"N2","max":6,"min":1,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:dropdown:16a8]
%   data: {"defaultValue":"\"ramp\"","itemLabels":["reshape(0:N1*N2-1,[N1 N2])","randn(N1,N2)"],"items":["\"ramp\"","\"random\""],"label":"Input","run":"SectionToEnd"}
%---
%[control:slider:0ed6]
%   data: {"defaultValue":1,"label":"k1","max":5,"min":-5,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:281c]
%   data: {"defaultValue":2,"label":"k2","max":5,"min":-5,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
