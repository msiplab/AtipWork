% practice14_5.m
%
% $Id: practice09_8_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% パラメータ設定
% 間引き行列（2x2)
downMtx = [ 1 1 ; -1 1 ];

% 配列の共分散行列
covMtx  = [2 0 ; 0 1];
% 配列のサイズ
sizeX = 31;

%% 2次元ガウス関数による配列の生成
arrayX = gaussian2cq(sizeX,covMtx);

%% 原信号の周波数振幅特性
figure(1)
freqz2(arrayX)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('Before downsampling')

%% 2次元ダウンサンプリング
arrayY = downsample2(arrayX,downMtx);

%% 処理後の周波数振幅特性
figure(2)
freqz2(arrayY)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('After downsampling')
        
% end
