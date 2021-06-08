function predictedFrame = mcPrediction( ...
    referenceFrame, mvField, me)
%
% $Id: mcPrediction.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (c) 2006-2015, Shogo MURAMATSU, All rights reserved
%
frameSize = me.frameSize;
mbSize = me.mbSize;
iMbRow = 1;
for iRow = 1:mbSize(1):frameSize(1)
    iRowTop = iRow;
    iRowBottom = iRowTop + mbSize(1) - 1;
    iMbCol = 1;
    for iCol = 1:mbSize(2):frameSize(2)
        iColLeft = iCol;
        iColRight = iColLeft + mbSize(2) - 1;    
        d = mvField(iMbRow,iMbCol,1:2);
        iRowTopInRefFrame = iRowTop + d(1);
        iRowBottomInRefFrame = ...
            iRowTopInRefFrame + mbSize(1) - 1;
        iColLeftInRefFrame = iColLeft + d(2);  
        iColRightInRefFrame = ...
            iColLeftInRefFrame + mbSize(2) - 1;                
        predictedBlock = referenceFrame(...
            iRowTopInRefFrame:iRowBottomInRefFrame,...
            iColLeftInRefFrame:iColRightInRefFrame);                         
        predictedFrame(...
            iRowTop:iRowBottom, iColLeft:iColRight) = predictedBlock;
        iMbCol = iMbCol + 1;
    end
    iMbRow = iMbRow + 1;
end

