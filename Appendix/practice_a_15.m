% practice_a_15.m
%
% $Id:$
%
% Copyright (C) 2012-2015 Shogo MURAMATSU, All rights reserved
%
mse  = @(s,r) sum((s(:)-r(:)).^2)/numel(s);
psnr = @(s,r) -10*log10(mse(s,r));

%% �p�����[�^�ݒ�
nseSigma = 20; % ���@�����F�K�E�X�m�C�Y�̕W���΍�
nlevels  = 3; % �E�F�[�u���b�g�i��

%% ���摜�̓ǂݍ���
%src = im2double(imread('./data/org.tif'));
src = im2double(imread('cameraman.tif'));
subplot(2,2,1), imshow(src);
title('���摜')

%% ���͏����i�Ώ̒����E�F�[�u���b�g�ϊ��j
[valueC,valueS] = sowtdec2(src,nlevels);

%% �ϊ��W���̔z��
pos = 0;
dim = valueS(1,:);
nel = prod(dim);
c0 = reshape(valueC(pos+1:pos+nel),dim)/(2^nlevels);
pos = nel;
for ilv = 1:nlevels
    dim = valueS(ilv+1,:);
    nel = prod(dim);
    %
    c1 = abs(reshape(valueC(pos+1:pos+nel),dim));
    pos = pos + nel;
    %
    c2 = abs(reshape(valueC(pos+1:pos+nel),dim));
    pos = pos + nel;    
    %
    c3 = abs(reshape(valueC(pos+1:pos+nel),dim));
    pos = pos + nel;        
    %
    c0 = [ c0 c1; c2 c3 ];
end
subplot(2,2,2), imshow(abs(c0).^0.25)
title('���摜�̕ϊ��W��')

%% �ϑ��摜�̐���

obs = imnoise(src,'gaussian',0,(nseSigma/255)^2);
subplot(2,2,3), imshow(obs);
title(sprintf('�m�C�Y�摜�FPSNR = %5.2f [dB]',psnr(src,obs)))

%% ���͏����i�Ώ̒����E�F�[�u���b�g�ϊ��j
[valueC,valueS] = sowtdec2(obs,nlevels);

%% �ϊ��W���̔z��
pos = 0;
dim = valueS(1,:);
nel = prod(dim);
c0 = reshape(valueC(pos+1:pos+nel),dim)/(2^nlevels);
pos = nel;
for ilv = 1:nlevels
    dim = valueS(ilv+1,:);
    nel = prod(dim);
    %
    c1 = abs(reshape(valueC(pos+1:pos+nel),dim));
    pos = pos + nel;
    %
    c2 = abs(reshape(valueC(pos+1:pos+nel),dim));
    pos = pos + nel;    
    %
    c3 = abs(reshape(valueC(pos+1:pos+nel),dim));
    pos = pos + nel;        
    %
    c0 = [ c0 c1; c2 c3 ];
end
subplot(2,2,4), imshow(abs(c0).^0.25)
title('�m�C�Y�摜�̕ϊ��W��')