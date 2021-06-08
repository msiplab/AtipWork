function rec = sowtrec2(valueC,valueS)
%SOWTREC2 Reconstruction by Symmetric Orthonormal Wavelet
%  
% SVN identifier:
% $Id: nshaarwtrec2.m 303 2012-03-11 01:39:03Z sho $
%
% Requirements: MATLAB R2011b
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
upsample2x2 = @(x) upsample(upsample(x,2).',2).';

%%
S = load('./data/sowt','h0','h1','h2','h3');
h0 = S.h0;
h1 = S.h1;
h2 = S.h2;
h3 = S.h3;

%%
nsubdim = valueS(1,:);
nlevels = size(valueS,1)-2;
numc = prod(nsubdim);
pos = 0;
c00 = reshape(valueC(pos+1:pos+numc),nsubdim);
pos = pos + numc;
for ilv = 2:nlevels+1
    r00 = circshift(imfilter(upsample2x2(c00),h0,'corr','circ'),[1 1]);
    %
    nsubdim = valueS(ilv,:);
    numc = prod(nsubdim);
    %
    c10 = reshape(valueC(pos+1:pos+numc),nsubdim);
    r10 = circshift(imfilter(upsample2x2(c10),h1,'corr','circ'),[1 1]);
    pos = pos + numc;
    %
    c01 = reshape(valueC(pos+1:pos+numc),nsubdim);
    r01 = circshift(imfilter(upsample2x2(c01),h2,'corr','circ'),[1 1]);
    pos = pos + numc;
    %
    c11 = reshape(valueC(pos+1:pos+numc),nsubdim);
    r11 = circshift(imfilter(upsample2x2(c11),h3,'corr','circ'),[1 1]);
    pos = pos + numc;
    %
    c00 = r00 + r10 + r01 + r11;
end
rec = c00;
end

