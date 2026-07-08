%[text] # Sample 5-2
%[text] ## 周波数解析
%[text] 単変量循環畳み込み
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Fourier analysis
%[text] Univariate circular convolution
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ### 入力信号 $\\{u\[n\]\\}\_n\n$ 
%[text] (Input signal $\\{u\[n\]\\}\_n\n$)
% Input x[n]
u = [1 2 3];
%%
%[text] ### 線形シフト不変システムのインパルス応答 $\\{h\[n\]\\}\_n\n$ 
%[text] (Impulse response of a linear shift-invariant system $\\{h\[n\]\\}\_n\n$)
% Impulse response h[n]
h = [1 1 1]/3;
%%
%[text] ### 周期 $N$ の循環畳み込みの出力応答$\\{v\[n\]\\}\_n\n$ 
%[text] (Output response $\\{v\[n\]\\}\_n\n$ of circular convolution with period $N$ )
%[text] 循環畳み込み演算 (Circular convolution)
%[text]  $\\{v\[n\]\\}\_n=\\{h\[n\]\\}\_n \\bigcirc \\{u\[n\]\\}\_n = \\sum\_{k=-\\infty}^{\\infty}u\[k\]\\{h\[(\\!(n-k)\\!)\_N\]\\}\_n\n$
% Setting the period N
nZeroPadding =0; %[control:slider:2095]{"position":[15,16]}
nPeriod = max(length(u),length(h)) + nZeroPadding;

% Output v[n]
v = cconv(h,u,nPeriod);
%%
%[text] ### 畳み込み演算との比較
%[text] (Comparison with convolution)
% Normal convolution
w = conv(h,u);

% Lengths of u, h, x and v
nu = length(u);
nh = length(h);
nv = length(v);
nw = length(w);

% Display sequences
figure(1)
nx = max(length(v),length(w));
amax = max(max(abs(u)),max(abs(v)));
% u[n]
subplot(4,1,1)
stem(0:nu-1,u,'filled')
axis([0 nx -amax amax])
xlabel('n')
ylabel('u[n]')
title('Input')
% h[n]
subplot(4,1,2)
stem(0:nh-1,h,'filled')
axis([0 nx -amax amax])
xlabel('n')
ylabel('h[n]')
title('Impulse response')
% v[n]
subplot(4,1,3)
stem(0:nv-1,v,'filled')
axis([0 nx -amax amax])
xlabel('n')
ylabel('v[n]')
title('Circular convolution')
% w[n]
subplot(4,1,4)
stem(0:nw-1,w)
axis([0 nx -amax amax])
xlabel('n')
ylabel('w[n]')
title('Normal convolution')
%[text] #### 通常の畳み込みと循環畳み込みが一致する条件
%[text] (The condition that normal convolution and circular convolution match)
%[text]  $L\_\\mathrm{v}=L\_\\mathrm{h}+L\_\\mathrm{u}-1\\leq N$
%[text] ただし、(where)
%[text] - $L\_\\mathrm{v}$: 出力の長さ (Output length)
%[text] - $L\_\\mathrm{h}$: インパルス応答の長さ (Length of impulse response)
%[text] - $L\_\\mathrm{u}$: 入力の長さ (Input length) \
% Adjusting the lengths
mymse = @(x,y) mean((double(x)-double(y)).^2,'all');
if nv > nw
    wc = [w(:); zeros(nv-nw,1)];
    vc = v(:);
else
    vc = [v(:); zeros(nw-nv,1)];
    wc = w(:);
end
% Check the condition
if (nw <= nPeriod)
    msg = 'TRUE';
else
    msg = 'FALSE (Increse # of zeros for padding)';
end
fprintf('Condition for CCONV to match CONV: \n\t %s', msg)
% MSE
fprintf('MSE: %f', mymse(vc,wc))
%%
%[text] ### 入力信号 $\\{u\[n\]\\}\_n\n$ のDFT
%[text] (DFT of input signal $\\{u\[n\]\\}\_n\n$)
%[text]  $U\[k\]=\\sum\_{n=0}^{N-1} u\[n\] W\_{N}^{n k}, k\\in\\{0,1,2,\\cdots,N-1\\}\n$
%[text] ただし，(where)
%[text]  $W\_N=e^{-\\j\\frac{2\\pi}{N}}$
% DFT of u[n]
U = fft(u,nPeriod);
%%
%[text] ### フィルタ $\\{h\[n\]\\}\_n\n$ のDFT
%[text] (DFT of impulse response $\\{h\[n\]\\}\_n\n$)
%[text]  $H\[k\]=\\sum\_{n=0}^{N-1} h\[n\] W\_{N}^{n k}, k\\in\\{0,1,2,\\cdots,N-1\\}\n$
% DFT of h[n]
H = fft(h,nPeriod);
%%
%[text] ### 出力信号 $\\{v\[n\]\\}\_n\n$ のDFT
%[text] (DFT of output signal $\\{v\[n\]\\}\_n\n$)
%[text]  $V\[k\]=\\sum\_{n=0}^{N-1} v\[n\] W\_{N}^{n k}, k\\in\\{0,1,2,\\cdots,N-1\\}\n$
% Frequency response of v[n]
V = fft(v,nPeriod);
%%
%[text] ### DFTの表示
%[text] (Display of DFTs)
% DFT index
k = 0:nPeriod-1;

% Display of DFTs
figure(2)
subplot(3,1,1)
stem(abs(U),'filled')
xlabel('k')
ylabel('|U[k]|')
subplot(3,1,2)
stem(k,abs(H),'filled')
xlabel('k')
ylabel('|H[k]|')
subplot(3,1,3)
stem(k,abs(V),'filled')
xlabel('k')
ylabel('|V[k]|')
%%
%[text] ### DFT積
%[text] (DFT product)
%[text]  $V\[k\]=H\[k\]U\[k\],\\ k\\in\\{0,1,2,\\cdots,N-1\\}$
%[text] 循環畳み込みとの比較 (Comparison with circular convolution)
% IDFT of DFT product
y = ifft(H.*U);
% MSE with the cconv result 'v'
fprintf('MSE: %f', mymse(v,y))
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:2095]
%   data: {"defaultValue":0,"label":"nPoints","max":16,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
