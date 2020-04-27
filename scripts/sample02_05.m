%% Sample 2-5
%% 画像データの入出力
% 色空間変換 
% 
% 画像処理特論
% 
% 村松 正吾 
% 
% 動作確認: MATLAB R2020a
%% Input and output of images
% Color space conversion
% 
% Advanced Topics in Image Processing
% 
% Shogo MURAMATSU
% 
% Verified: MATLAB R2020a
% 処理画像の準備
% (Preparation of sample image)
% 
% 本サンプルで利用する画像データを収めたdata フォルダにパスをとおす。
% 
% Create a path to the data folder that contains images used in this sample.

addpath('./data')
close
% Reading original image
X = im2double(imread('firenzeRgb.jpg'));
imshow(X)
title('Original')
% ネガ変換
% (Negative conversion)
% 
% $$$\left(\begin{array}{l}y_\mathrm{R} \\ y_\mathrm{G} \\ y_\mathrm{B}\end{array}\right)=T\left(\begin{array}{l}x_\mathrm{R} 
% \\ x_\mathrm{G} \\ x_\mathrm{B}\end{array}\right)=\left(\begin{array}{l}1.0 
% \\ 1.0 \\ 1.0\end{array}\right)-\left(\begin{array}{l}x_\mathrm{R} \\ x_\mathrm{G} 
% \\ x_\mathrm{B}\end{array}\right)$$$

% Definition of negative conversion
Tn = @(x) 1.0-x;
% Negative conversion of image I
Y = Tn(X);
imshow(Y)
title('Negative')
% RGB空間で累乗則変換
% (Power law conversion in RGB space)
% 
% $$$\left(\begin{array}{l}y_\mathrm{R} \\ y_\mathrm{G} \\ y_\mathrm{B}\end{array}\right)=T\left(\begin{array}{l}x_\mathrm{R} 
% \\ x_\mathrm{G} \\ x_\mathrm{B}\end{array}\right)=\left(\begin{array}{l}x_\mathrm{R}^\gamma 
% \\ x_\mathrm{G}^\gamma \\ x_\mathrm{B}^\gamma\end{array}\right)$$$

% Parameter setting of power law conversion
gamma = 0.5
% Power law conversion in RGB space
Y = imadjust(X,[],[],gamma);
imshow(Y)
title('Power law conversion in RGB space')
% HSV空間でV成分のみ累乗則変換
% (Power law conversion for V component in HSV space)
% 
% $$$\left(\begin{array}{l}u_\mathrm{H} \\ u_\mathrm{S} \\ u_\mathrm{V}\end{array}\right)=\mathrm{rgb2hsv}\left(\begin{array}{l}x_\mathrm{R} 
% \\ x_\mathrm{G} \\ x_\mathrm{B}\end{array}\right)$$$
% 
% $$$\left(\begin{array}{l}y_\mathrm{R} \\ y_\mathrm{G} \\ y_\mathrm{B}\end{array}\right)=\mathrm{hsv2rgb}\left(\begin{array}{l}u_\mathrm{H} 
% \\ u_\mathrm{S} \\ u_\mathrm{V}^\gamma\end{array}\right)$$$

% Parameter setting of power law conversion
gamma = 0.5
% Power law conversion for V component in HSV space
U = rgb2hsv(X);
U(:,:,3) = imadjust(U(:,:,3),[],[],gamma);
Y = hsv2rgb(U);
imshow(Y)
title('Power law conversion for V component in HSV space')
% RGB空間でヒストグラム均等化
% (Histogram equalization in RGB space)
% 
% $$$\left(\begin{array}{l}y_\mathrm{R} \\ y_\mathrm{G} \\ y_\mathrm{B}\end{array}\right)=T\left(\begin{array}{l}x_\mathrm{R} 
% \\ x_\mathrm{G} \\ x_\mathrm{B}\end{array}\right)=\left(\begin{array}{l}\mathrm{histeq}(x_\mathrm{R}) 
% \\ \mathrm{histeq}(x_\mathrm{G}) \\ \mathrm{histeq}(x_\mathrm{B})\end{array}\right)$$$

% Histogram equalization in RGB space
R = histeq(X(:,:,1));
G = histeq(X(:,:,2));
B = histeq(X(:,:,3));
Y = cat(3,R,G,B);
imshow(Y)
title('Histogram equalization in RGB space')
% HSV空間でV成分のみヒストグラム均等化
% (Histogram equalization for V component in HSV space)
% 
% $$$\left(\begin{array}{l}u_\mathrm{H} \\ u_\mathrm{S} \\ u_\mathrm{V}\end{array}\right)=\mathrm{rgb2hsv}\left(\begin{array}{l}x_\mathrm{R} 
% \\ x_\mathrm{G} \\ x_\mathrm{B}\end{array}\right)$$$
% 
% $$$\left(\begin{array}{l}y_\mathrm{R} \\ y_\mathrm{G} \\ y_\mathrm{B}\end{array}\right)=\mathrm{hsv2rgb}\left(\begin{array}{c}u_\mathrm{H} 
% \\ u_\mathrm{S} \\ \mathrm{histeq}(u_\mathrm{V})\end{array}\right)$$$

% Histogram equalization for V component in HSV space
U = rgb2hsv(X);
U(:,:,3) = histeq(U(:,:,3));
Y = hsv2rgb(U);
imshow(Y)
title('Histogram equalization for V component in HSI space')
%% 
% © Copyright, Shogo MURAMATSU, All rights reserved.