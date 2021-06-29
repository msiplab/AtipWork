% practice07_6.m
%
% $Id: practice07_6_ip.m,v 1.4 2007/07/07 01:06:38 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% DCT�_��
nPoints = 4;

%% DFT�_��
nPointsDft = 2 * nPoints;

%% OTDFT�̌v�Z
k=0:nPointsDft-1;
Wdft = dftmtx(nPointsDft);
Lambda = diag(exp(-1j*pi/nPointsDft*k));
Wotdft = Lambda * Wdft;

%% DCT�̌v�Z
E = [ eye(nPoints) ; fliplr(eye(nPoints)) ];
C = 1/sqrt(2*nPoints)*...
    diag([1/sqrt(2) ones(1,nPoints-1) ])*...
    Wotdft(1:nPoints,:)*E;

%% �덷�̕]��
norm(C-dctmtx(nPoints))
