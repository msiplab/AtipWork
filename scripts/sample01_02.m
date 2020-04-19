%% Sample 1-2
%% 画像データの表現
% 基本操作 
% 
% 
% 
% 画像処理特論
% 
% 村松 正吾 
% 
% 動作確認: MATLAB R2020a
%% Digital image representation
% Basic operations
% 
% 
% 
% Advanced Topics in Image Processing
% 
% Shogo MURAMATSU
% 
% Verified: MATLAB R2020a
% 行列 $\mathbf{A}$の定義
% (Definition of matrix $\mathbf{A}$)
% 
% $$\mathbf{A}=\left(\begin{array}{ll}1 & 2 \\ 3 & 4 \\ 5 & 6\end{array}\right)$$

A = [
    1 2 ;
    3 4 ;
    5 6 ]
% 行列 $\mathbf{B}$の定義
% (Definition of matrix $\mathbf{B}$ )
% 
% $$\mathbf{B}=\left(\begin{array}{lll}1 & 2 & 3 \\ 4 & 5 & 6\end{array}\right)$$

B = [
    1 2 3 ;
    4 5 6 ]
% 行列積の計算
% (Matrix product)
% 
% $$\mathbf{C}=\mathbf{A B}$$

C = A*B
%% 
% © Copyright, Shogo MURAMATSU, All rights reserved.
% 
%