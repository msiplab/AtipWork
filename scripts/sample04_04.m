%[text] # Sample 4-4
%[text] ## 線形シフト不変システム
%[text] 循環シフト
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Linear shift-invariant systems
%[text] Circular shift
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ### 単変量循環シフト
%[text] (Univariate circular shift)
%[text] 
%[text] 単変量の有限なサポート領域をもつ配列 $\\{u\[n\]\\in\\mathbb{K}\\}\_{n\\in{\\Omega\_\\mathrm{u}}\\subset\\mathbb{Z}}$の循環シフトは， (The circular shift of sequences with univariate finite support region can be represented as )
%[text]  $\\{v\[n\]\\}\_n =T\\left(\\{u\[n\]\\}\_n\\right) = \\{u\\left\[ (\\!(n-k)\\!)\_Q\\right\]\\}\_n,$
%[text] のように表現できる．ここで ， $Q\\in\\mathbb{N}$は周期, $\\{v\[n\]\\in\\mathbb{K}\\}\_{n\\in\\Omega\\subset\\mathbb{Z}}$は出力配列，(where  $Q\\in\\mathbb{N}$ is the period, $\\{v\[n\]\\in\\mathbb{K}\\}\_{n\\in\\Omega\\subset\\mathbb{Z}}$ is the destination sequence and)
%[text]  $(\\!(n)\\!)\_Q = n - Q\\left\\lfloor Q^{-1}n\\right\\rfloor.$
%[text] は， ${Q}$を法とする ${n}$ の剰余である．( denotes the ${n}$ modulo ${Q}$.) 
%[text] 
%[text] 【Example】(In case of ) $Q=6$, $k=1$ の場合：
%[text]  $\\left(\\begin{array}{cccccc}v\[0\] & v\[1\] &v\[2\]&v\[3\]&v\[4\]&v\[5\]\\end{array}\\right)\\\\=T\\left(\\begin{array}{cccccc}u\[0\]&u\[1\]&u\[2\]&u\[3\]&u\[4\]&u\[5\]\\end{array}\\right)\n=\\left(\\begin{array}{cccccc}u\[5\] & u\[0\] & u\[1\] & u\[2\] & u\[3\] & u\[4\]\\end{array}\\right)$
%[text] 
%[text] #### 信号の生成
%[text] (Signal generation)
% Generating an input sequence u[n] of finite support region
Q = 6; %[control:slider:3ddc]{"position":[5,6]}
ugen = "(0:Q-1)"; %[control:dropdown:0588]{"position":[8,17]}
u = eval(ugen)
%[text] #### シフト量の設定
%[text] (Setting the shift amount)
% Setting the shift amount 
k = 1; %[control:slider:7809]{"position":[5,6]}
%[text] #### 写像の定義
%[text] (Definition of a map)
% Definition of map T as a circular shift
mapT = @(x) circshift(x,k);
%[text] #### 写像
%[text] (Mapping)
% Mapping with the circular shift T(.)
v = mapT(u)
%%
%[text] ### 循環シフトの行列表現
%[text] (Matrix representation of the circular shift)
%[text] 
%[text] $Q=6$, $k=1$ の循環シフトは (The circular shift of $Q=6$, $k=1$ can be represented as a matrix as)
%[text]  $\\mathbf{v}=\\mathbf{Tu},$
%[text] のように行列表現できる．ただし，(where)
%[text] 
%[text]  $\\mathbf{v}=\\mathrm{vec}\\left(\\{v\[{n}\]\\}\_{n}\\right)=\\left(\\begin{array}{c}v\[0\]\\\\v\[1\]\\\\v\[2\]\\\\v\[3\]\\\\v\[4\]\\\\v\[5\]\\end{array}\\right), \\mathbf{u}=\\mathrm{vec}\\left(\\{u\[{n}\]\\}\_{n}\\right)=\\left(\\begin{array}{c}u\[0\]\\\\u\[1\]\\\\u\[2\]\\\\u\[3\]\\\\u\[4\]\\\\u\[5\]\\end{array}\\right),$
%[text]  $\\mathbf{T}\n=\\left(\\begin{array}{cccccc}\n0 & 0  & 0 & 0 & 0 & 1 \\\\\n1 & 0  & 0 & 0 & 0 & 0 \\\\\n0 & 1  & 0 & 0 & 0 & 0 \\\\\n0 & 0  & 1 & 0 & 0 & 0 \\\\\n0 & 0  & 0 & 1 & 0 & 0 \\\\\n0 & 0  & 0 & 0 & 1 & 0 \\\\\n0 & 0  & 0 & 0 & 0 & 1 \n\\end{array}\\right).$
%[text] 
%[text] #### 循環シフトの行列生成
%[text] (Circular shift matrix generation)
% Find the matrix representation of the circular shift
T = zeros(length(u));
for idx = 1:length(u)
    % Generating a standard basis vector
    e = zeros(size(u),'like',u);
    e(idx) = 1;
    % Response to the standard basis vector
    T(:,idx) = mapT(e); 
end
% Matrix representation of the circular shift
T
%%
%[text] ### 行列演算による単変量循環シフト
%[text] (Univariate circular shift by matrix operation)
%[text] 循環シフトは可換図に沿って (Circular shifts can be computed as)
%[text]  $\\{v\[{n}\]\\}\_{n}=\\mathrm{vec}\_{\\Omega\_\\mathrm{v}}^{-1}\\left(\\mathbf{v}\\right)=\\mathrm{vec}\_{\\Omega\_\\mathrm{v}}^{-1}\\left(\\mathbf{Tu}\\right)=\\mathrm{vec}\_{\\Omega\_\\mathrm{v}}^{-1}\\circ\\mathbf{T}\\mathrm{vec}\_{\\Omega\_\\mathrm{u}}\\left(\\{u\[n\]\\}\_n\\right)$
%[text] のように行列演算が可能である．すなわち，(along the commutative diagram. That is, we have)
%[text]  $T=\\mathrm{vec}\_{\\Omega\_\\mathrm{v}}^{-1}\\circ\\mathbf{T}\\mathrm{vec}\_{\\Omega\_\\mathrm{u}}.$
%[text] と表現できる．
% Column vectorization of sequence u[n]
vecu = u(:);

% Matrix operation
vecv = T*vecu;

% Reshaping the result into the original
recv = reshape(vecv,[1 Q])
%[text] #### 行列演算による単変量循環シフトの評価
%[text] (Evaluation of univariate circular shift by matrix operation)
% Comparizon between mapping and matrix operation
mymse = @(x,y) mean((double(x)-double(y)).^2,'all');
mymse(v,recv)
%%
%[text] ### 2変量循環シフト
%[text] (Bivariate circular shift)
%[text] 
%[text] 2変量の有限なサポート領域をもつ配列 $\\{u\[\\mathbf{n}\]\\in\\mathbb{K}\\}\_{\\mathbf{n}\\in{\\Omega\_\\mathrm{u}}\\subset\\mathbb{Z}^{2}}$の循環シフトは， (The circular shift of arrays with bivariate finite support region can be represented as )
%[text]  $\\{v\[\\mathbf{n}\]\\}\_\\mathbf{n} =T\\left(\\{u\[\\mathbf{n}\]\\}\_\\mathbf{n}\\right) = \\{u\\left\[ (\\!(\\mathbf{n}-\\mathbf{k})\\!)\_\\mathbf{Q}\\right\]\\}\_\\mathbf{n},$
%[text] のように表現できる．ただし，$\\mathbf{Q}\\in\\mathbb{Z}^{2\\times2}(\\det\\mathbf{Q}\\neq 0)$は周期行列,  $\\{v\[\\mathbf{n}\]\\in\\mathbb{K}\\}\_{\\mathbf{n}\\in\\Omega\\subset\\mathbb{Z}^2}$は出力配列，(where  $\\mathbf{Q}\\in\\mathbb{Z}^{2\\times2}(\\det\\mathbf{Q}\\neq 0)$ is the period matrix,  $\\{v\[\\mathbf{n}\]\\in\\mathbb{K}\\}\_{\\mathbf{n}\\in\\Omega\\subset\\mathbb{Z}^2}$ is the destination array and)
%[text]  $(\\!(\\mathbf{n})\\!)\_\\mathbf{Q} = \\mathbf{n} - \\mathbf{Q}\\left\\lfloor \\mathbf{Q}^{-1}\\mathbf{n}\\right\\rfloor$
%[text] は， $\\mathbf{Q}$を法とする $\\mathbf{n}$ の剰余である．( denotes the $\\mathbf{n}$ modulo $\\mathbf{Q}$.) 
%[text] 
%[text] 【Example】(In case of ) $\\mathbf{Q}=\\left(\\begin{array}{cc} 2 & 0 \\\\ 0 & 3\\end{array}\\right)$, $\\mathbf{k}=\\left(\\begin{array}{cc}k\_1 & k\_2\\end{array}\\right)^T=\\left(\\begin{array}{cc} 1 & 2 \\end{array}\\right)^T$ の場合：
%[text]  $\\left(\\begin{array}{ccc}v\[0,0\] & v\[0,1\] & v\[0,2\] \\\\\nv\[1,0\] & v\[1,1\] & v\[1,2\]  \\end{array}\\right)\\\\\n=T\\left(\\begin{array}{ccc}u\[0,0\] & u\[0,1\] & u\[0,2\] \\\\\nu\[1,0\] & u\[1,1\] & u\[1,2\]   \\end{array}\\right)\n=\\left(\\begin{array}{ccc}\nu\[1,1\]  & u\[1,2\] & u\[1,0\] \\\\\nu\[0,1\]  & u\[0,2\] & u\[0,0\] \n \\end{array}\\right)$
%[text] 
%[text] #### 信号の生成
%[text] (Signal generation)
% Generating an input array u[n1,n2] of finite support region
N1 = 2; % # of rows %[control:slider:2f4e]{"position":[6,7]}
N2 = 3; % # of columns %[control:slider:4c06]{"position":[6,7]}
ugen = "reshape((0:N1*N2-1),[N1 N2])"; %[control:dropdown:49d1]{"position":[8,38]}
u = eval(ugen)
%[text] #### シフト量の設定
%[text] (Setting the shift amount)
% Settings of the shift amount
k1 = 1; % # of shifts in the vertical direction %[control:slider:3c79]{"position":[6,7]}
k2 = 2; % # of shifts in the horizontal direction %[control:slider:050d]{"position":[6,7]}
%[text] #### 写像の定義
%[text] (Definition of a map)
% Definition of map T as a circular shift
mapT = @(x) circshift(x,[k1,k2]);
%[text] #### 写像
%[text] (Mapping)
% Mapping with the circular shift T(.)
v = mapT(u)
%%
%[text] ### 循環シフトの行列表現
%[text] (Matrix representation of the circular shift)
%[text] 
%[text] $\\mathbf{Q}=\\left(\\begin{array}{cc} 2 & 0 \\\\ 0 & 3\\end{array}\\right)$, $\\mathbf{k}=\\left(\\begin{array}{cc}k\_1 & k\_2\\end{array}\\right)^T=\\left(\\begin{array}{cc} 1 & 2 \\end{array}\\right)^T$ の循環シフトは (The circular shift of $\\mathbf{Q}=\\left(\\begin{array}{cc} 2 & 0 \\\\ 0 & 3\\end{array}\\right)$, $\\mathbf{k}=\\left(\\begin{array}{cc}k\_1 & k\_2\\end{array}\\right)^T=\\left(\\begin{array}{cc} 1 & 2 \\end{array}\\right)^T$  can be represented as a matrix as)
%[text]  $\\mathbf{v}=\\mathbf{Tu},$
%[text] のように行列表現できる．ただし，(where)
%[text] 
%[text]  $\\mathbf{v}=\\mathrm{vec}\\left(\\{v\[\\mathbf{n}\]\\}\_\\mathbf{n}\\right)=\\left(\\begin{array}{c}v\[0,0\]  \\\\\nv\[1,0\] \\\\\nv\[0,1\] \\\\\nv\[1,1\] \\\\\nv\[0,2\] \\\\\nv\[1,2\] \n\\end{array}\\right), \n\\mathbf{u}=\\mathrm{vec}\\left(\\{u\[\\mathbf{n}\]\\}\_\\mathbf{n}\\right)=\\left(\\begin{array}{c}\nu\[0,0\]  \\\\\nu\[1,0\] \\\\\nu\[0,1\] \\\\\nu\[1,1\] \\\\\nu\[0,2\] \\\\\nu\[1,2\] \n\\end{array}\\right),\n$
%[text]  $\\mathbf{T}\n=\\left(\\begin{array}{cccccc}\n     0  &   0 &    0  &   1 &    0 &    0 \\\\\n     0  &   0 &    1 &    0 &    0 &    0 \\\\\n     0   &  0  &   0  &   0 &    0 &    1 \\\\\n     0  &   0  &   0 &    0  &   1 &    0 \\\\\n     0   &  1  &   0  &   0  &   0 &    0 \\\\\n     1   &  0  &   0 &    0 &    0 &    0\n\\end{array}\\right).$
%[text] 
%[text] #### 循環シフトの行列生成
%[text] (Circular shift matrix generation)
% Find the matrix representation of the circular shift
T = zeros(numel(u));
for idx = 1:numel(u)
    % Generating a standard basis vector
    e = zeros(size(u),'like',u);
    e(idx) = 1;
    % Response to the standard basis vector
    T(:,idx) = reshape(mapT(e),[size(T,1) 1]); 
end
% Matrix representation of the circular shift
T
%%
%[text] ### 行列演算による2変量循環シフト
%[text] (Bivariate circular shift by matrix operation)
%[text] 循環シフトは可換図に沿って (Circular shifts can be computed as)
%[text]  $\\{v\[\\mathbf{n}\]\\}\_\\mathbf{n}=\\mathrm{vec}\_{\\Omega\_\\mathrm{v}}^{-1}\\left(\\mathbf{v}\\right)=\\mathrm{vec}\_{\\Omega\_\\mathrm{v}}^{-1}\\left(\\mathbf{Tu}\\right)=\\mathrm{vec}\_{\\Omega\_\\mathrm{v}}^{-1}\\circ\\mathbf{T}\\mathrm{vec}\_{\\Omega\_\\mathrm{u}}\\left(\\{u\[\\mathbf{n}\]\\}\_n\\right)$
%[text] のように行列演算が可能である．すなわち，(along the commutative diagram. That is, we have)
%[text]  $T=\\mathrm{vec}\_{\\Omega\_\\mathrm{v}}^{-1}\\circ\\mathbf{T}\\mathrm{vec}\_{\\Omega\_\\mathrm{u}}.$
%[text] と表現できる．
% Column vectorization of sequence u[n]
vecu = u(:);

% Matrix operation
vecv = T*vecu;

% Reshaping the result into the original
recv = reshape(vecv,[N1 N2])
%[text] #### 行列演算による単変量循環シフトの評価
%[text] (Evaluation of univariate circular shift by matrix operation)
% Comparizon between mapping and matrix operation
mymse(v,recv)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:3ddc]
%   data: {"defaultValue":6,"label":"Q","max":16,"min":2,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:dropdown:0588]
%   data: {"defaultValue":"\"(0:Q-1)\"","itemLabels":["(0:Q-1)","randn(1,Q)"],"items":["\"(0:Q-1)\"","\"randn(1,Q)\""],"label":"ドロップ ダウン","run":"SectionToEnd"}
%---
%[control:slider:7809]
%   data: {"defaultValue":1,"label":"s","max":5,"min":-5,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:2f4e]
%   data: {"defaultValue":2,"label":"Q1","max":6,"min":1,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:4c06]
%   data: {"defaultValue":3,"label":"Q2","max":6,"min":1,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:dropdown:49d1]
%   data: {"defaultValue":"\"reshape((0:N1*N2-1),[N1 N2])\"","itemLabels":["reshape((0:N1*N2-1),[N1 N2])","randn(N1,N2)"],"items":["\"reshape((0:N1*N2-1),[N1 N2])\"","\"randn(N1,N2)\""],"label":"ugen","run":"SectionToEnd"}
%---
%[control:slider:3c79]
%   data: {"defaultValue":1,"label":"s","max":5,"min":-5,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:050d]
%   data: {"defaultValue":2,"label":"s","max":5,"min":-5,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
