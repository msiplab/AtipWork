% practice07_13_text.m
%
% $Id: practice07_13_text.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

% 9/7変換の分析・合成フィルタのインパルス応答については、
% lifting97.mat に保存している。
% load して、h0, h1, f0, f1 を確認して欲しい。
%
% a = -1.586134342059924;
% b = -0.052980118572961;
% g =  0.882911075530934;
% d =  0.443506852043971;
% K =  1.230174104914001;
%

% 以下は、5/3変換の例　(参考：practice07_13.m ）

%% タイプIのポリフェーズフィルタ（分析器）
u00 = [1 0]; u01 = [1 1]/4;
u10 = [0 0]; u11 = [1 0];

ud00 = [0 u00]; ud01 = [u01 0];
ud10 = [0 u10]; ud11 = [u11 0];

p00 = [1 0]; p01 = [0 0];
p10 = -[1 1]/2; p11 = [1 0];

e00 = conv(ud00,p00)+conv(ud01,p10); e01 = conv(ud00,p01)+conv(ud01,p11);
e10 = conv(ud10,p00)+conv(ud11,p10); e11 = conv(ud10,p01)+conv(ud11,p11);

%% 分析フィルタ
h0 = upsample(e00,2)+upsample(e01,2,1);
h1 = upsample(e10,2)+upsample(e11,2,1);
fvtool(h0,1,h1,1);

%% タイプIIのポリフェーズフィルタ（合成器）
p00 = [1 0]; p01 = [0 0];
p10 = [1 1]/2; p11 = [1 0];

pd00 = [p00 0]; pd01 = [0 p01];
pd10 = [p10 0]; pd11 = [0 p11];

u00 = [1 0]; u01 = -[1 1]/4;
u10 = [0 0]; u11 = [1 0];

r00 = conv(pd00,u00)+conv(pd01,u10); r01 = conv(pd00,u01)+conv(pd01,u11);
r10 = conv(pd10,u00)+conv(pd11,u10); r11 = conv(pd10,u01)+conv(pd11,u11);

%% 合成フィルタ
f0 = upsample(r00,2,1)+upsample(r10,2);
f1 = upsample(r01,2,1)+upsample(r11,2);
fvtool(f0,1,f1,1);

