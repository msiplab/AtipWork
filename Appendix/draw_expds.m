clear
close all
%%
D = [2 1]/3;
v = 0.5;
lambda = 0.2;
gamma1 = 0.4;
beta = D*D';
tau2 = D*D';
gamma2 = 1/(1.05*tau2)*(1/gamma1-beta/2);

disp((1/gamma1 - gamma2*tau2) > beta/2)

%%
fg = @(s0,s1) 0.5*(v-(D(1)*s0+D(2)*s1)).^2 + lambda*(abs(s0)+abs(s1));

figure(1)

s0 = -1:.1:1;
s1 = -1:.1:1;
[S0,S1] = ndgrid(s0,s1);
F = fg(S0,S1);
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

xlabel('s_1')
ylabel('s_0')
zlabel('f(s)+g(s)+h(Ls)')

hold on

% Constraint
s0 = -1:.01:1;
s1 = -1:.01:1;
[S0,S1] = meshgrid(s0,s1);
ic = @(s1,s2) (D(1)*s1+D(2)*s2)<=0 & (D(1)*s1+D(2)*s2)>=-0.5;
C = repmat(ic(S0,S1),[1 1 3]);
hc = surf(s0,s1,zeros(size(C,1),size(C,2)),double(C));
hc.EdgeColor='interp';
hc.EdgeAlpha = 0.25;
hc.FaceAlpha = 0.25;
%

s = [0, -0.75].';
y = D*s;
for idx=0:19
    x(1,1) = s(1); % y
    x(2,1) = s(2); % x

    % primal
    c = s-gamma1*D'*((D*s-v)+y);
    t = sign(c).*max(abs(c)-gamma1*lambda,0);
    % dual
    u = y + gamma2*D*(2*t-s);
    y = u - gamma2*max(min(u/gamma2,0),-1);
    
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
imwrite(frame2im(getframe(1)),'expds.png')
set(gcf,'Color','default');
set(gca,'Color','default');