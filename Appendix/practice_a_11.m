% practice_a_11.m
%
% $Id:$
%
% Copyright (C) 2012-2015 Shogo MURAMATSU, All rights reserved
%

%% �z��̐ݒ�
nRows = 4;
nCols = 6;
X = rand(nRows,nCols);
fprintf('�摜 X\n')
disp(X)

%% �Ԉ������̐ݒ�
L = [ 2 2 ]; % [ �����Ԉ����� �����Ԉ����� ]
fprintf('�Ԉ�����(���� ����) L\n')
disp(L)

%% �Ԉ�������
Y = downsample(downsample(X,L(1)).',L(2)).';
fprintf('�摜 Y\n')
disp(Y)

%% �摜X�̗�x�N�g����
x = X(:);

%% �Ԉ����s��̐���
nPixels = nRows*nCols;
I = eye(nPixels);
idx = [];
for iCol = 1:nCols
    for iRow = 1:nRows
        if mod(iCol-1,L(2))==0 && mod(iRow-1,L(1))==0 
            k = (iCol-1)*nRows+iRow;
            idx = union(idx,k);
        end
    end
end
S = I(idx,:);
fprintf('�Ԉ����s�� S\n')
disp(S)

%% �Ԉ��������i�s�񉉎Z�j
y = S*x;

%% �]��
disp('�Ԉ��������i�s�񉉎Z�j�̕]������')
mse = sum((Y(:)-y).^2)/numel(Y);
fprintf('mse = %f\n',mse);
