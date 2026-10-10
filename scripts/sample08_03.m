%[text] # Sample 8-3: Image codec
%[text] Advanced Topics in Image Processing, Lecture 8 "Discrete Cosine Transforms"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Definition of a univariate transform
%[text] - Discrete Haar transform (DHT) matrix of the reference text (Sec. 6.2.2) \
%[text]  $\\mathbf{H}\_2=\\frac{1}{\\sqrt{2}}\\begin{pmatrix} 1 & 1 \\\\ 1 & -1 \\end{pmatrix}$
H2 = [1 1 ; 1 -1]/sqrt(2);
%%
%[text] ## Definition of the patch processing
%[text] Forward transform $\\rightarrow$ quantization $\\rightarrow$ inverse quantization $\\rightarrow$ inverse transform
%[text]  $\\mathcal{T}(\\mathbf{X})=\\mathbf{A}^{-1}\\left(\\mathbf{Q}\\odot\\mathrm{round}\\left( (\\mathbf{A}\\mathbf{X}\\mathbf{A}^\\top)\\oslash\\mathbf{Q}\\right)\\right)\\mathbf{A}^{-\\top}$
%[text] - $\\odot$: entry-wise multiplication
%[text] - $\\oslash$: entry-wise division
%[text] - $\\mathbf{Q}$: quantization table (quantization step of each coefficient)
mycodec = @(X,A,Q) inv(A)*(Q.*(round((A*double(X.data)*A.')./Q)))*inv(A).';
%[text] Patch size
blkSz = [2 2];
%%
%[text] ## Block processing of an array
%[text] Quality factor
%[text] - Controls the quantization steps
Qfactor = 1; %[control:slider:0daa]{"position":[11,12]}
%%
%[text] ## Definition of the input array
U = [
    2 2 3 1 ;
    2 2 3 1 ;
    3 3 2 0 ;
    1 1 0 2 ];
%%
%[text] ## Identity matrix case
A0 = eye(blkSz)
%[text] Quantization table $\\mathbf{Q}$
Q0 = Qfactor*[ % flat
    2 2 ;
    2 2 ];
%[text] Coding and decoding
mycodec0 = @(x) mycodec(x,A0,Q0);   % block processing
V0 = blockproc(U,blkSz,mycodec0)    % run the codec
U-V0                                % error
%%
%[text] ## Haar transform case
Ah = H2
%[text] Quantization table $\\mathbf{Q}$
Qh = Qfactor*[ % manually weighted
    3 4 ;
    4 5 ]/2;
%[text] Coding and decoding
mycodech = @(x) mycodec(x,Ah,Qh);   % block processing
Vh = blockproc(U,blkSz,mycodech)    % run the codec
U-Vh                                % error
%%
%[text] ## Quality assessment
%[text]  $\\mathrm{PSNR}(\\mathsf{u},\\mathsf{v})=10\\log\_{10}\\frac{V\_\\mathrm{peak}^2}{\\mathrm{MSE}(\\mathsf{u},\\mathsf{v})}$ \[dB\]
%[text] - A larger PSNR means a smaller error.
Qfactor
fprintf("PSNR (identity): %6.2f [dB]\n", psnr(U,V0,max(U(:))))
fprintf("PSNR (Haar H_2): %6.2f [dB]\n", psnr(U,Vh,max(U(:))))
%%
%[text] ## Read an image
[datfolder,~] = atip.prjfolders();
U = rgb2gray(imread(fullfile(datfolder,"barbaraFaceRgb.tif")));
%%
%[text] ## Coding and decoding
%[text] Identity matrix case
V0 = cast(blockproc(U,blkSz,mycodec0),"like",U);
%[text] Haar transform case
Vh = cast(blockproc(U,blkSz,mycodech),"like",U);
%%
%[text] ## Quality assessment
Qfactor
fprintf("PSNR (identity): %6.2f [dB]\n", psnr(U,V0))
fprintf("PSNR (Haar H_2): %6.2f [dB]\n", psnr(U,Vh))
%%
%[text] ## Image show
figure
imshow(U)
title("Original picture")
figure
imshow(V0)
title("Decoded picture w/ identity (PSNR: " + psnr(U,V0) + " dB)")
figure
imshow(Vh)
title("Decoded picture w/ Haar H_2 (PSNR: " + psnr(U,Vh) + " dB)")
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:0daa]
%   data: {"defaultValue":1,"label":"Qfactor","max":8,"min":0.5,"run":"SectionToEnd","runOn":"ValueChanging","step":0.5}
%---
