%[text] # Sample 9-2: FB implementation of block DCT
%[text] Advanced Topics in Image Processing, Lecture 9 "Discrete Wavelet Transforms"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Setting of the block size
% Number of channels (= block size M)
nChs = 4; %[control:slider:8003]{"position":[8,9]}
%%
%[text] ## Generation of the input
% Input signal x[n]
x = rand(1,3*nChs);
x = [0 x zeros(1,nChs-1)];
%%
%[text] ## Parallel filter bank implementation
% DCT matrix C_M
C = dctmtx(nChs);

% IDCT matrix C_M^T
Ct = C.';

% Analysis process
y = cell(nChs,1);
for iCh = 1:nChs
    hk = fliplr(C(iCh,:));
    % Decimation
    y{iCh} = downsample(conv(hk,x),nChs);
end
y = cell2mat(y);

% Synthesis process
xhat = 0;
for iCh = 1:nChs
    fk = Ct(:,iCh);
    % Interpolation
    xhatk = conv(fk,upsample(y(iCh,:),nChs));
    xhat = xhat + xhatk;
end
%%
%[text] ## Signal display
figure
tiledlayout(3,nChs,"TileSpacing","compact")
nexttile([1 nChs])
stem(0:length(x)-1,x,"filled")
title("Input x[n]")
xlabel("n")
xlim([0 length(xhat)])

for iCh = 1:nChs
    nexttile
    stem(0:size(y,2)-1,y(iCh,:),"filled")
    title("Subband y_" + (iCh-1) + "[m]")
    xlabel("m")
    ylim([min(y(:)) max(y(:))])
end

nexttile([1 nChs])
stem(0:length(xhat)-1,xhat,"filled")
title("Output x\_hat[n]")
xlabel("n")
xlim([0 length(xhat)])
%%
%[text] ## Impulse responses of the synthesis filters (basis vectors)
figure
tiledlayout(nChs/2,2,"TileSpacing","compact")
for iCh = 1:nChs
    fk = Ct(:,iCh);
    nexttile
    stem(0:length(fk)-1,fk,"filled")
    title("f_" + (iCh-1) + "[n]")
    xlabel("n")
    ylim([min(Ct(:)) max(Ct(:))])
end
%%
%[text] ## Frequency responses of the synthesis filters
figure
fftPoints = 512;
F = zeros(fftPoints,nChs);
legends = strings(nChs,1);
for iCh = 1:nChs
    fk = Ct(:,iCh);
    if iCh == 1
        [F(:,iCh),W] = freqz(fk,1,fftPoints);
    else
        F(:,iCh) = freqz(fk,1,fftPoints);
    end
    legends(iCh) = "F_" + (iCh-1);
end
plot(W/pi,abs(F))
axis([0 1 0 ceil(sqrt(nChs))])
xlabel("Normalized frequency (\times\pi rad/sample)")
ylabel("Magnitude")
legend(legends,"Location","southeast")
grid on
%%
%[text] ## Polyphase matrix implementation
%[text] Analysis and synthesis process
%[text]  $\\mathbf{E}=\\begin{pmatrix}  h\_0\[0\] & h\_0\[1\] & \\cdots & h\_0\[M-1\] \\\\ h\_1\[0\] & h\_1\[1\] & \\cdots & h\_1\[M-1\] \\\\ \\vdots & \\vdots & \\ddots & \\vdots \\\\ h\_{M-1}\[0\] & h\_{M-1}\[1\] & \\cdots & h\_{M-1}\[M-1\] \\end{pmatrix}=\\mathbf{C}\_M\\mathbf{J}\_M$
%[text]  $\\mathbf{R}=\\begin{pmatrix}  f\_0\[M-1\] & f\_1\[M-1\] & \\cdots & f\_{M-1}\[M-1\] \\\\ f\_0\[M-2\] & f\_1\[M-2\] & \\cdots & f\_{M-1}\[M-2\] \\\\ \\vdots & \\vdots & \\ddots & \\vdots \\\\ f\_0\[0\] & f\_1\[0\] & \\cdots & f\_{M-1}\[0\] \\end{pmatrix}=\\mathbf{J}\_M\\mathbf{C}\_M^\\top$
% Input signal
x = [zeros(1,nChs-1) x 0 ]; % adjust the delay for downsampling
disp(x)

% Serial-to-parallel conversion
xp = cell(nChs,1);
idx = 1;
for phase = 0:nChs-1
    xp{idx} = downsample(x,nChs,mod(nChs-1-phase,nChs));
    idx = idx + 1;
end
xp = cell2mat(xp);
disp(xp)

% Analysis process with the polyphase matrix
E = fliplr(C); % E = CJ
y = E*xp;
disp(y)
% Synthesis process with the polyphase matrix
R = flipud(Ct); % R = JC^T
xhatp = R*y;
disp(xhatp)
% Parallel-to-serial conversion
xhat = 0;
idx = 1;
for phase = nChs-1:-1:0
    xhat = xhat + upsample(xhatp(idx,:),nChs,phase);
    idx = idx + 1;
end
disp(xhat)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:8003]
%   data: {"defaultValue":4,"label":"nChs","max":8,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":2}
%---
