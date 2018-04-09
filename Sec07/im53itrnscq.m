function fullPicture = im53itrnscq(subLL,subHL,subLH,subHH)
%
% $Id: im53itrnscq.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

% 配列の準備
fullSize = size(subLL) + size(subHH);
fullPicture = zeros(fullSize);

% 係数並べ替え
fullPicture(1:2:end,1:2:end) = subLL;
fullPicture(1:2:end,2:2:end) = subHL;
fullPicture(2:2:end,1:2:end) = subLH;
fullPicture(2:2:end,2:2:end) = subHH;

% 水平変換（インプレース演算）
fullPicture = updateStep(fullPicture.',-1/4);
fullPicture = predictionStep(fullPicture,1/2).';

% 垂直変換（インプレース演算）
fullPicture = updateStep(fullPicture,-1/4);
fullPicture = predictionStep(fullPicture,1/2);

% end of im53itrnscq
