% practice_a_5.m
%
% $Id:$
%
% Copyright (C) 2012-2015 Shogo MURAMATSU, All rights reserved
%

%% WΜΜέθ
K = 32;

%% ρΜΆ¬
N = 128;
rng('default'); % Μϊ»
w = 0.1*randn(N,1);
x = filter(1,[1 -0.95],w);
subplot(3,1,1), stem(0:N-1,x)
axis([0 N -1.5 1.5])
ylabel('x[n]')
title('WmΕ¬»')

%% ¬
% ¬tB^
f0 = [  1 1 ].'/2;
f1 = [ -1 1 ].'/2;

%% iρjτέsρ
P = [zeros(1,N-1) 1; eye(N) ];      % όϊg£sρ
C = [zeros(N,1) eye(N) zeros(N,1)]; % ²«o΅sρ
d0 = C*convmtx(f0,N+1)*P;
d1 = C*convmtx(f1,N+1)*P;

%% «DΜ\z
D = zeros(N,2*N);
D(:,1:2:end) = d0;
D(:,2:2:end) = d1;

%% Moore-PenroseΜκΚ»tsρΙζιͺΝ
% ͺΝ
y = pinv(D)*x;

%% ρό`ί
y = y(:);
[~,ix] = sort(abs(y),'descend');
y(ix(K+1:end)) = 0;

%% ]Ώ
% ίΚ
tx = D*y;
subplot(3,1,2), stem(0:N-1,tx)
axis([0 N -1.5 1.5])
ylabel('~x[n]')

% ίλ·
r = x - tx;
subplot(3,1,3), stem(0:N-1,r)
axis([0 N -1.5 1.5])
ylabel('r[n]')

disp('WmΕ¬»')
mse = sum((x(:)-tx(:)).^2)/numel(x);
fprintf('mse = %f\n',mse);
