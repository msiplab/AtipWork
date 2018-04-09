%
% $Id: practice03_7.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 入力 x[n]
x = [1 2 3];

%% インパルス応答 h[n]
h = [1 1 1]/3;

%% 出力 y[n]
y = conv(h,x);

%% x[n] の表示
subplot(3,1,1);
stem(0:length(x)-1,x);
axis([0 length(y) 0 3]);
xlabel('n');ylabel('x[n]');

%% h[n] の表示
subplot(3,1,2);
stem(0:length(h)-1,h);
axis([0 length(y) 0 3]);
xlabel('n');ylabel('h[n]');

%% y[n] の表示
subplot(3,1,3);
stem(0:length(y)-1,y);
axis([0 length(y) 0 3]);
xlabel('n');ylabel('y[n]');

% end
