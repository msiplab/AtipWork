%[text] # Sample 3-1
%[text] ## 平滑化／先鋭化処理
%[text] 内積とノルム 
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Image smoothing/sharpening
%[text] Inner product and norm
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ### $N$次元ベクトルの内積
%[text] (Inner product of $N$-dimensional vectors)
%[text]{"align":"center"} $\\langle \\mathbf{u},\\mathbf{v}\\rangle=\\sum\_{i=0}^{N-1}u\_{i}v\_{i}$
%[text] ただし， $u\_i, v\_i$はベクトル $\\mathbf{u}, \\mathbf{v}\\in\\mathbb{R}^{N}$ の $i$-番目要素 $\[\\mathbf{u}\]\_i,$$\[\\mathbf{v}\]\_i$。
%[text] (where $u\_i, v\_i$ are the $i$-th element of vector $\\mathbf{u}, \\mathbf{v}\\in\\mathbb{R}^{N}$ , i.e.,  $\[\\mathbf{u}\]\_i,$$\[\\mathbf{v}\]\_i$, respectively.)
% Generate an two-dimensional vector u 
u1 = -1; %[control:slider:5337]{"position":[6,8]}
u2 = 1; %[control:slider:63f2]{"position":[6,7]}
u = [u1, u2].'
% Generate an two-dimensional vector v 
v1 = 1; %[control:slider:49b3]{"position":[6,7]}
v2 = 1; %[control:slider:5ffa]{"position":[6,7]}
v = [v1, v2].'
% Inner product of vectors u and v
innerprod = dot(u,v);
disp(['<u,v> = ' num2str(innerprod)])
% Plot vector v with the contour plot of lp-norm
figure(1)
plotv([u v],'-')
title('Vectors {\bf u} and {\bf v}')
xlabel('u_1, v_1')
ylabel('u_2, v_2')
colormap('default')
axis equal
axis([-3 3 -3 3])
grid on
%%
%[text] ### ベクトルとしてみた$N\_1 \\times N\_2$配列の 内積
%[text] (Inner product of $N\_1 \\times N\_2$ arrays as vector)
%[text]{"align":"center"} $\\langle\\mathbf{u},\\mathbf{v}\\rangle=\\sum\_{j=0}^{N\_2-1}\\sum\_{i=0}^{N\_1-1}u\_{i,j}v\_{i,j}$
%[text] ただし， $u\_{i,j}, v\_{i,j}$はベクトル $\\mathbf{u}, \\mathbf{v}\\in\\mathbb{R}^{N\_1\\times N\_2}$ の $i,j$-番目要素 $\[\\mathbf{u}\]\_{i,j},\[\\mathbf{v}\]\_{i,j}$。
%[text] ( where $u\_{i,j}, v\_{i,j}$ are the $i,j$-th element of vector $\\mathbf{u}, \\mathbf{v}\\in\\mathbb{R}^{N}$ , i.e.,  $\[\\mathbf{u}\]\_{i,j},\[\\mathbf{v}\]\_{i,j}$, respectively.)
% Array dimension
ndim1 = 2; %[control:slider:8d09]{"position":[9,10]}
ndim2 = 2; %[control:slider:5fc1]{"position":[9,10]}
% Generate a N1xN2 arrya v with normally distributed random numbers
u = randn(ndim1,ndim2)
v = randn(ndim1,ndim2)
% Visualization of array u
figure(2)
subplot(1,2,1)
imagesc(u)
title('Array {\bf u}')
colormap('gray')
colorbar
axis equal
axis off

% Visualization of array v
subplot(1,2,2)
imagesc(v)
title('Array {\bf v}')
colormap('gray')
colorbar
axis equal
axis off
%%
% Inner product of arrays u and v as vectors
innerprod = dot(u(:),v(:));
disp(['<u,v> = ' num2str(innerprod)])
%%
%[text] ### $N$次元ベクトルの $\\ell\_p$-ノルム
%[text] ($\\ell\_p$-norm of a $N$-dimensional vector)
%[text]{"align":"center"} $\\|\\mathbf{v}\\|\_{p}=\\left(\\sum\_{i=0}^{N-1}\\left|v\_{i}\\right|^{p}\\right)^{\\frac{1}{p}}$
%[text] ただし， $v\_i$はベクトル $\\mathbf{v}\\in\\mathbb{R}^{N}$ の $i$-番目要素 $\[\\mathbf{v}\]\_i$。
%[text] (where $v\_i$ stands for the $i$-th element of vector $\\mathbf{v}\\in\\mathbb{R}^{N}$ , i.e.,  $\[\\mathbf{v}\]\_i$.)
% Generate an two-dimensional vector v 
v1 = 1; %[control:slider:201a]{"position":[6,7]}
v2 = 1; %[control:slider:5e20]{"position":[6,7]}
v = [v1, v2].'
% Setting of parameter p
p = 1; %[control:slider:9685]{"position":[5,6]}

% lp-norm of v
lpnorm = norm(v,p);
disp(['||v||_' num2str(p) ' = ' num2str(lpnorm)])
% Plot vector v with the contour plot of lp-norm
figure(3)
plotv(v,'-')
title('Vector {\bf v}')
xlabel('v_1')
ylabel('v_2')
colormap('default')
axis equal
axis([-3 3 -3 3])
grid on
hold on
% Contour plot of lp-norm
fcontour(@(v1,v2) vecnorm([v1(:) v2(:)].',p),[-3 3 -3 3])
colorbar
hold off
%%
%[text] ### ベクトルとしてみた$N\_1 \\times N\_2$配列の $\\ell\_p$-ノルム
%[text] ($\\ell\_p$-norm of a $N\_1 \\times N\_2$ array as a vector)
%[text]{"align":"center"} $\\|\\mathbf{v}\\|\_{p}=\\left(\\sum\_{j=0}^{N\_2-1}\\sum\_{i=0}^{N\_1-1}\\left|v\_{i,j}\\right|^{p}\\right)^{\\frac{1}{p}}$
%[text] ただし， $v\_{i,j}$はベクトルとしてみた配列 $\\mathbf{v}\\in\\mathbb{R}^{N\_1\\times N\_2}$ の $i,j$-番目要素 $\[\\mathbf{v}\]\_{i,j}$。
%[text] (where $v\_{i,j}$ stands for the $i,j$-th element of array $\\mathbf{v}$ as a vector, i.e.,  $\[\\mathbf{v}\]\_{i,j}$.)
% Array dimension
ndim1 = 2; %[control:slider:1787]{"position":[9,10]}
ndim2 = 2; %[control:slider:43a1]{"position":[9,10]}
% Generate a N1xN2 arrya v with normally distributed random numbers
v = randn(ndim1,ndim2)
% Visualization of array v
figure(4)
imagesc(v)
title('Array {\bf v}')
colormap('gray')
colorbar
axis equal
axis off
%%
% Setting of parameter p
p = 1; %[control:slider:69c4]{"position":[5,6]}

% lp-(element-wise) norm of v
lpnorm = norm(v(:),p);
disp(['||v||_' num2str(p) ' = ' num2str(lpnorm)])
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:5337]
%   data: {"defaultValue":-1,"label":"v1","max":3,"min":-3,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:63f2]
%   data: {"defaultValue":1,"label":"v2","max":3,"min":-3,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:49b3]
%   data: {"defaultValue":1,"label":"v1","max":3,"min":-3,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:5ffa]
%   data: {"defaultValue":1,"label":"v2","max":3,"min":-3,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:8d09]
%   data: {"defaultValue":2,"label":"ndim","max":8,"min":1,"run":"Section","runOn":"ValueChanging","step":1}
%---
%[control:slider:5fc1]
%   data: {"defaultValue":2,"label":"ndim","max":8,"min":1,"run":"Section","runOn":"ValueChanging","step":1}
%---
%[control:slider:201a]
%   data: {"defaultValue":1,"label":"v1","max":3,"min":-3,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:5e20]
%   data: {"defaultValue":1,"label":"v2","max":3,"min":-3,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:9685]
%   data: {"defaultValue":1,"label":"p","max":16,"min":1,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:1787]
%   data: {"defaultValue":2,"label":"ndim","max":8,"min":1,"run":"Section","runOn":"ValueChanging","step":1}
%---
%[control:slider:43a1]
%   data: {"defaultValue":2,"label":"ndim","max":8,"min":1,"run":"Section","runOn":"ValueChanging","step":1}
%---
%[control:slider:69c4]
%   data: {"defaultValue":1,"label":"p","max":16,"min":1,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
