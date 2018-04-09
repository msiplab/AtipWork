% practice07_11.m
%
% $Id: practice07_11.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%
clear P H

%% DCT“_”
nPoints = 4;

%% DCTs—ñ
P = dct(eye(nPoints));

%% ü”g”U•“Á«
fftPoints = 512;
analysisFilters = fliplr(P);
H = zeros(fftPoints,nPoints);
for iChannel = 1:nPoints
    [H(:,iChannel),W] = freqz(analysisFilters(iChannel,:),1,fftPoints);
end
plot(W/pi,20*log10(abs(H)))
axis([0 1 -70 10])
xlabel('Normalized Frequency (x\pi rad/sample)')
ylabel('Magnitude (dB)')
grid on
