% practice08_1.m
%
% $Id: practice08_1.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �p�����[�^�ݒ�
% �����p���g��
Omega0 = 2*pi;
% �����p���g��
Omega1 = 4*pi;

%% �W�{�_�̒�`
[p0,p1] = meshgrid(-0.5:0.01:0.5,-0.5:0.01:0.5);

%% �񎟌��]���g�̒�`
x = cos(Omega0*p0 + Omega1*p1);

%% �񎟌��]���g�̕\��
surf(p1,p0,x)
xlabel('p_1')
ylabel('p_0')
zlabel('Magnitude')
colormap gray
shading interp
axis([-0.5 0.5 -0.5 0.5 -2 2])
%axis square;
    
% �\������]
axis vis3d
stepAngle = 2;
for iAngle=1:stepAngle:360
    camorbit(0,stepAngle,'camera');
    drawnow
end

% end of practice08_1.m
