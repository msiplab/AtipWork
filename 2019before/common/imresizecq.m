function pictureOut = imresizecq(pictureIn,ratio)
% IMRESIZECQ
%
% $Id: imresizecq.m,v 1.1 2006/04/19 17:34:37 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

nRows = size(pictureIn,1);
nCols = size(pictureIn,2);

% óÎéüÉzÅ[ÉãÉhÇ…ÇÊÇÈägëÂèàóù
pictureOut = zeros(nRows*ratio,nCols*ratio);
for iRow = 1:nRows
    for iCol = 1:nCols
        for iSubRow = 0:ratio-1
            iRowIntpd = ...
                (iRow-1)*ratio + 1 + iSubRow;
            for iSubCol = 0:ratio-1
                iColIntpd = ...
                     (iCol-1)*ratio + 1 + iSubCol;
                pictureOut(iRowIntpd, iColIntpd,:) = ...
                    pictureIn(iRow,iCol,:);
            end
        end
    end
end
