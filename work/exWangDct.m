%
% $Id: exWangDct.m,v 1.2 2006/05/29 12:08:53 sho Exp $
%
% Copyright (C) 2005-2006 Shogo MURAMATSU, All rights reserved
%

I4 = eye(4);
J4 = fliplr(I4);
O4 = zeros(4);
I8 = eye(8);I8 = eye(8);
B8 = [ I8(1:2:end,:) ; I8(2:2:end,:) ];
CII4 = dct(eye(4));
CIV4 = dctiv(eye(4));
CII8 = 1/sqrt(2) * B8.' ...
    * [ CII4 O4     ; 
        O4  CIV4*J4 ] ...
    * [ I4  J4  ;
        J4 -I4 ];
                        
norm( CII8 - dct(eye(8)) )                        
                                       
