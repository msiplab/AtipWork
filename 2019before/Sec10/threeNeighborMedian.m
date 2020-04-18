function outputField = threeNeighborMedian(field1, field2, field3)
%
% $Id: threeNeighborMedian.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (c) 2006-2015, Shogo MURAMATSU, All rights reserved
%
fieldSize = size(field1);
outputField = median( [field1(:) field2(:) field3(:) ], 2);
outputField = reshape(outputField,fieldSize);