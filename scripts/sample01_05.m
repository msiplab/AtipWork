%[text] # Sample 1-5
%[text] ## 画像データの表現
%[text] 画像の読み込みと表示 
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Digital image representation
%[text] Image read and show
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a 
%%
%[text] ### 画像の読み込み
%[text]  (Image read)
P = imread('peppers.png');
%[text] ### 画像の情報
%[text]  (Information of image)
whos P
%%
%[text] ### 画像の表示
%[text]  (Image show)
figure(1)
imshow(P)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
