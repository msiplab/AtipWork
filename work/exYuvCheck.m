%
% $Id: exYuvCheck.m,v 1.2 2006/05/29 12:08:53 sho Exp $
%
% Copyright (C) 2005-2006 Shogo MURAMATSU, All rights reserved
%

frameSizeY = [288 352];
frameSizeUV = [144 176];
nPixelsY = prod(frameSizeY);
nPixelsUV = prod(frameSizeUV);
precision = 'uint8=>uint8';
fileId = fopen('f:/videos/mobile.cif','r');

nFrames = 300;
minY = inf;
maxY = 0;
minU = inf;
maxU = 0;
minV = inf;
maxV = 0;
for iFrame = 1:nFrames

    pictureTpd= ...
       fread(fileId, nPixelsY, precision);
    if minY > min(min(pictureTpd))
        minY = min(min(pictureTpd));
    end;
    if maxY < max(max(pictureTpd))
        maxY = max(max(pictureTpd));
    end;

    pictureTpd = ...
       fread(fileId, nPixelsUV, precision);

   if minU > min(min(pictureTpd))
        minU = min(min(pictureTpd));
    end;
    if maxU < max(max(pictureTpd))
        maxU = max(max(pictureTpd));
    end;
    
    pictureTpd = ...
       fread(fileId, nPixelsUV, precision);

   if minV > min(min(pictureTpd))
        minV = min(min(pictureTpd));
    end;
    if maxV < max(max(pictureTpd))
        maxV = max(max(pictureTpd));
    end;
end;
    fprintf(' Y: [%d,%d]\n',minY,maxY);
    fprintf(' U: [%d,%d]\n',minU,maxU);
    fprintf(' V: [%d,%d]\n',minV,maxV);    
fclose(fileId);
