fplot(@(x) log(x))
grid on
ylabel('log(x)')
xlabel('x')
h = gca
h.Children
h.Children.LineWidth = 2
h.LineWidth = 1
h.FontSize = 18
