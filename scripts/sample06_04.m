%[text] # Sample 6-4: Adjoint operator
%[text] Advanced Topics in Image Processing, Lecture 6 "Sampling"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Adjoint operator
%[text] The operator $\\mathsf{T}^\\ast$ that satisfies the following relation for all $\\mathsf{x}$ and $\\mathsf{w}$ is called the adjoint operator of $\\mathsf{T}$
%[text] (\[M\] Example "Pull-back and adjoint map", Sec. 1.2.2):
%[text]{"align":"center"} $\\langle \\mathsf{w}, \\mathsf{T}(\\mathsf{x}) \\rangle=\\langle \\mathsf{T}^\\ast(\\mathsf{w}), \\mathsf{x}\\rangle$
%[text] This relation generalizes the Hermitian transpose of a matrix:
%[text]{"align":"center"} $\\langle \\mathbf{w}, \\mathbf{A}\\mathbf{x} \\rangle=\\langle \\mathbf{A}^\\mathsf{H}\\mathbf{w}, \\mathbf{x} \\rangle,\\quad \\langle \\mathbf{a},\\mathbf{b}\\rangle=\\mathbf{a}^\\mathsf{H}\\mathbf{b}$
%[text] `dot(a,b)` computes $\\mathbf{a}^\\mathsf{H}\\mathbf{b}$.
% Generation of vectors
nDimW = 2; %[control:slider:5b48]{"position":[9,10]}
nDimX = 2; %[control:slider:4e55]{"position":[9,10]}
vecX = randn(nDimX,1) + 1j*randn(nDimX,1);
vecW = randn(nDimW,1) + 1j*randn(nDimW,1);

% Generation of a matrix that maps C^nDimX to C^nDimW
matA = randn(nDimW,nDimX) + 1j*randn(nDimW,nDimX);

% Inner product <w,Ax>
innprodA = dot(vecW,matA*vecX);

% Inner product <A^H w,x>
innprodB = dot(matA'*vecW,vecX);

% Absolute difference
err = abs(innprodA - innprodB);
disp("|<w,Ax> - <A^H w,x>| = " + err)
%%
%[text] ## Hermitian transpose
%[text] The Hermitian transpose is the complex conjugate transpose: `ctranspose(A)` or `A'`.
% Complex conjugate transpose of matrix A
matB = ctranspose(matA);

% Frobenius norm of the difference
err = norm(matA' - matB,'fro');
disp("||B - A^H||_F = " + err)
%%
%[text] ## Adjoint operator of bivariate downsampling
% Input array size
N1 =6; %[control:slider:912b]{"position":[5,6]}
N2 =4; %[control:slider:4527]{"position":[5,6]}
% Downsampling ratios
M1 =2; %[control:slider:7425]{"position":[5,6]}
M2 =2; %[control:slider:5cdd]{"position":[5,6]}

% Definition of the bivariate separable downsampling
downsample2 = @(x,n) ...
    shiftdim(downsample(...
    shiftdim(downsample(x,...
    n(1)),1),...
    n(2)),1);

% Matrix representation of the bivariate downsampling:
% the columns are the responses to the standard basis
N = N1*N2;
nOut = numel(downsample2(zeros(N1,N2),[M1 M2]));
T = zeros(nOut,N);
for idx = 1:N
    % Standard basis
    e = zeros(N1,N2);
    e(idx) = 1;
    % Response to the standard basis
    t = downsample2(e,[M1 M2]);
    T(:,idx) = t(:);
end
%[text] Matrix representation $\\mathbf{T}\_{\\downarrow\\boldsymbol{M}}$
T
%[text] Its Hermitian transpose $\\mathbf{T}\_{\\downarrow\\boldsymbol{M}}^\\mathsf{H}$
T'
%[text] Adjoint operator
%[text]{"align":"center"} $\\mathsf{T}^\\ast\_{\\downarrow\\boldsymbol{M}}(\\mathsf{w})=\\mathrm{vec}\_{\\Omega\_\\mathsf{x}}^{-1} \\left(\\mathbf{T}\_{\\downarrow\\boldsymbol{M}}^\\mathsf{H}\\,\\mathrm{vec}\_{\\Omega\_\\mathsf{y}}(\\mathsf{w})\\right)$
% Adjoint operator T*
adjOp = @(w) reshape(T'*w(:),[N1 N2]);

% Generation of an input array x
arrayX = randn(N1,N2);
%[text]{"align":"center"} $\\mathsf{y}=\\mathsf{T}\_{\\downarrow\\boldsymbol{M}}(\\mathsf{x})$
% Downsampling (y = Tx)
arrayY = downsample2(arrayX,[M1 M2]);

% An array w in the same domain as y
arrayW = randn(size(arrayY),'like',arrayY)
%[text]{"align":"center"} $\\langle \\mathbf{w},\\mathbf{y}\\rangle=\\langle\\mathbf{w},\\mathbf{T}\\mathbf{x}\\rangle$
% Inner product <w,y> = <w,Tx>
innprodA = dot(arrayW(:),arrayY(:));
%[text] The adjoint operator of downsampling is zero insertion (upsampling):
%[text]{"align":"center"} $\\mathbf{r}=\\mathbf{T}^\\mathsf{H}\\mathbf{w}$
% Adjoint operation of downsampling (r = T^H w)
arrayR = adjOp(arrayW)
%[text]{"align":"center"} $\\langle \\mathbf{r},\\mathbf{x}\\rangle=\\langle\\mathbf{T}^\\mathsf{H}\\mathbf{w},\\mathbf{x}\\rangle$
% Inner product <r,x> = <T^H w,x>
innprodB = dot(arrayR(:),arrayX(:));

% Verify the adjoint relation
err = abs(innprodA - innprodB);
disp("|<w,Tx> - <T^H w,x>| = " + err)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:5b48]
%   data: {"defaultValue":2,"label":"nDimW","max":8,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:4e55]
%   data: {"defaultValue":2,"label":"nDimX","max":8,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:912b]
%   data: {"defaultValue":6,"label":"N1","max":8,"min":4,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:4527]
%   data: {"defaultValue":4,"label":"N2","max":8,"min":4,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:7425]
%   data: {"defaultValue":2,"label":"M1","max":4,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:5cdd]
%   data: {"defaultValue":2,"label":"M2","max":4,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
