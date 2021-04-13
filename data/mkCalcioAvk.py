# -*- coding: utf-8 -*-
#
# Make Calcio AVI file from Sequense of JPEG files
#
# Copyright (C) 2021 Shogo MURAMATSU, All rights reserved
#
from PIL import Image 
import requests 
import torch 
import torchvision 
import torchvision.io 

nFrames = 150
frameRate = 30

#%% 出力ファイル
fileNameOut = './pycalcio.avi'

#%% フレーム毎の処理
totensor = torchvision.transforms.ToTensor()
im2uint8 = torchvision.transforms.ConvertImageDtype(torch.uint8)
for iFrame in range(nFrames):
    # フレームの読出し
    url = 'https://github.com/msiplab/AtipWork/raw/master/data/calcio%03d.jpg'%iFrame
    pilimg = Image.open(requests.get(url, stream=True).raw)
    #fileNameIn = './calcio%03d.jpg'%iFrame
    #pilimg = Image.open(fileNameIn)
    picture = im2uint8(totensor(pilimg).permute((1,2,0)))
    
    # フレーム出力
    if iFrame == 0:
        frameseq = picture.unsqueeze(0)
    else:
        frameseq = torch.cat((frameseq,picture.unsqueeze(0)),dim=0)

torchvision.io.write_video(fileNameOut, frameseq, fps=frameRate, video_codec='libx264')


    

