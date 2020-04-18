% practice14_6.m
%
% $Id: practice09_9_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% パラメータ設定
% 垂直の補間率
verticalInpFactor = 3;
% 水平の補間率
horizontalInpFactor = 2;

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
title('Before upsampling')

%% アップサンプリング
arrayY = ...
    upsample(...
        upsample(arrayX,...
            verticalInpFactor).',...
               horizontalInpFactor).';

%% 処理後の周波数振幅特性
figure(2)
freqz2(arrayY)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('After upsampling')
        
% end
