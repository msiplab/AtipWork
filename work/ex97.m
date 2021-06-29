%
% $Id: ex97.m,v 1.2 2006/05/29 12:08:53 sho Exp $
%
% Copyright (C) 2005-2006 Shogo MURAMATSU, All rights reserved
%

a = -1.586134342059924;
b = -0.052980118572961;
g =  0.882911075530934;
d =  0.443506852043971;
K =  1.230174104914001;

% タイプIのポリフェーズフィルタ（分析器）
u00 = 1/K; u01 = d*[1 1]/K;
u10 = 0; u11 = K;

ud00 = [0 u00];
ud01 = u01;
ud10 = 0;
ud11 = u11;

p00 = 1; p01 = 0;
p10 = g*[1 1]; p11 = 1;

udp00 = [ud00 0]+conv(ud01,p10); 
udp01 = ud01;
udp10 = conv(ud11,p10); 
udp11 = ud11;

udpd00 = udp00;
udpd01 = [0 udp01]; 
udpd10 = udp10;
udpd11 = [0 udp11];

u00 = 1; u01 = b*[1 1];
u10 = 0; u11 = 1;

udpdu00 = udpd00;
udpdu01 = conv(udpd00,u01)+[udpd01 0];
udpdu10 = udpd10;
udpdu11 = conv(udpd10,u01)+[udpd11 0];

udpdud00 = [0 udpdu00];
udpdud01 = udpdu01;
udpdud10 = [0 udpdu10];
udpdud11 = udpdu11;

p00 = 1; p01 = 0;
p10 = a*[1 1]; p11 = 1;

e00 = [udpdud00 0]+conv(udpdud01,p10); 
e01 = udpdud01;
e10 = [udpdud10 0]+conv(udpdud11,p10); 
e11 = udpdud11;

% 分析フィルタ
[e00,e01] = eqtflength(e00,e01); % 長さを揃える
h0 = upsample(e00,2) + upsample(e01,2,1);
h0 = h0(1:end-1); % 最後の零値を取り除く

[e10,e11] = eqtflength(e10,e11); % 長さを揃える
h1 = upsample(e10,2) + upsample(e11,2,1);
h1 = h1(1:end-1); % 最後の零値を取り除く

fvtool(h0,1,h1,1);

% タイプIIのポリフェーズフィルタ（合成器）
p00 = 1; p01 = 0;
p10 = -a*[1 1]; p11 = 1;

pd00 = 1;
pd01 = 0;
pd10 = p10;
pd11 = [0 1];

u00 = 1; u01 = -b*[1 1]; 
u10 = 0; u11 = 1;

pdu00 = 1;
pdu01 = u01;
pdu10 = pd10;
pdu11 = conv(pd10,u01)+[pd11 0];

pdud00 = [0 1];
pdud01 = pdu01;
pdud10 = [0 pdu10];
pdud11 = pdu11;

p00 = 1; p01 = 0;
p10 = -g*[1 1]; p11 = 1;

pdudp00 = [pdud00 0]+conv(pdud01,p10); 
pdudp01 = pdud01;
pdudp10 = [pdud10 0]+conv(pdud11,p10); 
pdudp11 = pdud11;

pdudpd00 = pdudp00;
pdudpd01 = [0 pdudp01];
pdudpd10 = pdudp10;
pdudpd11 = [0 pdudp11];

u00 = K; u01 = -d*[1 1]/K;
u10 = 0; u11 = 1/K;

r00 = conv(pdudpd00,u00);
r01 = conv(pdudpd00,u01)+[conv(pdudpd01,u11) 0]; 
r10 = conv(pdudpd10,u00);
r11 = conv(pdudpd10,u01)+[conv(pdudpd11,u11) 0];

% 合成フィルタ
[r00,r10] = eqtflength(r00,r10); % 長さを揃える
f0 = upsample(r00,2,1)+upsample(r10,2);
f0 = f0(1:end-1); % 最後の零値を取り除く

[r01,r11] = eqtflength(r01,r11); % 長さを揃える
f1 = upsample(r01,2,1)+upsample(r11,2);
f1 = f1(1:end-1); % 最後の零値を取り除く

fvtool(f0,1,f1,1);

% end
