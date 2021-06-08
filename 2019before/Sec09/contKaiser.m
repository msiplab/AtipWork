function y = contKaiser(x,halfOrder,beta)
%
% $Id: contKaiser.m,v 1.3 2007/11/21 00:11:54 sho Exp $
%
% Copyright (C) 2006-2007 Shogo MURAMATSU, All rights reserved
%
if (abs(x) > halfOrder)
    y = 0;
else 
    y = real(besseli(0,beta*sqrt(1-(x/halfOrder).^2))/...
        besseli(0,beta));
end
