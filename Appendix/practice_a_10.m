% practice_a_10.m
%
% $Id:$
%
% Copyright (C) 2012-2015 Shogo MURAMATSU, All rights reserved
%

%% �z��̐ݒ�
nRows = 3;
nCols = 4;
X = rand(nRows,nCols);
fprintf('�摜 X\n')
disp(X)

%% �t�B���^�̐ݒ�
h = [ 1 2; 3 4 ];
fprintf('�C���p���X���� h\n')
disp(h)

%% ���]�t�B���^�̐ݒ�
f = rot90(h,2);
fprintf('�C���p���X���� f\n')
disp(f)

%% ���]�t�B���^�ɂ��i����j�􍞂݉��Z
Y = imfilter(X,f,'conv','circ');
fprintf('�摜 Y\n')
disp(Y)

%% �摜X�̗�x�N�g����
x = X(:);

%% �i����j�􍞂ݍs��̐���
nPixels = nRows*nCols;
H = zeros(nPixels,nPixels);
imph = zeros(nRows,nCols);
imph(1:size(h,1),1:size(h,2)) = h;
imph = circshift(imph,-floor(size(h)/2));
for n = 1:nPixels
    for k = 1:nPixels
        iRow = mod(mod(n-1,nRows) - mod(k-1,nRows), nRows) + 1;
        iCol = mod(floor((n-1)/nRows) - floor((k-1)/nRows), nCols) + 1;
        H(n,k) = imph(iRow,iCol);
    end
end
fprintf('�􍞂ݍs�� H\n')
disp(H)

%% �]�u�s��̐ݒ�
F = H.';
fprintf('�]�u�􍞂ݍs�� F\n')
disp(F)

%% �i����j�􍞂݉��Z
y = F*x;
U = circshift(reshape(y,nRows,nCols),-mod(floor(size(h.')/2),2)); % �ʒu����

%% �]��
disp('���]�t�B���^�����O�̍s�񉉎Z�]������')
mse = sum((Y(:)-U(:)).^2)/numel(Y);
fprintf('mse = %f\n',mse);
