function fullPicture = im97itrnscq(subLL,subHL,subLH,subHH)
%
% $Id: im97itrnscq.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

a = -1.586134342059924;
b = -0.052980118572961;
g =  0.882911075530934;
d =  0.443506852043971;
K =  1.230174104914001;

% 配列の準備
fullSize = size(subLL) + size(subHH);
fullPicture = zeros(fullSize);

% 係数並べ替え
fullPicture(1:2:end,1:2:end,:) = subLL;
fullPicture(1:2:end,2:2:end,:) = subHL;
fullPicture(2:2:end,1:2:end,:) = subLH;
fullPicture(2:2:end,2:2:end,:) = subHH;

% 水平変換（インプレース演算）
fullPicture(:,1:2:end,:) = fullPicture(:,1:2:end,:)*K;
fullPicture(:,2:2:end,:) = fullPicture(:,2:2:end,:)/K;
fullPicture = updateStep(fullPicture.',-d);
fullPicture = predictionStep(fullPicture,-g);
fullPicture = updateStep(fullPicture,-b);
fullPicture = predictionStep(fullPicture,-a).';

% 垂直変換（インプレース演算）
fullPicture(1:2:end,:,:) = fullPicture(1:2:end,:,:)*K;
fullPicture(2:2:end,:,:) = fullPicture(2:2:end,:,:)/K;
fullPicture = updateStep(fullPicture,-d);
fullPicture = predictionStep(fullPicture,-g);
fullPicture = updateStep(fullPicture,-b);
fullPicture = predictionStep(fullPicture,-a);

% end of im97itrnscq
