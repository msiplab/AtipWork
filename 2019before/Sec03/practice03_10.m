%
% $Id: practice03_10.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% フィルタ次数
nOrder = 60;

%% 通過域端
edgePass = .45;

%% 通過域利得
gainPass = 1;

%% 阻止域端
edgeStop = .55;

%% フィルタ設計
h = firpm(nOrder,...
   [0 edgePass edgeStop 1],[gainPass gainPass 0 0]);
disp(h)

%% FIR直接型構成
%Hd = dfilt.dffir(h);

%% インパルス応答表示
%impz(Hd);

%% 周波数応答表示
%freqz(Hd);

% end
