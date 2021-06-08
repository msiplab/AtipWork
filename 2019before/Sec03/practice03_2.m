%
% $Id: practice03_2.m,v 1.5 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% Quantization step
delta = 1/2;
   
%% Sampling period
Ts = 1/8;

%% Frequency
f = 1;

%% Duration
duration = 8;

%% Sampling points
t = 0:Ts:duration-Ts;

%% Sampled data
xc = cos(2*pi*f*t);

%% Qunatization and Dequantization
x = delta * round(xc/delta);

%% Presentation
stem(t,xc,'b');
hold on;
stem(t,x,'r');
hold off;

% End
