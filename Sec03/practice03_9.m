%
% $Id: practice03_9.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �t�B���^�W��
b = [1 1]/2;
a = [1 -1/2];

%% �C���p���X�����̕\��
figure(1);
impz(b,a);

%% Z���ʕ\��
figure(2);
zplane(b,a);

%% ���g������
figure(3);
freqz(b,a);

% end
