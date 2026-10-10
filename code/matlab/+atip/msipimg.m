function [X, imgfile] = msipimg(idx, sz, mode)
%MSIPIMG Read a sample image msipimg##.tif of the reference text
%
%   X = ATIP.MSIPIMG(IDX) returns the sample image msipimgNN.tif of the
%   reference text MsipText (NN = IDX, 1 to 8, 512x512 colour image) as a
%   uint8 RGB array.
%
%   X = ATIP.MSIPIMG(IDX, SZ) resizes it to SZ (a scalar means a square).
%   X = ATIP.MSIPIMG(IDX, SZ, "gray") returns a grayscale image (rgb2gray).
%   [X, IMGFILE] = ATIP.MSIPIMG(...) also returns the file location.
%
%   The image is searched in this order:
%     1. the data folder of AtipWork (msipimg01-08.tif are under Git)
%     2. the data folder of MsipWorkM placed next to AtipWork
%     3. GitHub (msiplab/MsipWorkM), saved to the data folder
%
%   Contents: 01 seashore, 02 bouquet, 03 macarons, 04 stone building,
%             05 stone statue face, 06 striped road, 07 Mont Blanc cake,
%             08 watermelon
%
%   Example:
%       X = atip.msipimg(2);                 % bouquet (colour, 512x512)
%       Y = atip.msipimg(4, 256, "gray");    % building (grayscale, 256x256)
%
%   See also ATIP.PRJFOLDERS
%
% Copyright (c) Shogo MURAMATSU, 2026
% All rights reserved.
%

arguments
    idx (1,1) double {mustBeInteger, mustBeInRange(idx,1,8)}
    sz double = []
    mode (1,1) string {mustBeMember(mode,["rgb","gray"])} = "rgb"
end

fname = sprintf("msipimg%02d.tif", idx);
[datfolder,~,prjroot] = atip.prjfolders();
imgfile = fullfile(datfolder, fname);
if ~isfile(imgfile)
    sibling = fullfile(fileparts(prjroot), "MsipWorkM", "data", fname);
    if isfile(sibling)
        imgfile = sibling;
    else
        websave(imgfile, "https://raw.githubusercontent.com/msiplab/MsipWorkM/master/data/" + fname);
    end
end

X = imread(imgfile);
if size(X,3) == 4          % drop the alpha channel if any
    X = X(:,:,1:3);
end
if mode == "gray"
    X = rgb2gray(X);
end
if ~isempty(sz)
    if isscalar(sz), sz = [sz sz]; end
    X = imresize(X, sz, "bicubic");
end

end
