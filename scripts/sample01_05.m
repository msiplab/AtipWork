%% Sample 1-5
%% 画像データの表現
% 画像の読み込みと表示 
% 
% 画像処理特論
% 
% 村松 正吾 
% 
% 動作確認: MATLAB R2023a
%% Digital image representation
% Image read and show
% 
% Advanced Topics in Image Processing
% 
% Shogo MURAMATSU
% 
% Verified: MATLAB R2023a 
% 画像の読み込み
% (Image read)

P = imread('peppers.png');
% 画像の情報
% (Information of image)

whos P
% 画像の表示
% (Image show)

figure(1)
imshow(P)
%% 
% © Copyright, Shogo MURAMATSU, All rights reserved.