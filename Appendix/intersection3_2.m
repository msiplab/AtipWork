close all
%% 
lambda = 1.0;
%% ŠÏ‘ª‰ß’ö
p = [ 2 1 ]/3;

%% M†Œ¹
x1 = -3;
x2 = 0;
x = [x1; x2];

% ŠÏ‘ª’l
f = @(x,y) p(1)*x+p(2)*y; 

%v = f(x) + w;

hfig = figure;

%% 
[xt,yt] = meshgrid(-2:0.1:2,-2:0.1:2);
zt1 = f(xt,yt);
hf1 = surf(xt,yt,zt1);
hf1.FaceAlpha = 0.5;
hf1.EdgeColor = 'interp';
hf1.EdgeAlpha = 0.5;

xlabel('x_1','FontSize',18)
ylabel('x_2','FontSize',18)
zlabel('b','FontSize',18)

%%
title(['\lambda = ' num2str(lambda)])

[az,el] = view;
view(az+90,el)
hold on

%%
%zt2 = abs(xt)+abs(yt);
%hc = contour(xt,yt,zt2);
%{
hf2.FaceAlpha = 0.2;
%hf2.EdgeColor = 'none';
hf2.FaceColor = 'magenta';
%}

lev = -2;

idx = find(zt1==lev);

% 
lwb = -2;

%
hp1 = plot3(xt(idx),yt(idx),lwb*ones(size(idx)));
hp1.LineWidth = 2;
hp1.Color = 'red';

%
zp = lev*ones(size(idx)) ...
    + abs(xt(idx))+abs(yt(idx));
hp2 = plot3(xt(idx),yt(idx),zp);
hp2.LineWidth = 2;
hp2.Color = 'blue';

if lambda > 0
    [mnz,mnidx] = min(zp(:));
    mnx = xt(mnidx);
    mny = yt(mnidx);
    hp3 = plot3(...
        mnx*[1 1],...
        mny*[1 1],...
        [lwb mnz]);
    hp3.Marker = 'o';
    hp3.MarkerSize = 8;
    hp3.MarkerEdgeColor = 'b';
    hp3.MarkerFaceColor = 'b';
    hp3.Color = 'b';
    hp3.LineWidth = 2;
    hp3.LineStyle = ':';
    hp3.Visible = false;
    %
end

%

%
zt3 = lev*ones(size(xt));
hf3 = surf(xt,yt,zt3);
hf3.FaceAlpha = 0.2;
%hf3.EdgeColor = 'none';
hf3.FaceColor = 'magenta';
hf3.EdgeColor = 'interp';
hf3.EdgeAlpha = 0.2;

axis equal

%%
delta = 1e-6;
lev = -1.5:0.1:0.5;
nImages = length(lev);
im = cell(nImages,1);
for iImage = 1:nImages
    idx = find((zt1<(lev(iImage)+delta)) & (zt1>(lev(iImage)-delta)));
    hp1.XData = xt(idx);
    hp1.YData = yt(idx);
    hp1.ZData = lwb*ones(size(idx));
    %
    zt = lev(iImage)*ones(size(xt)) ....
        +lambda*(abs(xt)+abs(yt));    
    hp2.XData = xt(idx);
    hp2.YData = yt(idx);
    hp2.ZData = zt(idx);
    %
    if lambda > 0
        [mnz,mnidx] = min(hp2.ZData);
        mnx = hp2.XData(mnidx);
        mny = hp2.YData(mnidx);
        hp3.XData = mnx*[1 1];
        hp3.YData = mny*[1 1];
        hp3.ZData = [lwb mnz];        
        hp3.Visible = true;        
    end
    %
    hf3.ZData = lev(iImage)*ones(size(xt));
    axis([-2 2 -2 2 lwb 2])
    
    
    drawnow
    
    %pause(0.1)
    frame = getframe(1);
    im{iImage} = frame2im(frame);
end

hold off

%%
close(hfig)

%%
filename = sprintf('intersection3_2_lmd%6.2e.gif',lambda); % Specify the output file name
for idx = 1:nImages
    [A,map] = rgb2ind(im{idx},256);
    if idx == 1
        imwrite(A,map,filename,'gif','LoopCount',2,'DelayTime',0.1);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.1);
    end
end
imwrite(A,map,['still_' filename])
