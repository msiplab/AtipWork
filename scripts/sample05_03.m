%[text] # Sample 5-3: Frequency of bivariate signals
%[text] Advanced Topics in Image Processing, Lecture 5 "Fourier Analysis"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Definition of a bivariate cosine wave
%[text]{"align":"center"} $u(\\boldsymbol{q})=\\cos(\\boldsymbol{\\nu}^\\top\\boldsymbol{q})=\\cos(\\nu\_\\mathrm{v} q\_\\mathrm{v} + \\nu\_\\mathrm{h} q\_\\mathrm{h})$
%[text] where
%[text]{"align":"center"} $\\boldsymbol{\\nu} = \\begin{pmatrix} \\nu\_\\mathrm{v} \\\\ \\nu\_\\mathrm{h} \\end{pmatrix}\\in\\mathbb{R}^2,\\quad \\boldsymbol{q} = \\begin{pmatrix} q\_\\mathrm{v} \\\\ q\_\\mathrm{h} \\end{pmatrix}\\in\\mathbb{R}^2$
%[text] are the angular-frequency vector and the coordinate vector (vertical, horizontal).
%%
%[text] ## Setting of the bivariate angular frequency
% Vertical angular frequency
f1 = 1; %[control:slider:33c4]{"position":[6,7]}
nuv = 2*pi*f1;
% Horizontal angular frequency
f2 = 2; %[control:slider:0ef9]{"position":[6,7]}
nuh = 2*pi*f2;

% Sampling points
[qh,qv] = meshgrid(-0.5:0.01:0.5,-0.5:0.01:0.5);

% Bivariate cosine wave
u = cos(nuv*qv + nuh*qh);
%%
%[text] ## Display of the bivariate cosine wave
figure
surf(qh,qv,u)
xlabel('q_h')
ylabel('q_v')
zlabel('cos(\nu^Tq)')
title("\nu = (" + nuv/pi + "\pi, " + nuh/pi + "\pi)^T")
colormap gray
shading interp
axis([-0.5 0.5 -0.5 0.5 -2 2])
axis ij
axis vis3d
%[text] ### Rotating the display
%[text] Remove the block comment to rotate the view.
%{
stepAngle = 2;
for iAngle = 1:stepAngle:360
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
%[control:slider:33c4]
%   data: {"defaultValue":1,"label":"nu_v/(2pi)","max":6,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
%[control:slider:0ef9]
%   data: {"defaultValue":2,"label":"nu_h/(2pi)","max":6,"min":0,"run":"SectionToEnd","runOn":"ValueChanging","step":1}
%---
