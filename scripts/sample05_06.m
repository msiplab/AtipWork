%[text] # Sample 5-6: Multivariate circular convolution
%[text] Advanced Topics in Image Processing, Lecture 5 "Fourier Analysis"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Preparation of a sample image $(x\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}$
x = im2double(imread('cameraman.tif'));
figure
imshow(x)
title('Original')
%%
%[text] ## Impulse response $(h\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}$ of a linear shift-invariant system
hsize1 = 3; %[control:slider:123e]{"position":[10,11]}
hsize2 = 3; %[control:slider:1057]{"position":[10,11]}
sigma = 1; %[control:slider:5c7f]{"position":[9,10]}
ftype = "log"; %[control:dropdown:1049]{"position":[9,14]}
h = rot90(fspecial(ftype,[hsize1 hsize2],sigma),2);
figure
[n2,n1] = meshgrid(-floor((hsize2-1)/2):ceil((hsize2-1)/2),-floor((hsize1-1)/2):ceil((hsize1-1)/2));
stem3(n2,n1,h,'filled')
xlabel('n_2')
ylabel('n_1')
axis ij
title("Impulse response of " + ftype + " filter")
%%
%[text] ## Output $(y\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}$ of the circular convolution with the periodic structure matrix $\\boldsymbol{N}$
%[text]{"align":"center"} $(y\[\\boldsymbol{n}\])\_{\\boldsymbol{n}} = \\left(\\sum\_{\\boldsymbol{m}\\in\\mathcal{N}\_\\mathrm{h}}h\[\\boldsymbol{m}\]x\[(\\!(\\boldsymbol{n}-\\boldsymbol{m})\\!)\_{\\boldsymbol{N}}\]\\right)\_{\\boldsymbol{n}}$
% Setting the period
nPeriod1 = 258; %[control:slider:0e79]{"position":[12,15]}
nPeriod2 = 258; %[control:slider:3037]{"position":[12,15]}
nPeriod = [nPeriod1 nPeriod2];
nZeroPadding = nPeriod - size(x);

% Zero padding
xzpd = padarray(x,nZeroPadding,0,'post');
figure
imshow(xzpd)
title('Zero-padded input')

% Output y[n]
y = imfilter(xzpd,h,'conv','circular');
%%
%[text] ## Comparison with the linear convolution
yl = imfilter(x,h,'conv','full');

figure
imshow(y+(min(y(:))<0)/2)
title('Circular convolution')
figure
imshow(yl+(min(yl(:))<0)/2)
title('Linear convolution')
%[text] ### Condition for the linear and circular convolutions to agree
%[text]{"align":"center"} $\\exists \\boldsymbol{c}\\in\\mathbb{Z}^D\\ \\mathrm{s.t.}\\ \\Omega\_\\mathsf{y}\\subseteq\\boldsymbol{c}+\\mathcal{N}(\\boldsymbol{N}),\\quad \\Omega\_\\mathsf{y}=\\{\\boldsymbol{n}+\\boldsymbol{m}\\mid\\boldsymbol{n}\\in\\Omega\_\\mathsf{x},\\boldsymbol{m}\\in\\mathcal{N}\_\\mathrm{h}\\}$
%[text] where
%[text] - $\\Omega\_\\mathsf{y}$: region of support of the output
%[text] - $\\mathcal{N}\_\\mathrm{h}$: region of support of the impulse response
%[text] - $\\Omega\_\\mathsf{x}$: region of support of the input \
%[text] In the following, the periodic structure matrix is the diagonal matrix
%[text]{"align":"center"} $\\boldsymbol{N}=\\begin{bmatrix}N\_1 & 0 \\\\ 0 & N\_2 \\end{bmatrix},$
%[text] that is,
%[text]{"align":"center"} $\\mathcal{N}(\\boldsymbol{N})=\\mathcal{N}(\\boldsymbol{N}^\\top)=\\{0,1,\\ldots,N\_1-1\\}\\times\\{0,1,\\ldots,N\_2-1\\},\\quad \\left|\\det(\\boldsymbol{N})\\right|=N\_1N\_2,$
%[text] and $\\Omega\_\\mathsf{x}\\subseteq\\mathcal{N}(\\boldsymbol{N})$ is assumed.
%[text] Example: if
%[text]{"align":"center"} $\\Omega\_\\mathsf{x}=\\{0,1,\\ldots,L\_{\\mathrm{x}1}-1\\}\\times\\{0,1,\\ldots,L\_{\\mathrm{x}2}-1\\},\\quad \\mathcal{N}\_\\mathrm{h}=\\{-1,0,1\\}\\times\\{-1,0,1\\},$
%[text] then
%[text]{"align":"center"} $\\Omega\_\\mathsf{y}=\\{-1,0,1,\\ldots,L\_{\\mathrm{x}1}\\}\\times\\{-1,0,1,\\ldots,L\_{\\mathrm{x}2}\\}.$
%[text] Therefore, from
%[text]{"align":"center"} $\\{\\boldsymbol{n}+(1,1)^\\top\\mid \\boldsymbol{n} \\in\\Omega\_\\mathsf{y}\\}=\\{0,1,\\ldots,L\_{\\mathrm{x}1}+1\\}\\times\\{0,1,\\ldots,L\_{\\mathrm{x}2}+1\\},$
%[text] the linear and circular convolutions agree if
%[text]{"align":"center"} $N\_1\\geq L\_{\\mathrm{x}1}+2,\\ N\_2\\geq L\_{\\mathrm{x}2}+2.$
% Adjusting the sizes for evaluation
dsz = size(y)-size(yl);
if dsz(1) > 0
    yc = y;
    ylc = padarray(yl,[dsz(1) 0],0,'post');
else
    ylc = yl;
    yc = padarray(y,[-dsz(1) 0],0,'post');
end
if dsz(2) > 0
    ylc = padarray(ylc,[0 dsz(2)],0,'post');
else
    yc = padarray(yc,[0 -dsz(2)],0,'post');
end
% Compensate the circular shift
ylc = circshift(ylc,-ceil((size(h)-1)/2));

% Sizes and MSE
mymse = @(a,b) mean((double(a)-double(b)).^2,'all');
fprintf("Period:         N1  = %d, N2  = %d\n",nPeriod1,nPeriod2);
fprintf("Size of image:  Lx1 = %d, Lx2 = %d\n",size(x,1),size(x,2));
fprintf("Size of filter: Lh1 = %d, Lh2 = %d\n",size(h,1),size(h,2));
fprintf("MSE: %f\n", mymse(yc,ylc))
%%
%[text] ## DFT of the input signal $(x\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}$
%[text]{"align":"center"} $X\[\\boldsymbol{k}\]=\\sum\_{\\boldsymbol{n}\\in\\mathcal{N}(\\boldsymbol{N})} x\[\\boldsymbol{n}\] \\mathrm{e}^{-\\mathrm{j}\\boldsymbol{k}^\\top(2\\pi\\boldsymbol{N}^{-1})\\boldsymbol{n}},\\ \\boldsymbol{k}\\in\\mathcal{N}(\\boldsymbol{N}^\\top)$
X = fftn(x,nPeriod);
%%
%[text] ## DFT of the impulse response $(h\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}$
%[text]{"align":"center"} $H\[\\boldsymbol{k}\]=\\sum\_{\\boldsymbol{n}\\in\\mathcal{N}(\\boldsymbol{N})} h\[\\boldsymbol{n}\] \\mathrm{e}^{-\\mathrm{j}\\boldsymbol{k}^\\top(2\\pi\\boldsymbol{N}^{-1})\\boldsymbol{n}},\\ \\boldsymbol{k}\\in\\mathcal{N}(\\boldsymbol{N}^\\top)$
H = fftn(h,nPeriod);
%%
%[text] ## DFT of the output signal $(y\[\\boldsymbol{n}\])\_{\\boldsymbol{n}}$
%[text]{"align":"center"} $Y\[\\boldsymbol{k}\]=\\sum\_{\\boldsymbol{n}\\in\\mathcal{N}(\\boldsymbol{N})} y\[\\boldsymbol{n}\] \\mathrm{e}^{-\\mathrm{j}\\boldsymbol{k}^\\top(2\\pi\\boldsymbol{N}^{-1})\\boldsymbol{n}},\\ \\boldsymbol{k}\\in\\mathcal{N}(\\boldsymbol{N}^\\top)$
Y = fftn(y,nPeriod);
%%
%[text] ## DFT product
%[text]{"align":"center"} $Y\[\\boldsymbol{k}\]=H\[\\boldsymbol{k}\]X\[\\boldsymbol{k}\],\\ \\boldsymbol{k}\\in\\mathcal{N}(\\boldsymbol{N}^\\top)$
%[text] Comparison with the circular convolution
% IDFT of the DFT product
yd = ifftn(H.*X);
% Compensate the circular shift (imfilter puts the origin at the kernel centre)
yd = circshift(yd,-ceil((size(h)-1)/2));
% MSE with the result of imfilter
fprintf("MSE: %f\n", mymse(y,yd))
%%
%[text] ## Spectral norm of the circular convolution
%[text]{"align":"center"} $\\|\\mathsf{T}\\|\_\\mathrm{S}=\\sigma\_0(\\mathbf{T})=\\max\_{\\boldsymbol{k}\\in\\mathcal{N}(\\boldsymbol{N}^\\top)}\\left|H\[\\boldsymbol{k}\]\\right|$
%[text] where $\\sigma\_0(\\mathbf{T})$ is the largest singular value of the matrix representation $\\mathbf{T}$.
% Map T as the circular convolution with h[n]
mapT = @(u) imfilter(u,h,'conv','circular');
%[text] ### Matrix representation of the bivariate circular convolution
% Redefining the period
N1 = 8; %[control:slider:9945]{"position":[6,7]}
N2 = 8; %[control:slider:6cc3]{"position":[6,7]}

% Matrix representation of the circular convolution
N = N1*N2;
T = zeros(N,N);
for idx = 1:N
    % Standard basis array
    e = zeros(N1,N2);
    e(idx) = 1;
    % Response to the standard basis array
    T(:,idx) = reshape(mapT(e),[N 1]);
end
T
%[text] ### Spectral norm
% The function norm evaluates the spectral norm (operator 2-norm) of a matrix
spnorm = norm(T,2)
%[text] ### Largest singular value
sigma0 = max(svd(T))
%[text] ### Maximum magnitude response
H = fftn(h,[N1 N2]);
maxmgn = max(abs(H(:)))
%%
%[text] ## Notes on the function `norm`
%[text] For matrices, pay attention to how the arguments and options are passed.
% Frobenius norm
norm(T,'fro')

% Entrywise 2-norm, which is identical to the Frobenius norm
norm(T(:),2)

% Operator 1-norm
norm(T,1)

% Entrywise 1-norm
norm(T(:),1)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:123e]
%   data: {"defaultValue":3,"label":"hsize1","max":9,"min":1,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:1057]
%   data: {"defaultValue":3,"label":"hsize2","max":9,"min":1,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:5c7f]
%   data: {"defaultValue":1,"label":"sigma","max":8,"min":0.5,"run":"SectionToEnd","runOn":"ValueChanging","step":0.5}
%---
%[control:dropdown:1049]
%   data: {"defaultValue":"\"log\"","itemLabels":["gaussian","log"],"items":["\"gaussian\"","\"log\""],"label":"ftype","run":"SectionToEnd"}
%---
%[control:slider:0e79]
%   data: {"defaultValue":258,"label":"N_1","max":512,"min":256,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:3037]
%   data: {"defaultValue":258,"label":"N_2","max":512,"min":256,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:9945]
%   data: {"defaultValue":8,"label":"N1","max":32,"min":8,"run":"SectionToEnd","runOn":"ValueChanging","step":8}
%---
%[control:slider:6cc3]
%   data: {"defaultValue":8,"label":"N2","max":32,"min":8,"run":"SectionToEnd","runOn":"ValueChanging","step":8}
%---
