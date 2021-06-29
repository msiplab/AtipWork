% practice_a_16.m
%
% $Id:$
%
% Copyright (C) 2012-2015 Shogo MURAMATSU, All rights reserved
%
 close all; clc

mse  = @(s,r) sum((s(:)-r(:)).^2)/numel(s);
psnr = @(s,r) -10*log10(mse(s,r));

%% �p�����[�^�ݒ�
nseSigma = 20; % ���@�����F�K�E�X�m�C�Y�̕W���΍�
nlevels  = 3; % �E�F�[�u���b�g�i��

%% ���摜�̓ǂݍ���
src = im2double(imread('./data/org.tif'));
%src = im2double(imread('cameraman.tif'));
subplot(2,2,1), imshow(src);
title('���摜')

%% �ϑ��摜�̐���
obs = imnoise(src,'gaussian',0,(nseSigma/255)^2);
subplot(2,2,2), imshow(obs);
title(sprintf('�m�C�Y�摜�FPSNR = %5.2f [dB]',psnr(src,obs)))

%% �E�B�[�i�[�t�B���^
resWnr = wiener2(obs, [5 5]);
subplot(2,2,3), imshow(resWnr);
title(sprintf('�����摜(Wiener)�FPSNR = %5.2f [dB]',psnr(src,resWnr)))

%% �\�t�g�k�ޏ���
% �E�F�[�u���b�g���ϊ��i�Ώ̒����j
[v,s] = sowtdec2(obs,nlevels);
% �T�u�o���h�K���\�t�g�k�ޏ���
y   = bayesshrink(v,s); 
% �E�F�[�u���b�g�t�ϊ��i�Ώ̒����j
res = sowtrec2(y,s);
subplot(2,2,4), imshow(res)
title(sprintf('�����摜(�\�t�g�k��)�FPSNR = %5.2f [dB]',psnr(src,res)))
