%
% $Id: practice03_10.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �t�B���^����
nOrder = 60;

%% �ʉ߈�[
edgePass = .45;

%% �ʉ߈旘��
gainPass = 1;

%% �j�~��[
edgeStop = .55;

%% �t�B���^�݌v
h = firpm(nOrder,...
   [0 edgePass edgeStop 1],[gainPass gainPass 0 0]);
disp(h)

%% FIR���ڌ^�\��
%Hd = dfilt.dffir(h);

%% �C���p���X�����\��
%impz(Hd);

%% ���g�������\��
%freqz(Hd);

% end
