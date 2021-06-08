function [subLL,subHL,subLH,subHH] = im53trnscq_ip(fullPicture)
%
% $Id: im53trnscq_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

fullPicture = double(fullPicture);

% 垂直変換（インプレース演算）
fullPicture = predictionStep_ip(fullPicture,-1/2);
fullPicture = updateStep_ip(fullPicture,1/4);

% 水平変換（インプレース演算）
fullPicture = predictionStep_ip(fullPicture.',-1/2);
fullPicture = updateStep_ip(fullPicture,1/4).';

% 係数並べ替え
subLL = fullPicture(1:2:end,1:2:end,:);
subHL = fullPicture(1:2:end,2:2:end,:);
subLH = fullPicture(2:2:end,1:2:end,:);
subHH = fullPicture(2:2:end,2:2:end,:);

% end of im53trnscq_ip
