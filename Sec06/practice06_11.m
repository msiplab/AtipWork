% practice06_11.m
%
% $Id: practice06_11.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �p�����[�^�ݒ�
% ��ԗ�
uFactor = 5;
% �Ԉ�����
dFactor = 6;

%% ���̓t�@�C��
fileNameIn = './data/calcio.avi';
vrObj = VideoReader(fileNameIn);
frameRateIn = vrObj.FrameRate;
fprintf('���̓t���[�����[�g: %f [fps]\n',frameRateIn);

%% �o�̓t�@�C��
fileNameOut = './tmp/calcioFps25.avi';
frameRateOut = frameRateIn * uFactor / dFactor;
vwObj = VideoWriter(fileNameOut,'Uncompressed AVI');
vwObj.FrameRate = frameRateOut;

%% �t���[������
open(vwObj)
while(hasFrame(vrObj)) %for iFrame = 1:dFactor:nFrames
    % �t���[���̓Ǐo��(Input phase 0)
    pictureCur = readFrame(vrObj);

    % �t���[���̏o��(Output phase 0)
    pictureOut = pictureCur; % �d�� 1
    writeVideo(vwObj,pictureOut);

    % �t���[���̓Ǐo��(Input phase 1)
    picturePre = readFrame(vrObj);

    % �t���[���̓Ǐo��(Input phase 2)
    pictureCur = readFrame(vrObj);

    % �t���[���̏o��(Output phase 1)
    pictureOut = uint8( (...
        7.0 * double(picturePre) + ...
        1.0 * double(pictureCur) ) / 8 );
    writeVideo(vwObj,pictureOut);

    % �t���[���̓Ǐo��(Input phase 3)
    picturePre = pictureCur;
    pictureCur = readFrame(vrObj);

    % �t���[���̏o��(Output phase 2)
    pictureOut = uint8( (...
        5.0 * double(picturePre) + ...
        3.0 * double(pictureCur) ) / 8 );
    writeVideo(vwObj,pictureOut);        
    
    % �t���[���̓Ǐo��(Input phase 4)
    picturePre = pictureCur;
    pictureCur = readFrame(vrObj);

    % �t���[���̏o��(Output phase 3)
    pictureOut = uint8( (...
        3.0 * double(picturePre) + ...
        5.0 * double(pictureCur) ) / 8 );
    writeVideo(vwObj,pictureOut);        
    
    % �t���[���̓Ǐo��(Input phase 5)
    picturePre = pictureCur;
    pictureCur = readFrame(vrObj);

    % �t���[���̏o��(Output phase 4)
    pictureOut = uint8( (...
        1.0 * double(picturePre) + ...
        7.0 * double(pictureCur) ) / 8 );
    
    % �t���[���̓Ǐo��(Input phase 5)
    picturePre = pictureCur;
    writeVideo(vwObj,pictureOut);

end
close(vwObj)

fprintf('�o�̓t���[�����[�g: %f [fps]\n',vwObj.FrameRate);

% end 