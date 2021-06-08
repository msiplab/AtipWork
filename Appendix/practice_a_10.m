% practice_a_10.m
%
% $Id:$
%
% Copyright (C) 2012-2015 Shogo MURAMATSU, All rights reserved
%

%% 配列の設定
nRows = 3;
nCols = 4;
X = rand(nRows,nCols);
fprintf('画像 X\n')
disp(X)

%% フィルタの設定
h = [ 1 2; 3 4 ];
fprintf('インパルス応答 h\n')
disp(h)

%% 反転フィルタの設定
f = rot90(h,2);
fprintf('インパルス応答 f\n')
disp(f)

%% 反転フィルタによる（巡回）畳込み演算
Y = imfilter(X,f,'conv','circ');
fprintf('画像 Y\n')
disp(Y)

%% 画像Xの列ベクトル化
x = X(:);

%% （巡回）畳込み行列の生成
nPixels = nRows*nCols;
H = zeros(nPixels,nPixels);
imph = zeros(nRows,nCols);
imph(1:size(h,1),1:size(h,2)) = h;
imph = circshift(imph,-floor(size(h)/2));
for n = 1:nPixels
    for k = 1:nPixels
        iRow = mod(mod(n-1,nRows) - mod(k-1,nRows), nRows) + 1;
        iCol = mod(floor((n-1)/nRows) - floor((k-1)/nRows), nCols) + 1;
        H(n,k) = imph(iRow,iCol);
    end
end
fprintf('畳込み行列 H\n')
disp(H)

%% 転置行列の設定
F = H.';
fprintf('転置畳込み行列 F\n')
disp(F)

%% （巡回）畳込み演算
y = F*x;
U = circshift(reshape(y,nRows,nCols),-mod(floor(size(h.')/2),2)); % 位置調整

%% 評価
disp('反転フィルタリングの行列演算評価結果')
mse = sum((Y(:)-U(:)).^2)/numel(Y);
fprintf('mse = %f\n',mse);
