function fullPicture = imdb2itrnscq(subLL,subHL,subLH,subHH)
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
subLL = fft2(upsample2x2(subLL));
subLH = fft2(upsample2x2(subLH));
subHL = fft2(upsample2x2(subHL));
subHH = fft2(upsample2x2(subHH));

% 水平変換
Fh0 = fft2(f0,size(subLL,1),size(subLL,2));
Fh1 = fft2(f1,size(subLL,1),size(subLL,2));
subL = Fh0.*subLL + Fh1.*subLH;
subH = Fh0.*subHL + Fh1.*subHH;

% 垂直変換
Fv0 = fft2(f0.',size(subLL,1),size(subLL,2));
Fv1 = fft2(f1.',size(subLL,1),size(subLL,2));
fullPicture = circshift(ifft2(Fv0.*subL + Fv1.*subH),[-2 -2]);

% end