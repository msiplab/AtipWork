%[text] # Sample 3-1: Inner product and norm
%[text] Advanced Topics in Image Processing, Lecture 3 "Image Smoothing and Sharpening"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Inner product of $N$-dimensional vectors
%[text]{"align":"center"} $\\langle \\mathbf{u},\\mathbf{v}\\rangle=\\sum\_{i=0}^{N-1}u\_{i}v\_{i}$
%[text] where $u\_i, v\_i$ are the $i$-th elements $\[\\mathbf{u}\]\_i$, $\[\\mathbf{v}\]\_i$ of the vectors
%[text] $\\mathbf{u}, \\mathbf{v}\\in\\mathbb{R}^{N}$ (\[M\] Definition "Inner product of multidimensional arrays", Section 1.2.1).
% Two-dimensional vector u
u1 = -1; %[control:slider:9d7e]{"position":[6,8]}
u2 = 1; %[control:slider:088b]{"position":[6,7]}
u = [u1, u2].'
% Two-dimensional vector v
v1 = 1; %[control:slider:6f14]{"position":[6,7]}
v2 = 1; %[control:slider:0844]{"position":[6,7]}
v = [v1, v2].'
% Inner product of vectors u and v
innerprod = dot(u,v);
disp("<u,v> = " + innerprod)
% Plot vectors u and v
figure
quiver([0 0], [0 0], [u(1) v(1)], [u(2) v(2)], 0, "LineWidth", 1.5)
text(u(1), u(2), " u"), text(v(1), v(2), " v")
title('Vectors {\bf u} and {\bf v}')
xlabel('u_1, v_1')
ylabel('u_2, v_2')
axis equal
axis([-3 3 -3 3])
grid on
%%
%[text] ## Inner product of $N\_1 \\times N\_2$ arrays as vectors
%[text]{"align":"center"} $\\langle\\mathsf{u},\\mathsf{v}\\rangle=\\sum\_{n\_2=0}^{N\_2-1}\\sum\_{n\_1=0}^{N\_1-1}u\[n\_1,n\_2\]v\[n\_1,n\_2\]$
%[text] where $u\[n\_1,n\_2\], v\[n\_1,n\_2\]$ are the elements of the arrays $\\mathsf{u}, \\mathsf{v}\\in\\mathbb{R}^{N\_1\\times N\_2}$.
% Array dimension
ndim1 = 2; %[control:slider:0666]{"position":[9,10]}
ndim2 = 2; %[control:slider:95d6]{"position":[9,10]}
% Generate N1xN2 arrays with normally distributed random numbers
u = randn(ndim1,ndim2)
v = randn(ndim1,ndim2)
% Visualization of the arrays u and v
figure
tiledlayout(1,2)
nexttile
imagesc(u)
title('Array {\sf u}')
colormap('gray')
colorbar
axis equal off
nexttile
imagesc(v)
title('Array {\sf v}')
colormap('gray')
colorbar
axis equal off
%%
% Inner product of arrays u and v as vectors (column vectorization u(:))
innerprod = dot(u(:),v(:));
disp("<u,v> = " + innerprod)
%%
%[text] ## $\\ell\_p$-norm of an $N$-dimensional vector
%[text]{"align":"center"} $\\|\\mathbf{v}\\|\_{p}=\\left(\\sum\_{i=0}^{N-1}\\left|v\_{i}\\right|^{p}\\right)^{\\frac{1}{p}}$
%[text] where $v\_i$ is the $i$-th element $\[\\mathbf{v}\]\_i$ of the vector $\\mathbf{v}\\in\\mathbb{R}^{N}$ (\[M\] Appendix A.1).
% Two-dimensional vector v
v1 = 1; %[control:slider:8fc4]{"position":[6,7]}
v2 = 1; %[control:slider:91d7]{"position":[6,7]}
v = [v1, v2].'
% Parameter p
p = 1; %[control:slider:5a6a]{"position":[5,6]}

% lp-norm of v
lpnorm = norm(v,p);
disp("||v||_" + p + " = " + lpnorm)
% Plot vector v with the contour plot of the lp-norm
figure
quiver(0, 0, v(1), v(2), 0, "LineWidth", 1.5)
title('Vector {\bf v}')
xlabel('v_1')
ylabel('v_2')
axis equal
axis([-3 3 -3 3])
grid on
hold on
% Contour plot of the lp-norm
fcontour(@(v1,v2) reshape(vecnorm([v1(:) v2(:)].',p),size(v1)),[-3 3 -3 3])
colorbar
hold off
%%
%[text] ## $\\ell\_p$-norm of an $N\_1 \\times N\_2$ array as a vector
%[text]{"align":"center"} $\\|\\mathsf{v}\\|\_{p}=\\left(\\sum\_{n\_2=0}^{N\_2-1}\\sum\_{n\_1=0}^{N\_1-1}\\left|v\[n\_1,n\_2\]\\right|^{p}\\right)^{\\frac{1}{p}}$
%[text] For $p=2$ this is the Frobenius norm of the array as a matrix, which differs from the spectral norm `norm(v)`.
% Array dimension
ndim1 = 2; %[control:slider:9663]{"position":[9,10]}
ndim2 = 2; %[control:slider:1c4d]{"position":[9,10]}
% Generate an N1xN2 array with normally distributed random numbers
v = randn(ndim1,ndim2)
% Visualization of array v
figure
imagesc(v)
title('Array {\sf v}')
colormap('gray')
colorbar
axis equal off
%%
% Parameter p
p = 1; %[control:slider:6a04]{"position":[5,6]}

% lp-norm of v as a vector (element-wise)
lpnorm = norm(v(:),p);
disp("||v||_" + p + " = " + lpnorm)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:9d7e]
%   data: {"defaultValue":-1,"label":"u1","max":3,"min":-3,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:088b]
%   data: {"defaultValue":1,"label":"u2","max":3,"min":-3,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:6f14]
%   data: {"defaultValue":1,"label":"v1","max":3,"min":-3,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:0844]
%   data: {"defaultValue":1,"label":"v2","max":3,"min":-3,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:0666]
%   data: {"defaultValue":2,"label":"ndim1","max":8,"min":1,"run":"Section","runOn":"ValueChanging","step":1}
%---
%[control:slider:95d6]
%   data: {"defaultValue":2,"label":"ndim2","max":8,"min":1,"run":"Section","runOn":"ValueChanging","step":1}
%---
%[control:slider:8fc4]
%   data: {"defaultValue":1,"label":"v1","max":3,"min":-3,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:91d7]
%   data: {"defaultValue":1,"label":"v2","max":3,"min":-3,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:5a6a]
%   data: {"defaultValue":1,"label":"p","max":16,"min":1,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
%[control:slider:9663]
%   data: {"defaultValue":2,"label":"ndim1","max":8,"min":1,"run":"Section","runOn":"ValueChanging","step":1}
%---
%[control:slider:1c4d]
%   data: {"defaultValue":2,"label":"ndim2","max":8,"min":1,"run":"Section","runOn":"ValueChanging","step":1}
%---
%[control:slider:6a04]
%   data: {"defaultValue":1,"label":"p","max":16,"min":1,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
