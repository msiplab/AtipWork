% practice_a_9.m
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

%% �i����j�􍞂݉��Z
Y = imfilter(X,h,'conv','circ');
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

%% �i����j�􍞂݉��Z
y = H*x;

%% �]��
disp('���`�t�B���^�����O�̍s�񉉎Z�]������')
mse = sum((Y(:)-y).^2)/numel(Y);
fprintf('mse = %f\n',mse);
