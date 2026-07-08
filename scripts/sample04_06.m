%[text] # Sample 4-6
%[text] ## 線形シフト不変システム
%[text] 循環畳み込み行列
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Linear shift-invariant systems
%[text] Circular convolution matrix
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ### 単変量循環畳み込み
%[text] (Univariate circular convolution)
%[text] 
%[text] 有限インパルス応答(FIR)$\\{h\[n\]\\in\\mathbb{R}\\}\_{n\\in{\\Omega\_\\mathrm{h}}\\subset\\mathbb{Z}}$を有する線形シフト不変システム $T(\\cdot)$を仮定する． (Let us assume a linear shift-invariant system $T(\\cdot)$ with a finite impulse response (FIR) $\\{h\[n\]\\in\\mathbb{R}\\}\_{n\\in{\\Omega\_\\mathrm{h}}\\subset\\mathbb{Z}}$.)
%[text] 配列 $\\{u\[n\]\\in\\mathbb{R}\\}\_{n\\in{\\Omega\_\\mathrm{u}}\\subset\\mathbb{Z}}$に対する周期拡張後の$T(\\cdot)$ の応答 $\\{v\[n\]\\in\\mathbb{R}\\}\_{n\\in{\\Omega\_\\mathrm{v}}\\subset\\mathbb{Z}}$は周期 $Q\\in\\mathbb{N}$ を法とする単変量循環畳み込み (The response $\\{v\[n\]\\in\\mathbb{R}\\}\_{n\\in{\\Omega\_\\mathrm{v}}\\subset\\mathbb{Z}}$ of  $T(\\cdot)$  to a sequence $\\{u\[n\]\\in\\mathbb{R}\\}\_{n\\in{\\Omega\_\\mathrm{u}}\\subset\\mathbb{Z}}$ after periodic extension can be represented by univariate circular convolution with period $Q$ as ) 
%[text]  $\\{v\[n\]\\}\_n =T\\left(\\{u\[n\]\\}\_n\\right) = \\sum\_{k\\in\\Omega\_\\mathrm{h\n}}h\[k\]\\{u\\left\[(\\!(n-k)\\!)\_Q\\right\]\\}\_n.$
%[text] により表現できる．ただし，(where) 
%[text]  $(\\!(n)\\!)\_Q = n - Q\\left\\lfloor Q^{-1}n\\right\\rfloor.$
%[text] は， ${Q}$を法とする ${n}$ の剰余である．( denotes the ${n}$ modulo ${Q}$.) 
%[text] 
%[text] #### 信号の生成
%[text] (Signal generation)
% Generating an input sequence u[n] of finite support region
Q = 6;  %[control:slider:78f0]{"position":[5,6]}
ugen = "(1:Q)"; %[control:dropdown:46ae]{"position":[8,15]}
u = eval(ugen)
%[text] #### インパルス応答の設定
%[text] (Setting the impulse response)
% Setting the shift amount 
h = [1 0 -1];
%[text] #### 写像の定義
%[text] (Definition of a map)
% Definition of map T as a modulo-Q circular convolution with h[n]
mapT = @(x) cconv(x,h,Q);
%[text] #### 写像の結果
%[text] (Result of mapping)
% Mapping with the circular convolution T(.)
v = mapT(u)
%%
%[text] ### 単変量循環畳み込みの行列表現
%[text] (Matrix representation of the univariate circular convolution)
%[text] 
%[text] 単変量循環畳み込み演算も (The univariate circular convolution can also be represented as a matrix as)
%[text]  $\\mathbf{v}=\\mathbf{Tu},$
%[text] のように行列表現できる． 
%[text] インパルス応答 $\\{h\[n\]\\}\_n$ のサポート領域 $\\Omega\_\\mathrm{h}=\\{0,1,2\\}$が，入力信号$\\{u\[n\]\\}\_n$のサポート領域$\\Omega\_\\mathrm{u}=\\{0,1,2,3,4,5\\}$ よりも短く周期 $Q=|\\Omega\_\\mathrm{u}|$ と設定されているとき，出力信号$\\{v\[n\]\\}\_n$のサポート領域も$\\Omega\_\\mathrm{v}=\\Omega\_\\mathrm{u}$となり，(If the support region $\\Omega\_\\mathrm{h}=\\{0,1,2\\}$ of the impulse response $\\{h\[n\]\\}\_n$ is shorter than the support region $\\Omega\_\\mathrm{u}=\\{0,1,2,3,4,5\\}$ of the input signal $\\{u\[n\]\\}\_n$ and  the period is set as $Q=|\\Omega\_\\mathrm{u}|$, then the support region of the output signal $\\{v\[n\]\\}\_n$ becomes also $\\Omega\_\\mathrm{v}=\\Omega\_\\mathrm{u}$, and we have )
%[text] 
%[text]  $\\mathbf{v}=\\mathrm{vec}\\left(\\{v\[{n}\]\\}\_{n}\\right)=\\left(\\begin{array}{c}v\[0\]\\\\v\[1\]\\\\v\[2\]\\\\v\[3\]\\\\v\[4\]\\\\v\[5\]\\end{array}\\right), \\mathbf{u}=\\mathrm{vec}\\left(\\{u\[{n}\]\\}\_{n}\\right)=\\left(\\begin{array}{c}u\[0\]\\\\u\[1\]\\\\u\[2\]\\\\u\[3\]\\\\u\[4\]\\\\u\[5\]\\end{array}\\right)$
%[text]  $\\mathbf{T}\n=\\left(\\begin{array}{cccccc}\nh\[0\] & 0  & 0 & 0 & h\[2\] & h\[1\] \\\\\nh\[1\] & h\[0\]  & 0 & 0 & 0 & h\[2\] \\\\\nh\[2\] & h\[1\]  & h\[0\] & 0 & 0 & 0 \\\\\n0 & h\[2\] & h\[1\]  & h\[0\] & 0 & 0 \\\\\n0 & 0 & h\[2\] & h\[1\]  & h\[0\] & 0 \\\\\n0 & 0 & 0 & h\[2\] & h\[1\]  & h\[0\]  \n\\end{array}\\right).$
%[text] 
%[text] と表現できる．
%[text] 
%[text] #### 単変量循環畳み込みの行列生成
%[text] (Matrix generation of univariate circular convolution)
% Find the matrix representation of the univariate circular convolution
T = zeros(length(u));
for idx = 1:length(u)
    % Generating a standard basis vector
    e = zeros(size(u),'like',u);
    e(idx) = 1;
    % Response to the standard basis vector
    T(:,idx) = mapT(e); 
end
% Matrix representation of the univariate circular convolution
T
%%
%[text] ### 行列演算による単変量循環畳み込み
%[text] (Univariate circular convolution by matrix operation)
%[text] 循環畳み込みも可換図に沿って (Circular convolution can also be computed as)
%[text]  $\\{v\[{n}\]\\}\_{n}=\\mathrm{vec}\_{\\Omega\_\\mathrm{v}}^{-1}\\left(\\mathbf{v}\\right)=\\mathrm{vec}\_{\\Omega\_\\mathrm{v}}^{-1}\\left(\\mathbf{Tu}\\right)=\\mathrm{vec}\_{\\Omega\_\\mathrm{v}}^{-1}\\circ\\mathbf{T}\\mathrm{vec}\_{\\Omega\_\\mathrm{u}}\\left(\\{u\[n\]\\}\_n\\right)$
%[text] のように行列演算が可能である．すなわち，(along the commutative diagram. That is, we have)
%[text]  $T=\\mathrm{vec}\_{\\Omega\_\\mathrm{v}}^{-1}\\circ\\mathbf{T}\\mathrm{vec}\_{\\Omega\_\\mathrm{u}}.$
%[text] と表現できる．
% Column vectorization of sequence u[n]
vecu = u(:);

% Matrix operation
vecv = T*vecu;

% Reshaping the result into the row sequnece
recv = reshape(vecv,[1 Q])
%[text] #### 行列演算による単変量循環畳み込みの評価
%[text] (Evaluation of univariate circular convolution by matrix operation)
% Comparizon between mapping and matrix operation
mymse = @(x,y) mean((double(x)-double(y)).^2,'all');
mymse(v,recv)
%%
%[text] ### 2変量循環畳み込み
%[text] (Bivariate circular convolution)
%[text] 
%[text] 有限インパルス応答(FIR)インパルス応答 $\\{h\[\\mathbf{n}\]\\}\_\\mathbf{n}$ を有する線形シフト不変システム $T(\\cdot)$を仮定する．(Assume a linear shift-invariant system T with a bivariate finite impulse response (FIR) $\\{h\[\\mathbf{n}\]\\in\\mathbb{R}\\}\_{\\mathbf{n}\\in{\\Omega\_\\mathrm{h}}\\subset\\mathbb{Z}^2}$.)  
%[text]  配列$\\{u\[\\mathbf{n}\]\\}\_\\mathbf{n}$に対する周期拡張後の$T(\\cdot)$ の応答$\\{v\[\\mathbf{n}\]\\}\_\\mathbf{n}$は周期 $\\mathbf{Q}\\in\\mathbb{Z}^{2\\times 2} $($\\det\\mathbf{Q}\\neq 0$) を法とする2変量循環畳み込み
%[text]  $\\{v\[\\mathbf{n}\]\\}\_\\mathbf{n} =T\\left(\\{u\[\\mathbf{n}\]\\}\_\\mathbf{n}\\right) = \\sum\_{\\mathbf{k}\\in\\Omega\_\\mathrm{h}}h\[\\mathbf{k}\]\\{u\\left\[(\\!(\\mathbf{n}-\\mathbf{k})\\!)\_\\mathbf{Q}\\right\]\\}\_\\mathbf{n},$
%[text] により表現できる．(The response $\\{v\[\\mathbf{n}\]\\}\_\\mathbf{n}$ of $T(\\cdot)$ after periodic extension to array $\\{u\[\\mathbf{n}\]\\}\_\\mathbf{n}$ can be represented by bivariate circular convolution with period $\\mathbf{Q}$,) ただし，$\\mathbf{Q}\\in\\mathbb{Z}^{2\\times2}(\\det\\mathbf{Q}\\neq 0)$は周期行列,  $\\{v\[\\mathbf{n}\]\\in\\mathbb{K}\\}\_{\\mathbf{n}\\in\\Omega\\subset\\mathbb{Z}^2}$は出力配列，(where  $\\mathbf{Q}\\in\\mathbb{Z}^{2\\times2}(\\det\\mathbf{Q}\\neq 0)$ is the period matrix,  $\\{v\[\\mathbf{n}\]\\in\\mathbb{K}\\}\_{\\mathbf{n}\\in\\Omega\\subset\\mathbb{Z}^2}$ is the destination array and)
%[text]  $(\\!(\\mathbf{n})\\!)\_\\mathbf{Q} = \\mathbf{n} - \\mathbf{Q}\\left\\lfloor \\mathbf{Q}^{-1}\\mathbf{n}\\right\\rfloor$
%[text] は， $\\mathbf{Q}$を法とする $\\mathbf{n}$ の剰余である．( denotes the $\\mathbf{n}$ modulo $\\mathbf{Q}$.) 
%[text] 
%[text] #### 信号の生成
%[text] (Signal generation)
% Generating an input array u[n1,n2] of finite support region
N1 = 2; % # of rows %[control:slider:7acd]{"position":[6,7]}
N2 = 3; % # of columns %[control:slider:7659]{"position":[6,7]}
ugen = "reshape((0:N1*N2-1),[N1 N2])"; %[control:dropdown:0542]{"position":[8,38]}
u = eval(ugen)
%[text] #### インパルス応答の設定
%[text] (Setting the impulse response)
h = [1 -1 ; 1 -1]
figure(1)
stem3(h,'filled')
axis ij
title('Impulse response')
%[text] #### 写像の定義
%[text] (Definition of a map)
% Definition of map T as a circular convolution with h[n]
mapT = @(x) imfilter(x,h,'conv','circ');
%[text] #### 写像の結果
%[text] (Result of mapping)
% Mapping with the circular shift T(.)
v = mapT(u)
%%
%[text] ### 2変量循環畳み込みの行列表現
%[text] (Matrix representation of the bivariate circular convolution)
%[text] 
%[text] 2変量循環畳み込み演算も (The bivariate circular convolution can also be represented as a matrix as)
%[text]  $\\mathbf{v}=\\mathbf{Tu},$
%[text] のように行列表現できる． 
%[text] インパルス応答 $\\{h\[\\mathbf{n}\]\\}\_\\mathbf{n}$ のサポート領域 $\\Omega\_\\mathrm{h}=\\{0,1\\}\\times \\{0,1\\}$が，入力信号$\\{u\[\\mathbf{n}\]\\}\_\\mathbf{n}$のサポート領域$\\Omega\_\\mathrm{u}=\\{0,1\\}\\times \\{0,1,2\\}$ よりも狭く周期行列が $\\mathbf{Q}=\\left(\\begin{array}{cc}N\_1 & 0 \\\\ 0 & N\_2\\end{array}\\right)=\\left(\\begin{array}{cc}2 & 0 \\\\ 0 & 3\\end{array}\\right)$ と設定されているとき，出力信号$\\{v\[\\mathbf{n}\]\\}\_\\mathbf{n}$のサポート領域も$\\Omega\_\\mathrm{v}=\\Omega\_\\mathrm{u}$となり，(If the support region $\\Omega\_\\mathrm{h}=\\{0,1\\}\\times \\{0,1\\}$ of the impulse response $\\{h\[\\mathbf{n}\]\\}\_\\mathbf{n}$ is narrower than the support region $\\Omega\_\\mathrm{u}=\\{0,1\\}\\times \\{0,1,2\\}$ of the input signal $\\{u\[\\mathbf{n}\]\\}\_\\mathbf{n}$ and  the period is set as $\\mathbf{Q}=\\left(\\begin{array}{cc}N\_1 & 0 \\\\ 0 & N\_2\\end{array}\\right)=\\left(\\begin{array}{cc}2 & 0 \\\\ 0 & 3\\end{array}\\right)$, then the support region of the output signal $\\{v\[\\mathbf{n}\]\\}\_\\mathbf{n}$ becomes also $\\Omega\_\\mathrm{v}=\\Omega\_\\mathrm{u}$, and we have )
%[text]  $\\mathbf{v}=\\mathrm{vec}\\left(\\{v\[\\mathbf{n}\]\\}\_\\mathbf{n}\\right)=\\left(\\begin{array}{c}\nv\[0,0\]\\\\v\[1,0\]\\\\v\[0,1\]\\\\v\[1,1\]\\\\\\vdots\\\\v\[1,2\]\\end{array}\\right), \\mathbf{u}=\\mathrm{vec}\\left(\\{u\[\\mathbf{n}\]\\}\_\\mathbf{n}\\right)=\\left(\\begin{array}{c}u\[0,0\]\\\\u\[1,0\]\\\\u\[0,1\]\\\\u\[1,1\]\\\\\\vdots\\\\u\[1,2\]\\end{array}\\right)$
%[text]  $\\mathbf{T}\n=\\left(\\begin{array}{cccccc}\nh\[1,1\] & h\[0,1\]  & h\[1,0\] & h\[0,0\] & 0 & 0 \\\\\nh\[0,1\] & h\[1,1\]  & h\[0,0\] & h\[1,0\] & 0 & 0 \\\\\n0 & 0 &h\[1,1\] & h\[0,1\]  & h\[1,0\] & h\[0,0\]  \\\\\n0 & 0 &h\[0,1\] & h\[1,1\]  & h\[0,0\] & h\[1,0\]  \\\\\nh\[1,0\] & h\[0,0\] & 0 & 0 &h\[1,1\] & h\[0,1\]  \\\\\nh\[0,0\] & h\[1,0\] & 0 & 0 &h\[0,1\] & h\[1,1\]  \n\\end{array}\\right).$
%[text] 
%[text] と表現できる．
%[text] 
%[text] #### 2変量循環畳み込みの行列生成
%[text] (Bivariate circular convolution matrix generation)
% Find the matrix representation of the circular convolution
T = zeros(numel(u));
for idx = 1:numel(u)
    % Generating a standard basis vector
    e = zeros(size(u),'like',u);
    e(idx) = 1;
    % Response to the standard basis vector
    T(:,idx) = reshape(mapT(e),[size(T,1) 1]); 
end
% Matrix representation of the convolution
T
%%
%[text] ### 行列演算による2変量循環畳み込み
%[text] (Bivariate circular convolution by matrix operation)
%[text] 2変量循環畳み込みも可換図に沿って (Bivariate circular convolution can also be computed as)
%[text]  $\\{v\[\\mathbf{n}\]\\}\_\\mathbf{n}=\\mathrm{vec}\_{\\Omega\_\\mathrm{v}}^{-1}\\left(\\mathbf{v}\\right)=\\mathrm{vec}\_{\\Omega\_\\mathrm{v}}^{-1}\\left(\\mathbf{Tu}\\right)=\\mathrm{vec}\_{\\Omega\_\\mathrm{v}}^{-1}\\circ\\mathbf{T}\\mathrm{vec}\_{\\Omega\_\\mathrm{u}}\\left(\\{u\[\\mathbf{n}\]\\}\_\\mathbf{n}\\right)$
%[text] のように行列演算が可能である．すなわち，(along the commutative diagram. That is, we have)
%[text]  $T=\\mathrm{vec}\_{\\Omega\_\\mathrm{v}}^{-1}\\circ\\mathbf{T}\\mathrm{vec}\_{\\Omega\_\\mathrm{u}}.$
%[text] と表現できる．
% Column vectorization of sequence u[n]
vecu = u(:);

% Matrix operation
vecv = T*vecu;

% Reshaping the result into the row sequnece
recv = reshape(vecv,[N1 N2])
%[text] #### 行列演算による2変量循環畳み込みの評価
%[text] (Evaluation of bivariate circular convolution by matrix operation)
% Comparizon between mapping and matrix operation
mymse(v,recv)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:78f0]
%   data: {"defaultValue":6,"label":"Q","max":16,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:dropdown:46ae]
%   data: {"defaultValue":"\"(1:Q)\"","itemLabels":["(1:Q)","randn(1,Q)"],"items":["\"(1:Q)\"","\"randn(1,Q)\""],"label":"ドロップ ダウン","run":"SectionToEnd"}
%---
%[control:slider:7acd]
%   data: {"defaultValue":2,"label":"Q1","max":6,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:7659]
%   data: {"defaultValue":3,"label":"Q2","max":6,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:dropdown:0542]
%   data: {"defaultValue":"\"reshape((0:N1*N2-1),[N1 N2])\"","itemLabels":["reshape((0:N1*N2-1),[N1 N2])","randn(N1,N2)"],"items":["\"reshape((0:N1*N2-1),[N1 N2])\"","\"randn(N1,N2)\""],"label":"ugen","run":"SectionToEnd"}
%---
