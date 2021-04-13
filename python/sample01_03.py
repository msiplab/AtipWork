# -*- coding: utf-8 -*-
#%% Sample 1-3
#%% 画像データの表現
# FOR ループ
# 
# 画像処理特論
# 
# 村松 正吾 
# 
# 動作確認: Python 3.7, PyTorch 1.8
#%% Digital image representation
# FOR loop
# 
# Advanced Topics in Image Processing
# 
# Shogo MURAMATSU
# 
# Verified: Python 3.7, PyTorch 1.8
# 変数 $s$ の初期化 
# (Initialize variable $s$)
# 
# $$s\leftarrow 0$$

s = 0
# 累積加算
# (Accumulation)
# 
# $$s = \sum_{k=1}^{10}k$$

for k in range(1,11):
   s = s + k

# 結果の表示
# (Display result)

s
#%% 
# © Copyright, Shogo MURAMATSU, All rights reserved.