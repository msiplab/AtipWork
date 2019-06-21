close all
%% äœë™âﬂíˆ
p = [ 2 1  ]/3;
q = [ 1 -2 ]/3;
yp = 0.5;
yq = -0.5;

%% êMçÜåπ
A = [ p ; q ];


% äœë™íl
f = @(x,y) p(1)*x+p(2)*y; 
g = @(x,y) q(1)*x+q(2)*y;

%v = f(x) + w;

hfig = figure;

%% f
[xt,yt] = meshgrid(-2:0.1:2,-2:0.1:2);
ztf1 = f(xt,yt);
hff1 = surf(xt,yt,ztf1);
hff1.FaceAlpha = 0.25;
hff1.EdgeColor = 'interp';
hff1.EdgeAlpha = 0.25;
xlabel('x_1','FontSize',18)
ylabel('x_2','FontSize',18)
zlabel('b','FontSize',18)

axis equal
[az,el] = view;
view(az+90,el)

hold on

%%
levf = -2;

idxf = find(ztf1==levf);

% 
lwb = -2;

%
hpf1 = plot3(xt(idxf),yt(idxf),lwb*ones(size(idxf)));
hpf1.LineWidth = 2;
hpf1.Color = 'red';

%
zp = levf*ones(size(idxf));
hpf2 = plot3(xt(idxf),yt(idxf),zp);
hpf2.LineWidth = 2;
hpf2.Color = 'blue';

%
ztf3 = levf*ones(size(xt));
hff3 = surf(xt,yt,ztf3);
hff3.FaceAlpha = 0.1;
%hf3.EdgeColor = 'none';
hff3.FaceColor = 'magenta';
hff3.EdgeColor = 'interp';
hff3.EdgeAlpha = 0.25;

%%
delta = 1e-6;
levf = -1.5:0.1:yp;
nImagesf = length(levf);
imf = cell(nImagesf,1);
for iImage = 1:nImagesf
    idxf = find((ztf1<(levf(iImage)+delta)) & (ztf1>(levf(iImage)-delta)));
    hpf1.XData = xt(idxf);
    hpf1.YData = yt(idxf);
    hpf1.ZData = lwb*ones(size(idxf));
    %
    zt = levf(iImage)*ones(size(xt));
    hpf2.XData = xt(idxf);
    hpf2.YData = yt(idxf);
    hpf2.ZData = zt(idxf);
    %
    hff3.ZData = levf(iImage)*ones(size(xt));
    axis([-2 2 -2 2 lwb 2])
    
    
    drawnow
    
    %pause(0.1)
    frame = getframe(1);
    imf{iImage} = frame2im(frame);
end

%% g
[xt,yt] = meshgrid(-2:0.1:2,-2:0.1:2);
ztg1 = g(xt,yt);
hfg1 = surf(xt,yt,ztg1);
hfg1.FaceAlpha = 0.25;
hfg1.EdgeColor = 'interp';
hfg1.EdgeAlpha = 0.25;
%hf1.EdgeColor = 'none';
%hf1.FaceColor = 'orange';
xlabel('x_1','FontSize',18)
ylabel('x_2','FontSize',18)
zlabel('b','FontSize',18)

hold on

%%
levg = -2;

idxg = find(ztg1==levg);

% 
lwb = -2;

%
hpg1 = plot3(xt(idxg),yt(idxg),lwb*ones(size(idxg)));
hpg1.LineWidth = 2;
hpg1.Color = 'red';

%
zp = levg*ones(size(idxg));
hpg2 = plot3(xt(idxg),yt(idxg),zp);
hpg2.LineWidth = 2;
hpg2.Color = 'blue';

%
ztg3 = levg*ones(size(xt));
hfg3 = surf(xt,yt,ztg3);
hfg3.FaceAlpha = 0.1;
%hf3.EdgeColor = 'none';
hfg3.FaceColor = 'magenta';
hfg3.EdgeColor = 'interp';
hfg3.EdgeAlpha = 0.25;

axis equal

%%
delta = 1e-6;
levg = -1.5:0.1:yq;
nImagesg = length(levg);
img = cell(nImagesg,1);
for iImage = 1:nImagesg
    idxg = find((ztg1<(levg(iImage)+delta)) & (ztg1>(levg(iImage)-delta)));
    hpg1.XData = xt(idxg);
    hpg1.YData = yt(idxg);
    hpg1.ZData = lwb*ones(size(idxg));
    %
    zt = levg(iImage)*ones(size(xt));
    hpg2.XData = xt(idxg);
    hpg2.YData = yt(idxg);
    hpg2.ZData = zt(idxg);
    %
    hfg3.ZData = levg(iImage)*ones(size(xt));
    axis([-2 2 -2 2 lwb 2])
    
    %%{
    mnz = levg(iImage);
    xa = A\[yp ; mnz];
    mnx = xa(1);
    mny = xa(2);
    hpg3 = plot3(mnx,mny,lwb);
    hpg3.Marker = 'o';
    hpg3.MarkerSize = 8;
    hpg3.MarkerEdgeColor = 'r';
    hpg3.MarkerFaceColor = 'r';
    hpg3.Color = 'r';
    hpg3.LineWidth = 2;
    hpg3.LineStyle = ':';
    hpg3.Visible = true;
    %%}
    
    %
    drawnow
    
    %pause(0.1)
    frame = getframe(1);
    img{iImage} = frame2im(frame);
    hpg3.Visible = false;    
end


%%

hold off

%%
close(hfig)

%%
filename = 'intersection3_1.gif'; % Specify the output file name
for idxf = 1:nImagesf
    [A,map] = rgb2ind(imf{idxf},256);
    if idxf == 1
        imwrite(A,map,filename,'gif','LoopCount',2,'DelayTime',0.1);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.1);
    end
end
imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',2);
for idxg = 1:nImagesg
    [A,map] = rgb2ind(img{idxg},256);
    imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.1);
end
imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',2);

imwrite(A,map,['still_' filename])
