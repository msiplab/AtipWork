%
% $Id: exLinComb.m,v 1.2 2006/05/29 12:08:53 sho Exp $
%
% Copyright (C) 2005-2006 Shogo MURAMATSU, All rights reserved
%

x = [ 1 2 ].'; % �x�N�g��x �̒�`
A = [ 1 1 ; -1 1 ]; % �ϊ��s��
y = A * x; % �ϊ��W���̌v�Z
invA = inv(A); % �ϊ��s��̋t�s��
b0 = invA(:,1); % ���x�N�g�� b0
b1 = invA(:,2); % ���x�N�g�� b1
y(1) * b0 + y(2) * b1 % ���x�N�g���̐��`����
