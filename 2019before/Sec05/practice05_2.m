% practice05_2.m
%
% $Id: practice05_2.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% ���摜�̓ǂݍ��݂ƕ\��
pictureRgb = imread('./data/firenzeRgb.jpg');
pictureGray = rgb2graycq(pictureRgb);
figure(1)
imshowcq(pictureGray)
title('Original')

%% �m�C�Y����������摜�̓ǂݍ��݂ƕ\��
pictureNoisy = imread('./data/firenzeNoisy.jpg');
figure(2)
imshowcq(pictureNoisy)
title('Before filtering')

%% �t�B���^�����ƌ��ʂ̕\��
[nRows, nCols] = size(pictureNoisy);
% ���E���ɗ�l��}��
pictureNoisy = [zeros(nRows,1) pictureNoisy zeros(nRows,1)];
pictureNoisy = [zeros(1,nCols+2) ; pictureNoisy ; zeros(1,nCols+2)];
% �t�B���^����
pictureMedian = zeros(nRows,nCols,'like',pictureNoisy);
pictureMax = zeros(nRows,nCols,'like',pictureNoisy);
pictureMin = zeros(nRows,nCols,'like',pictureNoisy);
for iCol = 1:nCols
    for iRow = 1:nRows
        % 3x3 �̈�̐؂�o��(���������̂P��f�̂���ɒ��Ӂj
        subDomain = pictureNoisy(iRow:iRow+2, iCol:iCol+2);
        % �����l, �ő�l, �ŏ��l�j�̏o��
        pictureMedian(iRow,iCol) = median(subDomain(:));
        pictureMax(iRow,iCol) = max(subDomain(:));
        pictureMin(iRow,iCol) = min(subDomain(:));
    end
end
figure(3)
imshowcq(pictureMedian)
title('After filtering (median)')

figure(4)
imshowcq(pictureMax)
title('After filtering (max)')

figure(5)
imshowcq(pictureMin)
title('After filtering (min)')

% end 
