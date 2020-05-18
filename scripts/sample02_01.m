%% Sample 2-1
%% 画像データの入出力
% RGB-グレースケール変換 
% 
% 画像処理特論
% 
% 村松 正吾 
% 
% 動作確認: MATLAB R2020a
%% Input and output of images
% RGB to grayscale
% 
% Advanced Topics in Image Processing
% 
% Shogo MURAMATSU
% 
% Verified: MATLAB R2020a
%  準備 
% (Preparation)
% 
% 本サンプルで利用する画像でーがを収めたdata フォルダにパスをとおす。
% 
% Create a path to the data folder that contains images used in this sample.

addpath('./data')
% RGBからグレースケールへ
% (RGB to Grayscale)
% 
% RGB色空間からグレースケールへの変換の定義
% 
% Definition of conversion from RGB color space to grayscale.
% 
% $$x_\mathrm{Y} = 0.2989x_\mathrm{R}+0.5870x_\mathrm{G}+0.1140x_\mathrm{B}$$

% Importing color images
pictureRgb = imread('firenzeRgb.jpg');
% COnversion to grayscale
pictureGray = uint8(...
    0.2959 * double(pictureRgb(:,:,1)) + ... % R
    0.5870 * double(pictureRgb(:,:,2)) + ... % G
    0.1140 * double(pictureRgb(:,:,3)) ...   % B
);
whos pictureRgb pictureGray
% uint8型画像の表示
% (Image show in uint8)
%% 
% * RGBカラー画像(RGB color image)
% * グレースケール画像(Grayscale image)

figure(1)
imshow(pictureRgb)
figure(2)
imshow(pictureGray)
% RGB2GRAY関数
% (RGB2GRAY funciton)
% 
% 入出力のデータ型を保存するグレースケール変換関数
% 
% Grayscale conversion function to store input and output data types.

pictureRgbDouble = im2double(pictureRgb);
pictureGrayDouble = rgb2gray(pictureRgbDouble);
whos pictureRgbDouble pictureGrayDouble
% double型画像の表示
% (Image show in double)
%% 
% * RGBカラー画像(RGB color image)
% * グレースケール画像(Grayscale image)

figure(3)
imshow(pictureRgbDouble)
figure(4)
imshow(pictureGrayDouble)
% 画像ビューアアプリ
% (Image viewer app)
%% 
% * RGBカラー画像(RGB color image)
% * グレースケール画像(Grayscale image)

imtool(pictureRgbDouble)
imtool(pictureGrayDouble)
%% 
% © Copyright, Shogo MURAMATSU, All rights reserved.