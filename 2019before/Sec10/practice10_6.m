% practice10_6.m
%
% $Id: practice10_6.m,v 1.3 2007/05/07 11:09:47 sho Exp $
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

%% ���t���[���̕\��
%�i�����x�N�g���ꂪ���₷���悤���H�j
imshowcq((double(currentFrame)/510+.5).^.25)
hold on

%% �����x�N�g����̕\��
[n0,n1] = ndgrid(...
    me.mbSize(1)/2:me.mbSize(1):me.frameSize(1),...
    me.mbSize(2)/2:me.mbSize(2):me.frameSize(2));
d0 = mvField(:,:,1);
d1 = mvField(:,:,2);
quiver(n1,n0,-d1,-d0,...
   'LineWidth',2) % �Ή��x�N�g���𔽓]�\��
hold off



