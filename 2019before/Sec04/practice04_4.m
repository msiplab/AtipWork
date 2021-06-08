% practice04_4.m
%
% $Id: practice04_4.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �p�����[�^�ݒ�
frameRate = 30;
nRepeats = 3;
nFrames = 150;

%% �t���[���摜��̓ǂݍ��݂�MOV�ւ̕ϊ�
frameSeq(1:nFrames) = ...
    struct('cdata', zeros(112,160, 3, 'uint8'),...
    'colormap', []);
for iFrame = 1:nFrames
    fileName = sprintf('./data/calcio%03d.jpg', iFrame - 1);
    pictureRgb = imread(fileName);
    frameSeq(iFrame) = im2frame(pictureRgb);
end

%% MOV�̕\��
axis off;
movie(frameSeq,nRepeats,frameRate);

% end 
