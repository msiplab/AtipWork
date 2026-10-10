close all
D = [2 1]/3;
s1 = .5;
s2 = .5;
u1 = D*[s1; s2]
sigma = sqrt(0.001);
x = 0:.001:1;
v = normpdf(x,u1,sigma);

h = plot(x,v)

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
%}
xlabel('v');  
ylabel('p(\bf{v}\rm{|}\bf{s}=\rm{(0.5,0.5)^T)}');

grid on
h.LineWidth = 2;
h.Parent.FontSize = 18;
%}