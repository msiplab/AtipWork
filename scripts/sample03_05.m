%[text] # Sample 3-5
%[text] ## 平滑化／先鋭化処理
%[text] 境界処理 
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Image smoothing/sharpening
%[text] Boundary operation
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 配列のパディング
%[text] (Pad array)
%[text] - Zero padding
%[text] - Periodic extension
%[text] - Symmetric extension \
% Pad size setting
padsize = 2; %[control:slider:4e97]{"position":[11,12]}
%
A = randi(8,4)
% Zero padding
B = padarray(A,[padsize padsize],0,'both')
% Periodic extension
C = padarray(A,[padsize padsize],'circular','both')
% Symmetric extension
D = padarray(A,[padsize padsize],'symmetric','both')
%[text] 
%%
%[text] ### サンプル画像の準備
%[text] (Preparation of sample image)
%[text] 本サンプルで利用する画像データを収めたdata フォルダにパスをとおす。
%[text] Create a path to the data folder that contains images used in this sample.
addpath('./data')
close
% Reading original image
I = im2double(imread('barbaraFaceRgb.tif'));
figure(1)
imshow(I)
title('Original')
%%
%[text] ### フィルタの設定
%[text] (Filter setting)
% Filter setting
hsize = 3; %[control:slider:70f6]{"position":[9,10]}
f = fspecial('average',hsize);
%%
%[text] ### 零値拡張
%[text] (Zero padding)
% Zero padding
Jz = imfilter(I,f);

% Show result
figure(2)
imshow(Jz)
title('After filtering (zero padding)')
%%
%[text] ### 周期拡張
%[text] (Periodic extension)
% Periodic extension
Jp = imfilter(I,f,'circular');

% Show result
figure(3)
imshow(Jp)
title('After filtering (periodic extension)')
%%
%[text] ### 対称拡張
%[text] (Symmetric extension)
% Symmetric extension
Js = imfilter(I,f,'symmetric');

% Show result
figure(4)
imshow(Js)
title('After filtering (symmetric extension)')
%%
%[text] ### 結果の比較
%[text] (Comparison)
% Patch size
psize = 64;

% Zero padding
figure(5)
subplot(1,3,1)
imshow(Jz(end-psize+1:end,1:psize,:))
title('Zero padding')

% Periodic extension
subplot(1,3,2)
imshow(Jp(end-psize+1:end,1:psize,:))
title('Periodic extension')

% Zero padding
subplot(1,3,3)
imshow(Js(end-psize+1:end,1:psize,:))
title('Symmetric extension')
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:4e97]
%   data: {"defaultValue":2,"label":"padsize","max":5,"min":0,"run":"Section","runOn":"ValueChanging","step":1}
%---
%[control:slider:70f6]
%   data: {"defaultValue":3,"label":"hsize","max":17,"min":1,"run":"SectionToEnd","runOn":"ValueChanging","step":2}
%---
