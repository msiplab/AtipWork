% practice14_10.m
%
% $Id: practice09_13_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 補間行列（2x2)
upMtx = [ 1 1 ; -1 1 ];
absDetU = abs(det(upMtx));

%% プロトタイプ一次元フィルタ設計
nOrder = 20; % プロトタイプフィルタの次数
passBandEdge = 1/absDetU * 0.8;
stopBandEdge = 1/absDetU * 1.2;
freqWeight = 0.5;
prtFilter = eigLpNqFir(...
    nOrder,passBandEdge,stopBandEdge,freqWeight,absDetU);

%% 間引きフィルタ設計1
phase = [0 0]; % 中心が残るよう間引きの位相を調整する
filter4Inp1 = absDetU * ...
   downsampleFilterDesign2(prtFilter, upMtx, phase);

%% 特性の表示
figure(1)
freqz2(filter4Inp1)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('filter 1')

%% 間引きフィルタ設計2
unimodMtx = [ 1 0 ; 1 -1 ];
phase = [0 0]; % 中心が残るよう間引きの位相を調整する
filter4Inp2 = absDetU * ... 
    downsampleFilterDesign2(prtFilter, upMtx*unimodMtx, phase);

%% 特性の表示
figure(2)
freqz2(filter4Inp2)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('filter 2')

%% インタポレーション実験パラメータ設定
% 信号の共分散行列
covMtx  = [8 0 ; 0 1 ]; %[1 2 ; 2 8];
% 信号のサイズ
sizeX = 31;

%% 二次元ガウス関数と間引きによる配列の生成
arrayX = downsample2(gaussian2cq(sizeX,covMtx),upMtx);

%% 原信号の周波数振幅特性
figure(3)
subplot(2,2,1)
freqz2(arrayX)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('Before upsampling')
axis([-1 1 -1 1 0 1.2])

%% 二次元アップサンプリング
arrayUpSpd = upsample2(arrayX,upMtx);

%% アップサンプル後の周波数振幅特性
figure(3)
subplot(2,2,2)
freqz2(arrayUpSpd)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('After upsampling')
axis([-1 1 -1 1 0 1.2])

%% 二次元インタポレーション(フィルタ1）
arrayY1 = filter2(filter4Inp1,arrayUpSpd);

%% 処理後の周波数振幅特性
figure(3)
subplot(2,2,3)
freqz2(arrayY1)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('After interpolation with filter 1')
axis([-1 1 -1 1 0 1.2])

%% 二次元インタポレーション（フィルタ2）
arrayY2 = filter2(filter4Inp2,arrayUpSpd);

%% 処理後の周波数振幅特性
figure(3)
subplot(2,2,4)
freqz2(arrayY2)
xlabel('\omega_1 (\times\pi rad)')
ylabel('\omega_0 (\times\pi rad)')
title('After interpolation with filter 2')
axis([-1 1 -1 1 0 1.2])

% end
