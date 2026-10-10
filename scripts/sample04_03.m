%[text] # Sample 4-3: Separable filter
%[text] Advanced Topics in Image Processing, Lecture 4 "Linear Shift-Invariant Systems"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Generation of an impulse response
ftype = "average"; %[control:dropdown:2281]{"position":[9,18]}
h = rot90(fspecial(ftype),2)
figure
stem3(h,'filled')
axis ij
title("Impulse response of " + ftype + " filter")
%%
%[text] ## Checking the separability
%[text] ### Checking the separability with the function `isfilterseparable`
[isSeparable, hCol, hRow] = isfilterseparable(h);

% Display the result
if isSeparable
    disp('h[n] is separable.')
    disp('hcol: ')
    disp(hCol)
    disp('hrow: ')
    disp(hRow)
    figure
    tiledlayout(1,2)
    nexttile
    stem3(hCol,'filled')
    axis ij
    title('hcol')
    nexttile
    stem3(hRow,'filled')
    axis ij
    title('hrow')
else
    disp('h[n] is not separable.')
end
%%
%[text] ### Checking the separability with the function `rank` and the singular value decomposition (SVD)
%[text] The separability of a bivariate impulse response can be checked by the rank $\\mathrm{rank}(\\mathbf{H})$
%[text] (number of non-zero singular values) of the matrix $\\mathbf{H}$ of its coefficients.
%[text] If $\\mathrm{rank}(\\mathbf{H})=1$, it is separable; if it is larger, it is non-separable.
%[text] The decomposition into univariate impulse responses is given by the SVD
%[text]{"align":"center"} $\\mathbf{H} = \\left(\\sqrt{\\sigma\_0}\\mathbf{u}\_0\\right)\\left(\\sqrt{\\sigma\_0}\\mathbf{v}\_0\\right)^\\top,$
%[text] where $\\sigma\_0$ is the largest (only non-zero) singular value of $\\mathbf{H}$, and $\\mathbf{u}\_0$ and $\\mathbf{v}\_0$ are
%[text] the left and right singular vectors, respectively.
isRankOne = (rank(h) == 1);

% Display the result
if isRankOne
    [U,S,V] = svd(h,'econ');
    disp('h[n] is separable.')
    disp('sigma0^(1/2)u0: ')
    disp(sqrt(S(1,1))*U(:,1))
    disp('sigma0^(1/2)v0^T: ')
    disp(sqrt(S(1,1))*V(:,1).')
else
    disp('h[n] is not separable.')
    disp("Rank of h is " + rank(h) + ".")
end
%%
%[text] ## Impulse response of the separable system as a bivariate linear shift-invariant system
mymse = @(a,b) mean((double(a)-double(b)).^2,'all');
if isSeparable
    D = 1;     % bivariate unit impulse
    hsep = imfilter(imfilter(D,...
        hCol,'conv','full'),...
        hRow,'conv','full')
    % Evaluation
    disp("MSE: " + mymse(h,hsep))
    figure
    stem3(hsep,'filled')
    axis ij
    title("As a separable system (MSE: " + mymse(h,hsep) + ")")
end
%%
%[text] ## Bivariate impulse response by the Kronecker tensor product
%[text] A separable filter can also be represented by the Kronecker tensor product
%[text]{"align":"center"} $\\mathbf{H} = \\mathbf{h}\_\\mathrm{col}\\otimes\\mathbf{h}\_\\mathrm{row}.$
if isSeparable
    hkron = kron(hCol,hRow)
    % Evaluation
    disp("MSE: " + mymse(h,hkron))
end
%%
%[text] ## Image filtering by separable processing
%[text] Read a sample image as type double.
I = im2double(imread('cameraman.tif'));
figure
tiledlayout(2,2)
nexttile(1)
imshow(I)
title('(a) Original')
%[text] Normal processing by `imfilter`
J = imfilter(I,h);
if min(J(:)) < 0
    J = J + .5;
end
nexttile(3)
imshow(J)
title('(c) Normal')
%[text] Separable processing by `imfilter`
if isSeparable
    K = imfilter(imfilter(I,hCol),hRow);
    if min(K(:)) < 0
        K = K + .5;
    end
    nexttile(4)
    imshow(K)
    title('(d) Separable')

    % Evaluation
    L = imabsdiff(J,K);
    nexttile(2)
    imshow(L)
    title("(b) Abs. diff. (MSE: " + mymse(K,J) + ")")
else
    nexttile(2)
    imshow(checkerboard(16,4,4) > 0.5)
    title("(b) " + ftype + " filter is non-separable.")
    nexttile(4)
    imshow(checkerboard(16,4,4) > 0.5)
    title("(d) " + ftype + " filter is non-separable.")
end
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:dropdown:2281]
%   data: {"defaultValue":"\"average\"","itemLabels":["average","disk","gaussian","log","laplacian","unsharp","prewitt","sobel"],"items":["\"average\"","\"disk\"","\"gaussian\"","\"log\"","\"laplacian\"","\"unsharp\"","\"prewitt\"","\"sobel\""],"label":"Filter type","run":"SectionToEnd"}
%---
