% practice08_4.m
%
% $Id: practice08_4_ip.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �ړ����σt�B���^�̃C���p���X����
h = fspecial('average');

%% ���g�������̕\��
freqz2(h)
xlabel('\omega_1 (\times \pi rad)')
ylabel('\omega_0 (\times \pi rad)')

% end of practice08_4.m
