function [outputArray, X, Y] = downsample2(inputArray,downMtx,phase)
%
% Inputs
%
%   inputArray: input array
%   downMtx:    downsampling matrix
%   phase:      downsampling phase
%
% Outputs
% 
%   outputArray: output array
%   X          : horizontal sampling points
%   Y          : vertical sampling points
%
% $Id: downsample2.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2006-2015 Shogo MURAMATSU, All rights reserved
%
if nargin < 3
    phase = [0 0].';
else
    phase = phase(:);
end

% 入力配列のサイズ
nRowsInputArray = size(inputArray,1);
nColsInputArray = size(inputArray,2);
nCompInputArray = size(inputArray,3);

% ダウンサンプリング後の配列範囲計算
vertexPoints(:,1) = [ 0 0 ].';
vertexPoints(:,2) = downMtx \ [ 0 nColsInputArray-1 ].';
vertexPoints(:,3) = downMtx \ [ nRowsInputArray-1 0 ].';
vertexPoints(:,4) = downMtx \ [ nRowsInputArray-1 nColsInputArray-1 ].';
minPoint = floor(min(vertexPoints,[],2));
maxPoint = ceil(max(vertexPoints,[],2));

% 間引き位相の FPD(downMtx)内への変換
phase = phase - downMtx * floor(downMtx \ phase);

% ダウンサンプリング
clear arrayY;
iRow = 1;
for m0 = minPoint(1):maxPoint(1)
    iCol = 1;
    for m1 = minPoint(2):maxPoint(2)
        originalPoint = downMtx * [ m0 m1 ].';
        n0 = originalPoint(1) + phase(1);
        n1 = originalPoint(2) + phase(2);
        if n0 >= 0 && n0 < nRowsInputArray  && ...
                n1 >= 0 && n1< nColsInputArray
            outputArray(iRow, iCol, :) = inputArray(n0 + 1, n1 + 1, :);            
        else
            outputArray(iRow, iCol, :) = zeros(1,nCompInputArray,...
                'like',inputArray);
        end
       iCol = iCol + 1;
    end
    iRow = iRow + 1;
end

Y = minPoint(1):maxPoint(1);
X = minPoint(2):maxPoint(2);

% end of downsample2
