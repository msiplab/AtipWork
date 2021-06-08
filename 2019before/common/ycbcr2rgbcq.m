function pictureRgb = ycbcr2rgbcq(pictureYCbCr)
% YCBCR2RGBCQ
%
% $Id: ycbcr2rgbcq.m,v 1.1 2006/04/19 17:34:37 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

if exist('ycbcr2rgb','file') == 2
    pictureRgb = rgb2gray(pictureYCbCr);
else
    pictureRgb = zeros(size(pictureYCbCr),'uint8');
    if isa(pictureYCbCr,'uint8')
        T = inv( ...
            diag([219.0 224.0 224.0]) * ...
            [  0.299  0.587  0.114;
            -0.169 -0.331  0.500;
            0.500 -0.419 -0.081 ]...
            );
        pictureY = double(pictureYCbCr(:,:,1)) - 16;
        pictureCb = double(pictureYCbCr(:,:,2)) - 128;
        pictureCr = double(pictureYCbCr(:,:,3)) - 128;
        for iCmp = 1:3
            pictureRgb(:,:,iCmp) = uint8( 255.0 * (...
                T(iCmp,1) * pictureY + ...
                T(iCmp,2) * pictureCb + ...
                T(iCmp,3) * pictureCr ...
                ));
        end
    else
        error('not uint8');
    end
end
