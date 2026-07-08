%[text] # Sample 2-5
%[text] ## 画像データの入出力
%[text] 色空間変換 
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Input and output of images
%[text] Color space conversion
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
X = im2double(imread('firenzeRgb.jpg'));
figure(1)
imshow(X)
title('Original')
%%
%[text] ### ネガ変換
%[text] (Negative conversion)
%[text]{"align":"center"} $&dollar&;\\left(\\begin{array}{l}y\_\\mathrm{R} \\\\ y\_\\mathrm{G} \\\\ y\_\\mathrm{B}\\end{array}\\right)=T\\left(\\begin{array}{l}x\_\\mathrm{R} \\\\ x\_\\mathrm{G} \\\\ x\_\\mathrm{B}\\end{array}\\right)=\\left(\\begin{array}{l}1.0 \\\\ 1.0 \\\\ 1.0\\end{array}\\right)-\\left(\\begin{array}{l}x\_\\mathrm{R} \\\\ x\_\\mathrm{G} \\\\ x\_\\mathrm{B}\\end{array}\\right)&dollar&;$
% Definition of negative conversion
Tn = @(x) 1.0-x;
% Negative conversion of image I
Y = Tn(X);
figure(2)
imshow(Y)
title('Negative')
%%
%[text] ### RGB空間でべき乗則変換
%[text] (Power law conversion in RGB space)
%[text]{"align":"center"} $&dollar&;\\left(\\begin{array}{l}y\_\\mathrm{R} \\\\ y\_\\mathrm{G} \\\\ y\_\\mathrm{B}\\end{array}\\right)=T\\left(\\begin{array}{l}x\_\\mathrm{R} \\\\ x\_\\mathrm{G} \\\\ x\_\\mathrm{B}\\end{array}\\right)=\\left(\\begin{array}{l}x\_\\mathrm{R}^\\gamma \\\\ x\_\\mathrm{G}^\\gamma \\\\ x\_\\mathrm{B}^\\gamma\\end{array}\\right)&dollar&;$
% Parameter setting of power law conversion
gamma = 0.5 %[control:slider:0140]{"position":[9,12]}
% Power law conversion in RGB space
Y = imadjust(X,[],[],gamma);
figure(3)
imshow(Y)
title('Power law conversion in RGB space')
%%
%[text] ### HSV空間でV成分のみべき乗則変換
%[text] (Power law conversion for V component in HSV space)
%[text]{"align":"center"} $&dollar&;\\left(\\begin{array}{l}u\_\\mathrm{H} \\\\ u\_\\mathrm{S} \\\\ u\_\\mathrm{V}\\end{array}\\right)=\\mathrm{rgb2hsv}\\left(\\begin{array}{l}x\_\\mathrm{R} \\\\ x\_\\mathrm{G} \\\\ x\_\\mathrm{B}\\end{array}\\right)&dollar&;$
%[text]{"align":"center"} $&dollar&;\\left(\\begin{array}{l}y\_\\mathrm{R} \\\\ y\_\\mathrm{G} \\\\ y\_\\mathrm{B}\\end{array}\\right)=\\mathrm{hsv2rgb}\\left(\\begin{array}{l}u\_\\mathrm{H} \\\\ u\_\\mathrm{S} \\\\ u\_\\mathrm{V}^\\gamma\\end{array}\\right)&dollar&;$
% Parameter setting of power law conversion
gamma = 0.5 %[control:slider:8dd8]{"position":[9,12]}
% Power law conversion for V component in HSV space
U = rgb2hsv(X);
[H,S,V] = imsplit(U);
V = imadjust(V,[],[],gamma);
U = cat(3,H,S,V);
Y = hsv2rgb(U);
figure(4)
imshow(Y)
title('Power law conversion for V component in HSV space')
%%
%[text] ### RGB空間でヒストグラム均等化
%[text] (Histogram equalization in RGB space)
%[text]{"align":"center"} $&dollar&;\\left(\\begin{array}{l}y\_\\mathrm{R} \\\\ y\_\\mathrm{G} \\\\ y\_\\mathrm{B}\\end{array}\\right)=T\\left(\\begin{array}{l}x\_\\mathrm{R} \\\\ x\_\\mathrm{G} \\\\ x\_\\mathrm{B}\\end{array}\\right)=\\left(\\begin{array}{l}\\mathrm{histeq}(x\_\\mathrm{R}) \\\\ \\mathrm{histeq}(x\_\\mathrm{G}) \\\\ \\mathrm{histeq}(x\_\\mathrm{B})\\end{array}\\right)&dollar&;$
% Histogram equalization in RGB space
[R,G,B] = imsplit(X);
R = histeq(R);
G = histeq(G);
B = histeq(B);
Y = cat(3,R,G,B);
figure(5)
imshow(Y)
title('Histogram equalization in RGB space')
%%
%[text] ### HSV空間でV成分のみヒストグラム均等化
%[text] (Histogram equalization for V component in HSV space)
%[text]{"align":"center"} $&dollar&;\\left(\\begin{array}{l}u\_\\mathrm{H} \\\\ u\_\\mathrm{S} \\\\ u\_\\mathrm{V}\\end{array}\\right)=\\mathrm{rgb2hsv}\\left(\\begin{array}{l}x\_\\mathrm{R} \\\\ x\_\\mathrm{G} \\\\ x\_\\mathrm{B}\\end{array}\\right)&dollar&;$
%[text]{"align":"center"} $&dollar&;\\left(\\begin{array}{l}y\_\\mathrm{R} \\\\ y\_\\mathrm{G} \\\\ y\_\\mathrm{B}\\end{array}\\right)=\\mathrm{hsv2rgb}\\left(\\begin{array}{c}u\_\\mathrm{H} \\\\ u\_\\mathrm{S} \\\\ \\mathrm{histeq}(u\_\\mathrm{V})\\end{array}\\right)&dollar&;$
% Histogram equalization for V component in HSV space
U = rgb2hsv(X);
[H,S,V] = imsplit(U);
V = histeq(V);
U = cat(3,H,S,V);
Y = hsv2rgb(U);
figure(6)
imshow(Y)
title('Histogram equalization for V component in HSI space')
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:0140]
%   data: {"defaultValue":0.5,"label":"gamma","max":4,"min":0,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:8dd8]
%   data: {"defaultValue":0.5,"label":"gamma","max":4,"min":0,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
