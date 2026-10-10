%[text] # Sample 9-5: In-place implementation
%[text] Advanced Topics in Image Processing, Lecture 9 "Discrete Wavelet Transforms"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Generation of the input
% Input signal x[n]
x = rand(64,1); % or [ 0 3 1 3 1 5 3 0 ] (even length)
%%
%[text] ## In-place implementation of the 9/7-DWT
%[text] The following functions are used.  Their definitions are attached at the end.
%[text] - TRANS97: in-place implementation of the forward 9/7-transform
%[text] - ITRANS97: in-place implementation of the inverse 9/7-transform \
%[text] The symmetric extension method is applied as the boundary processing.
% 3-level hierarchical analysis process (tree structure)
[y10,y11] = trans97(x);
[y20,y21] = trans97(y10);
[y30,y31] = trans97(y20);

% 3-level hierarchical synthesis process
xhat2 = itrans97(y30,y31);
xhat1 = itrans97(xhat2,y21);
xhat  = itrans97(xhat1,y11);
fprintf("Reconstruction error (max. abs.): %g\n", max(abs(x - xhat)))
%%
%[text] ## Signal display
figure
tiledlayout(3,8,"TileSpacing","compact")
% Input
nexttile([1 8])
stem(0:length(x)-1,x,"filled")
title("Input x[n]")
xlabel("n")
xlim([0 length(x)])

% Subbands y_0^(3), y_1^(3), y_1^(2), y_1^(1)
subbands = {y30, y31, y21, y11};
spans = [1 1 2 4];
for k = 1:4
    nexttile([1 spans(k)])
    stem(0:length(subbands{k})-1,subbands{k},"filled")
    ylim([-1 1])
end

% Output
nexttile([1 8])
stem(0:length(xhat)-1,xhat,"filled")
title("Output x\_hat[n]")
xlabel("n")
xlim([0 length(xhat)])
%%
%[text] ## Impulse responses of the synthesis filters (local basis vectors)
% 3-level hierarchical synthesis process applied to unit impulses
f = cell(4,1);
for idx = 1:4
    y30 = zeros(10,1);
    y31 = zeros(10,1);
    y21 = zeros(20,1);
    y11 = zeros(40,1);
    if idx == 1
        y30(ceil(end/2)) = 1;
    elseif idx == 2
        y31(ceil(end/2)) = 1;
    elseif idx == 3
        y21(ceil(end/2)) = 1;
    else
        y11(ceil(end/2)) = 1;
    end
    xhat2 = itrans97(y30,y31);
    xhat1 = itrans97(xhat2,y21);
    f{idx} = itrans97(xhat1,y11);
end

figure
tiledlayout(4,1,"TileSpacing","compact")
for idx = 1:4
    nexttile
    stem(0:length(f{idx})-1,f{idx},"filled")
    title("f_" + (idx-1) + "[n]")
end
%%
%[text] ## Frequency responses
figure
fftPoints = 512;
F = zeros(fftPoints,4);
for idx = 1:4
    if idx == 1
        [F(:,idx),W] = freqz(f{idx},1,fftPoints);
    else
        F(:,idx)     = freqz(f{idx},1,fftPoints);
    end
end
plot(W/pi, abs(F))
axis([0 1 0 10])
xlabel("Normalized frequency (\times\pi rad/sample)")
ylabel("Magnitude")
title("Frequency responses of the synthesis filters")
legend(["F_0","F_1","F_2","F_3"])
grid on
%%
%[text] ## Function definitions
%[text] Forward 9/7-transform with in-place implementation
function [subL,subH] = trans97(seq)
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%
alpha = -1.586134342059924;
beta  = -0.052980118572961;
gamma =  0.882911075530934;
delta =  0.443506852043971;
K =  1.230174104914001;

seq = double(seq);

% In-place implementation
seq = inplaceprediction(seq,alpha);
seq = inplaceupdate(seq,beta);
seq = inplaceprediction(seq,gamma);
seq = inplaceupdate(seq,delta);
seq(1:2:end) = seq(1:2:end)/K;
seq(2:2:end) = seq(2:2:end)*K;

% Split coefficients
subL = seq(1:2:end);
subH = seq(2:2:end);

end
%[text] Inverse 9/7-transform with in-place implementation
function seq = itrans97(subL,subH)
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%
alpha = -1.586134342059924;
beta  = -0.052980118572961;
gamma =  0.882911075530934;
delta =  0.443506852043971;
K =  1.230174104914001;

% Preparation
fulllength = length(subL) + length(subH);
seq = zeros(fulllength,1);

% Merge coefficients
seq(1:2:end) = subL;
seq(2:2:end) = subH;

% In-place implementation
seq(1:2:end) = seq(1:2:end)*K;
seq(2:2:end) = seq(2:2:end)/K;
seq = inplaceupdate(seq,-delta);
seq = inplaceprediction(seq,-gamma);
seq = inplaceupdate(seq,-beta);
seq = inplaceprediction(seq,-alpha);
end
%[text] Prediction lifting step with in-place implementation
function seq = inplaceprediction(seq,p)
%
% Copyright (C) 2020 Shogo MURAMATSU, All rights reserved
%
flagrow = isrow(seq);
if flagrow
    seq = seq.';
end

if (mod(length(seq),2)==0)
    seq(2:2:end) = seq(2:2:end) ... % Symmetric extension at the boundary
        + p * ( seq(1:2:end) + [seq(3:2:end);seq(end-1)]);
else
    seq(2:2:end) = seq(2:2:end) ...
        + p * (seq(1:2:end-2) + seq(3:2:end));
end
if flagrow
    seq = seq.';
end
end
%[text] Update lifting step with in-place implementation
function seq = inplaceupdate(seq,u)
%
% Copyright (C) 2020 Shogo MURAMATSU, All rights reserved
%
flagrow = isrow(seq);
if flagrow
    seq = seq.';
end
if (mod(length(seq),2)==0)
    seq(1:2:end) = seq(1:2:end) ...
        + u * ( [seq(2); seq(2:2:end-1)] + seq(2:2:end));
else
    seq(1:2:end) = seq(1:2:end) ... % Symmetric extension at the boundary
        + u * ( [seq(2); seq(2:2:end-1)] + [seq(2:2:end); seq(end-1)]);
end
if flagrow
    seq = seq.';
end
end
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
