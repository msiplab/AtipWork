%[text] # Lecture 1: Digital Image Representation
%[text] Shogo Muramatsu, "Advanced Topics in Image Processing"
%[text] Verified: MATLAB R2026b
%[text] This script makes all figures and numbers of the slides of lecture 1 (atip2027-01).
%[text] The notation follows the reference text \[M\] (MsipText), Sections 1.1.1 and 1.1.2.
%[text:tableOfContents]{"heading":"Contents"}
%%
%[text] ## Preparation
%[text] Figures and LaTeX snippets are written to the `results` folder.  AtipSlides imports them with
%[text] `tools/sync-results.ps1`.  The figure colours are the three colours of the MSIP Lab logo and grey.
[~,resfolder] = atip.prjfolders();
cmain = [0 136 85]/255;     % main (green) #008855
ccool = [46 117 182]/255;   % cool (blue)  #2E75B6
cwarm = [197 90 17]/255;    % warm (orange) #C55A11
%%
%[text] ## Image as an array
%[text] A grayscale image is a 2-D array $\\left(x\[n\_\\mathrm{v},n\_\\mathrm{h}\]\\right)\_{n\_\\mathrm{v},n\_\\mathrm{h}}$.
%[text] The vertical axis $n\_\\mathrm{v}$ points downward and the origin is the top-left pixel.
%[text] To show "before sampling" and "after sampling", the face of the stone statue (msipimg05) is
%[text] shown at full resolution and as $16\\times16$ pixels (block averaging).
X = im2double(atip.msipimg(5, 256, "gray"));
Xs = imresize(imresize(X, [16 16], "box"), [256 256], "nearest");
imwrite(X,  fullfile(resfolder, "atip-01-before.png"))
imwrite(Xs, fullfile(resfolder, "atip-01-after.png"))
%[text] Pixel values (8-bit) of the $16\\times16$ image around the top-left corner, $n\_\\mathrm{v},n\_\\mathrm{h}\\in\\{0,1,2,3\\}$
X16 = im2uint8(imresize(X, [16 16], "box"));
pix44 = X16(1:4,1:4)
atip.savetex("atip-01-patch", atip.arr2tex(pix44, "%d"));
%%
%[text] ## Standard-basis expansion
%[text] Example of \[M\] Section 1.1.1: any array in $\\mathbb{R}^{2\\times 3}$ is a linear combination of the
%[text] standard basis $\\left(\\delta\[\\boldsymbol{n}-\\boldsymbol{m}\]\\right)\_{\\boldsymbol{n}}$.
%[text] The coefficients are the element values themselves.
x = [3 2 7; 4 8 5];
[N1,N2] = size(x);
y = zeros(N1,N2);
for m2 = 0:N2-1
    for m1 = 0:N1-1
        e = zeros(N1,N2); e(m1+1,m2+1) = 1;     % (delta[n-m])_n
        y = y + x(m1+1,m2+1)*e;
    end
end
assert(isequal(x,y))
atip.savetex("atip-01-basis-x", atip.arr2tex(x, "%d"));
%%
%[text] ## Data amount of still images
%[text] Example "Data amount of still images" of \[M\] Section 1.1.2: $B=\\beta N\_1N\_2$ bits for a grayscale image
%[text] and $B=3\\beta N\_1N\_2$ bits for an RGB image, with $N\_1\\times N\_2=2304\\times 3456$.
N1 = 2304; N2 = 3456;
Bgray = 8*N1*N2               % 8-bit grayscale
Brgb  = 3*64*N1*N2            % double-precision RGB
assert(Bgray == 63700992 && Brgb == 1528823808)
atip.savetex("atip-01-still-n",     atip.fmtint(N1*N2));
atip.savetex("atip-01-still-gray",  atip.fmtint(Bgray));
atip.savetex("atip-01-still-graymb", sprintf("%.0f", Bgray/8/1e6));
atip.savetex("atip-01-still-rgb",   atip.fmtint(Brgb));
atip.savetex("atip-01-still-rgbmb", sprintf("%.0f", Brgb/8/1e6));
atip.savetex("atip-01-still-ratio", sprintf("%d", Brgb/Bgray));
%%
%[text] ## Bit rate of a video
%[text] Exercise "Bit rate of a video" of \[M\] Section 1.1.2: RGB video of $4320\\times7680$ pixels,
%[text] $\\Delta\_\\mathrm{t}=1/60$ s, $\\beta=8$ bits.
N1 = 4320; N2 = 7680; beta = 8; frate = 60;
Bframe = 3*beta*N1*N2          % bits per frame
R = Bframe*frate               % bits per second
assert(Bframe == 796262400 && R == 47775744000)
atip.savetex("atip-01-video-n",    atip.fmtint(N1*N2));
atip.savetex("atip-01-video-b",    atip.fmtint(Bframe));
atip.savetex("atip-01-video-r",    atip.fmtint(R));
atip.savetex("atip-01-video-gbps", sprintf("%.0f", R/1e9));
%%
%[text] ## Basic operations of MATLAB
%[text] Results shown on the slide "Matrices and vectors" (sample01\_02).
A = [1 2; 3 4; 5 6];
B = [1 2 3; 4 5 6];
C = A*B
atip.savetex("atip-01-matC", atip.arr2tex(C, "%d"));
s = 0;
for k = 1:10
    s = s + k;
end
atip.savetex("atip-01-csum", sprintf("%d", s));
%%
%[text] ## Indexing and slicing
%[text] MATLAB indices start from 1: $x\[n\_1,n\_2\]$ of the reference text is `X(n1+1,n2+1)`.
%[text] A colon `:` selects all elements along a dimension, e.g. $x\[\\colon,1\]$ is `X(:,2)`.
X = [3 2 7; 4 8 5];
e12  = X(2,3)            % x[1,2]
col1 = X(:,2)            % x[:,1]
row1 = X(end,:)          % x[1,:]
atip.savetex("atip-01-idx-x",    atip.arr2tex(X, "%d"));
atip.savetex("atip-01-idx-e12",  sprintf("%d", e12));
atip.savetex("atip-01-idx-col1", atip.arr2tex(col1, "%d"));
atip.savetex("atip-01-idx-row1", atip.arr2tex(row1, "%d"));
%%
%[text] ## Data types
%[text] Saturation of integer types and conversion to double precision in $\[0,1\]$.
sat1 = uint8(200) + uint8(100)
sat2 = uint8(100) - uint8(200)
dbl  = im2double(uint8(128))
u8   = im2uint8(0.5)                % round(0.5*255) = 128
atip.savetex("atip-01-sat1", sprintf("%d", sat1));
atip.savetex("atip-01-sat2", sprintf("%d", sat2));
atip.savetex("atip-01-im2double", sprintf("%.4f", dbl));
atip.savetex("atip-01-im2uint8", sprintf("%d", u8));
%%
%[text] ## RGB colour image and its components
%[text] $x\[:,:,n\_\\mathrm{c}\]$, $n\_\\mathrm{c}\\in\\{0,1,2\\}$, are the R, G and B component images
%[text] (bouquet, msipimg02).  In MATLAB, `P(:,:,nc+1)`.  The file is read at its original size
%[text] (shown on the slide) and resized to $256\\times256$ for the figures.
P0 = atip.msipimg(2);
sz0 = size(P0)
atip.savetex("atip-01-rgb-size0", sprintf("%d\\times %d\\times %d", sz0));
P = atip.msipimg(2, 256);
imwrite(P, fullfile(resfolder, "atip-01-rgb.png"))
names = ["r","g","b"];
for nc = 0:2
    imwrite(P(:,:,nc+1), fullfile(resfolder, "atip-01-rgb-" + names(nc+1) + ".png"))
end
sz = size(P);
atip.savetex("atip-01-rgb-size", sprintf("%d\\times %d\\times %d", sz));
%%
%[text] ## Pixel grid figure
%[text] The array $\\mathbf{X}$ with the axes $n\_\\mathrm{v}$ (downward) and $n\_\\mathrm{h}$ (rightward).
fig = figure(Units="centimeters", Position=[2 2 6 6], Color="w");
ax = axes(fig);
imagesc(ax, 0:3, 0:3, double(pix44)), colormap(ax, gray(256)), clim(ax, [0 255])
axis(ax, "image"), hold(ax, "on")
for v = 0:3
    for h = 0:3
        text(ax, h, v, string(pix44(v+1,h+1)), "HorizontalAlignment", "center", ...
            "Color", cwarm, "FontWeight", "bold", "FontSize", 9)
    end
end
hold(ax, "off")
xticks(ax, 0:3), yticks(ax, 0:3)
xlabel(ax, "$n_\mathrm{h}$", "Interpreter", "latex")
ylabel(ax, "$n_\mathrm{v}$", "Interpreter", "latex")
set(ax, "XAxisLocation", "top", "FontSize", 9, "XColor", cmain, "YColor", cmain)
exportgraphics(fig, fullfile(resfolder, "atip-01-grid.png"), "Resolution", 300)
close(fig)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
