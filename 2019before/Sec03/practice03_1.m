%
% $Id: practice03_1.m,v 1.4 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

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

%% Presentation
stem(t,xc);

% End
