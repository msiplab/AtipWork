% practice05_8.m
%
% $Id: practice05_8.m,v 1.3 2007/05/14 21:39:03 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% マスクの設定
sizeMask = 3;
aveMask = ones([sizeMask sizeMask]);
aveMask = aveMask/sum(aveMask(:));

%% 原画像の読み込みと表示
pictureRgb = imread('./data/barbaraFaceRgb.tif');
nRows = size(pictureRgb,1);
nCols = size(pictureRgb,2);
figure(1)
imshowcq(pictureRgb)
title('Original')

%% フィルタ処理（零値拡張）と結果の表示
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

%% フィルタ処理（周期拡張）と結果の表示
halfSize = (sizeMask-1)/2;
clear pictureFilteredVpe pictureFilteredPe;
% 垂直方向に周期拡張
pictureRgbVpe = [ pictureRgb(end-halfSize:end,:,:) ;
                  pictureRgb(:,:,:) ;
                  pictureRgb(1:halfSize,:,:) ];
% 水平方向に周期拡張              
pictureRgbPe = [ pictureRgbVpe(:,end-halfSize:end,:) ...
                 pictureRgbVpe(:,:,:) ...
                 pictureRgbVpe(:,1:halfSize,:) ];
% フィルタ処理
clear pictureFilteredPe;
pictureFilteredPe(:,:,1) = ...
            uint8(filter2(aveMask,double(pictureRgbPe(:,:,1))));
pictureFilteredPe(:,:,2) = ...
            uint8(filter2(aveMask,double(pictureRgbPe(:,:,2))));
pictureFilteredPe(:,:,3) = ...
            uint8(filter2(aveMask,double(pictureRgbPe(:,:,3))));
% クリッピング
clear pictureFilteredPec;
pictureFilteredPec = pictureFilteredPe(...
    halfSize+1:halfSize+nRows,...
    halfSize+1:halfSize+nCols,:);
% 結果表示
figure(3)
imshowcq(pictureFilteredPec)
title('After filtering (periodic extension)')

%% フィルタ処理（対称拡張）と結果の表示
halfSize = (sizeMask-1)/2;
clear pictureFilteredVse pictureFilteredSe;
% 垂直方向に対称拡張
pictureRgbVse = [ pictureRgb(halfSize:-1:1,:,:) ;
                  pictureRgb(:,:,:) ;
                  pictureRgb(end:-1:end-halfSize,:,:) ];
% 水平方向に対称拡張              
pictureRgbSe = [ pictureRgbVse(:,halfSize:-1:1,:) ...
                 pictureRgbVse(:,:,:) ...
                 pictureRgbVse(:,end:-1:end-halfSize,:) ];
% フィルタ処理
clear pictureFilteredSe;
pictureFilteredSe(:,:,1) = ...
            uint8(filter2(aveMask,double(pictureRgbSe(:,:,1))));
pictureFilteredSe(:,:,2) = ...
            uint8(filter2(aveMask,double(pictureRgbSe(:,:,2))));
pictureFilteredSe(:,:,3) = ...
            uint8(filter2(aveMask,double(pictureRgbSe(:,:,3))));
% クリッピング
clear pictureFilteredSec;
pictureFilteredSec = pictureFilteredSe(...
    halfSize+1:halfSize+nRows,...
    halfSize+1:halfSize+nCols,:);
% 結果表示
figure(4)
imshowcq(pictureFilteredSec)
title('After filtering (symmetric extension)')

% end 
