%
% $Id: exPgm2Jpg.m,v 1.1 2006/09/04 22:26:44 sho Exp $
%
% Copyright (C) 2005-2006 Shogo MURAMATSU, All rights reserved
%

nFrames = 378;
for iFrame = 1:nFrames
    fileName = ...
        sprintf('d:/temp/%d.pgm', iFrame - 1);
    picture = imread(fileName);
    pictureYuv(:,:,1) = ...
        picture(1:size(picture,1)*2/3,1:size(picture,2));
    pictureYuv(:,:,2) = ...
       imresize(picture(size(picture,1)*2/3+1:end,1:size(picture,2)/2),...
            2);
   pictureYuv(:,:,3) = ...
       imresize(picture(size(picture,1)*2/3+1:end,size(picture,2)/2+1:end),...
            2);
    pictureRgb = ycbcr2rgb(pictureYuv);
    fileOutput = ...
        sprintf('d:/temp/slide%03d.jpg',iFrame - 1);
    imshow(pictureRgb);
    imwrite(pictureRgb,fileOutput);
    drawnow;
end;


