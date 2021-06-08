% practice07_9.m
%
% $Id: practice07_9.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% ���͔z��
X = [ 2 2 3 1 ;
      2 2 3 1 ; 
      3 3 2 0 ; 
      1 1 0 2 ];

%% �ϊ��j
Cf = [ 1  1  1  1 ;
       2  1 -1 -2 ;
       1 -1 -1  1 ;
       1 -2  2 -1 ];

%% �X�P�[�����O�e�[�u��
a = 1/2; b = sqrt(2/5);
e00 = a^2; e01 = a*b/2; e11 = b^2/4;
Ef = [ e00 e01 e00 e01 ;
       e01 e11 e01 e11 ;
       e00 e01 e00 e01 ;
       e01 e11 e01 e11 ];

%% �񎟌��������x���ϊ�
Y = (Cf*X*Cf.').*Ef;
disp('Y')
disp(Y)

%% �ϊ��j
Ci = [ 1    1    1    1   ;
       1    1/2 -1/2 -1   ;
       1   -1   -1    1   ;
       1/2 -1    1   -1/2 ];

%% �X�P�[�����O�e�[�u��
e00 = a^2; e01 = a*b; e11 = b^2;
Ei = [ e00 e01 e00 e01 ;
       e01 e11 e01 e11 ;
       e00 e01 e00 e01 ;
       e01 e11 e01 e11 ];

%% �񎟌��������x�t�ϊ�
Xrec = Ci.'*(Y.*Ei)*Ci;

disp('X-Xrec')
disp(X-Xrec)


