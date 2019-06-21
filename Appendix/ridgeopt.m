clear all
close all
%%
D = [2 1]/3;
v = 0.5;

f = @(s1,s2) 0.5*(v-(D(1)*s1+D(2)*s2)).^2;
g = @(s1,s2) 0.5*(s1.^2+s2.^2);

s1 = -1:.1:1;
s2 = -1:.1:1;
[S1,S2] = meshgrid(s1,s2);
F = f(S1,S2);
G = g(S1,S2);
hf = surfc(s1,s2,F);
hf(1).FaceAlpha = 0.125;
hf(1).FaceColor = 'green';
hf(1).EdgeAlpha = 0.25;
%hf(1).EdgeColor = 'interp';
hf(2).LineWidth = 1;
%hf(2).LevelStep = 0.1;


[az,el] = view;
view(az+90,el)

hold on
hg = surfc(s1,s2,G);
hg(1).FaceAlpha = 0.125;
hg(1).FaceColor = 'blue';
hg(1).EdgeAlpha = 0.25;
%hg(1).EdgeColor = 'interp';
hg(2).LineWidth = 1;
%hg(2).LevelStep = 0.1;

xlabel('s_1')
ylabel('s_2')

idx = 1;
for lambda = [0.1 1 10 ]
    s(:,idx) = inv(D.'*D+lambda*eye(2))*D.'*v;
    ht = text(s(1,idx)+.1,s(2,idx)-.2,['\lambda=' num2str(lambda)]);
    ht.FontSize = 12;
    idx = idx+1;
end
hp = plot(s(1,:),s(2,:));
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