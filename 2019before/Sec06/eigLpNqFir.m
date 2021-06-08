function h = eigLpNqFir(order,passBandEdge,stopBandEdge,...
    alpha,factor)
% eigLpNqFir : 固有フィルタ設計 (Type I、ナイキストフィルタ)
%
%   h = eigLpNqFir(...
%                order,passBandEdge,stopBandEdge,alpha,factor)
%
%   order        : フィルタ次数 (偶数)
%   passBandEdge : 通過域端 (ナイキスト周波数を1.0として)
%   stopBandEdge : 阻止域端 (ナイキスト周波数を1.0として)
%   alpha        : 通過域と阻止域の重み(0.0<alpha<1.0)
%   factor       : 0 係数間隔(正整数)
%   h            : インパルス応答
%
%   フィルタ次数 order、通過域端 passBandEdge、
%   阻止域端 stopBandEdge、重みパラメータalpha を与えると、
%   固有フィルタ設計法により低域通過フィルタを作成し、
%   h としてインパルス応答を出力。
%
% $Id: eigLpNqFir.m,v 1.2 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2006-2007 Shogo MURAMATSU, All rights reserved
%
narginchk(5,5);

if rem(order,2) ~= 0
    err('次数は偶数でなければなりません。');
end
if (passBandEdge > stopBandEdge)
    err('通過域端は、阻止域端より低くなければなりません。');
end

% 独立なフィルタ係数の数
nCoefficients = order/2;

% 通過域端の換算（正規化角周波数）
omegaPass = passBandEdge * pi;
% 阻止域端の換算（正規化角周波数）
omegaStop = stopBandEdge * pi;

% 行列Q, Pの生成
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

% 行列Rの生成（実、対称の正定値行列）
R = alpha * P + (1-alpha) * Q;

% 係数ベクトルの準備（初期値をランダムに設定）
b = rand(nCoefficients+1,1);
b = makeNyquistFilter(b,factor);
b = b/norm(b);

% 最小固有値に対応する固有ベクトルの計算
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
