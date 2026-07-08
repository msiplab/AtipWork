%[text] # Sample 9-2
%[text] ## 離散ウェーブレット変換
%[text] ブロックDCTのフィルタバンク実装
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Discrete wavelet transform
%[text] Filter bank implementation of block DCT
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ## ブロックサイズの設定
%[text] (Settings of block size)
% # of channels
nChs = 4; %[control:slider:7367]{"position":[8,9]}
%%
%[text] ## 入力信号の生成
%[text] (Generation of input)
% Input signal
u = rand(1,3*nChs);
u = [0 u zeros(1,nChs-1)];
%%
%[text] ### 並列フィルタバンク実装
%[text] (Parallel filter bank implementation)
% DCT matrix
P =  dctmtx(nChs);

% IDCT matrix
Q = P.';

% Analysis process
s = cell(nChs,1);
for iCh = 1:nChs
    hk = fliplr(P(iCh,:));
    % Decimation
    s{iCh} = downsample(conv(hk,u),nChs); 
end
s = cell2mat(s);

% Synthesis process
v = 0;
for iCh = 1:nChs
    fk = Q(:,iCh);
    % Interpolation
    vk = conv(fk,upsample(s(iCh,:),nChs));
    v = v + vk;
end
%%
%[text] ## 信号表示
%[text] (Signal display)
figure(1)
subplot(3,nChs,1:nChs)
stem(0:length(u)-1,u,'filled')
title('Input u[n]')
xlabel('n')
ax = gca;
ax.XLim =[ 0 length(v)];

for iCh = 1:nChs
    subplot(3,nChs,nChs+iCh)
    stem(0:size(s,2)-1,s(iCh,:),'filled')
    title(['Subbnad s_' num2str(iCh-1) '[m]'])
    xlabel('m')
    ax = gca;
    ax.YLim =[ min(s(:)) max(s(:)) ];
end

subplot(3,nChs,2*nChs+(1:nChs))
stem(0:length(v)-1,v,'filled')
title('Outut v[n]')
xlabel('n')
ax = gca;
ax.XLim =[ 0 length(v)];
%%
%[text] ### 合成フィルタのインパルス応答（基底ベクトル）
%[text] (Impluse responses of synthesis filters; basis vectors)
figure(2)
for iCh = 1:nChs
    fk = Q(:,iCh);
    subplot(nChs/2,2,iCh)
    stem(0:length(fk)-1,fk,'filled')
    title([ 'f_' num2str(iCh-1) '[m]' ])
    xlabel('m')
    ax = gca;
    ax.YLim =[ min(Q(:)) max(Q(:)) ];
end
%%
%[text] ### 合成フィルタの周波数応答（基底ベクトル）
%[text] (Frequency responses of synthesis filters; basis vectors)
figure(3)
fftPoints = 512;
F = zeros(fftPoints,nChs);
legends = cell(nChs,1);
for iCh = 1:nChs
    fk = Q(:,iCh); 
    if iCh == 1
        [F(:,iCh),W] = freqz(fk,1,fftPoints);
    else
        F(:,iCh) = freqz(fk,1,fftPoints);
    end
    legends{iCh} = [ 'F_' num2str(iCh-1) ];
end
plot(W/pi,abs(F)) %20*log10(abs(F)))
axis([0 1 0 ceil(sqrt(nChs))]) %-70 10])
xlabel('Normalized Frequency (x\pi rad/sample)')
ylabel('Magnitude') % (dB)')
legend(legends,'Location','southeast')
grid on
%%
%[text] ### ポリフェーズ行列実装
%[text] (Polyphase matrix implemenation)
%[text] 分析合成処理 (Analysis and synthesis process)
%[text]  $\\mathbf{E}(z)=\\left(\\begin{array}{cccc}  h\_0\[0\] &h\_0\[1\] & \\cdots & h\_0\[M-1\] \\\\ h\_1\[0\]& h\_1\[1\] & \\cdots & h\_1\[M-1\] \\\\ \\vdots & \\vdots & \\ddots & \\vdots \\\\\nh\_{M-1}\[0\] & h\_{M-1}\[1\] & \\cdots & h\_{M-1}\[M-1\]\n\\end{array}\\right)$
%[text]  $\\mathbf{R}(z)=\\left(\\begin{array}{cccc}  f\_0\[M-1\] &f\_1\[M-1\] &\\cdots&f\_{M-1}\[M-1\] \\\\ f\_0\[M-2\]& f\_1\[M-2\] & \\cdots & f\_{M-1}\[M-2\] \\\\\n\\vdots & \\vdots & \\ddots & \\vdots \\\\\nf\_0\[0\] & f\_1\[0\] & \\cdots & f\_{M-1}\[0\]\\end{array}\\right)$
%[text] 
% Input Signal
u = [zeros(1,nChs-1) u 0 ]; % Adjust delay for downsampling
disp(u)

% Serial/Parallel conversion
x = cell(nChs,1);
idx = 1;
for phase = 0:nChs-1
    x{idx} = downsample(u,nChs,mod(nChs-1-phase,nChs));
    idx = idx + 1;
end
x = cell2mat(x);
disp(x)

% Analysis process w/ the polyphase matrix
E = fliplr(P); % E = PJ
s = E*x;
disp(s)
% Synthesis process w/ the polyphase matrix
R = flipud(Q); % R = JQ
y = R*s;
disp(y)
% Parallel/Serial conversion
v = 0;
idx = 1;
for phase = nChs-1:-1:0
    v = v + upsample(y(idx,:),nChs,phase);
    idx = idx + 1;
end
disp(v)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:7367]
%   data: {"defaultValue":4,"label":"nChs","max":8,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":2}
%---
