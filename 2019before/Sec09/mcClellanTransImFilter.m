function y = mcClellanTransImFilter(h,x,trans,varargin)
%
% y = mcClellanTransImFilter(h, x, trans, shape)
%
% Inputs
%   h     : Impulse response of 1-D prototype linear-phase filter
%   x     : Input 2-D array   
%   trans : McClellan transform coefficients
%   shape : Output shape option directly passed to imfilter function
%           (default 'same')
%  
% Outputs
%   y     : Output 2-D array
%
% See also: imfilter
%
% $Id: mcClellanTransImFilter.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2006-2015 Shogo MURAMATSU, All rights reserved
%

% 一次元線形位相フィルタ(Case I)の折り返し係数計算
h = h(:);
halfOrder = (length(h)-1)/2;
a = [h(halfOrder+1) ; 2*h(halfOrder+2:end)];

% 初段の計算　
delay = [ 0 0 0 ; 0 1 0 ; 0 0 0]; % 位相調整用
x0 = imfilter(delay, x, 'conv', varargin{:});
x1 = imfilter(trans, x, 'conv', varargin{:});
x2 = a(1)*imfilter(delay, x, 'conv', varargin{:});
% 二段目以降の計算
for i=2:halfOrder
    [x0, x1, x2] = ...
        mcClellanTransModule(x0, x1, x2, trans, a(i), varargin{:});
end
% 最終段の計算
y = a(halfOrder+1)*x1 + x2;

%--- private function
% マクレラン変換モジュール（一段）
function [y0,y1,y2] = ...
    mcClellanTransModule(x0, x1, x2, trans, a, varargin)

delay = [ 0 0 0 ; 0 1 0 ; 0 0 0]; % 位相調整用
y0 =  imfilter(delay, x1, 'conv', varargin{:});
y1 = -imfilter(delay, x0, 'conv', varargin{:})+...
    2.0*imfilter(trans,x1, 'conv', varargin{:});
y2 =  imfilter(delay, (a*x1)+x2, 'conv', varargin{:});
