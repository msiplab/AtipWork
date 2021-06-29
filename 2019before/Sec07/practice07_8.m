% practice07_8.m
%
% $Id: practice07_8.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �x�N�g���̎���
nPoints = 4;

%% ���֌W�� |��|<1
rho = 0.99995; 

%% �����U�s��
Rxx = toeplitz(power(rho,0:nPoints-1)); 

%% �ŗL�x�N�g���ƌŗL�l�̌v�Z
[V,D] = eig(Rxx);	

%% �ŗL�l�̃\�[�g
[Y,I] = sort(diag(D));  

%% KLT �s��
Phi = V(:,nPoints-I+1).';
disp('Phi')
disp(Phi)

% DCT �s��
C = dct(eye(nPoints));
disp('C')
disp(C)
