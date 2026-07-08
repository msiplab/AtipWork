%[text] # Sample 5-6
%[text] ## 周波数解析
%[text] 多変量循環畳み込み
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Fourier analysis
%[text] Multivariate circular convolution
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ### サンプル画像$\\{u\[\\mathbf{n}\]\\}\_\\mathbf{n}\n$の準備
%[text] (Preparation of sample image $\\{u\[\\mathbf{n}\]\\}\_\\mathbf{n}\n$)
% Reading original image
u = im2double(imread('cameraman.tif'));
figure(1)
imshow(u)
title('Original')
%%
%[text] ### 線形シフト不変システムのインパルス応答 $\\{h\[\\mathbf{n}\]\\}\_\\mathbf{n}\n$ 
%[text] (Impulse response of a linear shift-invariant system $\\{h\[\\mathbf{n}\]\\}\_\\mathbf{n}\n$
% Impulse response h[n]
hsize1 = 3; %[control:slider:3db3]{"position":[10,11]}
hsize2 = 3; %[control:slider:9d76]{"position":[10,11]}
sigma = 1; %[control:slider:31bb]{"position":[9,10]}
ftype = "log"; %[control:dropdown:3e02]{"position":[9,14]}
h = rot90(fspecial(ftype,[hsize1 hsize2],sigma),2);
figure(2)
[n1,n2] = meshgrid(-floor((hsize2-1)/2):ceil((hsize2-1)/2),-floor((hsize1-1)/2):ceil((hsize1-1)/2));
stem3(n1,n2,h,'filled')
xlabel('n_2')
ylabel('n_1')
axis ij
title(['Impulse response of ' char(ftype) ' filter'])
%%
%[text] ### 周期行列 $\\mathbf{Q}$ の循環畳み込みの出力応答$\\{v\[\\mathbf{n}\]\\}\_\\mathbf{n}\n$ 
%[text] (Output response $\\{v\[\\mathbf{n}\]\\}\_\\mathbf{n}\n$ of circular convolution with period $\\mathbf{Q}$ )
%[text] 循環畳み込み演算 (Circular convolution)
%[text]  $\\{v\[\\mathbf{n}\]\\}\_\\mathbf{n}=\\{h\[\\mathbf{n}\]\\}\_\\mathbf{n} \\bigcirc  \\{u\[\\mathbf{n}\]\\}\_\\mathbf{n} = \\sum\_{\\mathbf{k}\\in\\Omega\\subset\\mathbb{Z}^2}u\[\\mathbf{k}\]\\{h\[(\\!(\\mathbf{n}-\\mathbf{k})\\!)\_\\mathbf{Q}\]\\}\_\\mathbf{n}\n$
% Setting the period N
nPeriod1 =258; %[control:slider:163b]{"position":[11,14]}
nPeriod2 =258; %[control:slider:520f]{"position":[11,14]}
nPeriod = [nPeriod1 nPeriod2];
nZeroPadding = [nPeriod1 nPeriod2] - size(u);

% Zero padding
uzpd = padarray(u,nZeroPadding,0,'post');
figure(3)
imshow(uzpd)

% Output v[n]
v = imfilter(uzpd,h,'conv','circ');
%%
%[text] ### 畳み込み演算との比較
%[text] (Comparison with convolution)
% Normal convolution
w = imfilter(u,h,'conv','full');

% v[n]
figure(4)
imshow(v+(min(v(:))<0)/2)
title('Circular convolution')
% w[n]
figure(5)
imshow(w+(min(w(:))<0)/2)
title('Normal convolution')
%[text] #### 通常の畳み込みと循環畳み込みが一致する条件
%[text] (The condition that normal convolution and circular convolution match)
%[text]  $\\exists \\mathbf{m}\\in\\mathbb{Z}^D\\ \\mathrm{s.t.}\\ \\{  \\mathbf{n}+\\mathbf{m}|\\mathbf{n} \\in \\Omega\_\\mathrm{v}\\}\\subseteq  \\mathcal{N}(\\mathbf{Q})$
%[text]  $\\Omega\_\\mathrm{v}=\\{\\mathbf{n}+\\mathbf{k}\n|\\mathbf{n}\\in\\Omega\_\\mathrm{u},\\mathbf{k}\\in\\Omega\_\\mathrm{h}\\}$
%[text] ただし、(where)
%[text] - $\\Omega\_\\mathrm{v}$: 出力のサポート領域 (Output support region)
%[text] - $\\Omega\_\\mathrm{h}$: インパルス応答のサポート領域 (Support region of impulse response)
%[text] - $\\Omega\_\\mathrm{u}$: 入力のサポート領域 (Input support region) \
%[text] 以下では周期行列 $\\mathbf{Q}$ を対角行列 (In the following, the periodic matrix  $\\mathbf{Q}$ is set to a diagonal matrix)
%[text]  $\\mathbf{Q}=\\left(\\begin{array}{cc}\nN\_1 & 0 \\\\\n0 & N\_2 \\end{array}\\right)$ 
%[text] に設定する．すなわち，(That is,)
%[text]  $\\mathcal{N}(\\mathbf{Q})=\\mathcal{N}(\\mathbf{Q}^T)=\\{0,1,2,\\cdots,N\_1-1\\}\\times\\{0,1,2,\\cdots,N\_2-1\\}$
%[text]  $N=\\left|\\mathcal{N}(\\mathbf{Q})\\right|=\\left|\\det(\\mathbf{Q})\\right|=N\_1N\_2$
%[text] ただし，$\\Omega\_\\mathrm{u}\\subseteq\\mathcal{N}(\\mathbf{Q})$ を仮定する．( and $\\Omega\_\\mathrm{u}\\subseteq\\mathcal{N}(\\mathbf{Q})$ is assumed.)
%[text] 【Example】もし，(If)
%[text]  $\\Omega\_\\mathrm{u}=\\{0,1,2,\\cdots,L\_{\\mathrm{u}1}-1\\}\\times\\{0,1,2,\\cdots,L\_{\\mathrm{u}2}-1\\}$
%[text]  $\\Omega\_\\mathrm{h}=\\{-1,0,1\\}\\times\\{-1,0,1\\}$
%[text] ならば，(then,)
%[text]  $\\Omega\_\\mathrm{v}=\\{-1,0,1,2,\\cdots,L\_{\\mathrm{u}1}\\}\\times\\{-1,0,1,2,\\cdots,L\_{\\mathrm{u}2}\\}.$
%[text] よって，(Therefore, from)
%[text]  $\\left\\{  \\mathbf{n}+(1,1)^T\\vert \\mathbf{n} \\in\\Omega\_\\mathrm{v}\\}=\\{0,1,2,\\cdots,L\_{\\mathrm{u}1}+1\\}\\times\\{0,1,2,\\cdots,L\_{\\mathrm{u}2}+1\\},$
%[text] より，
%[text]  $N\_1\\geq L\_{\\mathrm{u}1}+2,\\ N\_2\\geq L\_{\\mathrm{u}2}+2,$
%[text] ならば，通常と畳み込みと循環畳み込みの結果が一致する．(then, the results of normal, convolution and circular convolution are consistent.)
% Adjusting the sizes for evaluation
dsz = size(v)-size(w);
if dsz(1) > 0
    vc = v;
    wc = padarray(w,[dsz(1) 0],0,'post');
else
    wc = w;
    vc = padarray(v,[-dsz(1) 0],0,'post');
end
if dsz(2) > 0
    wc = padarray(wc,[0 dsz(2)],0,'post');
else
    vc = padarray(vc,[0 -dsz(2)],0,'post');
end
% Compensate the circular shift
wc = circshift(wc,-ceil((size(h)-1)/2));

% Sizes and MSE
mymse = @(x,y) mean((double(x)-double(y)).^2,'all');
fprintf('Period:         N1  = %d, N2  = %d',nPeriod1,nPeriod2);
fprintf('Size of image:  Lu1 = %d, Lu2 = %d',size(u,1),size(u,2));
fprintf('Size of filter: Lh1 = %d, Lh2 = %d',size(h,1),size(h,2));
fprintf('MSE: %f', mymse(vc,wc))
%%
%[text] ### 入力信号 $\\{u\[\\mathbf{n}\]\\}\_\\mathbf{n}\n$ のDFT
%[text] (DFT of input signal $\\{u\[\\mathbf{n}\]\\}\_\\mathbf{n}\n$)
%[text]  $U\[\\mathbf{k}\]=\\sum\_{\\mathbf{n}\\in\\mathcal{N}(\\mathbf{Q})} u\[\\mathbf{n}\] e^{-\\j 2\\pi\\mathbf{k}^T\\mathbf{Q}^{-1}\\mathbf{n}},\\ \\mathbf{k}\\in\\mathcal{N}(\\mathbf{Q}^T)\n$
% DFT of u[n]
U = fftn(u,nPeriod);
%%
%[text] ### フィルタ $\\{h\[\\mathbf{n}\]\\}\_\\mathbf{n}\n$ のDFT
%[text] (DFT of impulse response $\\{h\[\\mathbf{n}\]\\}\_\\mathbf{n}\n$)
%[text]  $H\[\\mathbf{k}\]=\\sum\_{\\mathbf{n}\\in\\mathcal{N}(\\mathbf{Q})} h\[\\mathbf{n}\] e^{-\\j 2\\pi\\mathbf{k}^T\\mathbf{Q}^{-1}\\mathbf{n}},\\ \\mathbf{k}\\in\\mathcal{N}(\\mathbf{Q}^T)\n$
% DFT of h[n]
H = fftn(h,nPeriod);
%%
%[text] ### 出力信号 $\\{v\[\\mathbf{n}\]\\}\_\\mathbf{n}\n$ のDFT
%[text] (DFT of output signal $\\{v\[\\mathbf{n}\]\\}\_\\mathbf{n}\n$)
%[text]  $V\[\\mathbf{k}\]=\\sum\_{\\mathbf{n}\\in\\mathcal{N}(\\mathbf{Q})} v\[\\mathbf{n}\] e^{-\\j 2\\pi\\mathbf{k}^T\\mathbf{Q}^{-1}\\mathbf{n}},\\ \\mathbf{k}\\in\\mathcal{N}(\\mathbf{Q}^T)\n\n$
% Frequency response of v[n]
V = fftn(v,nPeriod);
%%
%[text] ### DFT積
%[text] (DFT product)
%[text]  $V\[\\mathbf{k}\]=H\[\\mathbf{k}\]U\[\\mathbf{k}\],\\ \\mathbf{k}\\in\\mathcal{N}(\\mathbf{Q})$
%[text] 循環畳み込みとの比較 (Comparison with circular convolution)
% IDFT of DFT product
y = ifftn(H.*U);
% Compensate the circular shift
y = circshift(y,-ceil((size(h)-1)/2));
% MSE with the cconv result 'v'
fprintf('MSE: %f', mymse(v,y))
%%
%[text] ### 循環畳み込みのスペクトルノルム
%[text] (Spectral norm of the circular convolution)
%[text]  $\\|\\mathbf{T}\\|\_2=\\sigma\_1(\\mathbf{T})=\\max\_{\\mathbf{k}\\in\\mathcal{N}(\\mathbf{Q}^T)}\\left|H\[\\mathbf{k}\]\\right|$
%[text] ただし，(where)
%[text] - $\\sigma\_1(\\mathbf{T})$:  $\\mathbf{T}$の最大特異値．(Maximum singular value of $\\mathbf{T}$) \
% Definition of map T as a circular convolution with h[n]
mapT = @(x) imfilter(x,h,'conv','circ');
%[text] #### 2変量循環畳み込みの行列表現
%[text] (Matrix representation of the bivariate circular convolution)
% Redefining the period
N1 =8; %[control:slider:62ff]{"position":[5,6]}
N2 =8; %[control:slider:6998]{"position":[5,6]}

% Find the matrix representation of the circular convolution
N  = N1*N2;
T = zeros(N);
for idx = 1:N
    % Generating a standard basis vector
    e = zeros(N1,N2);
    e(idx) = 1;
    % Response to the standard basis vector
    T(:,idx) = reshape(mapT(e),[N 1]); 
end
% Matrix representation of the circular convolution
T
%[text] #### スペクトルノルム
%[text] (Spectral norm)
% Function NORM evaluates the operator norm for a matrix
opnorm = norm(T,2) 
%[text] #### 最大特異値
%[text] (Maximum singular value)
sigma1 = max(svd(T))
%[text] #### 最大振幅応答
%[text] (Maximum magnitude response)
H = fftn(h,[N1 N2]);
maxmgn = max(abs(H(:)))
%%
%[text] ### 関数NORMに関する注意
%[text] (Notes on the Function NORM)
%[text] 行列に関するノルムを評価する際には引数の渡し方、オプションの指定に注意すること．(When evaluating the entorywise norm of a matrix, pay attention to the way of passing the arguments and options.)
% Froubenius norm 
norm(T,'fro')

% Entrywise 2-norm, which is identical to the Frobenius norm
norm(T(:),2)

% Operator 1-norm
norm(T,1)

% Entrywise 1-norm
norm(T(:),1)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:3db3]
%   data: {"defaultValue":3,"label":"hsize1","max":9,"min":1,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:9d76]
%   data: {"defaultValue":3,"label":"hsize2","max":9,"min":1,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:31bb]
%   data: {"defaultValue":1,"label":"sigma","max":8,"min":0.5,"run":"SectionToEnd","runOn":"ValueChanging","step":0.5}
%---
%[control:dropdown:3e02]
%   data: {"defaultValue":"\"log\"","itemLabels":["gaussian","log"],"items":["\"gaussian\"","\"log\""],"label":"ftype","run":"SectionToEnd"}
%---
%[control:slider:163b]
%   data: {"defaultValue":258,"label":"nPoints","max":512,"min":256,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:520f]
%   data: {"defaultValue":258,"label":"nPoints","max":512,"min":256,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:62ff]
%   data: {"defaultValue":8,"label":"N1","max":32,"min":8,"run":"SectionToEnd","runOn":"ValueChanging","step":8}
%---
%[control:slider:6998]
%   data: {"defaultValue":8,"label":"N2","max":32,"min":8,"run":"SectionToEnd","runOn":"ValueChanging","step":8}
%---
