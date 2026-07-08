%[text] # Sample 1-2
%[text] ## 画像データの表現
%[text] 基本操作 
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Digital image representation
%[text] Basic operations
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ###  行列 $\\mathbf{A}$の定義 
%[text] (Definition of matrix $\\mathbf{A}$)
%[text]{"align":"center"} $\\mathbf{A}=\\left(\\begin{array}{ll}1 & 2 \\\\ 3 & 4 \\\\ 5 & 6\\end{array}\\right)$
A = [
    1 2 ;
    3 4 ;
    5 6 ]
%%
%[text] ### 行列 $\\mathbf{B}$の定義
%[text]  (Definition of matrix $\\mathbf{B}$ )
%[text]{"align":"center"}  $\\mathbf{B}=\\left(\\begin{array}{lll}1 & 2 & 3 \\\\ 4 & 5 & 6\\end{array}\\right)$
B = [
    1 2 3 ;
    4 5 6 ]
%%
%[text] ### 行列積の計算
%[text] (Matrix product)
%[text]{"align":"center"} $\\mathbf{C}=\\mathbf{A B}$
C = A*B
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
