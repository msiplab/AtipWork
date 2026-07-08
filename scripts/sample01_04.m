%[text] # Sample 1-4
%[text] ## 画像データの表現
%[text] 配列の生成
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Digital image representation
%[text] Creation of arrays
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a 
%%
%[text] ### ワークスペースのクリア
%[text]  (Clear workspace)
clear
%%
%[text] ### 全ての要素が零の配列の生成
%[text] (Create array of all zeros)
X = zeros(2,3) % zeros array of size 2x3
%[text] ### 全ての要素が１の配列の生成
%[text]  (Create array of all ones)
Y = ones(3,4) % ones array of size 3x4
%%
%[text] ### ランダム配列の生成
%[text]  (Create array of random numbers)
Z = rand(2,3,4) % random array of size 2x3x4
%%
%[text] ### 配列のサイズ
%[text]  (Array size)
disp('Size of X')
size(X)

disp('Size of Y')
size(Y)

disp('Size of Z')
size(Z)
% 配列のタイプ
% (Array type)

disp('Type of X')
class(X)

L = zeros(2,3,'logical');
disp('Type of L')
class(L)

U = zeros(2,3,'uint8');
disp('Type of U')
class(U)

I = zeros(2,3,'int16');
disp('Type of I')
class(I)

S = zeros(2,3,'single');
disp('Type of S')
class(S)
%%
%[text] ### ワークスペース内の変数のリスト
%[text]  (List variables in workspace)
whos
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
