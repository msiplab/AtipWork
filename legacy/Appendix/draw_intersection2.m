%% äœë™âﬂíˆ
p = 2/3;

%% êMçÜåπ
x = -3;

% äœë™íl
f = @(x) p(1)*x; 

hfig = figure;

%% 
xt = -2:0.1:2;
yt1 = f(xt);
hp1 = plot(xt,yt1);
hp1.LineWidth = 2;
hp1.Color = 'red';
xlabel('x','FontSize',18)
ylabel('y','FontSize',18)

%%
hold on

%%
lev = -2;
yt2 = lev*ones(size(xt));
hp2 = plot(xt,yt2);
hp2.LineWidth = 2;
hp2.Color = 'blue';

%%
lwb = -2;


[mny,mnidx] = min(yt1);
mnx = xt(mnidx);
hp3 = plot(...
    mnx*[1 1],...
    [lwb mny]);
hp3.Marker = 'o';
hp3.MarkerSize = 8;
hp3.MarkerEdgeColor = 'b';
hp3.MarkerFaceColor = 'b';
hp3.Color = 'b';
hp3.LineWidth = 2;
hp3.LineStyle = ':';
hp3.Visible = false;
    
%% 

hold off
%%
lev = -1.5:0.1:0.5;
nImages = length(lev);
im = cell(nImages,1);
for iImage = 1:nImages
    hp2.YData = lev(iImage)*ones(size(hp1.XData));
    %
    [v,idx] = min( abs(hp1.YData - hp2.YData) );
    if v < 1e-1
        mnx = hp1.XData(idx);
        mny = f(mnx);
        hp3.XData = mnx*[1 1];
        hp3.YData = [lwb mny];       
        hp3.Visible = true;
    else
        hp3.Visible = false;
    end
    axis equal
    axis([-2 2 lwb 2])
    drawnow
    
    %pause(0.1)
    frame = getframe(1);
    im{iImage} = frame2im(frame);
    
end
close(hfig)

%%
filename = 'intersection2.gif'; % Specify the output file name
for idx = 1:nImages
    [A,map] = rgb2ind(im{idx},256);
    if idx == 1
        imwrite(A,map,filename,'gif','LoopCount',2,'DelayTime',0.1);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.1);
    end
end
