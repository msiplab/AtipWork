%[text] # Sample 2-1
%[text] ## 画像データの入出力
%[text] RGB-グレースケール変換 
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Input and output of images
%[text] RGB to grayscale
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ###  準備 
%[text] (Preparation)
%[text] 本サンプルで利用する画像でーがを収めたdata フォルダにパスをとおす。
%[text] Create a path to the data folder that contains images used in this sample.
addpath('./data')
%%
%[text] ### RGBからグレースケールへ
%[text] (RGB to Grayscale)
%[text] RGB色空間からグレースケールへの変換の定義
%[text] Definition of conversion from RGB color space to grayscale.
%[text]{"align":"center"} $x\_\\mathrm{Y} = 0.2989x\_\\mathrm{R}+0.5870x\_\\mathrm{G}+0.1140x\_\\mathrm{B}$
% Importing color images
pictureRgb = imread('firenzeRgb.jpg');
% COnversion to grayscale
pictureGray = uint8(...
    0.2959 * double(pictureRgb(:,:,1)) + ... % R
    0.5870 * double(pictureRgb(:,:,2)) + ... % G
    0.1140 * double(pictureRgb(:,:,3)) ...   % B
);
whos pictureRgb pictureGray
%%
%[text] ### uint8型画像の表示
%[text] (Image show in uint8)
%[text] - RGBカラー画像(RGB color image)
%[text] - グレースケール画像(Grayscale image) \
figure(1)
imshow(pictureRgb)
figure(2)
imshow(pictureGray)
%%
%[text] ### RGB2GRAY関数
%[text] (RGB2GRAY funciton)
%[text] 入出力のデータ型を保存するグレースケール変換関数
%[text] Grayscale conversion function to store input and output data types.
pictureRgbDouble = im2double(pictureRgb);
pictureGrayDouble = rgb2gray(pictureRgbDouble);
whos pictureRgbDouble pictureGrayDouble
%%
%[text] ### double型画像の表示
%[text] (Image show in double)
%[text] - RGBカラー画像(RGB color image)
%[text] - グレースケール画像(Grayscale image) \
figure(3)
imshow(pictureRgbDouble)
figure(4)
imshow(pictureGrayDouble)
%%
%[text] ### 画像ビューアアプリ
%[text] (Image viewer app)
%[text] - RGBカラー画像(RGB color image)
%[text] - グレースケール画像(Grayscale image) \
imtool(pictureRgbDouble)
imtool(pictureGrayDouble)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
