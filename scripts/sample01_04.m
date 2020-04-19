%% Sample 1-4
%% 画像データの表現
% 配列の生成
% 
% 
% 
% 画像処理特論
% 
% 村松 正吾 
% 
% 動作確認: MATLAB R2020a
%% Digital image representation
% Creation of arrays
% 
% 
% 
% Advanced Topics in Image Processing
% 
% Shogo MURAMATSU
% 
% Verified: MATLAB R2020a
% ワークスペースのクリア
% (Clear workspace)

clear
% 全ての要素が零の配列の生成
% (Create array of all zeros)

X = zeros(2,3) % zeros array of size 2x3
% 全ての要素が１の配列の生成
% (Create array of all ones)

Y = ones(3,4) % ones array of size 3x4
% ランダム配列の生成
% (Create array of random numbers)

Z = rand(2,3,4) % random array of size 2x3x4
% 配列のサイズ
% (Array size)

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

% ワークスペース内の変数のリスト
% (List variables in workspace)

whos
%% 
% © Copyright, Shogo MURAMATSU, All rights reserved.
% 
%