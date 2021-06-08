clear all
close all
%%
D = [2 1]/3;
v = 0.5;
lambda = 0.2;
gamma = 0.4;

%%
f = @(s0,s1) 0.5*(v-(D(1)*s0+D(2)*s1)).^2 + lambda*0.5*(s0.^2+s1.^2);

figure(1)

s0 = -1:.1:1;
s1 = -1:.1:1;
[S0,S1] = ndgrid(s0,s1);
F = f(S0,S1);
hf = surfc(s0,s1,F);
hf(1).FaceAlpha = 0.25;
%hf(1).FaceColor = 'green';
hf(1).EdgeAlpha = 0.25;
hf(1).EdgeColor = 'interp';
hf(2).LineWidth = 1;
%hf(2).LevelStep = 0.1;


%[az,el] = view;
%view(az+90,el)
ax = gca;
ax.YDir='reverse';

ylabel('s_0')
xlabel('s_1')
zlabel('f(s)')

hold on

%

s = [0, -0.75].';
for idx=0:19
    x(1,1) = s(1); % y
    x(2,1) = s(2); % x
    
    t = s-gamma*(D'*(D*s-v)+lambda*s);
    
    x(1,2) = t(1); % y
    x(2,2) = t(2); % x
    %
    nx = x(2,2);
    ny = x(1,2);
    px = x(2,1);
    py = x(1,1);
    
    hp = quiver(px,py,nx-px,ny-py);
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

%%
set(gcf,'Color','white');
set(gca,'Color','white');
imwrite(frame2im(getframe(1)),'exgrad.png')
set(gcf,'Color','default');
set(gca,'Color','default');