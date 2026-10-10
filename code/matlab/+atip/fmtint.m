function s = fmtint(v)
%FMTINT Format an integer with a comma every three digits for LaTeX
%
%   S = ATIP.FMTINT(V) rounds V to an integer and returns a string with
%   "{,}" every three digits (no extra space in math mode).
%
%   Example:
%       atip.fmtint(8294400)     % "8{,}294{,}400"
%
%   See also ATIP.SAVETEX
%
% Copyright (c) Shogo MURAMATSU, 2026
% All rights reserved.
%
arguments
    v (1,1) {mustBeNumeric}
end
s = string(sprintf("%d", round(v)));
s = regexprep(s, "(\d)(?=(\d{3})+$)", "$1{,}");
end
