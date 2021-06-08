%
% $Id: practice03_4.m,v 1.4 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% FFT points
nPoints = 512;

%% Sampling period
Ts = 1/8; % 1/Fs

%% Duration
duration = 8;

%% Sampling points
t = 0:Ts:duration-Ts;

%% Sampled data
x3 = cos(3*2*pi*t);
x5 = cos(5*2*pi*t);

%% Presentation for x3
figure(1); % Stem
stem(t,x3);
figure(2); % Analog Freq.
freqz(x3,1,nPoints,1/Ts);
subplot(2,1,1);
axis([0 1/(Ts*2) -100 50]);

%% Presentation for x5
figure(3); % Stem
stem(t,x5);
figure(4); % Analog Freq.
freqz(x5,1,nPoints,1/Ts);

% End
