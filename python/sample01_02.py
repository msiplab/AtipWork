# -*- coding: utf-8 -*-
#%% Sample 1-2
#%% 画像データの表現
# 基本操作 
# 
# 画像処理特論
# 
# 村松 正吾 
# 
# 動作確認: Python 3.8, PyTorch 1.8
#%% Digital image representation
# Basic operations
# 
# Advanced Topics in Image Processing
# 
# Shogo MURAMATSU
# 
# Verified: Python 3.8, PyTorch 1.8
import torch

#  行列 $\mathbf{A}$の定義 
# (Definition of matrix $\mathbf{A}$)
# 
# $$\mathbf{A}=\left(\begin{array}{ll}1 & 2 \\ 3 & 4 \\ 5 & 6\end{array}\right)$$

A = torch.tensor([ \
    [ 1, 2 ],
    [ 3, 4 ],
    [ 5, 6 ] ])
A
# 行列 $\mathbf{B}$の定義
# (Definition of matrix $\mathbf{B}$ )
# 
# $$\mathbf{B}=\left(\begin{array}{lll}1 & 2 & 3 \\ 4 & 5 & 6\end{array}\right)$$

B = torch.tensor([ \
    [ 1, 2, 3 ],
    [ 4, 5, 6 ] ])
B
# 行列積の計算
# (Matrix product)
# 
# $$\mathbf{C}=\mathbf{A B}$$

C = A @ B
C
#%% 
# © Copyright, Shogo MURAMATSU, All rights reserved.