% practice07_13.m
%
% $Id: practice07_13.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

% 9/7�ϊ��̕��́E�����t�B���^�̃C���p���X�����ɂ��ẮA
% lifting97.mat �ɕۑ����Ă���B
% load ���āAh0, h1, f0, f1 ���m�F���ė~�����B
%
% a = -1.586134342059924;
% b = -0.052980118572961;
% g =  0.882911075530934;
% d =  0.443506852043971;
% K =  1.230174104914001;
%

% �ȉ��́A5/3�ϊ��̗�@(�Q�l�Fpractice07_13_text.m �j

%% �^�C�vI�̃|���t�F�[�Y�t�B���^�i���͊�j
u00 = 1; u01 = [1 1]/4;
%u10 = 0; u11 = 1;

d00 = [0 1]; %d01 = 0;
%d10 = 0; d11 = 1;

ud00 = conv(u00,d00); ud01 = u01;
ud10 = 0; ud11 = 1;

%p00 = 1; p01 = 0;
p10 = -[1 1]/2; %p11 = 1;

e00 = [ud00 0] + conv(ud01,p10); 
e01 = ud01;
e10 = p10; 
e11 = 1;

%% ���̓t�B���^
[e00,e01] = eqtflength(e00,e01); % �����𑵂���
h0 = upsample(e00,2) + upsample(e01,2,1);
h0 = h0(1:end-1); % �Ō�̗�l����菜��

[e10,e11] = eqtflength(e10,e11); % �����𑵂���
h1 = upsample(e10,2) + upsample(e11,2,1);
h1 = h1(1:end-1); % �Ō�̗�l����菜��

fvtool(h0,1,h1,1);

%% �^�C�vII�̃|���t�F�[�Y�t�B���^�i������j
p00 = 1; p01 = 0;
p10 = [1 1]/2; p11 = 1;

d00 = 1; d01 = 0;
d10 = 0; d11 = [0 1];

pd00 = 1; pd01 = 0;
pd10 = p10; pd11 = d11;

u00 = 1; u01 = -[1 1]/4;
u10 = 0; u11 = 1;

r00 = 1;
r01 = u01;
r10 = pd10;
r11 = conv(pd10,u01)+[pd11 0];

%% �����t�B���^
[r00,r10] = eqtflength(r00,r10); % �����𑵂���
f0 = upsample(r00,2,1)+upsample(r10,2);
f0 = f0(1:end-1); % �Ō�̗�l����菜��

[r01,r11] = eqtflength(r01,r11); % �����𑵂���
f1 = upsample(r01,2,1)+upsample(r11,2);
f1 = f1(1:end-1); % �Ō�̗�l����菜��

fvtool(f0,1,f1,1);

% end


