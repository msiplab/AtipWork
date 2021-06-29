% practice09_7.m
%
% $Id: practice09_7_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% パラメータ設定
% 垂直の間引き率
verticalDecFactor = 2;
% 水平の間引き率
horizontalDecFactor = 3;

% 配列の標準偏差
sigma = 2;
% 配列のサイズ
sizeX = 31;

%% 2次元ガウス関数による配列の生成
arrayX = fspecial('gaussian',sizeX,sigma);

%% 原信号の周波数振幅特性
figure(1)
freqz2(arrayX)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('Before downsampling')

%% ダウンサンプリング
arrayY = ...
    downsample(...
        downsample(arrayX,...
            verticalDecFactor).',...
            horizontalDecFactor).';

%% 処理後の周波数振幅特性
figure(2)
freqz2(arrayY)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('After downsampling')
        
% end
