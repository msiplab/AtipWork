% practice07_7.m
%
% $Id: practice07_7_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �x�N�g���̎���
nPoints = 2;

%% ���摜�̓Ǎ�
pictureRgb = imread('data/barbaraRgb.tif');
pictureGray = rgb2gray(pictureRgb);

%% �񎟌��x�N�g���W���̒��o
nPixels = numel(pictureGray);
setOfX = reshape(pictureGray.', nPoints, nPixels/nPoints);

%% �����U�s��
Rxx = cov(double(setOfX.'));

%% �ŗL�l����
[V,D] = eig(Rxx);

%% �ŗL�l�̃\�[�g
[Y,I] = sort(diag(D));  

%% �ŗL�x�N�g������ъ����Ɠ]�u
Phi = V(:,nPoints-I+1).';
disp('Phi')
disp(Phi)

% end
