# -*- coding: utf-8 -*-
#%% Sample 2-1
#%% 画像データの入出力
# RGB-グレースケール変換 
# 
# 画像処理特論
# 
# 村松 正吾 
# 
# 動作確認: Python 3.7, PyTorch 1.8
#%% Input and output of images
# RGB to grayscale
# 
# Advanced Topics in Image Processing
# 
# Shogo MURAMATSU
# 
# Verified: Python 3.7, PyTorch 1.8
from PIL import Image
import requests
import torch
import torchvision
import torchvision.io
from matplotlib import pyplot as plt

#  準備 
# (Preparation)
# 
# 本サンプルで利用する画像でーがを収めたdata フォルダにパスをとおす。
# 
# Create a path to the data folder that contains images used in this sample.

#addpath('./data')
url = 'https://github.com/msiplab/AtipWork/raw/master/data/firenzeRgb.jpg'
totensor = torchvision.transforms.ToTensor()

# RGBからグレースケールへ
# (RGB to Grayscale)
# 
# RGB色空間からグレースケールへの変換の定義
# 
# Definition of conversion from RGB color space to grayscale.
# 
# $$x_\mathrm{Y} = 0.2989x_\mathrm{R}+0.5870x_\mathrm{G}+0.1140x_\mathrm{B}$$

# Importing color images
#pictureRgb = torchvision.io.read_image('./data/firenzeRgb.jpg')\
im2uint8 = torchvision.transforms.ConvertImageDtype(torch.uint8)
pictureRgb = im2uint8(totensor(Image.open(requests.get(url, stream=True).raw)))

# Conversion to grayscale
pictureGray = ( \
    0.2959 * pictureRgb[0,:,:].to(dtype=torch.double) + # R
    0.5870 * pictureRgb[1,:,:].to(dtype=torch.double) + # G
    0.1140 * pictureRgb[2,:,:].to(dtype=torch.double)   # B
).to(dtype=torch.uint8)
print(pictureRgb) 
print(pictureGray)
# uint8型画像の表示
# (Image show in uint8)
#%% 
# * RGBカラー画像(RGB color image)
# * グレースケール画像(Grayscale image)
topilimg = torchvision.transforms.ToPILImage()

plt.figure(1)
plt.imshow(topilimg(pictureRgb))
plt.figure(2)
print(pictureGray.size())
plt.imshow(topilimg(pictureGray),cmap='gray')
plt.show()
# RGB2GRAY関数
# (RGB2GRAY funciton)
# 
# 入出力のデータ型を保存するグレースケール変換関数
# 
# Grayscale conversion function to store input and output data types.
im2double = torchvision.transforms.ConvertImageDtype(torch.double)
rgb2gray = torchvision.transforms.Grayscale()

pictureRgbDouble = im2double(pictureRgb)
pictureGrayDouble = rgb2gray(pictureRgbDouble)
print(pictureRgbDouble)
print(pictureGrayDouble)
# double型画像の表示
# (Image show in double)
#%% 
# * RGBカラー画像(RGB color image)
# * グレースケール画像(Grayscale image)

plt.figure(3)
plt.imshow(topilimg(pictureRgbDouble))
plt.figure(4)
plt.imshow(topilimg(pictureGrayDouble),cmap='gray')
plt.show()
# 画像ビューアアプリ
# (Image viewer app)
#%% 
# * RGBカラー画像(RGB color image)
# * グレースケール画像(Grayscale image)

#imtool(pictureRgbDouble)
#imtool(pictureGrayDouble)
#%% 
# © Copyright, Shogo MURAMATSU, All rights reserved.