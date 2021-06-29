% practice09_12.m
%
% $Id: practice09_12.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 間引き行列（2x2)
downMtx = [ 1 1 ; -1 1 ];

absDetD = abs(det(downMtx));

%% プロトタイプ一次元フィルタ設計
nOrder = 20; % プロトタイプフィルタの次数
passBandEdge = 1/absDetD * 0.8;
stopBandEdge = 1/absDetD * 1.2;
freqWeight = 0.5;
prtFilter = eigLpFir(nOrder,passBandEdge,stopBandEdge,freqWeight);

%% 間引きフィルタ設計1
phase = [0 0]; % 中心が残るよう間引きの位相を調整する
filter4Dec1 = downsampleFilterDesign2(prtFilter, downMtx,phase);

%% 特性の表示
figure(1)
freqz2cq(filter4Dec1)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('filter 1')

%% 間引きフィルタ設計2
unimodMtx = [ 1 0 ; 1 -1 ];
phase = [0 0]; % 中心が残るよう間引きの位相を調整する
filter4Dec2 = downsampleFilterDesign2(prtFilter, downMtx*unimodMtx, phase);

%% 特性の表示
figure(2)
freqz2cq(filter4Dec2)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('filter 2')

%% デシメーション実験用パラメータ設定
% 信号の共分散行列
covMtx  = [1 2 ; 2 8];
% 信号のサイズ
sizeX = 63;

%% 二次元ガウス関数による配列の生成
arrayX = gaussian2cq(sizeX,covMtx);

%% 原信号の周波数振幅特性
figure(3)
freqz2cq(arrayX)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('Before decimation')
axis([-1 1 -1 1 0 1.2])
    
%% 二次元デシメーション（フィルタ1）
arrayFiltd1 = filter2(filter4Dec1,arrayX);
arrayY1 = downsample2(arrayFiltd1,downMtx);

%% 処理後の周波数振幅特性
figure(4)
subplot(2,2,1)
freqz2cq(arrayFiltd1)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('After filtering with filter 1')
axis([-1 1 -1 1 0 1.2])

figure(4)
subplot(2,2,2)
freqz2cq(arrayY1)
xlabel('\omega_1/\pi')
ylabel('\omega_0/\pi')
title('After decimation with filter 1')
axis([-1 1 -1 1 0 1.2])

%% 二次元デシメーション（フィルタ2）
arrayFiltd2 = filter2(filter4Dec2,arrayX);
arrayY2 = downsample2(arrayFiltd2,downMtx);

%% 処理後の周波数振幅特性
figure(4)
subplot(2,2,3)
freqz2cq(arrayFiltd2)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('After filtering with filter 2')
axis([-1 1 -1 1 0 1.2])

figure(4)
subplot(2,2,4)
freqz2cq(arrayY2)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('After decimation with filter 2')
axis([-1 1 -1 1 0 1.2])

% end
