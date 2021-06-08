function rec = ezwaverec2(valueC,valueS,F)
%EZWAVEREC2 Reconstruction by 2-D Wavelet
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
upsample2x2 = @(x) upsample(upsample(x,2).',2).';

%%
% S = load('./data/sowt','h0','h1','h2','h3');
f0 = F.f00;
f1 = F.f01;
f2 = F.f10;
f3 = F.f11;

%%
nsubdim = valueS(1,:);
nlevels = size(valueS,1)-2;
numc = prod(nsubdim);
pos = 0;
c00 = reshape(valueC(pos+1:pos+numc),nsubdim);
pos = pos + numc;
for ilv = 2:nlevels+1
    r00 = circshift(imfilter(upsample2x2(c00),f0,'conv','circ'),[1 1]);
    %
    nsubdim = valueS(ilv,:);
    numc = prod(nsubdim);
    %
    c10 = reshape(valueC(pos+1:pos+numc),nsubdim);
    r10 = circshift(imfilter(upsample2x2(c10),f1,'conv','circ'),[1 1]);
    pos = pos + numc;
    %
    c01 = reshape(valueC(pos+1:pos+numc),nsubdim);
    r01 = circshift(imfilter(upsample2x2(c01),f2,'conv','circ'),[1 1]);
    pos = pos + numc;
    %
    c11 = reshape(valueC(pos+1:pos+numc),nsubdim);
    r11 = circshift(imfilter(upsample2x2(c11),f3,'conv','circ'),[1 1]);
    pos = pos + numc;
    %
    c00 = r00 + r10 + r01 + r11;
end
rec = c00;
end