% practice07_5.m
%
% $Id: practice07_5_ip.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% DCT点数
nPoints = 4;

%% DCT行列の計算
C = dctmtx(nPoints);

%% 基底ベクトルの表示
nRows = size(C,1);
figure(1);
for iRow = 1:nRows
    subplot(ceil(nRows/2),2,iRow);
    stem(C(iRow,:)); 
end;

%% 基底画像の表示
figure(2)
adj = max(abs(C(:)))^2; % 輝度調整用
for iRowV=1:nRows
    for iRowH=1:nRows
        basisVecV = C(iRowV,:).';
        basisVecH = C(iRowH,:).';
        B=kron(basisVecV,basisVecH.'); % 基底画像        
        B=uint8(127*(B/adj+0.5));        % 輝度調整
        subplot(nRows,nRows,nRows*(iRowV-1)+iRowH);
        imshow(B);
    end
end