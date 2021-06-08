% practice06_2.m
%
% $Id: practice06_2.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �Ԉ�����
% �����̊Ԉ�����
hDecFactor = 2;
% �����̊Ԉ�����
vDecFactor = 2;
% �S�Ԉ�����
decFactor = hDecFactor * vDecFactor;

%% �摜�̓Ǎ��ƋP�x�l�̒��o
pictureRgb = imread('./data/barbaraFaceRgb.tif');
pictureGray = rgb2graycq(pictureRgb);
clear pictureRgb

%% �摜�T�C�Y�̒��o
nRows = size(pictureGray,1);
nCols = size(pictureGray,2);

%% ���ϑ���ɂ��k������
sizeExt = ceil(size(pictureGray) ./ [vDecFactor hDecFactor]) ...
    .* [vDecFactor hDecFactor];
pictureGrayExt = zeros(sizeExt);
pictureGrayExt(1:nRows,1:nCols) = pictureGray;
pictureGrayAcc = 0;
for iSubRow = 1:vDecFactor
   for iSubCol = 1:hDecFactor
      pictureGrayAcc = pictureGrayAcc + ...
          double(pictureGrayExt(iSubRow:vDecFactor:end,...
                                iSubCol:hDecFactor:end));
   end  
end
pictureGrayDecimated = uint8( pictureGrayAcc / decFactor );

%% ���摜�\��
figure(1)
imshowcq(pictureGray)
title('Original picture')

%% �k���摜�\��
figure(2)
imshowcq(pictureGrayDecimated)
title('Decimated picture')

% end
