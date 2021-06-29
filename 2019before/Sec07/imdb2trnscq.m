function [subLL,subHL,subLH,subHH] = imdb2trnscq(fullPicture)
%
% $Id: im53trnscq_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2015 Shogo MURAMATSU, All rights reserved
%

fullPicture = double(fullPicture);

h0 = [(1-sqrt(3)) (3-sqrt(3))  (3+sqrt(3)) (1+sqrt(3))]/(4*sqrt(2));
h1 = [(1+sqrt(3)) (-3-sqrt(3)) (3-sqrt(3)) (-1+sqrt(3))]/(4*sqrt(2));

% 垂直変換
X = fft2(fullPicture);
Hv0 = fft2(h0.',size(X,1),size(X,2));
Hv1 = fft2(h1.',size(X,1),size(X,2));
subL = Hv0.*X;
subH = Hv1.*X;

% 水平変換
Hh0 = fft2(h0,size(X,1),size(X,2));
Hh1 = fft2(h1,size(X,1),size(X,2));
subLL = Hh0.*subL;
subLH = Hh1.*subL;
subHL = Hh0.*subH;
subHH = Hh1.*subH;

% ダウンサンプリング
downsample2x2 = @(x) downsample(downsample(x,2).',2).';
subLL = downsample2x2(circshift(ifft2(subLL),[-2 -2]));
subLH = downsample2x2(circshift(ifft2(subLH),[-2 -2]));
subHL = downsample2x2(circshift(ifft2(subHL),[-2 -2]));
subHH = downsample2x2(circshift(ifft2(subHH),[-2 -2]));

% end
