%
% $Id: exIm2Frame.m,v 1.2 2006/05/29 12:08:53 sho Exp $
%
% Copyright (C) 2005-2006 Shogo MURAMATSU, All rights reserved
%

nFrames = 150;
for iFrame = 1:nFrames
    fileName = ...
    sprintf('data/calcio%03d.jpg', iFrame - 1);
    pictureRgb = imread(fileName);
    frameSeq(iFrame) = im2frame(pictureRgb);
%    multiFramesRgb(:,:,:,iFrame) = ...
%         pictureRgb;
end;
%frameSeq = immovie(multiFramesRgb);
movie(frameSeq,2,30);
