function freqz2cq(arrayX)
% FREQZ2CQ
%
% Input
%
%   arrayX: input array 
%
% $Id:$
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%
nPoints = pow2(ceil(log2(max([size(arrayX) 64]))));
freqX = fftshift(abs(fft2(double(arrayX),nPoints,nPoints)));
[f1,f0] = freqspace(nPoints);
[x,y]=meshgrid(f1,f0);
mesh(x,y,freqX);
xlabel('F_x');
ylabel('F_y');
zlabel('Magnitude');
%
