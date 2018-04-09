% practice10_7.m
%
% $Id: practice10_7.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% ���x�x�N�g���i�����A�����j
velocity = [2 2]; 

%% �T���p�����[�^�i�\���̂ɕێ��j
me.mbSize = [16 16]; % �u���b�N�T�C�Y
me.searchRegion = ...
    [ -7 7 ... % �T���͈́i�����j
    -7 7 ];  % �T���͈́i�����j

%% �t���[���摜�̏���
pictureObj = imread('./data/squareandgauss.tif');
pictureBg = imread('./data/background.tif');

%% �Q�ƃt���[���̐ݒ�
referenceFrame = pictureObj + ...
    uint8(not(pictureObj)) .* pictureBg; 

%% ���t���[���̐ݒ�
pictureObj = circshift(pictureObj, velocity); 
currentFrame = pictureObj + ...
    uint8(not(pictureObj)) .* pictureBg;
me.frameSize = size(currentFrame); % �t���[���T�C�Y

%% �����x�N�g����̐���
mvField = fullSearchBlockMatchingMe(...
    referenceFrame, currentFrame, me);

%% �����⏞�\��
predictedFrame = mcPrediction(...
    referenceFrame, mvField, me);

%% ���t���[���̕\��
figure(1)
imshowcq(currentFrame)
title('Current frame')

%% �����⏞�\���t���[���̕\��
figure(2)
imshowcq(predictedFrame)
title('Predicted frame')

%% �����̕\��
figure(3)
imshowcq(16*abs(currentFrame-predictedFrame))
title('Difference')
