figure(1) 

x = -1:0.1:1;
[X,Y] = meshgrid(x);

%%
figure(1)
f = @(x) -2.*x+3/2;

%%
Z = X.^2+Y.^2;
%[~,hCont1] = contour3(X,Y,Z,30);
hCont1 = surfc(X,Y,Z);
hCont1(1).FaceAlpha = 0.25;
hCont1(1).EdgeAlpha = 0.25;
ax = gca;
ax.ZLim = [0 1];
ax.XLim = [-1 1];
ax.YLim = [-1 1];
ax.YDir = 'reverse';
ylabel('s_0','FontSize',18)
xlabel('s_1','FontSize',18)
zlabel('||\bfs\rm||_2^2','FontSize',18)
hCont1(1).Parent.LineWidth = 1;
%[az,el] = view;
%view(az+90,el)
hold on

s0 = -1:0.05:1;
s1 = f(s0);
hp1 = plot(s1,s0);
hp1.LineWidth = 2;
hp1.Color = 'red';

s = s1.^2+s0.^2;
hsp1 = plot3(s1,s0,s);
hsp1.LineWidth = 2;
hsp1.Color = 'blue';

[mnz,mnidx] = min(s(:));
mn1 = s1(mnidx);
mn2 = s0(mnidx);
hmrk = plot3(...
        mn1*[1 1],...
        mn2*[1 1],...
        [0 mnz]);
hmrk.Marker = 'o';
hmrk.MarkerSize = 8;
hmrk.MarkerEdgeColor = 'b';
hmrk.MarkerFaceColor = 'b';
hmrk.Color = 'b';
hmrk.LineWidth = 2;
hmrk.LineStyle = ':';

hold off

imwrite(frame2im(getframe(1)),'contour2.png')
%%

figure(2)
Z = abs(X) + abs(Y);
%[~,hCont2] = contour3(X,Y,Z,30);
hCont2 = surfc(X,Y,Z);
hCont2(1).FaceAlpha = 0.25;
hCont2(1).EdgeAlpha = 0.25;
ax = gca;
ax.ZLim = [0 1];
ax.XLim = [-1 1];
ax.YLim = [-1 1];
ax.YDir = 'reverse';
ylabel('s_0','FontSize',18)
xlabel('s_1','FontSize',18)
zlabel('||\bfs\rm||_1','FontSize',18)
hCont2(1).Parent.LineWidth = 1;
%[az,el] = view;
%view(az+90,el)
hold on

s0 = -1:0.05:1;
s1 = f(s0);
hp2 = plot(s1,s0);
hp2.LineWidth = 2;
hp2.Color = 'red';

s = abs(s1)+abs(s0);
hsp2 = plot3(s1,s0,s);
hsp2.LineWidth = 2;
hsp2.Color = 'blue';


[mnz,mnidx] = min(s(:));
mn1 = s1(mnidx);
mn2 = s0(mnidx);
hmrk = plot3(...
        mn1*[1 1],...
        mn2*[1 1],...
        [0 mnz]);
hmrk.Marker = 'o';
hmrk.MarkerSize = 8;
hmrk.MarkerEdgeColor = 'b';
hmrk.MarkerFaceColor = 'b';
hmrk.Color = 'b';
hmrk.LineWidth = 2;
hmrk.LineStyle = ':';

hold off

imwrite(frame2im(getframe(2)),'contour1.png')

%%
p = 0.5;
figure(3)
Z = (abs(X).^p + abs(Y).^p);
%[~,hCont2] = contour3(X,Y,Z,30);
hCont3 = surfc(X,Y,Z);
hCont3(1).FaceAlpha = 0.25;
hCont3(1).EdgeAlpha = 0.25;
ax = gca;
ax.ZLim = [0 1];
ax.XLim = [-1 1];
ax.YLim = [-1 1];
ax.YDir = 'reverse';
ylabel('s_0','FontSize',18)
xlabel('s_1','FontSize',18)
zlabel(['||\bfs\rm||_{' num2str(p) '}^{' num2str(p) '}'],'FontSize',18)
hCont3(1).Parent.LineWidth = 1;

%[az,el] = view;
%view(az+90,el)
hold on

s0 = -1:0.05:1;
s1 = f(s0);
hp3 = plot(s1,s0);
hp3.LineWidth = 2;
hp3.Color = 'red';

s = (abs(s1).^p+abs(s0).^p);
hsp3 = plot3(s1,s0,s);
hsp3.LineWidth = 2;
hsp3.Color = 'blue';


[mnz,mnidx] = min(s(:));
mn1 = s1(mnidx);
mn2 = s0(mnidx);
hmrk = plot3(...
        mn1*[1 1],...
        mn2*[1 1],...
        [0 mnz]);
hmrk.Marker = 'o';
hmrk.MarkerSize = 8;
hmrk.MarkerEdgeColor = 'b';
hmrk.MarkerFaceColor = 'b';
hmrk.Color = 'b';
hmrk.LineWidth = 2;
hmrk.LineStyle = ':';

hold off

imwrite(frame2im(getframe(3)),['contour' strrep(num2str(p),'.','_') '.png'])