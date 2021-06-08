% practice09_1.m
%
% $Id: practice09_1.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2006-2015 Shogo MURAMATSU, All rights reserved
%

%% �J�b�g�I�t���g���̐ݒ�
fc0 = 1/3; % ���� (�~�� rad)
fc1 = 1/3; % ���� (�~�� rad)

%% �\���͈͂̐ݒ�
region = 20;

%% �C���p���X�����̌v�Z
[iHorizontal,iVertical] = meshgrid(-region:region, -region:region);
r0 = (fc0)*sinc((fc0)*iVertical);
r1 = (fc1)*sinc((fc1)*iHorizontal);
idealFilter = r0 .* r1;

%% �C���p���X�����̕\��
mesh(iHorizontal,iVertical,idealFilter)
xlabel('n_1')
ylabel('n_0')

% end of practice08_6.m
