% practice08_3.m
%
% $Id: practice08_3_ip.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 3-D FFT�_���i�����A���A���ԁj
sizeFft = [256 256 128];

%% �f���̓Ǎ�% �f���f�[�^�̓Ǎ���
fileName = './data/calcio.avi';
nFrames = 128;
vrObj = VideoReader(fileName);
height = vrObj.Height;
width  = vrObj.Width;
clear array3d
w = hanning(nFrames); % ���ԕ����ɓK�p
array3d = zeros(height,width,nFrames);
for iFrame = 1:nFrames
    pictureGray = rgb2gray(readFrame(vrObj));
    array3d(:,:,iFrame) = w(iFrame)*im2double(pictureGray);
end
clear frameSeq pictureGray

% 3-D FFT�̌v�Z
freqChar3d = abs(fftshift(fftn(array3d, sizeFft)));
clear array3d

% 3-D �X�y�N�g���̕\��
freqChar3d = freqChar3d/max(freqChar3d(:));
freqChar3d = freqChar3d.^0.1;
[wt,wh,wv] = meshgrid( ...
    -1:2/sizeFft(3):1-2/sizeFft(3),...
    -1:2/sizeFft(1):1-2/sizeFft(1),...
    -1:2/sizeFft(2):1-2/sizeFft(2));
freqChar3d = permute(freqChar3d,[2 3 1]);
slice(wt,wh,wv,freqChar3d, 0 ,0, 0, 'nearest')
shading flat
axis vis3d
colormap(jet)
xlabel('\omega_T (\times\pi rad)')
ylabel('\omega_H (\times\pi rad)')
zlabel('\omega_V (\times\pi rad)');
clear freqChar3d wt wh wv

%% AVI�t�@�C���ւ̏o��
%{
vwObj = VideoWriter('./tmp/calcioFftN.avi','Uncompressed AVI');
open(vwObj)
for iAngle=1:45
    camorbit(8,0,'camera');
    drawnow;
    frame = getframe(gca);
    writeVideo(vwObj,frame);
end
close(vwObj)
%}

% end of practice08_3.m