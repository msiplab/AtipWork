%[text] # Sample 1-3: FOR loop
%[text] Advanced Topics in Image Processing, Lecture 1 "Digital Image Representation"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Cumulative sum with a FOR loop
%[text]{"align":"center"} $s=\\sum_{k=1}^{10}k$
%[text] The colon operator `1:10` generates the index array $(1,2,\\ldots,10)$ (see `doc colon`).
s = 0;
for k = 1:10
    s = s + k;
end
disp(s)
%%
%[text] ## Vectorized version
%[text] MATLAB is fastest with array operations.  The same sum without a loop:
disp(sum(1:10))
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
