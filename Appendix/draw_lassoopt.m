close all
D = [2 1]/3;
v = 0.5;

f = @(s0,s1) 0.5*(v-(D(1)*s0+D(2)*s1)).^2;
g = @(s0,s1) (abs(s0)+abs(s1));

s0 = -1:.1:1;
s1 = -1:.1:1;
[S0,S1] = ndgrid(s0,s1);
F = f(S0,S1);
G = g(S0,S1);
hf = surfc(s0,s1,F);
hf(1).FaceAlpha = 0.125;
hf(1).FaceColor = 'green';
hf(1).EdgeAlpha = 0.25;
%hf(1).EdgeColor = 'interp';
hf(2).LineWidth = 1;
%hf(2).LevelStep = 0.1;

%[az,el] = view;
%view(az+90,el)
ax = gca;
ax.YDir='reverse';

hold on
hg = surfc(s0,s1,G);
hg(1).FaceAlpha = 0.125;
hg(1).FaceColor = 'blue';
hg(1).EdgeAlpha = 0.25;
%hg(1).EdgeColor = 'interp';
hg(2).LineWidth = 1;
%hg(2).LevelStep = 0.1;

%%
xlabel('s_1')
ylabel('s_0')

%%
idx = 1;
for lambda = [0.01 0.1 1]
    J = F + lambda*G;
    [row,col] = find(J==min(J(:)),1);
    s(1,idx) = S0(row,col);
    s(2,idx) = S1(row,col);
    ht = text(s(2,idx)+.1,s(1,idx)-.2,['\lambda=' num2str(lambda)]);    
    ht.FontSize = 12;
    idx = idx+1;
end
hp = plot(s(2,:),s(1,:));
hp.Marker = 'o';
hp.MarkerSize = 6;
hp.MarkerEdgeColor = 'r';
hp.MarkerFaceColor = 'r';
hp.Color = 'r';
hp.LineWidth = 2;
hp.LineStyle = ':';
hp.Visible = true;

hf(1).Parent.FontSize = 18;
hf(1).Parent.LineWidth = 2;
hf(1).Parent.ZLim = [0 1.0];
hold off

%%
set(gcf,'Color','white');
set(gca,'Color','white');
imwrite(frame2im(getframe(1)),'lassoopt.png')
set(gcf,'Color','default');
set(gca,'Color','default');

%%
%{
mu = [0.5 0.5];
Sigma = 0.001*[1 0; 0 1];
u1 = 0:.001:1; 
u2 = 0:.001:1;
[U1,U2] = meshgrid(u1,u2);
F = mvnpdf([U1(:) U2(:)],mu,Sigma);
F = reshape(F,length(u2),length(u1));
h = surfc(u1,u2,F);
h(1).FaceAlpha = 0.25;
h(1).EdgeAlpha = 0.125;
h(1).EdgeColor = 'interp';

caxis([min(F(:))-.5*range(F(:)),max(F(:))]);
axis([0 1 0 1 0 2e2])

xlabel('v');  
ylabel('p(\bf{v}\rm{|}\bf{s}=\rm{(0.5,0.5)^T)}');

grid on
h.LineWidth = 2;
h.Parent.FontSize = 18;
%}