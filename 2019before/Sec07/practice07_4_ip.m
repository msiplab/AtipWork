% practice07_4.m
%
% $Id: practice07_4_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

isImg = false;
isEye = false;

%% 変換行列（行、列共通）
if isEye
    A = eye(2); k
else
    A = [ 1 1 ;
        -1 1 ]/sqrt(2);
end

%% 量子化テーブル
Qfactor = 1;
if isEye
    Q = Qfactor*[ 2 2 ; %#ok
        2 2 ];
else
    Q = Qfactor*[ 1 2 ;
        2 4 ];
end


%% 画像配列（モノクロ画像）
if isImg
    pictureOrg = rgb2gray(imread('./data/barbaraFaceRgb.tif')); 
else
    pictureOrg = [ 2 2 3 1 ; 
        2 2 3 1 ;
        3 3 2 0 ;
        1 1 0 2 ];
end


%% ブロック処理
fun = @(X) A.'*(Q.*(round((A*double(X.data)*A.')./Q)))*A;
pictureRec = uint8(blockproc(pictureOrg,[2 2],fun));

%% 画像の表示
if isImg
    figure(1) %#ok
    imshow(pictureOrg)
    title('Original picture')
    
    figure(2)
    imshow(pictureRec)
    title('Reconstructed picture')
    
    disp('PSNR')
    disp(psnr(pictureOrg,pictureRec))
else
    disp('pictureOrg')
    disp(pictureOrg)
    disp('pictureRec')
    disp(pictureRec)
end
