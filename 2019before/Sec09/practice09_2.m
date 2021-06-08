% practice13_2.m
%
% $Id: practice09_2.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2006-2015 Shogo MURAMATSU, All rights reserved
%

%% �J�b�g�I�t���g���̐ݒ�
fc = 1/3; % (�~�� rad)  

%% �\���͈͂̐ݒ�
region = 20;

%% �C���p���X�����̌v�Z
[iHorizontal,iVertical] = meshgrid(-region:region,-region:region);
r = sqrt(iHorizontal.^2+iVertical.^2);
iOrg = find(r==0);
r(iOrg) = 1;
idealFilter = (fc/2)*besselj(1,pi*fc*r)./r;
idealFilter(iOrg) = pi*fc^2/4;

%% �C���p���X�����̕\��
mesh(iHorizontal,iVertical,idealFilter)
xlabel('n_1')
ylabel('n_0')

% end of practice08_7.m