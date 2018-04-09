% practice07_4.m
%
% $Id: practice07_4.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%
% practice07_4.m
%
% $Id: practice07_4_ip.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

isImg = false;
isEye = false;

%% �ϊ��s��i�s�A�񋤒ʁj
if isEye
    A = eye(2);
else
    A = [ 1 1 ;
        -1 1 ]/sqrt(2);
end

%% �ʎq���e�[�u��
Qfactor = 1;
if isEye
    Q = Qfactor*[ 2 2 ; %#ok
        2 2 ];
else
    Q = Qfactor*[ 1 2 ;
        2 4 ];
end


%% �摜�z��i���m�N���摜�j
if isImg
    pictureOrg = rgb2gray(imread('./data/barbaraFaceRgb.tif'));
else
    pictureOrg = [ 2 2 3 1 ;
        2 2 3 1 ;
        3 3 2 0 ;
        1 1 0 2 ];
end


%% �u���b�N����
% �u���b�N����
nRows = size(pictureOrg,1);
nCols = size(pictureOrg,2);
clear pictureRec;
for iRow = 1:2:nRows
    for iCol = 1:2:nCols
        % �u���b�N���o
        X = double(pictureOrg(iRow:iRow+1,iCol:iCol+1));
        % ���ϊ�
        Y = A*X*A.';
        % �ʎq��
        S = round(Y./Q);
        % �t�ʎq��
        Y = Q.*S;
        % �t�ϊ�
        X = A.'*Y*A;
        % �u���b�N�z�u
        pictureRec(iRow:iRow+1,iCol:iCol+1) = uint8(X);
    end
end

%% �摜�̕\��
if isImg
    figure(1) %#ok
    imshow(pictureOrg)
    title('Original picture')
    
    figure(2)
    imshow(pictureRec)
    title('Reconstructed picture')
else
    disp('pictureOrg')
    disp(pictureOrg)
    disp('pictureRec')
    disp(pictureRec)
end
