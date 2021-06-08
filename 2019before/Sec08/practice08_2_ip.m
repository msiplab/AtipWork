% practice08_2.m
%
% $Id: practice08_2_ip.m,v 1.4 2007/11/21 00:10:53 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 2-D FFT�_���i�����A���j
sizeFft = [1024 1024];

%% ���m�N���摜�̓Ǎ��ƕ\��
pictureGray = rgb2gray(imread('./data/boatsRgb.tif'));
figure(1)
imshow(pictureGray)

%% 2-D FFT�̌v�Z
freqChar2d = fftshift(fft2(im2double(pictureGray),...
    sizeFft(1),sizeFft(2)));

%% �U�������̕\���i�ݏ摥�ϊ��𗘗p�j
figure(2)
magnitude = abs(freqChar2d);
imshow(imadjust(magnitude/max(magnitude(:)),[],[],0.1))
%freqz2(freqChar2d);

%% �ʑ������̕\���i0[rad]�𒆊ԋP�x�l�Ƃ���j
figure(3)
phase = angle(freqChar2d);
imshow((phase+pi)/(2*pi))

% end of practice08_2.m