function [subLL,subHL,subLH,subHH] = im53trnscq(fullPicture)
%
% $Id: im53trnscq.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

% �{���x�ɕϊ�
fullPicture = double(fullPicture);

% �����ϊ��i�C���v���[�X���Z�j
fullPicture = predictionStep(fullPicture,-1/2);
fullPicture = updateStep(fullPicture,1/4);

% �����ϊ��i�C���v���[�X���Z�j
fullPicture = predictionStep(fullPicture.',-1/2);
fullPicture = updateStep(fullPicture,1/4).';

% �W�����בւ�
subLL = fullPicture(1:2:end,1:2:end);
subHL = fullPicture(1:2:end,2:2:end);
subLH = fullPicture(2:2:end,1:2:end);
subHH = fullPicture(2:2:end,2:2:end);

% end of im53transcq
