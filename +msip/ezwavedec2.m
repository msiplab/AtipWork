function [valueC,valueS] = ezwavedec2(src,nlevels,H)
%EZWAVEDEC2 Decomposition by 2-D Wavelet
%
% Requirements: MATLAB R2011b
%
% Copyright (c) 2020, Shogo MURAMATSU
%
% All rights reserved.
%
% Contact address: Shogo MURAMATSU,
%                Faculty of Engineering, Niigata University,
%                8050 2-no-cho Ikarashi, Nishi-ku,
%                Niigata, 950-2181, JAPAN
%

%%
downsample2x2 = @(x) downsample(downsample(x,2).',2).';

%%
% S = load('./data/sowt','h0','h1','h2','h3');
h0 = H.h00;
h1 = H.h01;
h2 = H.h10;
h3 = H.h11;

%%
nred = 1+3*nlevels;
nDim = size(src);
valueS = zeros(nlevels+2,2);
valueS(end,:) = nDim;
outcell = cell(1,nred);
c00 = src;
for ilv = 1:nlevels
    c10 = downsample2x2(imfilter(c00,h1,'conv','circ'));
    c01 = downsample2x2(imfilter(c00,h2,'conv','circ'));
    c11 = downsample2x2(imfilter(c00,h3,'conv','circ'));
    outcell{3*(nlevels-ilv)+2} = c10(:).';
    outcell{3*(nlevels-ilv)+3} = c01(:).';
    outcell{3*(nlevels-ilv)+4} = c11(:).';
    c00 = downsample2x2(imfilter(c00,h0,'conv','circ'));
    valueS(end-ilv,:) = size(c00);
end
outcell{1} = c00(:).';
valueC = cell2mat(outcell);
valueS(1,:) = size(c00);
end
