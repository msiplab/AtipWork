% practice08_1.m
%
% $Id: practice08_1.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% パラメータ設定
% 垂直角周波数
Omega0 = 2*pi;
% 水平角周波数
Omega1 = 4*pi;

%% 標本点の定義
[p0,p1] = meshgrid(-0.5:0.01:0.5,-0.5:0.01:0.5);

%% 二次元余弦波の定義
x = cos(Omega0*p0 + Omega1*p1);

%% 二次元余弦波の表示
surf(p1,p0,x)
xlabel('p_1')
ylabel('p_0')
zlabel('Magnitude')
colormap gray
shading interp
axis([-0.5 0.5 -0.5 0.5 -2 2])
%axis square;
    
% 表示を回転
axis vis3d
stepAngle = 2;
for iAngle=1:stepAngle:360
    camorbit(0,stepAngle,'camera');
    drawnow
end

% end of practice08_1.m
