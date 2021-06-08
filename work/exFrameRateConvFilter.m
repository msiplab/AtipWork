%
% $Id: exFrameRateConvFilter.m,v 1.2 2006/05/29 12:08:53 sho Exp $
%
% Copyright (C) 2005-2006 Shogo MURAMATSU, All rights reserved
%
path(path,'./Sec10');

h = 5 * eigenLowpassNyquistFilter(8,1/6*0,1/6*2,0.5,5);

gn = round(h*8)

g = gn/8;
