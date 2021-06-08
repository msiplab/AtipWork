function h = eigLpNqFir(order,passBandEdge,stopBandEdge,...
    alpha,factor)
% eigLpNqFir : �ŗL�t�B���^�݌v (Type I�A�i�C�L�X�g�t�B���^)
%
%   h = eigLpNqFir(...
%                order,passBandEdge,stopBandEdge,alpha,factor)
%
%   order        : �t�B���^���� (����)
%   passBandEdge : �ʉ߈�[ (�i�C�L�X�g���g����1.0�Ƃ���)
%   stopBandEdge : �j�~��[ (�i�C�L�X�g���g����1.0�Ƃ���)
%   alpha        : �ʉ߈�Ƒj�~��̏d��(0.0<alpha<1.0)
%   factor       : 0 �W���Ԋu(������)
%   h            : �C���p���X����
%
%   �t�B���^���� order�A�ʉ߈�[ passBandEdge�A
%   �j�~��[ stopBandEdge�A�d�݃p�����[�^alpha ��^����ƁA
%   �ŗL�t�B���^�݌v�@�ɂ����ʉ߃t�B���^���쐬���A
%   h �Ƃ��ăC���p���X�������o�́B
%
% $Id: eigLpNqFir.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2006-2007 Shogo MURAMATSU, All rights reserved
%
narginchk(5,5);

if rem(order,2) ~= 0
    err('�����͋����łȂ���΂Ȃ�܂���B');
end
if (passBandEdge > stopBandEdge)
    err('�ʉ߈�[�́A�j�~��[���Ⴍ�Ȃ���΂Ȃ�܂���B');
end

% �Ɨ��ȃt�B���^�W���̐�
nCoefficients = order/2;

% �ʉ߈�[�̊��Z�i���K���p���g���j
omegaPass = passBandEdge * pi;
% �j�~��[�̊��Z�i���K���p���g���j
omegaStop = stopBandEdge * pi;

% �s��Q, P�̐���
Q = zeros(nCoefficients+1);
P = zeros(nCoefficients+1);
for iRowCoef = 1:nCoefficients+1
    m=iRowCoef-1;
    for iColCoef = 1:nCoefficients+1
        n=iColCoef-1;
        if m==n
            if m==0
                Q(iRowCoef,iColCoef) = 0;
                P(iRowCoef,iColCoef) = 1-omegaStop/pi;
            else
                Q(iRowCoef,iColCoef) = 1/pi * ...
                    (3/2 * omegaPass ...
                        - 2*sin(m*omegaPass)/m ...
                        + sin(2*m*omegaPass)/(4*m) );           
                P(iRowCoef,iColCoef) = 1/(2*pi) * ...
                    ( pi - omegaStop ...
                        - sin(2*m*omegaStop)/(2*m) );
            end
        else
           if m==0 || n==0
               Q(iRowCoef,iColCoef) = 0;    
           else
               Q(iRowCoef,iColCoef) = 1/pi * ...
                    (omegaPass ...
                        - ( sin(m*omegaPass)/m + sin(n*omegaPass)/n) ...
                        + sin( (m+n)*omegaPass ) / (2 * (m+n) )...
                        + sin( (m-n)*omegaPass ) / (2 * (m-n) ) );
           end
           P(iRowCoef,iColCoef) = 1/(2*pi) * ...
                ( ( - sin( (m+n)*omegaStop )/(m+n) ) ...
                    + ( - sin( (m-n)*omegaStop )/(m-n) ) );
        end
    end
end

% �s��R�̐����i���A�Ώ̂̐���l�s��j
R = alpha * P + (1-alpha) * Q;

% �W���x�N�g���̏����i�����l�������_���ɐݒ�j
b = rand(nCoefficients+1,1);
b = makeNyquistFilter(b,factor);
b = b/norm(b);

% �ŏ��ŗL�l�ɑΉ�����ŗL�x�N�g���̌v�Z
previousCoefficients = zeros(size(b));
epsilon = Inf;
while (epsilon > 1e-9)
    b = R\b;
    b = makeNyquistFilter(b,factor);
    b = b/norm(b);
    epsilon = norm(b - previousCoefficients);
    previousCoefficients = b;
end

h = [flipud(b(2:nCoefficients+1)); 2 * b(1) ;b(2:nCoefficients+1)]; 
h = h/sum(h);

%---
function y = makeNyquistFilter(x,factor)

if factor > 1
    y = zeros(size(x));
    for idx=1:length(x)
        if (idx==1 || rem(idx-1,factor) ~=0)
            y(idx) = x(idx);
        else
            y(idx) = 0;
        end
    end
else
    y = x;
end
y = y(:);
