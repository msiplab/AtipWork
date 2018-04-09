% practice_a_14.m
%
% $Id:$
%
% Copyright (C) 2012-2015 Shogo MURAMATSU, All rights reserved
%

%% �E�F�[�u���b�g�i��
nlevels = 3;

%% ���摜�̓ǂݍ���
%xs = im2double(imread('./data/org.tif'));
xs = im2double(imread('cameraman.tif'));
subplot(1,3,1), imshow(xs)
title('���摜')

%% ���͏����i�Ώ̒����E�F�[�u���b�g�ϊ��j
[valueC,valueS] = sowtdec2(xs,nlevels);

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
subplot(1,3,2), imshow(c0)
title('�ϊ��W��')

%% ���������i�Ώ̒����E�F�[�u���b�g�ϊ��j
xr = sowtrec2(valueC,valueS);

%% �p�[�Z�o���̓����̊m�F
fprintf('||x||^2 = %f\n', norm(xs(:))^2);
fprintf('||y||^2 = %f\n', norm(valueC(:))^2);

%% PSNR
psnr = -10*log10(sum((xs(:)-xr(:)).^2));
fprintf('PSNR: %6.2f[dB]\n',psnr);
subplot(1,3,3), imshow(xr)
title('�č\���摜')