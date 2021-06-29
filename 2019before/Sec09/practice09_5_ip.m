% practice09_5.m
%
% $Id: practice09_5_ip.m,v 1.4 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2006-2007 Shogo MURAMATSU, All rights reserved
%

% カットオフ周波数
fc = 1/4;  % (×π rad)

% 通過域の仕様
passEdge = fc-1/10; % (×π rad)

% 阻止域の仕様
stopEdge = fc+1/10; % (×π rad)

% 許容誤差の仕様
deltaPass = 0.01;
deltaStop = 0.01;

% フィルタ H の近似仕様
specFrq = [passEdge stopEdge];
specAmp = [1 0];
specErr = [deltaPass deltaStop];
[n,Wn,beta,typ] = kaiserord(specFrq,specAmp,specErr,2);
if (mod(n,2)~=0)
    n=n+1; % 窓長が奇数となるように次数を偶数に修正
end
halfOrder = n/2;

% 窓関数と理想フィルタの設定
[iHorizontal,iVertical] = ...
    meshgrid(-halfOrder:halfOrder,-halfOrder:halfOrder);
r = sqrt(iHorizontal.^2+iVertical.^2);
w = contKaiser(r,halfOrder,beta);
iOrg = find(r==0);
r(iOrg) = 1;
idealFilter = (fc/2)*besselj(1,pi*fc*r)./r;
idealFilter(iOrg) = pi*fc^2/4;
    
% 二次元フィルタの計算
twoDimensionalFilter = w .* idealFilter;

figure(1);
mesh(-halfOrder:halfOrder,-halfOrder:halfOrder,...
    twoDimensionalFilter);
xlabel('n_1');
ylabel('n_0');

figure(2);
freqz2(twoDimensionalFilter);
xlabel('\omega_1 (\times\pi rad)');
ylabel('\omega_0 (\times\pi rad)');

% end of practice09_5.m
