% practice_a_12.m
%
% $Id:$
%
% Copyright (C) 2012-2015 Shogo MURAMATSU, All rights reserved
%

%% �z��̐ݒ�
nRows = 2;
nCols = 3;
X = rand(nRows,nCols);
fprintf('�摜 X\n')
disp(X)

%% ��l�}�����̐ݒ�
L = [ 2 2 ]; % [ ������l�}���� ������l�}���� ]
fprintf('��l�}����(���� ����) L\n')
disp(L)

%% ��l�}������
Y = upsample(upsample(X,L(1)).',L(2)).';
fprintf('�摜 Y\n')
disp(Y)

%% �摜X�̗�x�N�g����
x = X(:);

%% ��l�}���s��̐���
nPixels = prod(L)*nRows*nCols;
I = eye(nPixels);
idx = [];
for iCol = 1:nCols*L(2)
    for iRow = 1:nRows*L(1)
        if mod(iCol-1,L(2))==0 && mod(iRow-1,L(1))==0 
            k = (iCol-1)*nRows*L(1)+iRow;
            idx = union(idx,k);
        end
    end
end
U = I(idx,:).';
fprintf('��l�}���s�� U\n')
disp(U)

%% ��l�}�������i�s�񉉎Z�j
y = U*x;

%% �]��
disp('��l�}�������i�s�񉉎Z�j�̕]������')
mse = sum((Y(:)-y).^2)/numel(Y);
fprintf('mse = %f\n',mse);
