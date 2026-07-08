%[text] # Sample 2-4
%[text] ## 画像データの入出力
%[text] ヒストグラム均等化 
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Input and output of images
%[text] Histogram equalization
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### サンプル画像の準備
%[text] (Preparation of sample image)
%[text] 本サンプルで利用する画像データを収めたdata フォルダにパスをとおす。
%[text] Create a path to the data folder that contains images used in this sample.
addpath('./data')
close
% Reading original image
I = im2double(rgb2gray(imread('firenzeRgb.jpg')));
figure(1)
imshow(I)
title('Original')
figure(2)
imhist(I)
%%
%[text] ### ヒストグラム均等化前の加工
%[text] (Process before histogram equalization)
%[text]{"align":"center"} $v=T\_1(x)= x^\\gamma $
%[text]{"align":"center"} $y=T\_2(v)= \\frac{1}{2}(\\mathrm{sign}(2v-1)|2v-1|^{10^{-\\alpha}}+1)$
% Definition of process
gamma = 1 %[control:slider:52e5]{"position":[9,10]}
alpha = 0 %[control:slider:74f2]{"position":[9,10]}
T1 = @(x) x.^gamma;
T2 = @(v) 0.5*(sign(2.0*v-1.0).*abs(2*v-1.0).^(10^(-alpha))+1.0);
Tp = @(x) T2(T1(x));
figure(3)
fplot(Tp,[0,1])
axis square
grid on
% Preprocessing for histogram equalization
J = Tp(I);
figure(4)
imshow(J)
title('Preprocessed image for histogram equalization')
figure(5)
imhist(J)
%%
%[text] ### ヒストグラム均等化
%[text] (Histgram equalization)
% Power law conversion with IMADUST function
K = histeq(J);
figure(6)
imshow(K)
title('Result of histogram equalization')
figure(7)
imhist(K)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:52e5]
%   data: {"defaultValue":1,"label":"gamma","max":4,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:74f2]
%   data: {"defaultValue":0,"label":"alpha","max":4,"min":-4,"run":"SectionToEnd","runOn":"ValueChanging","step":0.1}
%---
