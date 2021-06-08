% practice_a_13.m
%
% $Id:$
%
% Copyright (C) 2012-2015 Shogo MURAMATSU, All rights reserved
%
close all

%% �^�C�g�t���[��
D = [ 1 cos(pi/3) cos(2*pi/3) ;
    0 sin(pi/3) sin(2*pi/3) ];

fprintf('�^�C�g�t���[���̗�\n');
disp(D)
fprintf('D*D.''\n');
disp(D*D.')
fprintf('---\n');
subplot(2,3,1)
for idx = 1:size(D,2)
    quiver(0, 0 , D(1,idx), D(2,idx)), hold on
end
axis equal
axis([-1.5 1.5 -1.5 1.5])
title('�^�C�g�t���[���̗�')
hold off

subplot(2,3,4)
T = D.'; 
for idx = 1:size(D,2)
    quiver(0, 0 , T(idx,1), T(idx,2)), hold on
end
axis equal
axis([-1.5 1.5 -1.5 1.5])
title('�o�΃t���[���̗�')
hold off

%% �o�������
D = [ cos(pi/4) 0 ;
    sin(pi/4) 1 ];

fprintf('�o�������̗�\n');
disp(D)
fprintf('D �ɑ΂���ϊ� T=inv(D)\n');
T = inv(D);
disp(T)
fprintf('D*T\n');
disp(D*T)
fprintf('---\n');
subplot(2,3,2)
for idx = 1:size(D,2)
    quiver(0, 0 , D(1,idx), D(2,idx)), hold on
end
axis equal
axis([-1.5 1.5 -1.5 1.5])
title('�o�������̗�')
hold off

subplot(2,3,5)
for idx = 1:size(D,2)
    quiver(0, 0 , T(idx,1), T(idx,2)), hold on
end
axis equal
axis([-1.5 1.5 -1.5 1.5])
title('�o�Ί��')
hold off

%% ���K�������
D = [ cos(pi/4) -sin(pi/4) ;
      sin(pi/4) cos(pi/4) ];

fprintf('���K�������̗�\n');
disp(D)
fprintf('D �ɑ΂���ϊ� T=D.''\n');
T = D.';
disp(T)
fprintf('D*T\n');
disp(D*T)
fprintf('---\n');
subplot(2,3,3)
for idx = 1:size(D,2)
    quiver(0, 0 , D(1,idx), D(2,idx)), hold on
end
axis equal
axis([-1.5 1.5 -1.5 1.5])
title('�������̗�')
hold off

subplot(2,3,6)
for idx = 1:size(D,2)
    quiver(0, 0 , T(idx,1), T(idx,2)), hold on
end
axis equal
axis([-1.5 1.5 -1.5 1.5])
title('�o�Ί��')
hold off

 

