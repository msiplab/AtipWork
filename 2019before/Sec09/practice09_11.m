% practice09_11.m
%
% $Id: practice09_11.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 補間率と間引き率
% 垂直補間率
up0 = 2;
% 垂直間引き率
down0 = 3;

% 水平補間率
up1 = 2;
% 水平間引き率
down1 = 3;

%% 画像の読込
pictureOriginal = rgb2graycq(imread('./data/barbaraFaceRgb.tif'));

%% 原画像
figure(1)
imshowcq(pictureOriginal)
title('Before conversion of sampling lattice')

%% 垂直用フィルタ設計
factor0 = max(up0,down0);
order0 = 2 * (up0 * down0 - 1);
edgePassBand0 = 1/factor0 * 0.5;
edgeStopBand0 = 1/factor0 * 1.5;
weight0 = 0.5; % pass:stop = 1:1
g0 = eigLpFir(order0,edgePassBand0,edgeStopBand0,weight0);

%% 水平用フィルタ設計
factor1 = max(up1,down1);
order1 = 2 * (up1 * down1 - 1);
edgePassBand1 = 1/factor1 * 0.5;
edgeStopBand1 = 1/factor1 * 1.5;
weight1 = 0.5; % pass:stop = 1:1
g1 = eigLpFir(order1,edgePassBand1,edgeStopBand1,weight1);

%% 2次元フィルタ
G = up0 * up1 * kron(g1.',g0);
figure(2)
freqz2cq(G)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')

%% 2次元アップサンプリング
upMtx = diag([up0 up1]);
pictureU = upsample2(pictureOriginal,upMtx);

%% 2次元畳み込み
clear pictureG
nComponents = size(pictureU,3);
for iComponent=1:nComponents
    pictureG(:,:,iComponent) = ...
        filter2(G,double(pictureU(:,:,iComponent)),'same');
end

%% 2次元ダウンサンプリング
downMtx = diag([down0 down1]);
pictureOutput = uint8(downsample2(pictureG,downMtx));

%% 処理画像
figure(3)
imshowcq(pictureOutput)
title('After conversion of sampling lattice')
        
% end
