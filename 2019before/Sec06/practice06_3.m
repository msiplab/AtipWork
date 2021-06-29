% practice06_3.m
%
% $Id: practice06_3.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% ��ԗ�
% �����̕�ԗ�
hIntFactor = 2;
% �����̕�ԗ�
vIntFactor = 2;
% �S�Ԉ�����
intFactor = hIntFactor * vIntFactor;

%% �摜�̓Ǎ��ƋP�x�l�̒��o
pictureRgb = imread('./data/boatsBackRgb.tif');
pictureGray = rgb2graycq(pictureRgb);
clear pictureRgb;

%% �뎟�z�[���h�ɂ��g�又��
pictureGrayIntpd = ...
    zeros(size(pictureGray).*[vIntFactor hIntFactor],'uint8');
for iSubRow = 1:vIntFactor
    for iSubCol = 1:hIntFactor
        pictureGrayIntpd(...
            iSubRow:vIntFactor:end,...
            iSubCol:hIntFactor:end) = pictureGray;
    end    
end

%% ���摜�\��
figure(1)
imshowcq(pictureGray)
title('Original picture')

%% �g��摜�\��
figure(2)
imshowcq(pictureGrayIntpd)
title('Interpolated picture')

% end
