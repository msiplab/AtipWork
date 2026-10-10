%[text] # Sample 1-2: Basic operations
%[text] Advanced Topics in Image Processing, Lecture 1 "Digital Image Representation"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Definition of matrix $\\mathbf{A}$
%[text]{"align":"center"} $\\mathbf{A}=\\begin{pmatrix}1 & 2 \\\\ 3 & 4 \\\\ 5 & 6\\end{pmatrix}$
%[text] A semicolon `;` ends a row.  No declaration is needed; the default type is `double`.
A = [
    1 2 ;
    3 4 ;
    5 6 ]
%%
%[text] ## Definition of matrix $\\mathbf{B}$
%[text]{"align":"center"} $\\mathbf{B}=\\begin{pmatrix}1 & 2 & 3 \\\\ 4 & 5 & 6\\end{pmatrix}$
B = [
    1 2 3 ;
    4 5 6 ]
%%
%[text] ## Matrix product
%[text]{"align":"center"} $\\mathbf{C}=\\mathbf{A}\\mathbf{B}$
C = A*B
%%
%[text] ## Element-wise product and transpose
%[text] `.*` multiplies element by element; `.'` is the transpose ($\\mathbf{A}^\\top$)
%[text] and `'` the Hermitian transpose ($\\mathbf{A}^\\mathsf{H}$).
D = A.*B.'
At = A.'
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
