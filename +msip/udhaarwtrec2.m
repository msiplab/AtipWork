function rec = nshaarwtrec2(valueC,valueS)
%NSHAARWTREC2 Reconstruction by Non-subsampled Haar Wavelet
%  
% Requirements: MATLAB R2011b
%
% Copyright (c) 2012-2015 All rights reserved, Shogo MURAMATSU
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
nsubdim = valueS(1,:);
nlevels = size(valueS,1)-2;
numc = prod(nsubdim);
pos = 0;
c00 = reshape(valueC(pos+1:pos+numc),nsubdim);
h00 = upsample(upsample(h00,2^(nlevels-1)).',2^(nlevels-1)).';
h10 = upsample(upsample(h10,2^(nlevels-1)).',2^(nlevels-1)).';
h01 = upsample(upsample(h01,2^(nlevels-1)).',2^(nlevels-1)).';
h11 = upsample(upsample(h11,2^(nlevels-1)).',2^(nlevels-1)).';
pos = pos + numc;
for ilv = 2:nlevels+1
    r00 = circshift(imfilter(c00,h00,'corr','circ'),[1 1]);
    %
    nsubdim = valueS(ilv,:);
    numc = prod(nsubdim);
    %
    c10 = reshape(valueC(pos+1:pos+numc),nsubdim);
    r10 = circshift(imfilter(c10,h10,'corr','circ'),[1 1]);
    pos = pos + numc;
    %
    c01 = reshape(valueC(pos+1:pos+numc),nsubdim);
    r01 = circshift(imfilter(c01,h01,'corr','circ'),[1 1]);
    pos = pos + numc;
    %
    c11 = reshape(valueC(pos+1:pos+numc),nsubdim);
    r11 = circshift(imfilter(c11,h11,'corr','circ'),[1 1]);
    pos = pos + numc;
    %
    c00 = r00 + r10 + r01 + r11;
    %
    h00 = downsample(downsample(h00,2).',2).';
    h10 = downsample(downsample(h10,2).',2).';
    h01 = downsample(downsample(h01,2).',2).';
    h11 = downsample(downsample(h11,2).',2).';
end
rec = c00;
end

