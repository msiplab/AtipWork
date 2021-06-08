% practice07_9.m
%
% $Id: practice07_9.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 入力配列
X = [ 2 2 3 1 ;
      2 2 3 1 ; 
      3 3 2 0 ; 
      1 1 0 2 ];

%% 変換核
Cf = [ 1  1  1  1 ;
       2  1 -1 -2 ;
       1 -1 -1  1 ;
       1 -2  2 -1 ];

%% スケーリングテーブル
a = 1/2; b = sqrt(2/5);
e00 = a^2; e01 = a*b/2; e11 = b^2/4;
Ef = [ e00 e01 e00 e01 ;
       e01 e11 e01 e11 ;
       e00 e01 e00 e01 ;
       e01 e11 e01 e11 ];

%% 二次元整数精度順変換
Y = (Cf*X*Cf.').*Ef;
disp('Y')
disp(Y)

%% 変換核
Ci = [ 1    1    1    1   ;
       1    1/2 -1/2 -1   ;
       1   -1   -1    1   ;
       1/2 -1    1   -1/2 ];

%% スケーリングテーブル
e00 = a^2; e01 = a*b; e11 = b^2;
Ei = [ e00 e01 e00 e01 ;
       e01 e11 e01 e11 ;
       e00 e01 e00 e01 ;
       e01 e11 e01 e11 ];

%% 二次元整数精度逆変換
Xrec = Ci.'*(Y.*Ei)*Ci;

disp('X-Xrec')
disp(X-Xrec)


