function [valueC,valueS] = sowtdec2(src,nlevels)
%SOWTDEC2 Decomposition by Symmetric Orthonormal Wavelet
%
% SVN identifier:
% $Id: nshaarwtdec2.m 303 2012-03-11 01:39:03Z sho $
%
% Requirements: MATLAB R2011b
%
% Reference:
%   Atsuyuki Adachi, Shogo Muramatsu, Hisakazu Kikuchi, 
%   ``Constraints of Second-Order Vanishing Moments on Lattice Structures
%     for Non-separable Orthogonal Symmetric Wavelets,''
%   IEICE Trans. Fundamentals, Vol. E92-A, No. 3, pp.788-797, Mar. 2009.
%
% Copyright (c) 2012-2015, Shogo MURAMATSU
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
S = load('./data/sowt','h0','h1','h2','h3');
h0 = S.h0;
h1 = S.h1;
h2 = S.h2;
h3 = S.h3;

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
