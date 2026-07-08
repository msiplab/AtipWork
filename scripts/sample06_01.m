%[text] # Sample 6-1
%[text] ## 標本化
%[text] Sinc関数
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Sampling
%[text] Sinc function
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ### 標本化周期の設定
%[text] (Setting the sampling period)
%[text] - $\\Delta\_\\mathrm{t}$: 標本化周期 (Sampling period) \
% Sampling period
deltat = 1 %[control:slider:24bc]{"position":[10,11]}
%%
%[text] ### Sinc関数
%[text] (Sinc function)
%[text]  $\\mathrm{sinc}(\\Delta\_\\mathbf{t}^{-1}t) \\colon = \\frac{\\sin(\\pi \\Delta\_\\mathrm{t}^{-1}t)}{\\pi \\Delta\_\\mathrm{t}^{-1}t}$
% Sinc function
if ~license('test','signal_toolbox')
    sinc = @(x) (x==0) + (x~=0).*(sin(pi*x)./(pi*x)); 
end
figure(1)
fplot(@(x) sinc(x/deltat),[-15 15])
xlabel('Time t')
ylabel('sinc(t/\Delta_t)')
axis([-15 15 -0.5 1.5])
%%
%[text] ### 入力信号の設定
%[text] (Setting the input signal)
%[text]  $u(t) = \\sum\_{k\\in\\mathbb{Z}} c\[k\]\\mathrm{sinc}\n(\\Delta\_\\mathrm{t}^{-1}t-k)$
%[text] シャノンの標本化定理は帯域制限信号 (Shannon's sampling theorem is for the bandwidth-limiting signal )
%[text]  $u\\in \\mathrm{span}\\{\\mathrm{sinc}(\\Delta\_\\mathrm{t}^{-1}\\cdot-n)\\}\_n.$
%[text] を対象とする。
% Configuration
ts = -10;
te = 20;
k = 0:floor(10/deltat);
td = linspace(ts,te,(te-ts)*floor(1e3/deltat));
[Ts,K] = ndgrid(td,k);

% Generation of signal
c = rand(size(k));
u = sinc(Ts/deltat - K)*c(:);

% Plot the signal
figure(2)
plot(td,u)
xlabel('Time t')
ylabel('Signal u(t)')
axis([ts te -0.5 1.5])
%%
%[text] ### Sinc関数による標本化
%[text] ### (Sampling with sinc function)
%[text]  $u\[n\] = \\Delta\_\\mathrm{t}^{-1}\\int\_{-\\infty}^{\\infty}u(t)\\mathrm{sinc}(\\Delta\_\\mathrm{t}^{-1}t-n)dt$
%[text] 以下では有限なサポート領域および台形則で積分を近似していることに注意 (Note that the following approximates the integral with a finite support region and a trapezoidal law.)
% Trapezoidal numerical integration
s = (1/deltat)*trapz(td,u.*sinc(Ts/deltat-K));

% Plot samples
figure(2)
stem(deltat*k,s,'filled')
xlabel('Index n')
ylabel('Sequence u[n]')
axis([ts te -.5 1.5])
%%
%[text] ### 信号再構成
%[text] (Signal reconstruction)
%[text]  $\\hat{u}(t) = \\sum\_{k\\in\\mathbb{Z}} u\[k\]\\mathrm{sinc}\n(\\Delta\_\\mathrm{t}^{-1}t-k)$
% Reconstruct the signal from the samples
uhat = sinc(Ts/deltat - K)*s(:);

% Plot the signal
figure(3)
plot(td,u,'b',td,uhat,'--r',deltat*k,s,'or')
xlabel('Time t')
ylabel('Signal u\^(t)')
axis([ts te -0.5 1.5])
legend('Original','Reconstructed','Samples')
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:24bc]
%   data: {"defaultValue":1,"label":"deltat","max":2,"min":0.5,"run":"SectionToEnd","runOn":"ValueChanging","step":0.1}
%---
