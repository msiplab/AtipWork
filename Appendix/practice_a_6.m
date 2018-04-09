% practice_a_6.m
%
% $Id:$
%
% Copyright (C) 2012-2015 Shogo MURAMATSU, All rights reserved
%

%% �W���̐��̐ݒ�
K = 32;

%% ����̐���
N = 128;
rng('default'); % �����̏�����
w = 0.1*randn(N,1);
x = filter(1,[1 -0.95],w);
subplot(3,1,1), stem(0:N-1,x)
axis([0 N -1.5 1.5])
ylabel('x[n]')
title('l_0�m�����ŏ���')

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

%% �����}�b�`���O�ǐ�(OMP)�@�^�}�b�`���O�ǐ�(MP)�@
isOmp = true;
isGp = true;
% ������
M  = size(D,2);
e  = ones(M,1);
z  = zeros(M,1);
g  = zeros(M,1);
y  = zeros(M,1);
tx = zeros(N,1);
r  = x - tx;
sup = [];
% �ߎ�����
subplot(3,1,2), hsr = stem(0:N-1,tx);
axis([0 N -1.5 1.5])
ylabel('~{x}[n]')
% �ߎ��덷
subplot(3,1,3), hse = stem(0:N-1,r);
axis([0 N -1.5 1.5])
ylabel('r[n]')
for k=1:K
    % �}�b�`���O����
    for m = 1:M %setdiff(1:M,sup)
        d = D(:,m);
        g(m) = d.'*r;
        z(m) = g(m)/(d'*d);
        e(m) = r.'*r - g(m)*z(m);
    end
    % �ŏ��l�T���i�ǐՁj
    [~,mmin]= min(e);
    % �T�|�[�g�X�V
    sup = union(sup,mmin);
    if isOmp % Orthogonal Matching Pursuit
        Ds = D(:,sup);
        if isGp % Gradient Pursuit
            % �b��X�V
            c = Ds*g(sup);
            a = (r.'*c)/(norm(c)^2);
            y(sup)  = y(sup) + a*g(sup);
        else
            % �b��X�V
            Ds = D(:,sup);
            y(sup)  = pinv(Ds) * x;
        end
    else % Matching Pursuit
        % �b��X�V
        y(mmin) = y(mmin) + z(mmin);
    end
    % �c������
    tx = D*y;
    r = x - tx;
    % �O���t�X�V
    set(hsr,'YData',tx);
    set(hse,'YData',r);
    drawnow
end

%% �]��
if isOmp 
    if isGp
        disp('l0�m�����ŏ���(GP)')
    else
        disp('l0�m�����ŏ���(OMP)')
    end
else
    disp('l0�m�����ŏ���(MP)')
end
mse = sum((x(:)-tx(:)).^2)/numel(x);
fprintf('mse = %f\n',mse);