% practice_a_1.m
%
% $Id:$
%
% Copyright (C) 2012-2015 Shogo MURAMATSU, All rights reserved
%
close all; clc

mse  = @(s,r) sum((s(:)-r(:)).^2)/numel(s);
psnr = @(s,r) -10*log10(mse(s,r));

downsample2x2 = @(x) downsample(downsample(x,2).',2).';
upsample2x2 = @(x) upsample(upsample(x,2).',2).';

%% �p�����[�^�ݒ�
psfSigma = 2; % �_�L����֐��̕W���΍� 
nseSigma = 0; % ���@�����F�K�E�X�m�C�Y�̕W���΍�
nlevels  = 3; % �E�F�[�u���b�g�i��
eps      = 1e-4; % ISTA �̋��e�덷�i���������j
lambda   = 0.00015; % ����p�����[�^��

%% ���摜�̓ǂݍ���
src = im2double(imread('./data/org.tif'));
%src = im2double(imread('cameraman.tif'));
subplot(2,2,1), imshow(src);
title('���摜')

%% �ϑ��摜�̐���
psfSize = 2*round(4*psfSigma)+1;
psf = fspecial('gaussian',psfSize,psfSigma);
linrprocess = @(x) downsample2x2(imfilter(x,psf,'conv','circ'));
obs = imnoise(linrprocess(src),'gaussian',0,(nseSigma/255)^2);
subplot(2,2,2), imshow(obs);
title('�ϑ��摜')

%% �o�C�L���[�r�b�N���
resBci = imresize(obs, 2*size(obs), 'bicubic');
subplot(2,2,3), imshow(resBci);
title(sprintf('�����摜(Bicubic)�FPSNR = %5.2f [dB]',psnr(src,resBci)))

%% �J�Ԃ��k�ށ^臒l�A���S���Y��(ISTA)
% �O�����FP.'P�̍ő�ŗL�l�i�ׂ���@�j
dualprocess = @(x) imfilter(upsample2x2(x),psf,'corr','circ');
upst = 0*obs;
upst(1,1) = 1;
eps_ = 1e-6;
err_ = Inf;
while ( err_ > eps_ ) 
    upre = upst;
    v    = linrprocess(upre); % P
    upst = dualprocess(v);    % P.'
    err_ = norm(upst(:)-upre(:))^2/norm(upst(:));
end
n  = sum(upst(:).'*upst(:));
d  = sum(upst(:).'*upre(:));
lc = n/d;
fprintf('���v�V�b�c�萔�F %f\n',lc);

% �J��Ԃ�����
softshrink  = @(y,lmd) sign(y).*max(abs(y)-lmd,0);
[y,s] = nshaarwtdec2(dualprocess(obs),nlevels);
err = Inf;
subplot(2,2,4), hi = imshow(dualprocess(obs));
ht = title('�����摜(ISTA)');
while ( err > eps ) 
    ypre = y;
    v = linrprocess(nshaarwtrec2(ypre,s));
    e = nshaarwtdec2(dualprocess(v-obs),nlevels)/lc;
    y = softshrink(ypre - e,lambda/lc);
    err = norm(y(:)-ypre(:))^2/norm(y(:));
    resIsta = nshaarwtrec2(y,s);
    set(hi,'CData',resIsta)
    set(ht,'String',sprintf('�����摜(ISTA)�FPSNR = %5.2f [dB]',psnr(src,resIsta)))
    drawnow    
end