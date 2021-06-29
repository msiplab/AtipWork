%
% $Id: exDct.m,v 1.3 2006/05/29 12:08:53 sho Exp $
%
% Copyright (C) 2005-2006 Shogo MURAMATSU, All rights reserved
%
X = [ 2 2 3 1 ; 2 2 3 1 ; 3 3 2 0 ; 1 1 0 2 ];

C = [ 1  1  1  1 ;
         2  1 -1 -2 ;
         1 -1 -1  1 ;
         1 -2  2 -1 ];
     
   a = 1/2; b = sqrt(2/5);     
   e00 = a^2; e01 = a*b/2; e11 = b^2/4;
   E = [ e00 e01 e00 e01 ;
         e01 e11 e01 e11 ;
         e00 e01 e00 e01 ;
         e01 e11 e01 e11 ];

   % “ñŽŸŒ³DCT
   Y = (C*X*C.').*E;

Y-dct2(X)
