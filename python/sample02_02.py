# -*- coding: utf-8 -*-
#%% Sample 2-2
#%% 画像データの入出力
# 動画像処理 
# 
# 画像処理特論
# 
# 村松 正吾 
# 
# 動作確認: Python 3.7, PyTorch 1.8
#%% Input and output of images
# Video processing
# 
# Advanced Topics in Image Processing
# 
# Shogo MURAMATSU
# 
# Verified: Python 3.7, PyTorch 1.8
# サンプル画像の準備
# (Preparation of sample image)
# 
# 本サンプルで利用する画像データを収めたdata フォルダにパスをとおして，サンプル動画を準備。
# 
# Create a path to the data folder that contains images used in this sample, 
# and prepare a sample video.
#import requests 
import torch
import torchvision
import torchvision.io 

# Preparation of a sample video
#mkCalcioAvi

# 入力動画の準備
# (Preparation of input video)
# 
# VideoReaderオブジェクトの生成
# 
# Instantiation of VideoReader object

framesIn,_,info = torchvision.io.read_video('./data/pycalcio.avi',0, pts_unit='sec')
frameRate = info['video_fps']
nFrames = framesIn.size(0)

# フレーム毎の処理
# (Frame-by-frame processing)
# 
# フレームごとのグレースケール変換
# 
# Frame-by-frame grayscale conversion

#%% 
rgb2gray = torchvision.transforms.Grayscale(num_output_channels=3)
framesIn = framesIn.permute(0,3,1,2)
framesOut = torch.empty([])
for iFrame in range(nFrames):
    # Read frame
    pictureIn = framesIn[iFrame]
    # Process frame
    pictureOut = rgb2gray(pictureIn)
    print(pictureOut.size())    
    # Write frame
    if iFrame == 0:
        framesOut = pictureOut.unsqueeze(0)
    else:
        framesOut = torch.cat((framesOut,pictureOut.unsqueeze(0)),0) 

#
framesOut = framesOut.permute(0,2,3,1)    
torchvision.io.write_video('./tmp/pycalcio_gray.avi', framesOut, fps=frameRate, video_codec='libx264')
#%% 
# © Copyright, Shogo MURAMATSU, All rights reserved.