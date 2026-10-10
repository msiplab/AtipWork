%[text] # Sample 7-5: Adjoint of convolution
%[text] Advanced Topics in Image Processing, Lecture 7 "Geometric Image Processing"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Generation of the impulse response
ftype = "prewitt"; %[control:dropdown:1647]{"position":[9,18]}
h = rot90(fspecial(ftype),2)
fig1 = figure;
stem3(h,'filled')
axis ij
title('Impulse response h[n]')
%%
%[text] ## Matrix representation of bivariate circular convolution
%[text] Circular convolution with the periodic structure matrix $\\boldsymbol{N}$ (\[M\] Sec. 4.3.2)
%[text]{"align":"center"} $y\[\\boldsymbol{n}\] = \\sum\_{\\boldsymbol{m}\\in\\mathcal{N}\_\\mathrm{h}}h\[\\boldsymbol{m}\]\\,x\[(\\!(\\boldsymbol{n}-\\boldsymbol{m})\\!)\_{\\boldsymbol{N}}\],\\quad \\boldsymbol{n}\\in\\mathcal{N}(\\boldsymbol{N})$
% Input array size
N1 =6; %[control:slider:6123]{"position":[5,6]}
N2 =4; %[control:slider:4d22]{"position":[5,6]}

% Matrix representation of the bivariate circular convolution:
% the columns are the responses to the standard basis
N = N1*N2;
T = zeros(N);
for idx = 1:N
    % Standard basis
    e = zeros(N1,N2);
    e(idx) = 1;
    % Response to the standard basis
    t = imfilter(e,h,'conv','circular');
    T(:,idx) = t(:);
end
%[text] Matrix representation $\\mathbf{T}\_\\mathrm{h}$
T
%%
%[text] ## Adjoint operator of bivariate circular convolution
%[text] Hermitian transpose $\\mathbf{T}\_\\mathrm{h}^\\mathsf{H}$
T'
%[text] Adjoint operator
%[text]{"align":"center"} $\\mathsf{T}\_\\mathrm{h}^\\ast(\\mathsf{w})=\\mathrm{vec}\_{\\Omega\_\\mathsf{x}}^{-1} \\left(\\mathbf{T}\_\\mathrm{h}^\\mathsf{H}\\,\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}(\\mathsf{w})\\right)$
% Adjoint operator T*
adjOp = @(w) reshape(T'*w(:),[N1 N2]);
%%
%[text] ## Confirmation of the preservation of the inner product
%[text] Generation of an input array $\\mathsf{x}$
arrayX = randn(N1,N2);
%[text] Output of the circular convolution $\\mathsf{y}=\\mathsf{T}\_\\mathrm{h}(\\mathsf{x})$
arrayY = imfilter(arrayX,h,'conv','circular');
%[text] An arbitrary array $\\mathsf{w}$ in the output domain
arrayW = randn(size(arrayY),'like',arrayY);
%[text] Inner product $\\alpha=\\langle \\mathbf{w},\\mathbf{y}\\rangle=\\langle\\mathbf{w},\\mathbf{T}\_\\mathrm{h}\\mathbf{x}\\rangle$
innprodA = dot(arrayW(:),arrayY(:))
%[text] Adjoint operation $\\mathbf{r}=\\mathbf{T}\_\\mathrm{h}^\\mathsf{H}\\mathbf{w}$
arrayR = adjOp(arrayW)
%[text] Inner product $\\beta=\\langle \\mathbf{r},\\mathbf{x}\\rangle=\\langle\\mathbf{T}\_\\mathrm{h}^\\mathsf{H}\\mathbf{w},\\mathbf{x}\\rangle$
innprodB = dot(arrayR(:),arrayX(:));

% Verify the preservation of the inner product
err = abs(innprodA - innprodB);
disp("|<w,Tx> - <T^H w,x>| = " + err)
%%
%[text] ## Circular convolution with the reversed impulse response
%[text] The adjoint is the circular convolution with $f\[\\boldsymbol{n}\]=\\overline{h\[-\\boldsymbol{n}\]}$:
%[text]{"align":"center"} $r\[\\boldsymbol{n}\] = \\sum\_{\\boldsymbol{m}}\\overline{h\[-\\boldsymbol{m}\]}\\,w\[(\\!(\\boldsymbol{n}-\\boldsymbol{m})\\!)\_{\\boldsymbol{N}}\]$
% Reversed impulse response
f = conj(rot90(h,2))
fig2 = figure;
stem3(f,'filled')
axis ij
title('Impulse response f[n]')

% Circular convolution with the impulse response f
arrayS = imfilter(arrayW,f,'conv','circular')
%[text] Comparison between the matrix operation and IMFILTER (for the $3\\times3$ kernels both place the origin at the centre)
% Definition of MSE
mymse = @(x,y) mean((x-y).^2,'all');

% Evaluation
disp("MSE between the matrix operation and IMFILTER: " + mymse(arrayR,arrayS))
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:dropdown:1647]
%   data: {"defaultValue":"\"prewitt\"","itemLabels":["prewitt","sobel"],"items":["\"prewitt\"","\"sobel\""],"label":"Kernel","run":"SectionToEnd"}
%---
%[control:slider:6123]
%   data: {"defaultValue":6,"label":"N1","max":8,"min":4,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:4d22]
%   data: {"defaultValue":4,"label":"N2","max":8,"min":4,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
