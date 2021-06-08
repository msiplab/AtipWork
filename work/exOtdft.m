%
% $Id: exOtdft.m,v 1.2 2006/05/29 12:08:53 sho Exp $
%
% Copyright (C) 2005-2006 Shogo MURAMATSU, All rights reserved
%

nPoints = 8;
k=0:nPoints-1;
Wdft = fft(eye(nPoints));
Lamda = diag(exp(-j*pi/nPoints*k));
Wotdft = Lamda * Wdft;
Wotdft' * Wotdft

nPointsDct = nPoints/2;
E = [ eye(nPointsDct) ; fliplr(eye(nPointsDct)) ];
C = 1/sqrt(2*nPointsDct)*...
    diag([1/sqrt(2) ones(1,nPointsDct-1) ])*...
    Wotdft(1:nPointsDct,:)*E;
