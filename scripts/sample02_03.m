%[text] # Sample 2-3
%[text] ## 画像データの入出力
%[text] 輝度値変換 
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Input and output of images
%[text] Intensity transforms
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
%[text] ### ネガ変換
%[text] (Negative conversion)
%[text]{"align":"center"} $y=T(x) = 1.0-x$
% Definition of negative conversion
Tn = @(x) 1.0-x;
figure(3)
fplot(Tn,[0,1])
axis square
grid on
% Negative conversion of image I
J = Tn(I);
figure(4)
imshow(J)
title('Negative')
figure(5)
imhist(J)
%%
%[text] ### 対比伸長
%[text] (Contrast stretching)
%[text]{"align":"center"} $y=T(x) = \\frac{1}{2}(\\mathrm{sign}(2x-1)|2x-1|^{10^{\n-\\alpha}}+1)$
% Definition of contrast stretching
alpha = 1 %[control:slider:60f7]{"position":[9,10]}
Tc = @(x) 0.5*(sign(2.0*x-1.0).*abs(2*x-1.0).^(10^(-alpha))+1.0);
figure(6)
fplot(Tc,[0,1])
axis square
grid on
% Contrast stretching of image I
K = Tc(I);
figure(7)
imshow(K)
title('Contrast stretching')
figure(8)
imhist(K)
%%
%[text] ### べき乗則変換
%[text]  (Power law conversion)
%[text]{"align":"center"} $y=T(x) = x^\\gamma$ 
% Definition of power law conversion
gamma = 0.5 %[control:slider:8ba8]{"position":[9,12]}
Tp = @(x) x.^gamma;
figure(9)
fplot(Tp,[0,1])
axis square
grid on
% Power law conversion of image I
L = Tp(I);
figure(10)
imshow(L)
title('Power law conversion')
figure(11)
imhist(L)
%%
%[text] ### 輝度値調整関数
%[text] (Image adjustment function)
%[text] IMADJUST は高機能な輝度値調整関数で，uint8型画像に対してもべき乗則変換を含めた細かい調整が可能
%[text] IMADJUST is a sophisticated intensity adjustment function that allows fine tuning of images including uint8-type ones, such as power law conversion.
% Parameter setting of power law conversion
gamma = 0.5 %[control:slider:184c]{"position":[9,12]}
% Conversion to uint8
U = im2uint8(I);
% Power law conversion with IMADUST function
M = imadjust(U,[],[],gamma);
figure(12)
imshow(M)
title('Power law conversion with IMADJUST')
figure(13)
imhist(M)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:60f7]
%   data: {"defaultValue":1,"label":"alpha","max":3,"min":0,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:8ba8]
%   data: {"defaultValue":0.5,"label":"gamma","max":4,"min":0,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:184c]
%   data: {"defaultValue":0.5,"label":"gamma","max":4,"min":0,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
