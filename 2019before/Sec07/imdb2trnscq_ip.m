function [subLL,subHL,subLH,subHH] = imdb2trnscq_ip(fullPicture)
%
% $Id: im53trnscq_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2015 Shogo MURAMATSU, All rights reserved
%

fullPicture = double(fullPicture);

h0 = [(1-sqrt(3)) (3-sqrt(3))  (3+sqrt(3)) (1+sqrt(3))]/(4*sqrt(2));
h1 = [(1+sqrt(3)) (-3-sqrt(3)) (3-sqrt(3)) (-1+sqrt(3))]/(4*sqrt(2));

% 垂直変換
subL = imfilter(fullPicture,h0.','conv','circ');
subH = imfilter(fullPicture,h1.','conv','circ');

% 水平変換
subLL = imfilter(subL,h0,'conv','circ');
subLH = imfilter(subL,h1,'conv','circ');
subHL = imfilter(subH,h0,'conv','circ');
subHH = imfilter(subH,h1,'conv','circ');

% ダウンサンプリング
downsample2x2 = @(x) downsample(downsample(x,2).',2).';
subLL = downsample2x2(subLL);
subLH = downsample2x2(subLH);
subHL = downsample2x2(subHL);
subHH = downsample2x2(subHH);

% end

