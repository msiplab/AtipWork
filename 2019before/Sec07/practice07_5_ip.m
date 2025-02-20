% practice07_5.m
%
% $Id: practice07_5_ip.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% DCT_
nPoints = 4;

%% DCTsñÌvZ
C = dctmtx(nPoints);

%% îêxNgÌ\¦
nRows = size(C,1);
figure(1);
for iRow = 1:nRows
    subplot(ceil(nRows/2),2,iRow);
    stem(C(iRow,:)); 
end;

%% îêæÌ\¦
figure(2)
adj = max(abs(C(:)))^2; % Px²®p
for iRowV=1:nRows
    for iRowH=1:nRows
        basisVecV = C(iRowV,:).';
        basisVecH = C(iRowH,:).';
        B=kron(basisVecV,basisVecH.'); % îêæ        
        B=uint8(127*(B/adj+0.5));        % Px²®
        subplot(nRows,nRows,nRows*(iRowV-1)+iRowH);
        imshow(B);
    end
end