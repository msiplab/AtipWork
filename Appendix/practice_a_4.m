% practice_a_3.m
%
% $Id:$
%
% Copyright (C) 2012-2015 Shogo MURAMATSU, All rights reserved
%

%% ���͓_���̐ݒ�
N = 4;

%% ��������
% �����t�B���^
f0 = [  1 1 ].'/2;
f1 = [ -1 1 ].'/2;

%% �i����j�􍞂ݍs��
P = [zeros(1,N-1) 1; eye(N) ];      % �����g���s��
C = [zeros(N,1) eye(N) zeros(N,1)]; % �����o���s��
d0 = C*convmtx(f0,N+1)*P;
d1 = C*convmtx(f1,N+1)*P;

%% ����D�̍\�z
D = zeros(N,2*N);
D(:,1:2:end) = d0;
D(:,2:2:end) = d1;
fprintf('D = \n')
disp(D)

%% Moore-Penrose�̈�ʉ��t�s��ɂ�镪�͏���
% �M���̐���
x = rand(N,1);
fprintf('���� x\n')
disp(x)

% ��ʉ��t�s��̌v�Z
disp('���[�A�E�y�����[�Y�̈�ʉ��t�s��')
fprintf('T = D^+ = \n')
T = pinv(D); % Moore-Penrose �̈�ʉ��t�s��
disp(T)

% ���͏���
y = T*x;
fprintf('norm(y) = %f\n', norm(y));

% ��������
r = D*y;
mse = sum((x(:)-r(:)).^2)/numel(x);
fprintf('mse = %f\n\n',mse)

%% ���̈�ʉ��t�s��ɂ�镪�͏���
% ��ʉ��t�s��̌v�Z
gamma = 0.5;
delta = 1 - gamma;
disp('���̈�ʉ��t�s��')
fprintf('T = \n')
h0 = [ gamma  delta ].';
h1 = [ gamma -delta ].';
P = [eye(N) ; 1 zeros(1,N-1)];      % �����g���s��
C = [zeros(N,1) eye(N) zeros(N,1)]; % �����o���s��
t0 = C*convmtx(h0,N+1)*P;
t1 = C*convmtx(h1,N+1)*P;
T = zeros(2*N,N);
T(1:2:end,:) = t0;
T(2:2:end,:) = t1;
disp(T)

% ���͏���
y = T*x;
fprintf('norm(y) = %f\n', norm(y));

% ��������
r = D*y;
mse = sum((x(:)-r(:)).^2)/numel(x);
fprintf('mse = %f\n\n',mse);
