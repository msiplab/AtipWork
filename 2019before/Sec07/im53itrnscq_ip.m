function fullPicture = im53itrnscq_ip(subLL,subHL,subLH,subHH)
%
% $Id: im53itrnscq_ip.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

% �z��̏���
fullSize = size(subLL) + size(subHH);
fullPicture = zeros(fullSize);

% �W�����בւ�
fullPicture(1:2:end,1:2:end,:) = subLL;
fullPicture(1:2:end,2:2:end,:) = subHL;
fullPicture(2:2:end,1:2:end,:) = subLH;
fullPicture(2:2:end,2:2:end,:) = subHH;

% �����ϊ��i�C���v���[�X���Z�j
fullPicture = updateStep_ip(fullPicture.',-1/4);
fullPicture = predictionStep_ip(fullPicture,1/2).';

% �����ϊ��i�C���v���[�X���Z�j
fullPicture = updateStep_ip(fullPicture,-1/4);
fullPicture = predictionStep_ip(fullPicture,1/2);

% end of im53itrnscq_ip