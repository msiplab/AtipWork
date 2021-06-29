% practice06_9.m
%
% $Id: practice06_9.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%%　補間率の設定（2以上の整数）
uFactor = 2;

%% フィルタのインパルス応答の設定
lineIntpFilter = [1:uFactor-1 uFactor uFactor-1:-1:1]/uFactor;

%% インパルス応答の表示
subplot(2,1,1)
impz(lineIntpFilter)
set(gca,'XLim',[-1 length(lineIntpFilter)])

%% 周波数振幅特性の表示
subplot(2,1,2)
[H,W] = freqz(lineIntpFilter);
plot(W/pi,20*log10(abs(H)))
title(sprintf('Linear Interpolation Filter (uFactor = %d)',uFactor),...
    'FontSize',12)
xlabel('\omega [rad]/\pi','FontSize',12)
ylabel('|F(e^{j\omega})| [dB]','FontSize',12)
gain = 20*log10(uFactor);
axis([ 0 1 -80+gain 20+gain])
grid on
hold on
line([0 1/uFactor 1/uFactor],[gain gain -100],...
    'LineStyle',':','LineWidth',2,'Color','red')
hold off

% end
