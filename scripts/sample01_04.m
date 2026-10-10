%[text] # Sample 1-4: Array creation
%[text] Advanced Topics in Image Processing, Lecture 1 "Digital Image Representation"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Array creation
%[text] A $D$-dimensional array $\\mathsf{x}\\in\\mathbb{R}^{N_1\\times N_2\\times\\cdots\\times N_D}$
%[text] is created by `zeros`, `ones`, `rand`, etc. with the size $N_1,N_2,\\ldots,N_D$.
X = zeros(2,3)      % zeros array of size 2x3
Y = ones(3,4)       % ones array of size 3x4
Z = rand(2,3,4)     % uniform random array of size 2x3x4
%%
%[text] ## Array size
%[text] `size` returns $N_1,N_2,\\ldots,N_D$ and `numel` the number of elements $N=N_1N_2\\cdots N_D$.
size(X)
size(Y)
size(Z)
numel(Z)
%%
%[text] ## Array type
%[text] The type (class) decides the range of the element values and the number of bits $\\beta$ per element.
class(X)
L = zeros(2,3,'logical');  class(L)
U = zeros(2,3,'uint8');    class(U)
I = zeros(2,3,'int16');    class(I)
S = zeros(2,3,'single');   class(S)
whos X L U I S
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
