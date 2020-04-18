% practice07_7.m
%
% $Id: practice07_7_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% ベクトルの次数
nPoints = 2;

%% 原画像の読込
pictureRgb = imread('data/barbaraRgb.tif');
pictureGray = rgb2gray(pictureRgb);

%% 二次元ベクトル集合の抽出
nPixels = numel(pictureGray);
setOfX = reshape(pictureGray.', nPoints, nPixels/nPoints);

%% 共分散行列
Rxx = cov(double(setOfX.'));

%% 固有値分解
[V,D] = eig(Rxx);

%% 固有値のソート
[Y,I] = sort(diag(D));  

%% 固有ベクトルを並び換えと転置
Phi = V(:,nPoints-I+1).';
disp('Phi')
disp(Phi)

% end
