function mvField = fullSearchBlockMatchingMe(...
    referenceFrame, currentFrame, me )
%
% $Id: fullSearchBlockMatchingMe.m,v 1.5 2007/11/22 03:12:15 sho Exp $
%
% Copyright (c) 2006-2015, Shogo MURAMATSU, All rights reserved
%

% 動きベクトル場の探索開始
iMbRow = 1;
mvField = zeros(ceil(me.frameSize(1)/me.mbSize(1)),...
    ceil(me.frameSize(2)/me.mbSize(2)),...
    2);
for iRow = 1:me.mbSize(1):me.frameSize(1)
    iRowTop = iRow;
    iRowBottom = iRowTop + me.mbSize(1) - 1;
    iMbCol = 1;
    for iCol = 1:me.mbSize(2):me.frameSize(2)
        iColLeft = iCol;
        iColRight = iColLeft + me.mbSize(2) - 1;    
        currentBlock = currentFrame(...
            iRowTop:iRowBottom, iColLeft:iColRight);
        mvField(iMbRow,iMbCol,1:2) = ...
            subSearch(referenceFrame, currentBlock,...
                [iRowTop iColLeft], me);
        iMbCol = iMbCol + 1;
    end
    iMbRow = iMbRow + 1;
end

%%
function mv = subSearch(...
    referenceFrame, currentBlock, iTopLeft, me)
%
iRowTop = iTopLeft(1);
iColLeft = iTopLeft(2);
% 動きベクトルの探索開始
minimumSad = Inf;
for d0 = me.searchRegion(1):me.searchRegion(2)
    iRowTopInRefFrame = iRowTop + d0;
    iRowBottomInRefFrame = ...
        iRowTopInRefFrame + me.mbSize(1) - 1;
    for d1 = me.searchRegion(3):me.searchRegion(4)
        iColLeftInRefFrame = iColLeft + d1;  
        iColRightInRefFrame = ...
            iColLeftInRefFrame + me.mbSize(2) - 1;                
        if ( iRowTopInRefFrame > 0 && ...
            iColLeftInRefFrame > 0 && ...
            iRowBottomInRefFrame <= me.frameSize(1) && ...
            iColRightInRefFrame <= me.frameSize(2) )
            candidateBlock = referenceFrame(...
                iRowTopInRefFrame:iRowBottomInRefFrame,...
                iColLeftInRefFrame:iColRightInRefFrame);                         
            currentSad = sum(abs(... % 差分絶対値和
                double(candidateBlock(:))-double(currentBlock(:))));
            if (currentSad < minimumSad)
                 mv = [d0 d1];
                 minimumSad = currentSad;
            elseif ( d0 == 0 && d1 == 0 &&...
                    currentSad == minimumSad )
                 mv = [0 0];
            end
        end
    end
end
