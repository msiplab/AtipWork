%[text] # Sample 5-3
%[text] ## 周波数解析
%[text] 2変量信号の周波数
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Fourier analysis
%[text] Frequency of bivariate signals
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ### 二変量余弦波の定義
%[text] (Definition of bivariate cosine wave)
%[text]  $\\cos(\\mathbf{\\Omega}^T\\mathbf{p})=\\cos(\\Omega\_1 p\_1 + \\Omega\_2 p\_2)$
%[text] ただし，(where)
%[text]  $\\mathbf{\\Omega} = \\left(\\begin{array}{c} \\Omega\_1 \\\\ \\Omega\_2 \\end{array}\\right)\\in\\mathbb{R}^2$
%[text]  $\\mathbf{p} = \\left(\\begin{array}{c} p\_1 \\\\ p\_2 \\end{array}\\right)\\in\\mathbb{R}^2$
%%
%[text] ### 二変量角周波数の設定
%[text] (Bivariate angular frequency setting)
% Vertical angular frequency
f1 = 1; %[control:slider:0435]{"position":[6,7]}
Omega1 = 2*pi*f1;
% Horizontal angular frequnecy
f2 = 2; %[control:slider:0351]{"position":[6,7]}
Omega2 = 2*pi*f2;

% Definition of sampling points
[p2,p1] = meshgrid(-0.5:0.01:0.5,-0.5:0.01:0.5);

% Definition of a bivariate cosine wave
x = cos(Omega1*p1 + Omega2*p2);
%%
%[text] ### 二変量余弦波の表示
%[text] (Bivariate cosine wave display)
% Display of a bivariate cosine wave
surf(p2,p1,x)
xlabel('p_2')
ylabel('p_1')
zlabel('cos({\bf\Omega}^T{\bfp})')
title(['{\bf \Omega} =(' num2str(Omega1/pi) '\pi,' num2str(Omega2/pi) '\pi)^T'])
colormap gray
shading interp
axis([-0.5 0.5 -0.5 0.5 -2 2])
axis ij
axis vis3d
%[text] #### 表示を回転
%[text] (Rotate the display)
%{
stepAngle = 2;
for iAngle=1:stepAngle:360
    camorbit(0,stepAngle,'camera');
    drawnow
end
%}
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:0435]
%   data: {"defaultValue":1,"label":"Omega1","max":6,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:0351]
%   data: {"defaultValue":2,"label":"Omega2","max":6,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
