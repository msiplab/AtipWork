# -*- coding: utf-8 -*-
#%% Sample 1-5
#%% 画像データの表現
# 画像の読み込みと表示 
# 
# 画像処理特論
# 
# 村松 正吾 
# 
# 動作確認: Python 3.7, PyTorch 1.8
#%% Digital image representation
# Image read and show
# 
# Advanced Topics in Image Processing
# 
# Shogo MURAMATSU
# 
# Verified: Python 3.7, PyTorch 1.8
from PIL import Image
import requests
import torchvision
from matplotlib import pyplot as plt 

#%% 画像の読み込み
# (Image read)
url = 'http://homepages.cae.wisc.edu/~ece533/images/peppers.png'
totensor = torchvision.transforms.ToTensor()
P = totensor(Image.open(requests.get(url, stream=True).raw))

#%% 画像の情報
# (Information of image)

print(P.dtype)
#%% 画像の表示
# (Image show)
topilimg = torchvision.transforms.ToPILImage()

plt.figure(1)
plt.imshow(topilimg(P))
plt.show()
#%% 
# © Copyright, Shogo MURAMATSU, All rights reserved.