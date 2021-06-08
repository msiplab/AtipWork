% practice06_12.m
%
% $Id: practice06_12.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% パラメータ設定
%　間引き率の設定（正整数）
dFactor = 2;

% 通過域端の設定
pass = 1/dFactor * (1 - 0.2);
% 阻止域端の設定
stop = 1/dFactor * (1 + 0.2);
% 重みパラメータ
alpha = 0.5;
% フィルタ次数
nOrder = 30;

%% フィルタ設計
h = eigLpFir(nOrder,pass,stop,alpha);

%% インパルス応答の表示
subplot(2,1,1)
impz(h)

%% 周波数振幅応答の表示
subplot(2,1,2)
[H,W] = freqz(h);
plot(W/pi,20*log10(abs(H)))
title(sprintf('Decimation Filter (dFactor = %d)',dFactor),'FontSize',12)
xlabel('\omega [rad]/\pi','FontSize',12)
ylabel('|H(e^{j\omega})| [dB]','FontSize',12)
axis([ 0 1 -80 20 ])
grid on
hold on
line([0 1/dFactor 1/dFactor],[0 0 -100],...
    'LineStyle',':','LineWidth',2,'Color','red')
hold off

% end
