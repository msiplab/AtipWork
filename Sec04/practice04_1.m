% practice04_1.m
%
% $Id: practice04_1.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �摜�̍����ƕ�
nRows = 612;
nCols = 816;

%% logical �o�C�i���摜
pictureBinary = false(nRows,nCols);

%% uint8 ���m�N���摜
pictureGray = zeros(nRows,nCols,'uint8');

%% double ���m�N���摜
pictureGrayDouble = zeros(nRows,nCols,'double');

%% uint8 �J���[�摜
pictureRgb = zeros(nRows,nCols,3,'uint8');

%% double �J���[�摜
pictureRgbDouble = zeros(nRows,nCols,3,'double');

%% �e�ʂ̔�r
clear nRows nCols
whos pictureBinary pictureGray pictureGrayDouble ...
    pictureRgb pictureRgbDouble

% end 
