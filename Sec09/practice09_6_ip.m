% practice09_6.m
%
% $Id: practice09_6_ip.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2006-2015 Shogo MURAMATSU, All rights reserved
%

%% 一次元零位相FIRフィルタの準備
% カットオフ周波数
fc = 1/3; % (×π rad)

% 通過域の仕様
passEdge = fc-1/10; % (×π rad)

% 阻止域の仕様
stopEdge = fc+1/10; % (×π rad)

% 許容誤差の仕様
deltaPass = 0.01;
deltaStop = 0.01;

%% 一次元フィルタの近似仕様
specFrq = [passEdge stopEdge];
specAmp = [1 0];
specErr = [deltaPass deltaStop];
spec = firpmord(specFrq,specAmp,specErr,2,'cell');
if (mod(spec{1},2)~=0)
    spec{1}=spec{1}+1; % フィルタのタップ数が奇数となるように次数を偶数に修正
end
halfOrder = spec{1}/2;
h = firpm(spec{:});

%% 擬似円対称低域通過フィルタ用パラメータ
parameters.A = -1/2;
parameters.B = 1/2;
parameters.C = 1/2;
parameters.D = 1/4;
parameters.E = 1/4;

%% 等位線の計算
nPoints = 64;
[f1, f0] = freqspace(nPoints);
[w1, w0] = meshgrid(pi*f1,pi*f0);
g = mcClellanTrans(w1, w0, parameters);

%% 等位線の表示
figure(1)
c = contour(f1, f0, g, cos(0.1*pi:0.1*pi:0.9*pi));
clabel(c)
xlabel('\omega_1 (\times \pi rad)')
ylabel('\omega_0 (\times \pi rad)')
pbaspect([1 1 1]);

%% 二次元フィルタ設計
T = [ parameters.D  parameters.B  parameters.E;
      parameters.C 2*parameters.A parameters.C;
      parameters.E  parameters.B  parameters.D]/2;
twoDimensionalFilter = ftrans2(h,T);
% もしくは、
% delta = 1;
% twoDimensionalFilter = mcClellanTransImFilter(h, delta, T, 'full');

%% インパルス応答の表示
figure(2)
mesh(-halfOrder:halfOrder,-halfOrder:halfOrder,...
    twoDimensionalFilter)
xlabel('n_1')
ylabel('n_0')

%% 振幅応答の表示
figure(3)
freqz2cq(twoDimensionalFilter)
xlabel('\omega_1 (\times \pi rad)')
ylabel('\omega_0 (\times \pi rad)')
% end of practice09_6.m
