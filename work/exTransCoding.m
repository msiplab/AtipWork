%
% $Id: exTransCoding.m,v 1.2 2006/05/29 12:08:53 sho Exp $
%
% Copyright (C) 2005-2006 Shogo MURAMATSU, All rights reserved
%

% �ϊ��s��i�s�A�񋤒ʁj
A = [ 1 1 ; 
     -1 1 ]/sqrt(2); 

% �ʎq���e�[�u��
Q = [ 1 2 ;
      2 4 ];

% �摜�z��i���m�N���摜�j
pictureOrg = rgb2gray(imread('./data/barbaraFaceRgb.tif'));
    
% �u���b�N����
fun = inline('A.''*(Q.*(round((A*double(X)*A.'')./Q)))*A','X','A','Q');
pictureRec = uint8(blkproc(pictureOrg,[2 2],fun,A,Q));

% �摜�̕\��
figure(1);
imshow(pictureOrg);
title('Original picture');

figure(2);
imshow(pictureRec);
title('Reconstructed picture');
