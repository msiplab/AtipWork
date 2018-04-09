%
% $Id: practice03_9.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% フィルタ係数
b = [1 1]/2;
a = [1 -1/2];

%% インパルス応答の表示
figure(1);
impz(b,a);

%% Z平面表示
figure(2);
zplane(b,a);

%% 周波数応答
figure(3);
freqz(b,a);

% end
