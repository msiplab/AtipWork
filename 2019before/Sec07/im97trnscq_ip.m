function [subLL,subHL,subLH,subHH] = im97trnscq_ip(fullPicture)
%
% $Id: im97trnscq_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

a = -1.586134342059924;
b = -0.052980118572961;
g =  0.882911075530934;
d =  0.443506852043971;
K =  1.230174104914001;

fullPicture = double(fullPicture);

% 垂直変換（インプレース演算）
fullPicture = predictionStep_ip(fullPicture,a);
fullPicture = updateStep_ip(fullPicture,b);
fullPicture = predictionStep_ip(fullPicture,g);
fullPicture = updateStep_ip(fullPicture,d);
fullPicture(1:2:end,:,:) = fullPicture(1:2:end,:,:)/K;
fullPicture(2:2:end,:,:) = fullPicture(2:2:end,:,:)*K;

% 水平変換（インプレース演算）
fullPicture = predictionStep_ip(fullPicture.',a);
fullPicture = updateStep_ip(fullPicture,b);
fullPicture = predictionStep_ip(fullPicture,g);
fullPicture = updateStep_ip(fullPicture,d).';
fullPicture(:,1:2:end,:) = fullPicture(:,1:2:end,:)/K;
fullPicture(:,2:2:end,:) = fullPicture(:,2:2:end,:)*K;

% 係数並べ替え
subLL = fullPicture(1:2:end,1:2:end,:);
subHL = fullPicture(1:2:end,2:2:end,:);
subLH = fullPicture(2:2:end,1:2:end,:);
subHH = fullPicture(2:2:end,2:2:end,:);

% end of im97trnscq_ip
