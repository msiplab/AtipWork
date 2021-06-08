% practice08_2.m
%
% $Id: practice08_2.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 2-D FFT�_���i�����A���j
sizeFft = [1024 1024];

%% ���m�N���摜�̓Ǎ��ƕ\��
pictureGray = rgb2graycq(imread('./data/boatsRgb.tif'));
figure(1)
imshowcq(pictureGray)

%% 2-D FFT�̌v�Z
freqChar2d = fftshift(fft2(double(pictureGray),...
    sizeFft(1),sizeFft(2)));

%% �U�������̕\���i�ݏ摥�ϊ��𗘗p�j
figure(2)
magnitude = abs(freqChar2d);
imshowcq((magnitude/max(magnitude(:))).^0.1)

%% �ʑ������̕\���i0[rad]�𒆊ԋP�x�l�Ƃ���j
figure(3)
phase = angle(freqChar2d);
imshowcq((phase+pi)/(2*pi))

% end of practice08_2.m