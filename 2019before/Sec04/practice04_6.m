% practice04_6.m
%
% $Id: practice04_6.m,v 1.4 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �摜�t�@�C���̓Ǎ�
pictureRgb = imread('./data/firenzeRgb.jpg');

%% ���m�N���摜�ւ̕ϊ�
pictureGray = rgb2graycq(pictureRgb);

%% �K�����̐ݒ�
nGrayLevels = 256; % ��������8bit����

%% �����O�̉摜�̕\��
subplot(2,2,1);
imshowcq(pictureGray);
title('Before histgram equalization');

%% �����O�̃q�X�g�O�����̉��
hx = histc(pictureGray(:),0:nGrayLevels-1);

%% �����O�̃q�X�g�O�����̕\��
subplot(2,2,2);
stem(0:nGrayLevels-1,hx,'Marker','none');
axis([0 nGrayLevels 0 10000]);
title('Before histgram equalization');

%% ���K���q�X�g�O�����̌v�Z
nPixels = numel(pictureGray);
px = hx/nPixels;

%% �ϊ��\�̍쐬
lut = double([]);
lut(1) = px(1);
for iGrayLevel = 1:nGrayLevels-1
    lut(iGrayLevel+1) = lut(iGrayLevel)+px(iGrayLevel+1);
end
lutUint8 = uint8((nGrayLevels-1)*lut);

%% �q�X�g�O�����ϓ���
[nRows, nCols] = size(pictureGray);
pictureHistEqd = uint8([]);
for iCol = 1:nCols
    for iRow = 1:nRows
        pictureHistEqd(iRow,iCol) = ...
            uint8(lutUint8(pictureGray(iRow,iCol)+1));
    end
end

%% ������̃q�X�g�O�����̉��
hy = histc(pictureHistEqd(:),0:nGrayLevels-1);

%% ������̉摜�̕\��
subplot(2,2,3);
imshowcq(pictureHistEqd);
title('After histgram equalization');

%% ������̃q�X�g�O�����̕\��
subplot(2,2,4);
stem(0:nGrayLevels-1,hy,'Marker','none');
axis([0 nGrayLevels 0 10000]);
title('After histgram equalization');

% end
