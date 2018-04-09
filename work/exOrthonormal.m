%
% $Id: exOrthonormal.m,v 1.2 2006/05/29 12:08:53 sho Exp $
%
% Copyright (C) 2005-2006 Shogo MURAMATSU, All rights reserved
%

theta = pi/10;
A = [ cos(theta) -sin(theta) ;
      sin(theta)  cos(theta) ];
A.'*A 
