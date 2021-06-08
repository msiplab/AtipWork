function y = chebPoly(x,order)
%
% $Id: chebPoly.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2006-2015 Shogo MURAMATSU, All rights reserved
%
if order == 0
    y = 1;
elseif order == 1
    y = x;
elseif order > 1
    y = (2 * x .* chebPoly(x,order-1)) - chebPoly(x,order-2);
else
    error('invalid argument');
end
        
