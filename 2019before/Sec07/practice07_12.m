% practice07_12.m
%
% $Id: practice07_12.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% ���͐M���̐���
xOrg = 0:5; % �������Ƃ���B

%% ���̓t�B���^
h0 = [  (1+sqrt(3)) (3+sqrt(3))  (3-sqrt(3)) (1-sqrt(3)) ]/8;
h1 = [  (1-sqrt(3)) -(3-sqrt(3)) (3+sqrt(3)) -(1+sqrt(3)) ]/8;

%% �^�C�vI�̃|���t�F�[�Y�t�B���^�i���͊�j
e00 = h0(1:2:end);
e01 = h0(2:2:end);
e10 = h1(1:2:end);
e11 = h1(2:2:end);

%% �����t�B���^
f0 = 2*fliplr(h0); % ���Ԕ��]���ĂQ�{
f1 = 2*fliplr(h1); % ���Ԕ��]���ĂQ�{

%% �^�C�vII�̃|���t�F�[�Y�t�B���^�i������j
r00 = f0(2:2:end);
r10 = f0(1:2:end);
r01 = f1(2:2:end);
r11 = f1(1:2:end);

%% S/P�ϊ�
x0 = [xOrg(1:2:end) 0];
x1 = [0 xOrg(2:2:end)];

%% ���͏����i�|���t�F�[�Y�����j
y0 = conv(e00,x0) + conv(e01,x1);
y1 = conv(e10,x0) + conv(e11,x1);

%% ���������i�|���t�F�[�Y�����j
u0 = conv(r00,y0) + conv(r01,y1);
u1 = conv(r10,y0) + conv(r11,y1);

%% P/S �ϊ�
xRec = upsample(u0,2,1)+upsample(u1,2);

%% �\��
disp('xOrg')
disp(xOrg)

disp('xRec')
disp(xRec)
