% practice08_5.m
%
% $Id: practice08_5_ip.m,v 1.3 2007/11/21 00:08:40 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 速度ベクトル（垂直、水平）
velocity = [2 2];

%% 第0番目フレームの読込
pictureOrg = im2double(imread('./data/gaussian2d.tif'));

%% 動画像の生成
nFrames = 32;
picture = pictureOrg;
array3d = zeros(size(picture,1),size(picture,2),nFrames);
figure(1)
w = hanning(nFrames);
vwObj = VideoWriter('./tmp/motion.avi','Uncompressed AVI');
vwObj.FrameRate = 15;
open(vwObj)
for iFrame = 1:nFrames
    array3d(:,:,iFrame) = w(iFrame)*picture;
    picture = circshift(picture, velocity);
    imshow(picture);
    drawnow;
    writeVideo(vwObj,uint8(255*picture));
end
close(vwObj)

%% 3-D FFTの計算
sizeFft = [128 128 128];
freqChar3d = abs(fftshift(fftn(array3d, sizeFft)));
clear array3d

%% 3-D スペクトルの表示
figure(2)
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

% end of practice08_5.m