% practice09_3.m
%
% $Id: practice09_3_ip.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2006-2015 Shogo MURAMATSU, All rights reserved
%

%% パラメータ設定
% 通過域の仕様
passEdge0 = 1/3-1/10; % 垂直 (×π rad)
passEdge1 = 1/3-1/10; % 水平 (×π rad)

% 阻止域の仕様
stopEdge0 = 1/3+1/10; % 垂直 (×π rad)
stopEdge1 = 1/3+1/10; % 水平 (×π rad)

% 許容誤差の仕様
deltaPass = 0.01;
deltaStop = 0.01;

% 各次元の許容誤差の仕様
deltaPass0 = sqrt(1+deltaPass)-1;
deltaStop0 = deltaStop/(1+deltaPass0);
deltaPass1 = sqrt(1+deltaPass)-1;
deltaStop1 = deltaStop/(1+deltaPass1);

%% フィルタ H_0 の近似仕様
specFrq0 = [passEdge0 stopEdge0];
specAmp0 = [1 0];
specErr0 = [deltaPass0 deltaStop0];
spec0 = firpmord(specFrq0,specAmp0,specErr0,2,'cell');
if (mod(spec0{1},2)~=0)
    spec0{1}=spec0{1}+1; % フィルタのタップ数が奇数となるように修正
end
halfOrder0 = spec0{1}/2;

%% フィルタ H_1 の近似仕様
specFrq1 = [passEdge1 stopEdge1];
specAmp1 = [1 0];
specErr1 = [deltaPass1 deltaStop1];
spec1 = firpmord(specFrq1,specAmp1,specErr1,2,'cell');
if (mod(spec1{1},2)~=0)
    spec1{1}=spec1{1}+1; % フィルタのタップ数が奇数となるように修正
end
halfOrder1 = spec1{1}/2;

%% 各次元のフィルタ設計
oneDimensionalFilter0 = firpm(spec0{:});
oneDimensionalFilter1 = firpm(spec1{:});

%% フィルタ特性の表示
figure(1)
impz(oneDimensionalFilter0)
figure(2)
freqz(oneDimensionalFilter0)
figure(3)
impz(oneDimensionalFilter1)
figure(4)
freqz(oneDimensionalFilter1)

%% 可分離二次元フィルタ
twoDimensionalFilter = ...
    kron(oneDimensionalFilter1(:).',oneDimensionalFilter0(:));
figure(5)
mesh(-halfOrder1:halfOrder1,-halfOrder0:halfOrder0,...
    twoDimensionalFilter)
xlabel('n_1')
ylabel('n_0')

figure(6)
freqz2(twoDimensionalFilter)
xlabel('\omega_1 (\times \pi rad)')
ylabel('\omega_0 (\times \pi rad)')

% end of practice08_8.m
