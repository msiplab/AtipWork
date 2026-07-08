%[text] # Sample 4-2
%[text] ## 線形シフト不変システム
%[text] 相関と畳み込み
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Linear shift-invariant systems
%[text] Correlation and convolution
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
%[text] ### フィルタカーネル $\\{w\[n\]\\}\_n\n$ 
%[text] (Filter kernel $\\{w\[n\]\\}\_n\n$)
% Filter kernel w[n]
w = [-1 0 1];
%%
%[text] ### 相互相関$\\{x\[n\]\\}\_n\n$ 
%[text] (Cross-correlation $\\{x\[n\]\\}\_n\n$)
%[text] 相互相関 (Cross-correlation) 
%[text]  $\\{x\[n\]\\}\_n=\\sum\_{k=-\\infty}^{\\infty}u\[k\]\\{w\[n+k\]\\}\_n\n$
% Output x[n]
x = xcorr(u,w);
ndiff = length(u)-length(w);
% Extract the significant subsequence
if ndiff <= 0
    x = x(1:end+ndiff)
else
    x = x(ndiff+1:end)
end
%%
%[text] ### 線形シフト不変システムの出力応答$\\{v\[n\]\\}\_n\n$ 
%[text] (The linear shift-invariant system response $\\{v\[n\]\\}\_n\n$)
%[text] 畳み込み演算 (Convolution)
%[text]  $\\{v\[n\]\\}\_n=\\{h\[n\]\\}\_n \\ast \\{u\[n\]\\}\_n = \\sum\_{k=-\\infty}^{\\infty}u\[k\]\\{h\[n-k\]\\}\_n\n$
%[text] フィルタカーネル $\\{w\[n\]\\}\_n$の反転 (Reversing the filter kernel  $\\{w\[n\]\\}\_n$.)
%[text]  $\\{h\[n\]\\}\_n=\\{w\[-n\]\\}\_n$
% Flip the elements in w[n]
h = flip(w)
%[text] $\\{h\[n\]\\}\_n$をインパルス応答とした畳み込み演算． (A convolutional operation with $\\{h\[n\]\\}\_n$ as the impulse response.)
% Output y[n]
v = conv(h,u)
%%
%[text] ### 入出力のプロット
%[text] (Plot of the input and output)
% Lengths of u, h, x and v
nu = length(u);
nw = length(w);
nx = length(x);
nv = length(v);

figure(1)
amax = max(max(abs(u)),max(abs(x)));
%% u[n]
subplot(4,1,1)
stem(0:nu-1,u,'filled')
axis([0 nx -amax amax])
xlabel('n')
ylabel('u[n]')

%% w[n]
subplot(4,1,2)
stem(0:nw-1,w,'filled')
axis([0 nx -amax amax])
xlabel('n')
ylabel('w[n]')

%% x[n]
subplot(4,1,3)
stem(0:nx-1,x,'filled')
axis([0 nx -amax amax])
xlabel('n')
ylabel('x[n]')

%% v[n]
subplot(4,1,4)
stem(0:nv-1,v,'filled')
axis([0 nx -amax amax])
xlabel('n')
ylabel('v[n]')
%%
%[text] ### 平均自乗誤差(MSE)による評価
%[text] (Evaluation in terms of the mean squared errors (MSE))
%[text]  $\\mathrm{MSE}(\\{x\[n\]\\}\_n,\\{v\[n\]\\}\_n) \\colon =\\frac{1}{\\left|\\Omega\\right|}\\sum\_{n\\in\\Omega}\\left|x\[n\]-v\[n\]\\right|^2,$
%[text] ただし， $\\Omega$は添え字集合， $|\\Omega|$ は添え字の数．(where $\\Omega$ denotes the index set and $|\\Omega|$ means the cardinality.)
% Comparison between x and v
mymse = @(x,y) mean((double(x)-double(y)).^2,'all');
mymse(x,v)
%%
%[text] ### 2変量フィルタリングと畳み込み
%[text] (Bivariate filtering and convolution)
%[text] インパルス信号 (Impulse signal)
%[text]  $\\delta\[\\mathbf{n}\] = \\left\\{\\begin{array}{ll} 1 & \\mathbf{n}=\\mathbf{0} \\\\ 0 & \\mathrm{otherwise}\\end{array}\\right.$
% Bivariate impulse signal
D = 1
%[text] フィルタカーネル $\\{f\[\\mathbf{n}\]\\}\_{\\mathbf{n}}$の設定 (Setting of filter kernel $\\{f\[\\mathbf{n}\]\\}\_{\\mathbf{n}}$)
% Definition of filter kernel f[n]
f = reshape(1:9,[3 3])
%[text] 関数IMFILTERのインパルス応答はフィルタカーネル$\\{f\[\\mathbf{n}\]\\}\_{\\mathbf{n}}$の各軸反転となる．
%[text] (The impulse response of function IMFILTER is an inversion of each axis of the filter kernel $\\{f\[\\mathbf{n}\]\\}\_{\\mathbf{n}}$.)
%[text] 'full' オプションはクリッピングをせずに出力する．(The 'full' option outputs without clipping.)
% Impulse response of IMFILTER
imfilter(D,f,'full') 
%[text] フィルタカーネル$\\{f\[\\mathbf{n}\]\\}\_{\\mathbf{n}}$を各軸反転 (Flip the filter kernel $\\{f\[\\mathbf{n}\]\\}\_{\\mathbf{n}}$ on each axis.)
% Flipping filer kernel f[n]
h = rot90(f,2)
%[text] 関数IMFILTERの'conv'オプションは2番目の引数をインパルス応答$\\{h\[\\mathbf{n}\]\\}\_{\\mathbf{n}}$として畳み込みを行う．
%[text] (The 'conv' option of function IMFILTER performs convolution with the second argument as an impulse response.)
% IMFILTER with the options 'conv' and 'full'
imfilter(D,h,'conv','full')
%[text] オプション'full'のみの結果と同じことが確かめられる．(It can be verified that the result is the same as for the option 'full' only.)
%[text] 関数IMFILTERの'conv'と'full'オプションは関数CONV2と同等の機能をもつ．(The 'conv' and 'full' options of the function IMFILTER have the same functions as those of the function CONV2.)
conv2(D,h)
%%
%[text] ### **画像フィルタリングの例**
%[text] (Example of image filtering)
%[text] 
%[text] サンプル画像の読み込み (Reading a sample image)
% Reading image 'cameraman.tif' as double type.
I = im2double(imread('cameraman.tif'));
figure(2)
subplot(2,2,1)
imshow(I)
title('(a) Original')
%[text] 水平Prewittカーネルの生成
%[text] (Generate a horizontal Prewitt kernel)
% Generate the horizontal Prewitt kernel
f = fspecial('prewitt').'
%[text] オプションなしIMFILTER 実行
%[text] (IMFILTER without any option)
% IMFILTER w/o any option
J = imfilter(I,f);
subplot(2,2,2)
imshow(J+.5)
title('(b) Prewitt w/o any option ')
%[text] 'corr'オプション付きIMFILTER 実行
%[text] (IMFILTER without the option 'corr')
% IMFILTER w the option 'corr' (Correlation mode)
K = imfilter(I,f,'corr');
subplot(2,2,3)
imshow(K+.5)
title(sprintf('(c) Prewitt w "corr" (MSE w (b): %4.2f)',mymse(J,K)))
%[text] フィルタカーネル$\\{f\[\\mathbf{n}\]\\}\_{\\mathbf{n}}$を各軸反転 (Flip the filter kernel $\\{f\[\\mathbf{n}\]\\}\_{\\mathbf{n}}$ on each axis.)
% Flipping filer kernel f[n]
h = rot90(f,2)
%[text] 'conv'オプション付きIMFILTER 実行
%[text] (IMFILTER without the option 'conv')
% IMFILTER w the option 'conv' (Convolution mode)
L = imfilter(I,h,'conv');
subplot(2,2,4)
imshow(L+.5)
title(sprintf('(d) Prewitt w "conv" (MSE w (b): %4.2f)',mymse(J,L)))
%[text] (b),(c),(d)の結果はすべて同じ．(The results in (b), (c), and (d) are all the same.)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
