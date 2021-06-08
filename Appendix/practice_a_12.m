% practice_a_12.m
%
% $Id:$
%
% Copyright (C) 2012-2015 Shogo MURAMATSU, All rights reserved
%

%% 配列の設定
nRows = 2;
nCols = 3;
X = rand(nRows,nCols);
fprintf('画像 X\n')
disp(X)

%% 零値挿入率の設定
L = [ 2 2 ]; % [ 垂直零値挿入率 水平零値挿入率 ]
fprintf('零値挿入率(垂直 水平) L\n')
disp(L)

%% 零値挿入処理
Y = upsample(upsample(X,L(1)).',L(2)).';
fprintf('画像 Y\n')
disp(Y)

%% 画像Xの列ベクトル化
x = X(:);

%% 零値挿入行列の生成
nPixels = prod(L)*nRows*nCols;
I = eye(nPixels);
idx = [];
for iCol = 1:nCols*L(2)
    for iRow = 1:nRows*L(1)
        if mod(iCol-1,L(2))==0 && mod(iRow-1,L(1))==0 
            k = (iCol-1)*nRows*L(1)+iRow;
            idx = union(idx,k);
        end
    end
end
U = I(idx,:).';
fprintf('零値挿入行列 U\n')
disp(U)

%% 零値挿入処理（行列演算）
y = U*x;

%% 評価
disp('零値挿入処理（行列演算）の評価結果')
mse = sum((Y(:)-y).^2)/numel(Y);
fprintf('mse = %f\n',mse);
