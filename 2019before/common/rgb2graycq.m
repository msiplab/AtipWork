function pictureGray = rgb2graycq(pictureRgb)
% RGB2GRAYCQ
%
% $Id: rgb2graycq.m,v 1.1 2006/04/19 17:34:37 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%
%

if exist('rgb2gray','file') == 2
    pictureGray = rgb2gray(pictureRgb);
else
    pictureGray = ...
        0.2989 * pictureRgb(:,:,1) + ... % R
        0.5870 * pictureRgb(:,:,2) + ... % G
        0.1140 * pictureRgb(:,:,3);      % B
    
    if isa(pictureRgb,'uint8')
        pictureGray = uint8(pictureGray);
    elseif isa(pictureRgb,'uint16')
        pictureGray = uint16(pictureGray);
    elseif isa(pictureRgb,'double')
        pictureGray = double(pictureGray);
    end
end

% end of rgb2graycq
