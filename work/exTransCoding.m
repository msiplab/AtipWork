%
% $Id: exTransCoding.m,v 1.2 2006/05/29 12:08:53 sho Exp $
%
% Copyright (C) 2005-2006 Shogo MURAMATSU, All rights reserved
%

% 変換行列（行、列共通）
A = [ 1 1 ; 
     -1 1 ]/sqrt(2); 

% 量子化テーブル
Q = [ 1 2 ;
      2 4 ];

% 画像配列（モノクロ画像）
pictureOrg = rgb2gray(imread('./data/barbaraFaceRgb.tif'));
    
% ブロック処理
fun = inline('A.''*(Q.*(round((A*double(X)*A.'')./Q)))*A','X','A','Q');
pictureRec = uint8(blkproc(pictureOrg,[2 2],fun,A,Q));

% 画像の表示
figure(1);
imshow(pictureOrg);
title('Original picture');

figure(2);
imshow(pictureRec);
title('Reconstructed picture');
