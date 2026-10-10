%[text] # Sample 4-5: Convolution matrix
%[text] Advanced Topics in Image Processing, Lecture 4 "Linear Shift-Invariant Systems"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Univariate convolution
%[text] Assume a linear shift-invariant system $\\mathsf{T}(\\cdot)$ with a finite impulse response (FIR) $(h\[n\])\_{n\\in\\mathcal{N}\_\\mathrm{h}}$, $\\mathcal{N}\_\\mathrm{h}\\subset\\mathbb{Z}$.
%[text] The response $(y\[n\])\_{n\\in\\Omega\_\\mathsf{y}}$ of $\\mathsf{T}(\\cdot)$ to a sequence $(x\[n\])\_{n\\in\\Omega\_\\mathsf{x}}$ is given by the convolution
%[text]{"align":"center"} $(y\[n\])\_n =\\mathsf{T}\\left((x\[n\])\_n\\right) = \\sum\_{m\\in\\mathcal{N}\_\\mathrm{h}}h\[m\](x\[n-m\])\_n.$
%[text] ### Signal generation
% Input sequence x[n] with a finite region of support
N = 6; %[control:slider:5ea5]{"position":[5,6]}
xgen = "ramp"; %[control:dropdown:95c5]{"position":[8,14]}
switch xgen
    case "ramp"
        x = 1:N
    otherwise
        x = randn(1,N)
end
%[text] ### Impulse response
h = [1 0 -1];
%[text] ### Definition of the map
% Map T as the convolution with h[n]
mapT = @(u) conv(u,h);
%[text] ### Result of the mapping
y = mapT(x)
%%
%[text] ## Matrix representation of the univariate convolution
%[text] The convolution of an FIR system is represented by a matrix as
%[text]{"align":"center"} $\\mathbf{y}=\\mathbf{T}\\mathbf{x}.$
%[text] When the support of the impulse response $(h\[n\])\_n$ is $\\mathcal{N}\_\\mathrm{h}=\\{0,1,2\\}$ and that of the input $(x\[n\])\_n$ is
%[text] $\\Omega\_\\mathsf{x}=\\{0,1,2,3,4,5\\}$, the output $(y\[n\])\_n$ has the support $\\Omega\_\\mathsf{y}=\\{0,1,2,3,4,5,6,7\\}$, and
%[text]{"align":"center"} $\\mathbf{y}=\\mathrm{vec}\\left((y\[n\])\_n\\right)=\\begin{pmatrix}y\[0\]\\\\y\[1\]\\\\y\[2\]\\\\y\[3\]\\\\y\[4\]\\\\y\[5\]\\\\y\[6\]\\\\y\[7\]\\end{pmatrix},\\quad \\mathbf{x}=\\mathrm{vec}\\left((x\[n\])\_n\\right)=\\begin{pmatrix}x\[0\]\\\\x\[1\]\\\\x\[2\]\\\\x\[3\]\\\\x\[4\]\\\\x\[5\]\\end{pmatrix},$
%[text]{"align":"center"} $\\mathbf{T}=\\begin{pmatrix}h\[0\] & 0 & 0 & 0 & 0 & 0 \\\\ h\[1\] & h\[0\] & 0 & 0 & 0 & 0 \\\\ h\[2\] & h\[1\] & h\[0\] & 0 & 0 & 0 \\\\ 0 & h\[2\] & h\[1\] & h\[0\] & 0 & 0 \\\\ 0 & 0 & h\[2\] & h\[1\] & h\[0\] & 0 \\\\ 0 & 0 & 0 & h\[2\] & h\[1\] & h\[0\] \\\\ 0 & 0 & 0 & 0 & h\[2\] & h\[1\] \\\\ 0 & 0 & 0 & 0 & 0 & h\[2\]\\end{pmatrix}.$
%[text] Note that the support of the output is $\\Omega\_\\mathsf{y}=\\{n+m\\in\\mathbb{Z}\\mid n\\in\\Omega\_\\mathsf{x},m\\in\\mathcal{N}\_\\mathrm{h}\\}$ and the number of rows of $\\mathbf{T}$ is
%[text]{"align":"center"} $|\\Omega\_\\mathsf{y}|=|\\Omega\_\\mathsf{x}|+|\\mathcal{N}\_\\mathrm{h}|-1=6+3-1=8.$
%[text] ### Generation of the univariate convolution matrix
T = zeros(length(x)+length(h)-1,length(x));
for idx = 1:length(x)
    % Standard basis vector
    e = zeros(size(x),'like',x);
    e(idx) = 1;
    % Response to the standard basis vector
    T(:,idx) = mapT(e);
end
% Matrix representation of the univariate convolution
T
%[text] ### Using the function `convmtx`
%[text] The function `convmtx` also generates the univariate convolution matrix.
H = convmtx(h(:),length(x)) %#ok
%%
%[text] ## Univariate convolution by a matrix operation
%[text] Along the commutative diagram, the convolution is computed as
%[text]{"align":"center"} $(y\[n\])\_n=\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}^{-1}\\left(\\mathbf{y}\\right)=\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}^{-1}\\left(\\mathbf{T}\\mathbf{x}\\right)=\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}^{-1}\\circ\\mathbf{T}\\,\\mathrm{vec}\_{\\Omega\_\\mathsf{x}}\\left((x\[n\])\_n\\right),$
%[text] that is,
%[text]{"align":"center"} $\\mathsf{T}=\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}^{-1}\\circ\\mathbf{T}\\,\\mathrm{vec}\_{\\Omega\_\\mathsf{x}}.$
% Column vectorization of x[n]
vecx = x(:);
% Matrix operation
vecy = T*vecx;
% Reshape the result into a row sequence
recy = reshape(vecy,[1 (length(x)+length(h)-1)])
%[text] ### Evaluation of the univariate convolution by the matrix operation
% Comparison between the map and the matrix operation
mymse = @(a,b) mean((double(a)-double(b)).^2,'all');
mymse(y,recy)
%%
%[text] ## Bivariate convolution
%[text] Assume a linear shift-invariant system $\\mathsf{T}(\\cdot)$ with a bivariate FIR $(h\[\\boldsymbol{n}\])\_{\\boldsymbol{n}\\in\\mathcal{N}\_\\mathrm{h}}$, $\\mathcal{N}\_\\mathrm{h}\\subset\\mathbb{Z}^2$.
%[text] The response $(y\[\\boldsymbol{n}\])\_{\\boldsymbol{n}\\in\\Omega\_\\mathsf{y}}$ of $\\mathsf{T}(\\cdot)$ to an array $(x\[\\boldsymbol{n}\])\_{\\boldsymbol{n}\\in\\Omega\_\\mathsf{x}}$ is given by the convolution
%[text]{"align":"center"} $(y\[\\boldsymbol{n}\])\_{\\boldsymbol{n}} =\\mathsf{T}\\left((x\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}\\right) = \\sum\_{\\boldsymbol{m}\\in\\mathcal{N}\_\\mathrm{h}}h\[\\boldsymbol{m}\](x\[\\boldsymbol{n}-\\boldsymbol{m}\])\_{\\boldsymbol{n}}.$
%[text] ### Signal generation
% Input array x[n1,n2] with a finite region of support
N1 = 2; % # of rows %[control:slider:9038]{"position":[6,7]}
N2 = 3; % # of columns %[control:slider:0d40]{"position":[6,7]}
xgen = "ramp"; %[control:dropdown:6b1e]{"position":[8,14]}
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
% Map T as the convolution with h[n]
mapT = @(u) imfilter(u,h,'conv','full'); % or conv2(u,h)
%[text] ### Result of the mapping
y = mapT(x)
%%
%[text] ## Matrix representation of the bivariate convolution
%[text] The convolution of a bivariate FIR system is represented by a matrix as
%[text]{"align":"center"} $\\mathbf{y}=\\mathbf{T}\\mathbf{x}.$
%[text] When the support of the impulse response $(h\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}$ is $\\mathcal{N}\_\\mathrm{h}=\\{0,1\\}\\times \\{0,1\\}$ and that of the input
%[text] $(x\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}$ is $\\Omega\_\\mathsf{x}=\\{0,1\\}\\times \\{0,1,2\\}$, the output $(y\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}$ has the support
%[text] $\\Omega\_\\mathsf{y}=\\{0,1,2\\}\\times\\{0,1,2,3\\}$, and
%[text]{"align":"center"} $\\mathbf{y}=\\mathrm{vec}\\left((y\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}\\right)=\\begin{pmatrix}y\[0,0\]\\\\y\[1,0\]\\\\y\[2,0\]\\\\y\[0,1\]\\\\\\vdots\\\\y\[2,3\]\\end{pmatrix},\\quad \\mathbf{x}=\\mathrm{vec}\\left((x\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}\\right)=\\begin{pmatrix}x\[0,0\]\\\\x\[1,0\]\\\\x\[0,1\]\\\\x\[1,1\]\\\\\\vdots\\\\x\[1,2\]\\end{pmatrix},$
%[text]{"align":"center"} $\\mathbf{T}=\\begin{pmatrix}h\[0,0\] & 0 & 0 & 0 & \\cdots & 0 \\\\ h\[1,0\] & h\[0,0\] & 0 & 0 & \\cdots & 0 \\\\ 0 & h\[1,0\] & 0 & 0 & \\cdots & 0 \\\\ h\[0,1\] & 0 & h\[0,0\] & 0 & \\cdots & 0 \\\\ h\[1,1\] & h\[0,1\] & h\[1,0\] & h\[0,0\] & \\cdots & 0 \\\\ 0 & h\[1,1\] & 0 & h\[1,0\] & \\cdots & 0 \\\\ \\vdots & \\vdots & \\vdots & \\vdots & \\ddots & \\vdots \\\\ 0 & 0 & 0 & 0 & \\cdots & h\[1,1\]\\end{pmatrix}.$
%[text] Note that the support of the output is $\\Omega\_\\mathsf{y}=\\{\\boldsymbol{n}+\\boldsymbol{m}\\in\\mathbb{Z}^2\\mid \\boldsymbol{n}\\in\\Omega\_\\mathsf{x},\\boldsymbol{m}\\in\\mathcal{N}\_\\mathrm{h}\\}$ and the number of rows of $\\mathbf{T}$ is
%[text]{"align":"center"} $|\\Omega\_\\mathsf{y}|=(2+2-1)\\times(3+2-1)=3\\times 4=12.$
%[text] ### Generation of the bivariate convolution matrix
T = zeros(prod(size(x)+size(h)-1),numel(x));
for idx = 1:numel(x)
    % Standard basis array
    e = zeros(size(x),'like',x);
    e(idx) = 1;
    % Response to the standard basis array
    T(:,idx) = reshape(mapT(e),[size(T,1) 1]);
end
% Matrix representation of the convolution
T
%[text] ### Using the function `convmtx2`
%[text] The function `convmtx2` also generates the bivariate convolution matrix.
H = convmtx2(h,size(x)) %#ok
%%
%[text] ## Bivariate convolution by a matrix operation
%[text] Along the commutative diagram, the convolution is computed as
%[text]{"align":"center"} $(y\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}=\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}^{-1}\\left(\\mathbf{y}\\right)=\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}^{-1}\\left(\\mathbf{T}\\mathbf{x}\\right)=\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}^{-1}\\circ\\mathbf{T}\\,\\mathrm{vec}\_{\\Omega\_\\mathsf{x}}\\left((x\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}\\right),$
%[text] that is,
%[text]{"align":"center"} $\\mathsf{T}=\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}^{-1}\\circ\\mathbf{T}\\,\\mathrm{vec}\_{\\Omega\_\\mathsf{x}}.$
% Column vectorization of x[n]
vecx = x(:);
% Matrix operation
vecy = T*vecx;
% Reshape the result into the output array
recy = reshape(vecy,(size(x)+size(h)-1))
%[text] ### Evaluation of the bivariate convolution by the matrix operation
% Comparison between the map and the matrix operation
mymse(y,recy)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:5ea5]
%   data: {"defaultValue":6,"label":"N","max":16,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:dropdown:95c5]
%   data: {"defaultValue":"\"ramp\"","itemLabels":["1:N","randn(1,N)"],"items":["\"ramp\"","\"random\""],"label":"Input","run":"SectionToEnd"}
%---
%[control:slider:9038]
%   data: {"defaultValue":2,"label":"N1","max":6,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:0d40]
%   data: {"defaultValue":3,"label":"N2","max":6,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:dropdown:6b1e]
%   data: {"defaultValue":"\"ramp\"","itemLabels":["reshape(0:N1*N2-1,[N1 N2])","randn(N1,N2)"],"items":["\"ramp\"","\"random\""],"label":"Input","run":"SectionToEnd"}
%---
