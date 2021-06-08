function [outputArray, X, Y] = upsample2(inputArray,upMtx)
%
% Inputs
%
%   inputArray: input array
%   upMtx: upsampling matrix
%
% Outputs
%
%   outputArray: output array 
%   X          : horizontal sampling points
%   Y          : vertical sampling points
%
% $Id: upsample2.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2007 Shogo MURAMATSU, All rights reserved
%

% 入力配列のサイズ
nRowsInputArray = size(inputArray,1);
nColsInputArray = size(inputArray,2);
nCompInputArray = size(inputArray,3);

% アップサンプリング後の配列範囲計算
vertexPoints(:,1) = [ 0 0 ].';
vertexPoints(:,2) = upMtx * [ 0 nColsInputArray ].';
vertexPoints(:,3) = upMtx * [ nRowsInputArray 0 ].';
vertexPoints(:,4) = upMtx * [ nRowsInputArray nColsInputArray ].';
minPoint = floor(min(vertexPoints,[],2));
maxPoint = ceil(max(vertexPoints,[],2))-1;

% アップサンプリング
clear arrayY;
iRow = 1;
for m0 = minPoint(1):maxPoint(1)
    iCol = 1;
    for m1 = minPoint(2):maxPoint(2)
        outputArray(iRow, iCol, :) = zeros(1,nCompInputArray,...
                'like',inputArray);        
        originalPoint = upMtx \ [ m0 m1 ].';
        lat = upMtx * fix(originalPoint);
        if m0 == lat(1) && m1 == lat(2)
            n0 = originalPoint(1);
            n1 = originalPoint(2);
            if n0 >= 0 && n0 < nRowsInputArray  && ...
                n1 >= 0 && n1< nColsInputArray
                outputArray(iRow, iCol, :) = inputArray(n0 + 1, n1 + 1, :);    
            end
        end
       iCol = iCol + 1;
    end
    iRow = iRow + 1;
end

Y = minPoint(1):maxPoint(1);
X = minPoint(2):maxPoint(2);

% end of upsample2
