%
% $Id: practice03_5.m,v 1.4 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%
close all;

%% Window size
nPoints = 64;

%% Sampling period
Ts = 1/8; % 1/Fs

%% Duration
duration = nPoints*Ts;

%% Sampling points
t = 0:Ts:duration-Ts;

%% Sampled data
xc = cos(2*pi*t);

%% Window
w = window(@hanning, nPoints);

%% Windowed data
xw = w(:).*xc(:);
xr = xc(:);

%% Time-domain presentation
figure(1);
subplot(2,1,1); 
stem(t,xc);
subplot(2,1,2); 
stem(t,xw);

%% Frequency-domain presentation
figure(2);
freqz(xw,1,512,1/Ts);
hold on
freqz(xr,1,512,1/Ts);
subplot(2,1,1);
axis([0 1/(Ts*2) -100 50]);

%% Window
wvtool(w);


% End
