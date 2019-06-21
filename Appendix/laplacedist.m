close all
%sigma = sqrt(0.001);

b = 0.02;%sqrt(sigma^2/2)
mu = 0;

f = @(x) 1/(2*b)*exp(-abs(x-mu)/b);

h = fplot(f,[-1 1])
xlabel('x')
ylabel('L(x|\mu=0,b=0.02)')
grid on
axis([-1 1 0 30])
h.LineWidth = 2;
h.Parent.FontSize = 18;
h.Parent.LineWidth = 1;


