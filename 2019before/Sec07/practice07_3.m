% practice07_3.m
%
% $Id: practice07_3.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �z��
X = [ 0 2 ; 4 6 ];

%% �ϊ��s��
A = [ 1 1 ; -1 1 ]/sqrt(2); 

%% ���ϊ�
Y = A*X*A.';

%% �\��
disp('Y')
disp(Y)
