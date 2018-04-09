% practice_a_11.m
%
% $Id:$
%
% Copyright (C) 2012-2015 Shogo MURAMATSU, All rights reserved
%

%% 配列の設定
nRows = 4;
nCols = 6;
X = rand(nRows,nCols);
fprintf('画像 X\n')
disp(X)

%% 間引き率の設定
L = [ 2 2 ]; % [ 垂直間引き率 水平間引き率 ]
fprintf('間引き率(垂直 水平) L\n')
disp(L)

%% 間引き処理
Y = downsample(downsample(X,L(1)).',L(2)).';
fprintf('画像 Y\n')
disp(Y)

%% 画像Xの列ベクトル化
x = X(:);

%% 間引き行列の生成
nPixels = nRows*nCols;
I = eye(nPixels);
idx = [];
for iCol = 1:nCols
    for iRow = 1:nRows
        if mod(iCol-1,L(2))==0 && mod(iRow-1,L(1))==0 
            k = (iCol-1)*nRows+iRow;
            idx = union(idx,k);
        end
    end
end
S = I(idx,:);
fprintf('間引き行列 S\n')
disp(S)

%% 間引き処理（行列演算）
y = S*x;

%% 評価
disp('間引き処理（行列演算）の評価結果')
mse = sum((Y(:)-y).^2)/numel(Y);
fprintf('mse = %f\n',mse);
