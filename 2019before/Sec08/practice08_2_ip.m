% practice08_2.m
%
% $Id: practice08_2_ip.m,v 1.4 2007/11/21 00:10:53 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 2-D FFT点数（高さ、幅）
sizeFft = [1024 1024];

%% モノクロ画像の読込と表示
pictureGray = rgb2gray(imread('./data/boatsRgb.tif'));
figure(1)
imshow(pictureGray)

%% 2-D FFTの計算
freqChar2d = fftshift(fft2(im2double(pictureGray),...
    sizeFft(1),sizeFft(2)));

%% 振幅特性の表示（累乗則変換を利用）
figure(2)
magnitude = abs(freqChar2d);
imshow(imadjust(magnitude/max(magnitude(:)),[],[],0.1))
%freqz2(freqChar2d);

%% 位相特性の表示（0[rad]を中間輝度値とする）
figure(3)
phase = angle(freqChar2d);
imshow((phase+pi)/(2*pi))

% end of practice08_2.m