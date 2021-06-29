% practice07_6.m
%
% $Id: practice07_6_ip.m,v 1.4 2007/07/07 01:06:38 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% DCTì_êî
nPoints = 4;

%% DFTì_êî
nPointsDft = 2 * nPoints;

%% OTDFTÇÃåvéZ
k=0:nPointsDft-1;
Wdft = dftmtx(nPointsDft);
Lambda = diag(exp(-1j*pi/nPointsDft*k));
Wotdft = Lambda * Wdft;

%% DCTÇÃåvéZ
E = [ eye(nPoints) ; fliplr(eye(nPoints)) ];
C = 1/sqrt(2*nPoints)*...
    diag([1/sqrt(2) ones(1,nPoints-1) ])*...
    Wotdft(1:nPoints,:)*E;

%% åÎç∑ÇÃï]âø
norm(C-dctmtx(nPoints))
