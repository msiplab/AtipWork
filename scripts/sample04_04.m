%% Sample 4-4
%% 線形シフト不変システム
% 循環シフト
% 
% 画像処理特論
% 
% 村松 正吾 
% 
% 動作確認: MATLAB R2020a
%% Linear shift-invariant systems
% Circular shift
% 
% Advanced Topics in Image Processing
% 
% Shogo MURAMATSU
% 
% Verified: MATLAB R2020a
% 準備
% (Preparation)

close all
% 単変量循環シフト
% (Univariate circular shift)
% 
% 
% 
% 単変量の有限なサポート領域をもつ配列 $\{u[n]\in\mathbb{K}\}_{n\in{\Omega_\mathrm{u}}\subset\mathbb{Z}}$の循環シフトは， 
% (The circular shift of sequences with univariate finite support region can be 
% represented as )
% 
% $$\{v[n]\}_n =T\left(\{u[n]\}_n\right) = \{u\left[ (\!(n-k)\!)_Q\right]\}_n,$$
% 
% のように表現できる．ここで ， $Q\in\mathbb{N}$は周期, $\{v[n]\in\mathbb{K}\}_{n\in\Omega\subset\mathbb{Z}}$は出力配列，(where  
% $Q\in\mathbb{N}$ is the period, $\{v[n]\in\mathbb{K}\}_{n\in\Omega\subset\mathbb{Z}}$ 
% is the destination sequence and)
% 
% $$(\!(n)\!)_Q = n - Q\left\lfloor Q^{-1}n\right\rfloor.$$
% 
% は， ${Q}$を法とする ${n}$ の剰余である．( denotes the ${n}$ modulo ${Q}$.) 
% 
% 
% 
% 【Example】(In case of ) $Q=6$, $k=1$ の場合：
% 
% $$\left(\begin{array}{cccccc}v[0] & v[1] &v[2]&v[3]&v[4]&v[5]\end{array}\right)\\=T\left(\begin{array}{cccccc}u[0]&u[1]&u[2]&u[3]&u[4]&u[5]\end{array}\right)=\left(\begin{array}{cccccc}u[5] 
% & u[0] & u[1] & u[2] & u[3] & u[4]\end{array}\right)$$
% 
% 
% 信号の生成
% (Signal generation)

% Generating an input sequence u[n] of finite support region
Q = 6;
ugen = "(0:Q-1)";
u = eval(ugen)
% シフト量の設定
% (Setting the shift amount)

% Setting the shift amount 
k = 1;
% 写像の定義
% (Definition of a map)

% Definition of map T as a circular shift
mapT = @(x) circshift(x,k);
% 写像
% (Mapping)

% Mapping with the circular shift T(.)
v = mapT(u)
% 循環シフトの行列表現
% (Matrix representation of the circular shift)
% 
% 
% 
% $Q=6$, $k=1$ の循環シフトは (The circular shift of $Q=6$, $k=1$ can be represented 
% as a matrix as)
% 
% $$\mathbf{v}=\mathbf{Tu},$$
% 
% のように行列表現できる．ただし，(where)
% 
% 
% 
% $$\mathbf{v}=\mathrm{vec}\left(\{v[{n}]\}_{n}\right)=\left(\begin{array}{c}v[0]\\v[1]\\v[2]\\v[3]\\v[4]\\v[5]\end{array}\right), 
% \mathbf{u}=\mathrm{vec}\left(\{u[{n}]\}_{n}\right)=\left(\begin{array}{c}u[0]\\u[1]\\u[2]\\u[3]\\u[4]\\u[5]\end{array}\right),$$
% 
% $$\mathbf{T}=\left(\begin{array}{cccccc}0 & 0  & 0 & 0 & 0 & 1 \\1 & 0  & 
% 0 & 0 & 0 & 0 \\0 & 1  & 0 & 0 & 0 & 0 \\0 & 0  & 1 & 0 & 0 & 0 \\0 & 0  & 0 
% & 1 & 0 & 0 \\0 & 0  & 0 & 0 & 1 & 0 \\0 & 0  & 0 & 0 & 0 & 1 \end{array}\right).$$
% 
% 
% 循環シフトの行列生成
% (Circular shift matrix generation)

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
% 行列演算による単変量循環シフト
% (Univariate circular shift by matrix operation)
% 
% 循環シフトは可換図に沿って (Circular shifts can be computed as)
% 
% $$\{v[{n}]\}_{n}=\mathrm{vec}_{\Omega_\mathrm{v}}^{-1}\left(\mathbf{v}\right)=\mathrm{vec}_{\Omega_\mathrm{v}}^{-1}\left(\mathbf{Tu}\right)=\mathrm{vec}_{\Omega_\mathrm{v}}^{-1}\circ\mathbf{T}\mathrm{vec}_{\Omega_\mathrm{u}}\left(\{u[n]\}_n\right)$$
% 
% のように行列演算が可能である．すなわち，(along the commutative diagram. That is, we have)
% 
% $$T=\mathrm{vec}_{\Omega_\mathrm{v}}^{-1}\circ\mathbf{T}\mathrm{vec}_{\Omega_\mathrm{u}}.$$
% 
% と表現できる．

% Column vectorization of sequence u[n]
vecu = u(:);

% Matrix operation
vecv = T*vecu;

% Reshaping the result into the original
recv = reshape(vecv,[1 Q])
% 行列演算による単変量循環シフトの評価
% (Evaluation of univariate circular shift by matrix operation)

% Comparizon between mapping and matrix operation
mymse = @(x,y) mean((double(x)-double(y)).^2,'all');
mymse(v,recv)
% 2変量循環シフト
% (Bivariate circular shift)
% 
% 
% 
% 2変量の有限なサポート領域をもつ配列 $\{u[\mathbf{n}]\in\mathbb{K}\}_{\mathbf{n}\in{\Omega_\mathrm{u}}\subset\mathbb{Z}^{2}}$の循環シフトは， 
% (The circular shift of arrays with bivariate finite support region can be represented 
% as )
% 
% $$\{v[\mathbf{n}]\}_\mathbf{n} =T\left(\{u[\mathbf{n}]\}_\mathbf{n}\right) 
% = \{u\left[ (\!(\mathbf{n}-\mathbf{k})\!)_\mathbf{Q}\right]\}_\mathbf{n},$$
% 
% のように表現できる．ただし，$\mathbf{Q}\in\mathbb{Z}^{2\times2}(\det\mathbf{Q}\neq 0)$は周期行列,  
% $\{v[\mathbf{n}]\in\mathbb{K}\}_{\mathbf{n}\in\Omega\subset\mathbb{Z}^2}$は出力配列，(where  
% $\mathbf{Q}\in\mathbb{Z}^{2\times2}(\det\mathbf{Q}\neq 0)$ is the period matrix,  
% $\{v[\mathbf{n}]\in\mathbb{K}\}_{\mathbf{n}\in\Omega\subset\mathbb{Z}^2}$ is 
% the destination array and)
% 
% $$(\!(\mathbf{n})\!)_\mathbf{Q} = \mathbf{n} - \mathbf{Q}\left\lfloor \mathbf{Q}^{-1}\mathbf{n}\right\rfloor$$
% 
% は， $\mathbf{Q}$を法とする $\mathbf{n}$ の剰余である．( denotes the $\mathbf{n}$ modulo 
% $\mathbf{Q}$.) 
% 
% 
% 
% 【Example】(In case of ) $\mathbf{Q}=\left(\begin{array}{cc} 2 & 0 \\ 0 & 3\end{array}\right)$, 
% $\mathbf{k}=\left(\begin{array}{cc}k_1 & k_2\end{array}\right)^T=\left(\begin{array}{cc} 
% 1 & 2 \end{array}\right)^T$ の場合：
% 
% $$\left(\begin{array}{ccc}v[0,0] & v[0,1] & v[0,2] \\v[1,0] & v[1,1] & v[1,2]  
% \end{array}\right)\\=T\left(\begin{array}{ccc}u[0,0] & u[0,1] & u[0,2] \\u[1,0] 
% & u[1,1] & u[1,2]   \end{array}\right)=\left(\begin{array}{ccc}u[1,1]  & u[1,2] 
% & u[1,0] \\u[0,1]  & u[0,2] & u[0,0]  \end{array}\right)$$
% 
% 
% 信号の生成
% (Signal generation)

% Generating an input array u[n1,n2] of finite support region
N1 = 2; % # of rows
N2 = 3; % # of columns
ugen = "reshape((0:N1*N2-1),[N1 N2])";
u = eval(ugen)
% シフト量の設定
% (Setting the shift amount)

% Settings of the shift amount
k1 = 1; % # of shifts in the vertical direction
k2 = 2; % # of shifts in the horizontal direction
% 写像の定義
% (Definition of a map)

% Definition of map T as a circular shift
mapT = @(x) circshift(x,[k1,k2]);
% 写像
% (Mapping)

% Mapping with the circular shift T(.)
v = mapT(u)
% 循環シフトの行列表現
% (Matrix representation of the circular shift)
% 
% 
% 
% $\mathbf{Q}=\left(\begin{array}{cc} 2 & 0 \\ 0 & 3\end{array}\right)$, $\mathbf{k}=\left(\begin{array}{cc}k_1 
% & k_2\end{array}\right)^T=\left(\begin{array}{cc} 1 & 2 \end{array}\right)^T$ 
% の循環シフトは (The circular shift of $\mathbf{Q}=\left(\begin{array}{cc} 2 & 0 \\ 
% 0 & 3\end{array}\right)$, $\mathbf{k}=\left(\begin{array}{cc}k_1 & k_2\end{array}\right)^T=\left(\begin{array}{cc} 
% 1 & 2 \end{array}\right)^T$  can be represented as a matrix as)
% 
% $$\mathbf{v}=\mathbf{Tu},$$
% 
% のように行列表現できる．ただし，(where)
% 
% 
% 
% $$\mathbf{v}=\mathrm{vec}\left(\{v[\mathbf{n}]\}_\mathbf{n}\right)=\left(\begin{array}{c}v[0,0]  
% \\v[1,0] \\v[0,1] \\v[1,1] \\v[0,2] \\v[1,2] \end{array}\right), \mathbf{u}=\mathrm{vec}\left(\{u[\mathbf{n}]\}_\mathbf{n}\right)=\left(\begin{array}{c}u[0,0]  
% \\u[1,0] \\u[0,1] \\u[1,1] \\u[0,2] \\u[1,2] \end{array}\right),$$
% 
% $$\mathbf{T}=\left(\begin{array}{cccccc}     0  &   0 &    0  &   1 &    0 
% &    0 \\     0  &   0 &    1 &    0 &    0 &    0 \\     0   &  0  &   0  &   
% 0 &    0 &    1 \\     0  &   0  &   0 &    0  &   1 &    0 \\     0   &  1  
% &   0  &   0  &   0 &    0 \\     1   &  0  &   0 &    0 &    0 &    0\end{array}\right).$$
% 
% 
% 循環シフトの行列生成
% (Circular shift matrix generation)

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
% 行列演算による2変量循環シフト
% (Bivariate circular shift by matrix operation)
% 
% 循環シフトは可換図に沿って (Circular shifts can be computed as)
% 
% $$\{v[\mathbf{n}]\}_\mathbf{n}=\mathrm{vec}_{\Omega_\mathrm{v}}^{-1}\left(\mathbf{v}\right)=\mathrm{vec}_{\Omega_\mathrm{v}}^{-1}\left(\mathbf{Tu}\right)=\mathrm{vec}_{\Omega_\mathrm{v}}^{-1}\circ\mathbf{T}\mathrm{vec}_{\Omega_\mathrm{u}}\left(\{u[\mathbf{n}]\}_n\right)$$
% 
% のように行列演算が可能である．すなわち，(along the commutative diagram. That is, we have)
% 
% $$T=\mathrm{vec}_{\Omega_\mathrm{v}}^{-1}\circ\mathbf{T}\mathrm{vec}_{\Omega_\mathrm{u}}.$$
% 
% と表現できる．

% Column vectorization of sequence u[n]
vecu = u(:);

% Matrix operation
vecv = T*vecu;

% Reshaping the result into the original
recv = reshape(vecv,[N1 N2])
% 行列演算による単変量循環シフトの評価
% (Evaluation of univariate circular shift by matrix operation)

% Comparizon between mapping and matrix operation
mymse(v,recv)
%% 
% © Copyright, Shogo MURAMATSU, All rights reserved.