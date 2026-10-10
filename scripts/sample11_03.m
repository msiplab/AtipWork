%[text] # Sample 11-3: Normal equation
%[text] Advanced Topics in Image Processing, Lecture 11 "Image Denoising"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Problem setting
%[text] $\\hat{\\mathbf{s}}=\\arg\\min\_{\\mathbf{s}}\\frac{1}{2}\\|\\mathbf{v}-\\mathbf{D}\\mathbf{s}\\|\_2^2+\\frac{\\lambda}{2}\\|\\mathbf{s}\\|\_2^2$
%[text] - $\\mathbf{D} = \\left(\\begin{array}{cc} \\frac{2}{3} & \\frac{1}{3}\\end{array}\\right)\\colon\\quad \\mathbb{R}^2\\rightarrow\\mathbb{R}^1$
%[text] - $\\mathbf{v}=\\frac{1}{2}\\in\\mathbb{R}^1$ (change it with the slider)
%[text] - $\\lambda\\in\[0,\\infty)$
%[text] - $\\mathbf{s}\\in\\mathbb{R}^2$ \
D = [2 1]/3;
v = 0.5; %[control:slider:0229]{"position":[5,8]}
%%
%[text] ## Function plot
%[text] Fidelity term (green) and regularizer (blue)
% Function settings
f = @(s0,s1) 0.5*(v-(D(1)*s0+D(2)*s1)).^2; % Fidelity term
r = @(s0,s1) 0.5*(s0.^2+s1.^2);            % Regularizer
% Variable settings
s0 = linspace(-1,1,21);
s1 = linspace(-1,1,21);
[S0,S1] = ndgrid(s0,s1);
% Evaluation
F = f(S0,S1);
R = r(S0,S1);
% Surfc plot of the fidelity
fig = figure;
ax = axes(fig);
hf = surfc(ax,s0,s1,F);
hf(1).FaceAlpha = 0.125;
hf(1).FaceColor = 'green';
hf(1).EdgeAlpha = 0.25;
hf(2).LineWidth = 1;
ax.YDir = 'reverse';
hold(ax,"on")
% Surfc plot of the regularizer
hg = surfc(ax,s0,s1,R);
hg(1).FaceAlpha = 0.125;
hg(1).FaceColor = 'blue';
hg(1).EdgeAlpha = 0.25;
hg(2).LineWidth = 1;
xlabel(ax,"$s[1]$","Interpreter","latex")
ylabel(ax,"$s[0]$","Interpreter","latex")
%%
%[text] ## Normal equation and its solution
%[text] Normal equation
%[text] $(\\mathbf{D}^\\top\\mathbf{D}+\\lambda\\mathbf{I})\\mathbf{s}=\\mathbf{D}^\\top\\mathbf{v}$
%[text] Solution
%[text] $\\hat{\\mathbf{s}}=(\\mathbf{D}^\\top\\mathbf{D}+\\lambda\\mathbf{I})^{-1}\\mathbf{D}^\\top\\mathbf{v}$
% Evaluation for lambda = 0.1, 1, 10
lmdset = logspace(-1,1,3);
s = zeros(size(D,2),length(lmdset));
for idx = 1:length(lmdset)
    lambda = lmdset(idx);
    s(:,idx) = (D.'*D+lambda*eye(2))\(D.'*v);
    ht = text(ax,s(2,idx)+.1,s(1,idx)-.2,"\lambda=" + lambda);
    ht.FontSize = 12;
end
%[text] Solution plot
hp = plot(ax,s(2,:),s(1,:));
hp.Marker = 'o';
hp.MarkerSize = 6;
hp.MarkerEdgeColor = 'r';
hp.MarkerFaceColor = 'r';
hp.Color = 'r';
hp.LineWidth = 2;
hp.LineStyle = ':';
hold(ax,"off")
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[control:slider:0229]
%   data: {"defaultValue":0.5,"label":"v","max":0.5,"min":-0.5,"run":"SectionToEnd","runOn":"ValueChanging","step":0.1}
%---
