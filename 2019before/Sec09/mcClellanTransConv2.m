function y = mcClellanTransConv2(h,x,trans,shape)
%
% y = mcClellanTransConv2(h, x, trans, shape)
%
% Inputs
%   h     : Impulse response of 1-D prototype linear-phase filter
%   x     : Input 2-D array   
%   trans : McClellan transform coefficients
%   shape : Output shape option directly passed to conv2 function
%           (default 'full')
%  
% Outputs
%   y     : Output 2-D array
%
% See also: conv2
%
% $Id: mcClellanTransConv2.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2006-2015 Shogo MURAMATSU, All rights reserved
%
if nargin < 4
    shape = 'full';
end

% 一次元線形位相フィルタ(Case I)の折り返し係数計算
h = h(:);
halfOrder = (length(h)-1)/2;
a = [h(halfOrder+1) ; 2*h(halfOrder+2:end)];

% 初段の計算　
delay = [ 0 0 0 ; 0 1 0 ; 0 0 0]; % 位相調整用
x0 = conv2(delay, x, shape);
x1 = conv2(trans, x, shape);
x2 = a(1)*conv2(delay, x, shape);
% 二段目以降の計算
for i=2:halfOrder
    [x0, x1, x2] = mcClellanTransModule(x0, x1, x2, trans, a(i), shape);
end
% 最終段の計算
y = a(halfOrder+1)*x1 + x2;

%--- private function
% マクレラン変換モジュール（一段）
function [y0,y1,y2] = mcClellanTransModule(x0, x1, x2, trans, a, shape)

delay = [ 0 0 0 ; 0 1 0 ; 0 0 0]; % 位相調整用
y0 =  conv2(delay, x1, shape);
y1 = -conv2(delay, x0, shape)+2.0*conv2(trans,x1, shape);
y2 =  conv2(delay, (a*x1)+x2, shape);
