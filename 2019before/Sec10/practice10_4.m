% practice10_4.m
%
% $Id: practice10_4.m,v 1.7 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% ���x�x�N�g���i�����A�����j
velocity = [0 0];

%% mobile.avi �ɑ΂��鏈���̏ꍇ true 
isMobileAvi = false;

if isMobileAvi
    vrObj = VideoReader('tmp/mobile.avi'); % mobile.avi �͗��4.9�Ő���
    nFramesIn = [];
    frameRateIn = vrObj.FrameRate;
    height = vrObj.Height;
    width  = vrObj.Width;
    frameSize = [height width];
else
    % �C���^���[�X�f�����f���̐���
    frameSeq = mkInterlacedMov(velocity);
    nFramesIn = length(frameSeq);
    frameRateIn = 30;
    frameSize = size(frame2im(frameSeq(1)));
end

%% VideoWriter �I�u�W�F�N�g�̐���
outputFileName = 'tmp/adpip.avi';
frameRateOut = 2 * frameRateIn;
nFrameOut = 2 * nFramesIn;
vwObj = VideoWriter(outputFileName,'Uncompressed AVI');
vwObj.FrameRate = frameRateOut;
me.frameSize = frameSize;

%% �������o�^�K�����IP�ϊ�
deintPicture0 = 128*ones(frameSize,'uint8');
deintPicture1 = 128*ones(frameSize,'uint8');
previousField = 128*ones(frameSize./[2 1],'uint8');  
iFrame = 1;
hasFrame_ = true;
open(vwObj)
while(hasFrame_)
    if isMobileAvi
        pictureI  = rgb2graycq(readFrame(vrObj));
        hasFrame_ = hasFrame(vrObj);
    else
        pictureI  = frame2im(frameSeq(iFrame));
        iFrame    = iFrame + 1;
        hasFrame_ = (iFrame < nFramesIn);
    end
    % Process for picture0
    deintPicture0(2:2:end,:) = pictureI(2:2:end,:);
    % Vertical averaging    
    deintPicture0(1:2:end,:) = ...
                1/2 * pictureI(2:2:end,:) ...
                + 1/2 * [pictureI(2,:) ; ...
                     pictureI(2:2:end-2,:)];    
    % Comb detection
    alphaMap0 = abs( (...
        double(previousField) - double(deintPicture0(1:2:end,:)))/255);
    alphaMap0 = alphaMap0.^.25;
    % Adaptive interpolation
    deintPicture0(1:2:end,:) = uint8(...
        (1-alphaMap0) .* double(previousField) ...
        + alphaMap0 .* double(deintPicture0(1:2:end,:)));
    previousField = pictureI(2:2:end,:);    
    
    % Process for picture1
    deintPicture1(1:2:end,:) = pictureI(1:2:end,:);
    % Vertical averaging
    deintPicture1(2:2:end,:) = ...
                1/2 * pictureI(1:2:end,:) ...
                + 1/2 * [pictureI(3:2:end,:) ; ...
                    pictureI(end-1,:)];    
    % Comb detection
    alphaMap1 = abs( (...
        double(previousField) - double(deintPicture1(2:2:end,:)))/255);
    alphaMap1 = alphaMap1.^.25;  
    % Adaptive interpolation
    deintPicture1(2:2:end,:) = uint8(...
        (1-alphaMap1) .* double(previousField) ...
        + alphaMap1 .* double(deintPicture1(2:2:end,:)));
    previousField = pictureI(1:2:end,:);
    % Output to avi file
    writeVideo(vwObj, deintPicture0);
    writeVideo(vwObj, deintPicture1);
end
close(vwObj)

%
    