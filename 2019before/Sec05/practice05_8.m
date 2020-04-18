% practice05_8.m
%
% $Id: practice05_8.m,v 1.3 2007/05/14 21:39:03 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �}�X�N�̐ݒ�
sizeMask = 3;
aveMask = ones([sizeMask sizeMask]);
aveMask = aveMask/sum(aveMask(:));

%% ���摜�̓ǂݍ��݂ƕ\��
pictureRgb = imread('./data/barbaraFaceRgb.tif');
nRows = size(pictureRgb,1);
nCols = size(pictureRgb,2);
figure(1)
imshowcq(pictureRgb)
title('Original')

%% �t�B���^�����i��l�g���j�ƌ��ʂ̕\��
clear pictureFilteredZp;
pictureFilteredZp(:,:,1) = ...
            uint8(filter2(aveMask,double(pictureRgb(:,:,1))));
pictureFilteredZp(:,:,2) = ...
            uint8(filter2(aveMask,double(pictureRgb(:,:,2))));
pictureFilteredZp(:,:,3) = ...
            uint8(filter2(aveMask,double(pictureRgb(:,:,3))));        
figure(2)
imshowcq(pictureFilteredZp)
title('After filtering (zero padding)')

%% �t�B���^�����i�����g���j�ƌ��ʂ̕\��
halfSize = (sizeMask-1)/2;
clear pictureFilteredVpe pictureFilteredPe;
% ���������Ɏ����g��
pictureRgbVpe = [ pictureRgb(end-halfSize:end,:,:) ;
                  pictureRgb(:,:,:) ;
                  pictureRgb(1:halfSize,:,:) ];
% ���������Ɏ����g��              
pictureRgbPe = [ pictureRgbVpe(:,end-halfSize:end,:) ...
                 pictureRgbVpe(:,:,:) ...
                 pictureRgbVpe(:,1:halfSize,:) ];
% �t�B���^����
clear pictureFilteredPe;
pictureFilteredPe(:,:,1) = ...
            uint8(filter2(aveMask,double(pictureRgbPe(:,:,1))));
pictureFilteredPe(:,:,2) = ...
            uint8(filter2(aveMask,double(pictureRgbPe(:,:,2))));
pictureFilteredPe(:,:,3) = ...
            uint8(filter2(aveMask,double(pictureRgbPe(:,:,3))));
% �N���b�s���O
clear pictureFilteredPec;
pictureFilteredPec = pictureFilteredPe(...
    halfSize+1:halfSize+nRows,...
    halfSize+1:halfSize+nCols,:);
% ���ʕ\��
figure(3)
imshowcq(pictureFilteredPec)
title('After filtering (periodic extension)')

%% �t�B���^�����i�Ώ̊g���j�ƌ��ʂ̕\��
halfSize = (sizeMask-1)/2;
clear pictureFilteredVse pictureFilteredSe;
% ���������ɑΏ̊g��
pictureRgbVse = [ pictureRgb(halfSize:-1:1,:,:) ;
                  pictureRgb(:,:,:) ;
                  pictureRgb(end:-1:end-halfSize,:,:) ];
% ���������ɑΏ̊g��              
pictureRgbSe = [ pictureRgbVse(:,halfSize:-1:1,:) ...
                 pictureRgbVse(:,:,:) ...
                 pictureRgbVse(:,end:-1:end-halfSize,:) ];
% �t�B���^����
clear pictureFilteredSe;
pictureFilteredSe(:,:,1) = ...
            uint8(filter2(aveMask,double(pictureRgbSe(:,:,1))));
pictureFilteredSe(:,:,2) = ...
            uint8(filter2(aveMask,double(pictureRgbSe(:,:,2))));
pictureFilteredSe(:,:,3) = ...
            uint8(filter2(aveMask,double(pictureRgbSe(:,:,3))));
% �N���b�s���O
clear pictureFilteredSec;
pictureFilteredSec = pictureFilteredSe(...
    halfSize+1:halfSize+nRows,...
    halfSize+1:halfSize+nCols,:);
% ���ʕ\��
figure(4)
imshowcq(pictureFilteredSec)
title('After filtering (symmetric extension)')

% end 
