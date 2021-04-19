# -*- coding: utf-8 -*-
#%% Sample 1-4
#%% 画像データの表現
# 配列の生成
# 
# 画像処理特論
# 
# 村松 正吾 
# 
# 動作確認: Python 3.7, PyTorch 1.8
#%% Digital image representation
# Creation of arrays
# 
# Advanced Topics in Image Processing
# 
# Shogo MURAMATSU
# 
# Verified: Python 3.7, PyTorch 1.8
import torch
#%% ワークスペースのクリア
# (Clear workspace)
#clear

#%% 全ての要素が零の配列の生成
# (Create array of all zeros)

X = torch.zeros(2,3) # zeros array of size 2x3
#%% 全ての要素が１の配列の生成
# (Create array of all ones)

Y = torch.ones(3,4) # ones array of size 3x4
#%% ランダム配列の生成
# (Create array of random numbers)

Z = torch.rand(2,3,4) # random array of size 2x3x4
#%% 配列のサイズ
# (Array size)

print('Size of X')
print(X.size())

print('Size of Y')
print(Y.size())

print('Size of Z')
print(Z.size())
#%% 配列のタイプ
# (Array type)

print('Type of X')
print(X.dtype)

L = torch.zeros(2,3,dtype=torch.bool)
print('Type of L')
print(L.dtype)

U = torch.zeros(2,3,dtype=torch.uint8)
print('Type of U')
print(U.dtype)

I = torch.zeros(2,3,dtype=torch.int16)
print('Type of I')
print(I.dtype)

S = torch.zeros(2,3,dtype=torch.float)
print('Type of S')
print(S.dtype)
#%% ワークスペース内の変数のリスト
# (List variables in workspace)

#whos
#%% 
# © Copyright, Shogo MURAMATSU, All rights reserved.