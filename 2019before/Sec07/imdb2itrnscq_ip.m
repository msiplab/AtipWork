function fullPicture = imdb2itrnscq_ip(subLL,subHL,subLH,subHH)
%
% $Id: im53itrnscq_ip.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2015 Shogo MURAMATSU, All rights reserved
%

h0 = [(1-sqrt(3)) (3-sqrt(3))  (3+sqrt(3)) (1+sqrt(3))]/(4*sqrt(2));
h1 = [(1+sqrt(3)) (-3-sqrt(3)) (3-sqrt(3)) (-1+sqrt(3))]/(4*sqrt(2));
f0 = fliplr(h0);
f1 = fliplr(h1);

% アップサンプリング
upsample2x2 = @(x) upsample(upsample(x.',2,1).',2,1);
subLL = upsample2x2(subLL);
subLH = upsample2x2(subLH);
subHL = upsample2x2(subHL);
subHH = upsample2x2(subHH);

% 水平変換
subL = imfilter(subLL,f0,'conv','circ')...
    + imfilter(subLH,f1,'conv','circ');
subH = imfilter(subHL,f0,'conv','circ')...
    + imfilter(subHH,f1,'conv','circ');

% 垂直変換
fullPicture = imfilter(subL,f0.','conv','circ')...
    + imfilter(subH,f1.','conv','circ');


% end