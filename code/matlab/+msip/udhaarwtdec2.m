function [valueC,valueS] = udhaarwtdec2(src,nlevels)
%UDHAARWTDEC2 Decomposition by Undecimated Haar Wavelet
%
%   [C,S] = MSIP.UDHAARWTDEC2(X,NLEVELS) applies the NLEVELS-level undecimated
%   (redundant) 2-D Haar DWT with circular extension.  The subbands are
%   stacked in C (approximation first) and their sizes in S.
%
%   Separable filters as in the reference text [M] (Example "Haar DWT",
%   Sec. 6.4.1), delayed and scaled for the undecimated transform:
%     synthesis  F0(z) = (1+z^-1)/2,  F1(z) = (1-z^-1)/2,
%     analysis   H0(z) = (1+z^-1)/2,  H1(z) = (-1+z^-1)/2  (adjoint pair).
%   Together with MSIP.UDHAARWTREC2 this is a Parseval tight frame.
%
% Requirements: MATLAB R2011b
%
% Copyright (c) 2012-2026 All rights reserved., Shogo MURAMATSU
%
% Contact address: Shogo MURAMATSU,
%                Faculty of Engineering, Niigata University,
%                8050 2-no-cho Ikarashi, Nishi-ku,
%                Niigata, 950-2181, JAPAN
%
h00 = [ 1  1;  1  1]/4;
h10 = [-1 -1;  1  1]/4;   % vertical highpass  x horizontal lowpass
h01 = [-1  1; -1  1]/4;   % vertical lowpass   x horizontal highpass
h11 = [ 1 -1; -1  1]/4;   % vertical highpass  x horizontal highpass
nred = 1+3*nlevels;
nDim = size(src);
valueS = repmat(nDim,[nlevels+2 1]);
outcell = cell(1,nred);
c00 = src;
for ilv = 1:nlevels
    c10 = imfilter(c00,h10,'conv','circ');
    c01 = imfilter(c00,h01,'conv','circ');
    c11 = imfilter(c00,h11,'conv','circ');
    outcell{3*(nlevels-ilv)+2} = c10(:).';
    outcell{3*(nlevels-ilv)+3} = c01(:).';
    outcell{3*(nlevels-ilv)+4} = c11(:).';
    c00 = imfilter(c00,h00,'conv','circ');
    h00 = upsample(upsample(h00,2).',2).';
    h10 = upsample(upsample(h10,2).',2).';
    h01 = upsample(upsample(h01,2).',2).';
    h11 = upsample(upsample(h11,2).',2).';
end
outcell{1} = c00(:).';
valueC = cell2mat(outcell);
end

