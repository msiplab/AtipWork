%[text] # Sample 2-4: Histogram equalization
%[text] Advanced Topics in Image Processing, Lecture 2 "Input and Output of Images"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Preparation of sample image
datfolder = atip.prjfolders();
% Read the original image
I = im2double(rgb2gray(imread(fullfile(datfolder,'firenzeRgb.jpg'))));
figure
imshow(I)
title('Original')
figure
imhist(I)
%%
%[text] ## Process before histogram equalization
%[text] A power-law transform followed by contrast stretching changes the histogram of the input
%[text] (\[M\] Section 2.1.4).
%[text]{"align":"center"} $v=\\phi\_1(x)= x^\\gamma$
%[text]{"align":"center"} $y=\\phi\_2(v)= \\frac{1}{2}\\left(\\mathrm{sign}(2v-1)|2v-1|^{10^{-\\alpha}}+1\\right)$
% Definition of the process
gamma = 1 %[control:slider:036c]{"position":[9,10]}
alpha = 0 %[control:slider:37e1]{"position":[9,10]}
T1 = @(x) x.^gamma;
T2 = @(v) 0.5*(sign(2.0*v-1.0).*abs(2*v-1.0).^(10^(-alpha))+1.0);
Tp = @(x) T2(T1(x));
figure
fplot(Tp,[0,1])
axis square
grid on
% Preprocessing for histogram equalization
J = Tp(I);
figure
imshow(J)
title('Preprocessed image for histogram equalization')
figure
imhist(J)
%%
%[text] ## Histogram equalization
%[text] The lookup table $y=\\phi(x)=\\left\\lfloor (L-1)\\sum\_{v=0}^{x}p\_v\\right\\rceil$ is designed from the
%[text] normalized histogram $p\_x$ (\[M\] Section 2.2.2).  `histeq` gives a similar result automatically.
K = histeq(J);
figure
imshow(K)
title('Result of histogram equalization')
figure
imhist(K)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:036c]
%   data: {"defaultValue":1,"label":"gamma","max":4,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:37e1]
%   data: {"defaultValue":0,"label":"alpha","max":4,"min":-4,"run":"SectionToEnd","runOn":"ValueChanging","step":0.1}
%---
