clear all
close all
%%
D = [2 1]/3;
v = 0.5;
lambda = 0.2;
gamma = 0.4;

beta = D*D';
disp(gamma < 2/beta)

%%
fg = @(s1,s2) 0.5*(v-(D(1)*s1+D(2)*s2)).^2 + lambda*(abs(s1)+abs(s2));

figure(1)

s1 = -1:.1:1;
s2 = -1:.1:1;
[S1,S2] = meshgrid(s1,s2);
F = fg(S1,S2);
hf = surfc(s1,s2,F);
hf(1).FaceAlpha = 0.25;
%hf(1).FaceColor = 'green';
hf(1).EdgeAlpha = 0.25;
hf(1).EdgeColor = 'interp';
hf(2).LineWidth = 1;
%hf(2).LevelStep = 0.1;


[az,el] = view;
view(az+90,el)


xlabel('s_1')
ylabel('s_2')
zlabel('f(s)+g(s)')

hold on

%

s = [0, -0.75].';
for idx=0:19
    x(1,1) = s(1);
    x(2,1) = s(2);
    
    c = s-gamma*(D'*(D*s-v));
    t = sign(c).*max(abs(c)-gamma*lambda,0);
    
    x(1,2) = t(1);
    x(2,2) = t(2);
    %
    hp = quiver(x(1,1),x(2,1),x(1,2)-x(1,1),x(2,2)-x(2,1));
    hp.Marker = 'o';
    hp.ShowArrowHead = 'on';
    hp.MaxHeadSize = 120;
    hp.MarkerSize = 6;
    hp.MarkerEdgeColor = 'r';
    %hp.MarkerFaceColor = 'r';
    hp.Color = 'r';
    hp.LineWidth = 2;
    %hp.LineStyle = ':';

    
    s = t;
end
hp.Parent.FontSize = 18;
hp.Parent.LineWidth = 1;
hp.Parent.ZLim = [0 1.5];

hold off
