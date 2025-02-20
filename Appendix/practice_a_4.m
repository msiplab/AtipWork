% practice_a_3.m
%
% $Id:$
%
% Copyright (C) 2012-2015 Shogo MURAMATSU, All rights reserved
%

%% όΝ_Μέθ
N = 4;

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
fprintf('D = \n')
disp(D)

%% Moore-PenroseΜκΚ»tsρΙζιͺΝ
% MΜΆ¬
x = rand(N,1);
fprintf('ρ x\n')
disp(x)

% κΚ»tsρΜvZ
disp('[AEy[YΜκΚ»tsρ')
fprintf('T = D^+ = \n')
T = pinv(D); % Moore-Penrose ΜκΚ»tsρ
disp(T)

% ͺΝ
y = T*x;
fprintf('norm(y) = %f\n', norm(y));

% ¬
r = D*y;
mse = sum((x(:)-r(:)).^2)/numel(x);
fprintf('mse = %f\n\n',mse)

%% ΌΜκΚ»tsρΙζιͺΝ
% κΚ»tsρΜvZ
gamma = 0.5;
delta = 1 - gamma;
disp('ΌΜκΚ»tsρ')
fprintf('T = \n')
h0 = [ gamma  delta ].';
h1 = [ gamma -delta ].';
P = [eye(N) ; 1 zeros(1,N-1)];      % όϊg£sρ
C = [zeros(N,1) eye(N) zeros(N,1)]; % ²«o΅sρ
t0 = C*convmtx(h0,N+1)*P;
t1 = C*convmtx(h1,N+1)*P;
T = zeros(2*N,N);
T(1:2:end,:) = t0;
T(2:2:end,:) = t1;
disp(T)

% ͺΝ
y = T*x;
fprintf('norm(y) = %f\n', norm(y));

% ¬
r = D*y;
mse = sum((x(:)-r(:)).^2)/numel(x);
fprintf('mse = %f\n\n',mse);
