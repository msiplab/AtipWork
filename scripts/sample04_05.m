%[text] # Sample 4-5
%[text] ## 線形シフト不変システム
%[text] 畳み込み行列
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Linear shift-invariant systems
%[text] Convolution matrix
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ### 単変量畳み込み
%[text] (Univariate convolution)
%[text] 
%[text] 有限インパルス応答(FIR)$\\{h\[n\]\\in\\mathbb{R}\\}\_{n\\in{\\Omega\_\\mathrm{h}}\\subset\\mathbb{Z}}$を有する線形シフト不変システム $T(\\cdot)$を仮定する．(Let us assume a linear shift-invariant system $T(\\cdot)$ with a finite impulse response (FIR) $\\{h\[n\]\\in\\mathbb{R}\\}\_{n\\in{\\Omega\_\\mathrm{h}}\\subset\\mathbb{Z}}$.)
%[text]  $T(\\cdot)$ の配列 $\\{u\[n\]\\in\\mathbb{R}\\}\_{n\\in{\\Omega\_\\mathrm{u}}\\subset\\mathbb{Z}}$に対する応答 $\\{v\[n\]\\in\\mathbb{R}\\}\_{n\\in{\\Omega\_\\mathrm{v}}\\subset\\mathbb{Z}}$は畳み込み (The response  $\\{v\[n\]\\in\\mathbb{R}\\}\_{n\\in{\\Omega\_\\mathrm{v}}\\subset\\mathbb{Z}}$ to a sequence  $\\{u\[n\]\\in\\mathbb{R}\\}\_{n\\in{\\Omega\_\\mathrm{u}}\\subset\\mathbb{Z}}$ of  $T(\\cdot)$  can be represented by convolution )
%[text]  $\\{v\[n\]\\}\_n =T\\left(\\{u\[n\]\\}\_n\\right) = \\sum\_{k\\in\\Omega\_\\mathrm{h}}h\[k\]\\{u\\left\[n-k\\right\]\\}\_n.$
%[text] により表現できる．
%[text] 
%[text] #### 信号の生成
%[text] (Signal generation)
% Generating an input sequence u[n] of finite support region
Q = 6;  %[control:slider:8da8]{"position":[5,6]}
ugen = "(1:Q)"; %[control:dropdown:820b]{"position":[8,15]}
u = eval(ugen)
%[text] #### インパルス応答の設定
%[text] (Setting the impulse response)
% Setting the shift amount 
h = [1 0 -1];
%[text] #### 写像の定義
%[text] (Definition of a map)
% Definition of map T as a convolution with h[n]
mapT = @(x) conv(x,h);
%[text] #### 写像の結果
%[text] (Result of mapping)
% Mapping with the circular shift T(.)
v = mapT(u)
%%
%[text] ### 単変量畳み込みの行列表現
%[text] (Matrix representation of the univariate convolution)
%[text] 
%[text] FIRシステムの畳み込み演算は (The convolution of an FIR system can be represented as a matrix as)
%[text]  $\\mathbf{v}=\\mathbf{Tu},$
%[text] のように行列表現できる． 
%[text] インパルス応答 $\\{h\[n\]\\}\_n$ のサポート領域が $\\Omega\_\\mathrm{h}=\\{0,1,2\\}$，入力信号$\\{u\[n\]\\}\_n$のサポート領域が$\\Omega\_\\mathrm{u}=\\{0,1,2,3,4,5\\}$ のとき，出力信号$\\{v\[n\]\\}\_n$のサポート領域は$\\Omega\_\\mathrm{v}=\\{0,1,2,3,4,5,6,7\\}$となり，(When the support region of the impulse response  $\\{h\[n\]\\}\_n$ is $\\Omega\_\\mathrm{h}=\\{0,1,2\\}$ and the support region of the input signal $\\{u\[n\]\\}\_n$ is $\\Omega\_\\mathrm{u}=\\{0,1,2,3,4,5\\}$, the support region of the output signal $\\{v\[n\]\\}\_n$ is $\\Omega\_\\mathrm{v}=\\{0,1,2,3,4,5,6,7\\}$, and we have)
%[text] 
%[text]  $\\mathbf{v}=\\mathrm{vec}\\left(\\{v\[{n}\]\\}\_{n}\\right)=\\left(\\begin{array}{c}v\[0\]\\\\v\[1\]\\\\v\[2\]\\\\v\[3\]\\\\v\[4\]\\\\v\[5\]\\\\v\[6\]\\\\v\[7\]\\end{array}\\right), \\mathbf{u}=\\mathrm{vec}\\left(\\{u\[{n}\]\\}\_{n}\\right)=\\left(\\begin{array}{c}u\[0\]\\\\u\[1\]\\\\u\[2\]\\\\u\[3\]\\\\u\[4\]\\\\u\[5\]\\end{array}\\right)$
%[text]  $\\mathbf{T}\n=\\left(\\begin{array}{cccccc}\nh\[0\] & 0  & 0 & 0 & 0 & 0 \\\\\nh\[1\] & h\[0\]  & 0 & 0 & 0 & 0 \\\\\nh\[2\] & h\[1\]  & h\[0\] & 0 & 0 & 0 \\\\\n0 & h\[2\] & h\[1\]  & h\[0\] & 0 & 0 \\\\\n0 & 0 & h\[2\] & h\[1\]  & h\[0\] & 0 \\\\\n0 & 0 & 0 & h\[2\] & h\[1\]  & h\[0\]  \\\\\n0 & 0 & 0 & 0 & h\[2\]  & h\[1\]  \\\\\n0 & 0 & 0 & 0 & 0  & h\[2\] \n\\end{array}\\right).$
%[text] 
%[text] と表現できる．なお，出力のサポート領域が$\\Omega\_\\mathrm{v}=\\{(n+k)\\in\\mathbb{Z}|n\\in\\Omega\_\\mathrm{u},k\\in\\Omega\_\\mathrm{h}\\}$となり $\\mathbf{T}$ の行数が (Note that the support area of the output is $\\Omega\_\\mathrm{v}=\\{(n+k)\\in\\mathbb{Z}|n\\in\\Omega\_\\mathrm{u},k\\in\\Omega\_\\mathrm{h}\\}$ and the number of rows in $\\mathbf{T}$  is 
%[text]  $|\\Omega\_\\mathrm{v}|=|\\Omega\_\\mathrm{u}|+|\\Omega\_\\mathrm{h}|-1=6+3-1=8.$
%[text] となることに注意する．
%[text] 
%[text] #### 単変量畳み込みの行列生成
%[text] (Matrix generation of univariate convolution)
% Find the matrix representation of the univariate convolution
T = zeros(length(u)+length(h)-1,length(u));
for idx = 1:length(u)
    % Generating a standard basis vector
    e = zeros(size(u),'like',u);
    e(idx) = 1;
    % Response to the standard basis vector
    T(:,idx) = mapT(e); 
end
% Matrix representation of the univariate convolution
T
%[text] #### 関数CONVMTXの利用
%[text] (Using the CONVMTX function)
%[text] 
%[text] 単変量畳み込み行列の生成に関数CONVMTXも利用できる．
%[text] (The function CONVMTX can also be used to generate univariate convolutional matrices.)
% Generating the matrix representation of the univariate convolution by CONVMTX
H = convmtx(h(:),length(u)) %#ok
%%
%[text] ### 行列演算による単変量畳み込み
%[text] (Univariate convolution by matrix operation)
%[text] 畳み込みは可換図に沿って (Convolution can be computed as)
%[text]  $\\{v\[{n}\]\\}\_{n}=\\mathrm{vec}\_{\\Omega\_\\mathrm{v}}^{-1}\\left(\\mathbf{v}\\right)=\\mathrm{vec}\_{\\Omega\_\\mathrm{v}}^{-1}\\left(\\mathbf{Tu}\\right)=\\mathrm{vec}\_{\\Omega\_\\mathrm{v}}^{-1}\\circ\\mathbf{T}\\mathrm{vec}\_{\\Omega\_\\mathrm{u}}\\left(\\{u\[n\]\\}\_n\\right)$
%[text] のように行列演算が可能である．すなわち，(along the commutative diagram. That is, we have)
%[text]  $T=\\mathrm{vec}\_{\\Omega\_\\mathrm{v}}^{-1}\\circ\\mathbf{T}\\mathrm{vec}\_{\\Omega\_\\mathrm{u}}.$
%[text] と表現できる．
% Column vectorization of sequence u[n]
vecu = u(:);

% Matrix operation
vecv = T*vecu;

% Reshaping the result into the row sequnece
recv = reshape(vecv,[1 (length(u)+length(h)-1)])
%[text] #### 行列演算による単変量畳み込みの評価
%[text] (Evaluation of univariate convolution by matrix operation)
% Comparizon between mapping and matrix operation
mymse = @(x,y) mean((double(x)-double(y)).^2,'all');
mymse(v,recv)
%%
%[text] ### 2変量畳み込み
%[text] (Bivariate convolution)
%[text] 
%[text] 2変量の有限インパルス応答(FIR)$\\{h\[\\mathbf{n}\]\\in\\mathbb{R}\\}\_{\\mathbf{n}\\in{\\Omega\_\\mathrm{h}}\\subset\\mathbb{Z}^2}$を有する線形シフト不変システム $T(\\cdot)$を仮定する．(Assume a linear shift-invariant system T with a bivariate finite impulse response (FIR) $\\{h\[\\mathbf{n}\]\\in\\mathbb{R}\\}\_{\\mathbf{n}\\in{\\Omega\_\\mathrm{h}}\\subset\\mathbb{Z}^2}$.)  
%[text]  $T(\\cdot)$ の配列 $\\{u\[\\mathbf{n}\]\\in\\mathbb{R}\\}\_{\\mathbf{n}\\in{\\Omega\_\\mathrm{u}}\\subset\\mathbb{Z}^2}$に対する応答 $\\{v\[\\mathbf{n}\]\\in\\mathbb{R}\\}\_{\\mathbf{n}\\in{\\Omega\_\\mathrm{u}}\\subset\\mathbb{Z}^2}$は畳み込み (The response $\\{v\[\\mathbf{n}\]\\in\\mathbb{R}\\}\_{\\mathbf{n}\\in{\\Omega\_\\mathrm{u}}\\subset\\mathbb{Z}^2}$ to the array $\\{u\[\\mathbf{n}\]\\in\\mathbb{R}\\}\_{\\mathbf{n}\\in{\\Omega\_\\mathrm{u}}\\subset\\mathbb{Z}^2}$ of $T(\\cdot)$  can be represented by convolution )
%[text]  $\\{v\[\\mathbf{n}\n\]\\}\_\\mathbf{n} =T\\left(\\{u\[\\mathbf{n}\]\\}\_\\mathbf{n}\\right) = \\sum\_{k\\in\\Omega\_\\mathrm{h}}h\[\\mathbf{k}\]\\{u\\left\[\\mathbf{n}-\\mathbf{k}\\right\]\\}\_\\mathbf{n}.$
%[text] により表現できる．
%[text] 
%[text] #### 信号の生成
%[text] (Signal generation)
% Generating an input array u[n1,n2] of finite support region
N1 = 2; % # of rows %[control:slider:4040]{"position":[6,7]}
N2 = 3; % # of columns %[control:slider:78e5]{"position":[6,7]}
ugen = "reshape((0:N1*N2-1),[N1 N2])"; %[control:dropdown:0ebe]{"position":[8,38]}
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
% Definition of map T as a convolution with h[n]
mapT = @(x) imfilter(x,h,'conv','full'); % or conv2(x,h);
%[text] #### 写像の結果
%[text] (Result of mapping)
% Mapping with the circular shift T(.)
v = mapT(u)
%%
%[text] ### 2変量畳み込みの行列表現
%[text] (Matrix representation of the bivariate convolution)
%[text] 
%[text] 2変量FIRシステムの畳み込み演算は (The convolution of a bivariate FIR system can be represented as a matrix as)
%[text]  $\\mathbf{v}=\\mathbf{Tu},$
%[text] のように行列表現できる． 
%[text] インパルス応答 $\\{h\[\\mathbf{n}\]\\}\_\\mathbf{n}$ のサポート領域が $\\Omega\_\\mathrm{h}=\\{0,1\\}\\times \\{0,1\\}$，入力信号$\\{u\[\\mathbf{n}\]\\}\_\\mathbf{n}$のサポート領域が$\\Omega\_\\mathrm{u}=\\{0,1\\}\\times \\{0,1,2\\}$ のとき，出力信号$\\{v\[\\mathbf{n}\]\\}\_\\mathbf{n}$のサポート領域は$\\Omega\_\\mathrm{v}=\\{0,1,2\\}\\times\\{0,1,2,3\\}$となり，(If the support region  of the impulse response $\\{h\[\\mathbf{n}\]\\}\_\\mathbf{n}$  is  $\\Omega\_\\mathrm{h}=\\{0,1\\}\\times \\{0,1\\}$, and the support region of the input signal $\\{u\[\\mathbf{n}\]\\}\_\\mathbf{n}$ is $\\Omega\_\\mathrm{u}=\\{0,1\\}\\times \\{0,1,2\\}$, then the support region of the output signal $\\{v\[\\mathbf{n}\]\\}\_\\mathbf{n}$ is $\\Omega\_\\mathrm{v}=\\{0,1,2\\}\\times\\{0,1,2,3\\}$ and can be expressed as )
%[text]  $\\mathbf{v}=\\mathrm{vec}\\left(\\{v\[\\mathbf{n}\]\\}\_\\mathbf{n}\\right)=\\left(\\begin{array}{c}\nv\[0,0\]\\\\v\[1,0\]\\\\v\[2,0\]\\\\v\[0,1\]\\\\\\vdots\\\\v\[2,3\]\\end{array}\\right), \\mathbf{u}=\\mathrm{vec}\\left(\\{u\[\\mathbf{n}\]\\}\_\\mathbf{n}\\right)=\\left(\\begin{array}{c}u\[0,0\]\\\\u\[1,0\]\\\\u\[0,1\]\\\\u\[1,1\]\\\\\\vdots\\\\u\[1,2\]\\end{array}\\right)$
%[text]  $\\mathbf{T}\n=\\left(\\begin{array}{cccccc}\nh\[0,0\] &  0 & 0 & 0 & \\cdots & 0 \\\\\nh\[1,0\]  & h\[0,0\]  & 0 & 0 & \\cdots & 0 \\\\\n0 & h\[1,0\]  & h\[0,0\] & 0 & \\cdots & 0 \\\\\nh\[1,0\]  & 0 & h\[1,0\]  & h\[0,0\] & \\cdots & 0 \\\\\nh\[1,1\]  & h\[1,0\] & 0 & h\[1,0\]  & \\cdots & 0 \\\\\n0 & h\[1,1\] & h\[1,0\] & 0 & \\cdots & 0  \\\\\n\\vdots & \\vdots & \\vdots & \\vdots & \\ddots  & \\vdots  \\\\\n0 & 0 & 0 & 0 & \\cdots  & h\[1,1\] \n\\end{array}\\right).$
%[text] 
%[text] と表現できる．なお，出力のサポート領域が$\\Omega\_\\mathrm{v}=\\{(n+k)\\in\\mathbb{Z}|n\\in\\Omega\_\\mathrm{u},k\\in\\Omega\_\\mathrm{h}\\}$となり $\\mathbf{T}$ の行数が (Note that the support region of the output is $\\Omega\_\\mathrm{v}=\\{(n+k)\\in\\mathbb{Z}|n\\in\\Omega\_\\mathrm{u},k\\in\\Omega\_\\mathrm{h}\\}$ and the number of rows in $\\mathbf{T}$is )
%[text]  $|\\Omega\_\\mathrm{v}|=(2+2-1)\\times(3+2-1)=2\\times 4=12.$
%[text] となることに注意する．
%[text] 
%[text] #### 2変量畳み込みの行列生成
%[text] (Matrix generation of bivariate matrix)
% Find the matrix representation of the convolution
T = zeros(prod(size(u)+size(h)-1),numel(u));
for idx = 1:numel(u)
    % Generating a standard basis vector
    e = zeros(size(u),'like',u);
    e(idx) = 1;
    % Response to the standard basis vector
    T(:,idx) = reshape(mapT(e),[size(T,1) 1]); 
end
% Matrix representation of the convolution
T
%[text] #### 関数CONVMTX2の利用
%[text] (Using the CONVMTX2 function)
%[text] 
%[text] 2変量畳み込み行列の生成に関数CONVMTX2も利用できる．
%[text] (The function CONVMTX2 can also be used to generate bivariate convolutional matrices.)
% Generating the matrix representation of the bivariate convolution by CONVMTX2
H = convmtx2(h,size(u)) %#ok
%%
%[text] ### 行列演算による2変量畳み込み
%[text] (Bivariate convolution by matrix operation)
%[text] 畳み込みは可換図に沿って (Convolution can be computed as)
%[text]  $\\{v\[{n}\]\\}\_{n}=\\mathrm{vec}\_{\\Omega\_\\mathrm{v}}^{-1}\\left(\\mathbf{v}\\right)=\\mathrm{vec}\_{\\Omega\_\\mathrm{v}}^{-1}\\left(\\mathbf{Tu}\\right)=\\mathrm{vec}\_{\\Omega\_\\mathrm{v}}^{-1}\\circ\\mathbf{T}\\mathrm{vec}\_{\\Omega\_\\mathrm{u}}\\left(\\{u\[n\]\\}\_n\\right)$
%[text] のように行列演算が可能である．すなわち，(along the commutative diagram. That is, we have)
%[text]  $T=\\mathrm{vec}\_{\\Omega\_\\mathrm{v}}^{-1}\\circ\\mathbf{T}\\mathrm{vec}\_{\\Omega\_\\mathrm{u}}.$
%[text] と表現できる．
% Column vectorization of sequence u[n]
vecu = u(:);

% Matrix operation
vecv = T*vecu;

% Reshaping the result into the row sequnece
recv = reshape(vecv,(size(u)+size(h)-1))
%[text] #### 行列演算による単変量畳み込みの評価
%[text] (Evaluation of univariate convolution by matrix operation)
% Comparizon between mapping and matrix operation
mymse(v,recv)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:8da8]
%   data: {"defaultValue":6,"label":"Q","max":16,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:dropdown:820b]
%   data: {"defaultValue":"\"(1:Q)\"","itemLabels":["(1:Q)","randn(1,Q)"],"items":["\"(1:Q)\"","\"randn(1,Q)\""],"label":"ドロップ ダウン","run":"SectionToEnd"}
%---
%[control:slider:4040]
%   data: {"defaultValue":2,"label":"Q1","max":6,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:78e5]
%   data: {"defaultValue":3,"label":"Q2","max":6,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:dropdown:0ebe]
%   data: {"defaultValue":"\"reshape((0:N1*N2-1),[N1 N2])\"","itemLabels":["reshape((0:N1*N2-1),[N1 N2])","randn(N1,N2)"],"items":["\"reshape((0:N1*N2-1),[N1 N2])\"","\"randn(N1,N2)\""],"label":"ugen","run":"SectionToEnd"}
%---
