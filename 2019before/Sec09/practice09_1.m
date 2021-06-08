% practice09_1.m
%
% $Id: practice09_1.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2006-2015 Shogo MURAMATSU, All rights reserved
%

%% カットオフ周波数の設定
fc0 = 1/3; % 垂直 (×π rad)
fc1 = 1/3; % 水平 (×π rad)

%% 表示範囲の設定
region = 20;

%% インパルス応答の計算
[iHorizontal,iVertical] = meshgrid(-region:region, -region:region);
r0 = (fc0)*sinc((fc0)*iVertical);
r1 = (fc1)*sinc((fc1)*iHorizontal);
idealFilter = r0 .* r1;

%% インパルス応答の表示
mesh(iHorizontal,iVertical,idealFilter)
xlabel('n_1')
ylabel('n_0')

% end of practice08_6.m
