%
% $Id: ex97_text.m,v 1.2 2006/05/29 12:08:53 sho Exp $
%
% Copyright (C) 2005-2006 Shogo MURAMATSU, All rights reserved
%

a = -1.586134342059924;
b = -0.052980118572961;
g =  0.882911075530934;
d =  0.443506852043971;
K =  1.230174104914001;

% タイプIのポリフェーズフィルタ（分析器）
u00 = [1 0]/K; u01 = d*[1 1]/K;
u10 = [0 0]; u11 = [1 0]*K;

ud00 = [0 u00];
ud01 = [u01 0];
ud10 = [0 u10];
ud11 = [u11 0];

p00 = [1 0]; p01 = [0 0];
p10 = g*[1 1]; p11 = [1 0];

udp00 = conv(ud00,p00)+conv(ud01,p10); 
udp01 = conv(ud00,p01)+conv(ud01,p11);
udp10 = conv(ud10,p00)+conv(ud11,p10); 
udp11 = conv(ud10,p01)+conv(ud11,p11);

udpd00 = [udp00 0];
udpd01 = [0 udp01];
udpd10 = [udp10 0];
udpd11 = [0 udp11];

u00 = [1 0]; u01 = b*[1 1];
u10 = [0 0]; u11 = [1 0];

udpdu00 = conv(udpd00,u00)+conv(udpd01,u10); 
udpdu01 = conv(udpd00,u01)+conv(udpd01,u11);
udpdu10 = conv(udpd10,u00)+conv(udpd11,u10); 
udpdu11 = conv(udpd10,u01)+conv(udpd11,u11);

udpdud00 = [0 udpdu00];
udpdud01 = [udpdu01 0];
udpdud10 = [0 udpdu10];
udpdud11 = [udpdu11 0];

p00 = [1 0]; p01 = [0 0];
p10 = a*[1 1]; p11 = [1 0];

e00 = conv(udpdud00,p00)+conv(udpdud01,p10); 
e01 = conv(udpdud00,p01)+conv(udpdud01,p11);
e10 = conv(udpdud10,p00)+conv(udpdud11,p10); 
e11 = conv(udpdud10,p01)+conv(udpdud11,p11);

% 分析フィルタ
h0 = upsample(e00,2)+upsample(e01,2,1);
h1 = upsample(e10,2)+upsample(e11,2,1);
fvtool(h0,1,h1,1);

% タイプIIのポリフェーズフィルタ（合成器）
p00 = [1 0]; p01 = [0 0];
p10 = -a*[1 1]; p11 = [1 0];

pd00 = [p00 0];
pd01 = [0 p01];
pd10 = [p10 0];
pd11 = [0 p11];

u00 = [1 0]; u01 = -b*[1 1]; 
u10 = [0 0]; u11 = [1 0];

pdu00 = conv(pd00,u00)+conv(pd01,u10); 
pdu01 = conv(pd00,u01)+conv(pd01,u11);
pdu10 = conv(pd10,u00)+conv(pd11,u10); 
pdu11 = conv(pd10,u01)+conv(pd11,u11);

pdud00 = [0 pdu00];
pdud01 = [pdu01 0];
pdud10 = [0 pdu10];
pdud11 = [pdu11 0];

p00 = [1 0]; p01 = [0 0];
p10 = -g*[1 1]; p11 = [1 0];

pdudp00 = conv(pdud00,p00)+conv(pdud01,p10); 
pdudp01 = conv(pdud00,p01)+conv(pdud01,p11);
pdudp10 = conv(pdud10,p00)+conv(pdud11,p10); 
pdudp11 = conv(pdud10,p01)+conv(pdud11,p11);

pdudpd00 = [pdudp00 0];
pdudpd01 = [0 pdudp01];
pdudpd10 = [pdudp10 0];
pdudpd11 = [0 pdudp11];

u00 = [1 0]*K; u01 = -d*[1 1]/K;
u10 = [0 0]; u11 = [1 0]/K;

r00 = conv(pdudpd00,u00)+conv(pdudpd01,u10); 
r01 = conv(pdudpd00,u01)+conv(pdudpd01,u11);
r10 = conv(pdudpd10,u00)+conv(pdudpd11,u10); 
r11 = conv(pdudpd10,u01)+conv(pdudpd11,u11);

% 合成フィルタ
f0 = upsample(r00,2,1)+upsample(r10,2);
f1 = upsample(r01,2,1)+upsample(r11,2);
fvtool(f0,1,f1,1);
