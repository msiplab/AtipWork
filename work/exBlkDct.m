%
% $Id: exBlkDct.m,v 1.2 2006/05/29 12:08:53 sho Exp $
%
% Copyright (C) 2005-2006 Shogo MURAMATSU, All rights reserved
%
pictureRgb = imread('./data/barbaraFaceRgb.tif');
pictureGray = im2double(rgb2gray(pictureRgb));
clear pictureRgb;

blkSize = [8 8];
pictureDct = blkproc(pictureGray,blkSize,'dct2(x)');
clear pictureGray;

pictureDct = abs(pictureDct);
pictureDct(1:8:end,1:8:end) = pictureDct(1:8:end,1:8:end)/8;

figure(1);
imshow(pictureDct);
%imwrite(pictureDct,'d:/temp/fig07-DctA.tif');

for iRow = 1:8
    tmp = [];
    for iCol = 1:8
        B = pictureDct(iRow:8:end,iCol:8:end);
        tmp = [ tmp B];
    end;
    if iRow == 1
        pictureSb = tmp;
    else
        pictureSb = [ pictureSb ; tmp ];
    end;
end;    

figure(2);
imshow(pictureSb);
%imwrite(pictureSb,'d:/temp/fig07-DctB.tif');
