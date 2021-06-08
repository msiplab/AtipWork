function [ valueC, valueT ] = bayesshrink(valueC, valueS)
%BAYESSHRINK Bayes Shrinkage
%  
% SVN identifier:
% $Id: nshaarwtrec2.m 303 2012-03-11 01:39:03Z sho $
%
% Requirements: MATLAB R2011b
%
% Reference:
%  S. G. Chang, B. Yu and M. Vetterli ``Adaptive Wavelet Thresholding
%  for Image Denoising and Compression,'' IEEE Trans. Image Process., 
%  vol.9, no.9, pp.1532-1546, Sept. 2000.
%
% Copyright (c) 2012-2015 All rights reserved, Shogo MURAMATSU
%
% Contact address: Shogo MURAMATSU,
%                Faculty of Engineering, Niigata University,
%                8050 2-no-cho Ikarashi, Nishi-ku,
%                Niigata, 950-2181, JAPAN
%

% Estimation of standard deviation
numfinec=prod(valueS(end-1,:));
hh1 = valueC(numfinec+1:2*numfinec); % finest wavelet coefs
esigma = median(abs(hh1))/.6745;
ve = esigma^2;

% Subband dependent thresholding
numc = prod(valueS(1,:));
pos = numc;
iSub = 1;
valueT(iSub,1) = 0;
for iLevel=2:size(valueS,1)-1
    numc = prod(valueS(iLevel,:));
    for ihvd = 1:3
        iSub = iSub + 1;
        c = valueC(pos+1:pos+numc);
        vy = var(c);
        sigmax = sqrt(max(vy-ve,0));
        T = min(ve/sigmax,max(abs(c(:))));
        nc = (abs(c)-T);
        nc(nc<0) = 0;
        valueC(pos+1:pos+numc) = sign(c).*nc;
        valueT(iSub,1) = T;
        pos = pos+numc;
    end
end
end

