function imshowcq(picture)
% IMSHOWCQ
%
% $Id: imshowcq.m,v 1.1 2006/04/19 17:34:37 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

if exist('imshow','file') == 2
    imshow(picture)
else
    if size(picture,3) == 1
        pictureRgb(:,:,1) = picture;
        pictureRgb(:,:,2) = picture;
        pictureRgb(:,:,3) = picture;
    elseif size(picture,3) == 3
        pictureRgb = picture;
    else
        error('Dimension must be either of nxmx1 or nxmx3.');
    end
    
    hold off
    image(pictureRgb)
    axis image
    axis off
end

% end of imshowcq