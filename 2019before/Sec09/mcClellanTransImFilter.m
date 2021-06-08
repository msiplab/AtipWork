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

% �ꎟ�����`�ʑ��t�B���^(Case I)�̐܂�Ԃ��W���v�Z
h = h(:);
halfOrder = (length(h)-1)/2;
a = [h(halfOrder+1) ; 2*h(halfOrder+2:end)];

% ���i�̌v�Z�@
delay = [ 0 0 0 ; 0 1 0 ; 0 0 0]; % �ʑ������p
x0 = imfilter(delay, x, 'conv', varargin{:});
x1 = imfilter(trans, x, 'conv', varargin{:});
x2 = a(1)*imfilter(delay, x, 'conv', varargin{:});
% ��i�ڈȍ~�̌v�Z
for i=2:halfOrder
    [x0, x1, x2] = ...
        mcClellanTransModule(x0, x1, x2, trans, a(i), varargin{:});
end
% �ŏI�i�̌v�Z
y = a(halfOrder+1)*x1 + x2;

%--- private function
% �}�N�������ϊ����W���[���i��i�j
function [y0,y1,y2] = ...
    mcClellanTransModule(x0, x1, x2, trans, a, varargin)

delay = [ 0 0 0 ; 0 1 0 ; 0 0 0]; % �ʑ������p
y0 =  imfilter(delay, x1, 'conv', varargin{:});
y1 = -imfilter(delay, x0, 'conv', varargin{:})+...
    2.0*imfilter(trans,x1, 'conv', varargin{:});
y2 =  imfilter(delay, (a*x1)+x2, 'conv', varargin{:});
