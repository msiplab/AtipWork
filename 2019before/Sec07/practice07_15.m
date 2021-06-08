% practice07_15.m
%
% $Id: practice07_15.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% 画像の読込
pictureRgb = imread('./data/barbaraFaceRgb.tif');

%% モノクロ画像への変換
pictureGray = rgb2graycq(im2double(pictureRgb));

%% 3レベル 5/3 DWT
[subLL2,subHL2,subLH2,subHH2] = im53trnscq(pictureGray);
[subLL1,subHL1,subLH1,subHH1] = im53trnscq(subLL2);
[subLL0,subHL0,subLH0,subHH0] = im53trnscq(subLL1);

%% サブバンド画像の表示
subband0 = [subLL0 4*abs(subHL0) ; 
    4*abs(subLH0) 4*abs(subHH0)];
subband1 = [subband0 4*abs(subHL1) ; 
    4*abs(subLH1) 4*abs(subHH1)];
subband2 = [ subband1 4*abs(subHL2);
    4*abs(subLH2) 4*abs(subHH2) ];
figure(1)
imshow(subband2)

%% 3レベル 5/3 IDWT
subLL1 = im53itrnscq(subLL0,subHL0,subLH0,subHH0);
subLL2 = im53itrnscq(subLL1,subHL1,subLH1,subHH1);
pictureRec = im53itrnscq(subLL2,subHL2,subLH2,subHH2);

%% 復元画像の表示
figure(2)
imshow(pictureRec)

% end