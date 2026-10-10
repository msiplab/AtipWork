# -*- coding: utf-8 -*-
#
# Make the Calcio AVI file from the sequence of JPEG files
#
# Reads calcio000.jpg, ..., calcio149.jpg from the folder of this script
# (the data folder of AtipWork) and writes pycalcio.avi (H.264, 30 frames/s)
# to the results folder next to it (created if needed).
#
# Copyright (C) 2021-2026 Shogo MURAMATSU, All rights reserved
#
from pathlib import Path
from PIL import Image
import torch
import torchvision
import torchvision.io

nFrames = 150
frameRate = 30

datFolder = Path(__file__).resolve().parent
resFolder = datFolder.parent / 'results'
resFolder.mkdir(exist_ok=True)

#%% Output file
fileNameOut = str(resFolder / 'pycalcio.avi')

#%% Frame-by-frame processing
totensor = torchvision.transforms.ToTensor()
im2uint8 = torchvision.transforms.ConvertImageDtype(torch.uint8)
frames = []
for iFrame in range(nFrames):
    # Read the frame
    fileNameIn = datFolder / ('calcio%03d.jpg' % iFrame)
    pilimg = Image.open(fileNameIn)
    picture = im2uint8(totensor(pilimg).permute((1, 2, 0)))
    frames.append(picture)
frameseq = torch.stack(frames, dim=0)

torchvision.io.write_video(fileNameOut, frameseq, fps=frameRate, video_codec='libx264')
