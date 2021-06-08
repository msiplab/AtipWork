% practice06_1.m
%
% $Id: practice06_1.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% ŠÔˆø‚«—¦
% …•½‚ÌŠÔˆø‚«—¦
horizontalDecFactor = 2;
% ‚’¼‚ÌŠÔˆø‚«—¦
verticalDecFactor = 2;

%% ‰æ‘œ‚Ì“Ç
pictureRgb = imread('./data/barbaraFaceRgb.tif');
pictureGray = rgb2graycq(pictureRgb);
clear pictureRgb;

%% ŠÔˆø‚«ˆ—
pictureGrayDownsampled = pictureGray(...
            1:verticalDecFactor:end,...
            1:horizontalDecFactor:end);
% pictureGrayDownsampled = ...
%     downsample(downsample(pictureGray,...
%                           vDecFactor).',...
%                hDecFactor).';

%% Œ´‰æ‘œ‚Ì•\¦
figure(1)
imshowcq(pictureGray)
title('Original picture')

%% ŠÔˆø‚«ˆ—Œã‚Ì‰æ‘œ‚Ì•\¦
figure(2)
imshowcq(pictureGrayDownsampled)
title('Downsampled picture')

% end
