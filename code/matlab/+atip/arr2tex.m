function y = arr2tex(x,format)
%ARR2TEX Convert a numeric array into the body of a LaTeX matrix
%
%   Y = ATIP.ARR2TEX(X) converts the 2-D array X into the string
%       x11 & x12 & ... \\
%       x21 & x22 & ...
%   which can be put directly into pmatrix or bmatrix.
%
%   Y = ATIP.ARR2TEX(X,FORMAT) specifies the number format (sprintf style).
%   The default is "%g".
%
%   The output format is the same as msip.arr2tex of MsipWorkM.
%
%   Example:
%       atip.arr2tex([1 2; 3 4])          % "1 & 2\\ 3 & 4"
%       atip.arr2tex(magic(3)/9,"%.3f")
%
%   See also ATIP.SAVETEX
%
% Copyright (c) Shogo MURAMATSU, 2026
% All rights reserved.
%
arguments
    x (:,:) {mustBeNumeric}
    format (1,1) string = "%g"
end

rows = size(x,1);
lines = strings(rows,1);
for i = 1:rows
    lines(i) = strjoin(arrayfun(@(v) sprintf(format,v), x(i,:)), " & ");
end
y = strjoin(lines, "\\" + newline);
end
