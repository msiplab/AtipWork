function [valueC,valueS] = nshaarwtdec2(src,nlevels)
%NSHAARWTDEC2 Decomposition by Non-subsampled Haar Wavelet
%  
% Requirements: MATLAB R2011b
%
% Copyright (c) 2012-2015 All rights reserved., Shogo MURAMATSU
%
% Contact address: Shogo MURAMATSU,
%                Faculty of Engineering, Niigata University,
%                8050 2-no-cho Ikarashi, Nishi-ku,
%                Niigata, 950-2181, JAPAN
%
h00 = [1  1;  1  1]/4;
h10 = [1  1; -1 -1]/4;
h01 = [1 -1;  1 -1]/4;
h11 = [1 -1; -1  1]/4;
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

