% practice07_2.m
%
% $Id: practice07_2_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 原画像の読込
pictureRgb = imread('data/barbaraFaceRgb.tif');
pictureGray = rgb2gray(pictureRgb);

%% 原画像の表示
figure(1)
imshow(pictureGray)
title('Original picture')

%% 二次元ベクトル集合の抽出
nPixels = numel(pictureGray);
setOfX = reshape(pictureGray.', 2, nPixels/2);

%% 変換前の散布図
figure(2)
scatter(setOfX(1,:),setOfX(2,:),'.')
axis square
xlabel('x_0')
ylabel('x_1')
title('Scatter plot (before transform)')

%% 信号変換
setOfY = 1 / sqrt(2) * [ 1 1 ; -1 1 ] * double(setOfX);

%% 変換後の散布図
figure(3)
scatter(setOfY(1,:),setOfY(2,:),'.')
axis square
xlabel('y_0')
ylabel('y_1')
title('Scatter plot (after transform)')

% end
