%[text] # Sample 3-4
%[text] ## 平滑化／先鋭化処理
%[text] 順序統計フィルタ 
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Image smoothing/sharpening
%[text] Oder statistic filter
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### サンプル画像の準備
%[text] (Preparation of sample image)
close
% Reading original image
I = im2double(imread('cameraman.tif'));
figure(1)
imshow(I)
title('Original')
%%
%[text] ### ゴマ塩ノイズ画像の準備
%[text] (Preparation of a contaminated image with salt & pepper noise)
% Density
d = 0.05; %[control:slider:998b]{"position":[5,9]}
% Add noise
J = imnoise(I,'salt & pepper',d);

% Show the result
figure(2)
imshow(J)
title('Contaminated image')
%%
%[text] ### 中央値フィルタ
%[text] (Median filter)
% Domain size setting 
hsize = 3 %[control:slider:4408]{"position":[9,10]}
% Median fltering
K = medfilt2(J,[hsize hsize]);

% Show the result
figure(3)
imshow(K)
title('Median filter')
%%
%[text] ### 最大値フィルタ
%[text] (Maximum filter)
% Domain setting
hsize = 3; %[control:slider:4efb]{"position":[9,10]}
domain = ones(hsize);

% Maximum filtering
L = ordfilt2(J,nnz(domain),domain);

% Show the result
figure(4)
imshow(L)
title('Maximum filter')
%%
%[text] ### 最小値フィルタ
%[text] (Minumum filter)
% Domain setting
hsize = 3; %[control:slider:0772]{"position":[9,10]}
domain = ones(hsize);

% Minimum filtering
M = ordfilt2(J,1,domain);

% Show the result
figure(5)
imshow(M)
title('Minimum filter')
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:998b]
%   data: {"defaultValue":0.05,"label":"d","max":1,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":0.05}
%---
%[control:slider:4408]
%   data: {"defaultValue":3,"label":"hsize","max":31,"min":1,"run":"Section","runOn":"ValueChanging","step":2}
%---
%[control:slider:4efb]
%   data: {"defaultValue":3,"label":"hsize","max":31,"min":1,"run":"Section","runOn":"ValueChanging","step":2}
%---
%[control:slider:0772]
%   data: {"defaultValue":3,"label":"hsize","max":31,"min":1,"run":"Section","runOn":"ValueChanging","step":2}
%---
