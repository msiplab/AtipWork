%[text] # Sample 11-3
%[text] ## 画像ノイズ除去
%[text] 正規方程式
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Image denoising
%[text] Normal equation
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### 準備
%[text] (Preparation)
close all
%%
%[text] ## 問題設定
%[text] (Problem setting)
%[text]  $\\hat{\\mathbf{s}}=\\arg\\min\_{\\mathbf{s}}\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{Ds}\\|\_2^2+\\frac{\\lambda}{2}\\|\\mathbf{s}\\|\_2^2$
%[text] - $\\mathbf{D} = \\left(\\begin{array}{cc} \\frac{2}{3} & \\frac{1}{3}\\end{array}\\right)\\colon\\quad \\mathbb{R}^2\\rightarrow\\mathbb{R}^1$
%[text] - $\\mathbf{v}=\\frac{1}{2}\\in\\mathbb{R}^1$
%[text] - $\\lambda\\in\[0,\\infty)$
%[text] - $\\mathbf{s}\\in\\mathbb{R}^2$ \
D = [2 1]/3;
v = 0.5; %[control:slider:11a9]{"position":[5,8]}
%%
%[text] ### 関数プロット
%[text] (Function plot)
% Function settings
f = @(s0,s1) 0.5*(v-(D(1)*s0+D(2)*s1)).^2; % Fidelity term
r = @(s0,s1) 0.5*(s0.^2+s1.^2); % Regularizer
% Variable settings
s0 = linspace(-1,1,21);
s1 = linspace(-1,1,21);
[S0,S1] = ndgrid(s0,s1);
% Evaluation
F = f(S0,S1);
R = r(S0,S1);
% Surfc plot of the fidelity
figure
hf = surfc(s0,s1,F);
hf(1).FaceAlpha = 0.125;
hf(1).FaceColor = 'green';
hf(1).EdgeAlpha = 0.25;
hf(2).LineWidth = 1;
set(gca,'YDir','reverse');
hold on
% Surfc plot of the regularizer
hg = surfc(s0,s1,R);
hg(1).FaceAlpha = 0.125;
hg(1).FaceColor = 'blue';
hg(1).EdgeAlpha = 0.25;
hg(2).LineWidth = 1;
xlabel('s_1')
ylabel('s_0')
%%
%[text] ### 正規方程式とその解
%[text] (Normal Equation and its Solution)
%[text] 正規方程式 (Normal equation)
%[text]  $(\\mathbf{D}^T\\mathbf{D}+\\lambda\\mathbf{I})\\mathbf{s}=\\mathbf{D}^T\\mathbf{v}$
%[text] 解 (Solution)
%[text]  $\\hat{\\mathbf{s}}=(\\mathbf{D}^T\\mathbf{D}+\\lambda\\mathbf{I})^{-1}\\mathbf{D}^T\\mathbf{v}$
% Evaluation values for λ
lmdset = logspace(-1,1,3);
idx = 1;
s = zeros(size(D,2),length((lmdset)));
for lambda = lmdset
    s(:,idx) = (D.'*D+lambda*eye(2))\(D.'*v); 
    ht = text(s(2,idx)+.1,s(1,idx)-.2,['\lambda=' num2str(lambda)]);
    ht.FontSize = 12;
    idx = idx+1;
end
%[text] 解のプロット (Solution plot)
hp = plot(s(2,:),s(1,:));
hp.Marker = 'o';
hp.MarkerSize = 6;
hp.MarkerEdgeColor = 'r';
hp.MarkerFaceColor = 'r';
hp.Color = 'r';
hp.LineWidth = 2;
hp.LineStyle = ':';
hp.Visible = true;
hold off
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:11a9]
%   data: {"defaultValue":0.5,"label":"v","max":0.5,"min":-0.5,"run":"SectionToEnd","runOn":"ValueChanging","step":0.1}
%---
