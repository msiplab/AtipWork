%
% $Id: practice03_6.m,v 1.3 2007/05/14 21:39:03 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 数列
x = [ 1 2 3 ];

%% Z変換
[re,im]=meshgrid(-2:.1:2,-2:.2:2); % 複素平面上のサンプル点
z = re+1i*im;
X = 0;
for iSample=1:length(x)
    X = X + x(iSample) * z.^(-iSample+1);
end

%% メッシュ表示
figure(1);
mesh(re,im,abs(X));
xlabel('Real');
ylabel('Imaginary');
zlabel('|X(z)|');
axis([-2 2 -2 2 0 10]);

%% ゼロ点／極点配置
figure(2);
zplane(x);

% End
