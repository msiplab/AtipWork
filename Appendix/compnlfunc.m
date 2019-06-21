function compnlfunc()

theta1 = randn(1);
theta2 = randn(1);

x = rand(2,1);
g = @(theta1,theta2) f2(f1(x,theta1),theta2);

% ”’l“I”÷•ª
dtheta = 1e-9;
dy1 = (g(theta1+dtheta,theta2)-g(theta1-dtheta,theta2))/(2*dtheta);
dy2 = (g(theta1,theta2+dtheta)-g(theta1,theta2-dtheta))/(2*dtheta);
dfnum = [dy1(:).' ; dy2(:).']

% ‰ğÍ“I”÷•ª
v = f1(x,theta1);
Jy2 = jf2(v,theta2);
dy1 = Jy2*df1(x,theta1);
dy2 = df2(v,theta2); % OK

dfana = [dy1(:).' ; dy2(:).']

end

function y = f1(x,theta)
R = [ cos(theta) -sin(theta); sin(theta) cos(theta) ];
y = R*x;
end

function dy = df1(x,theta)
dR = [ -sin(theta) -cos(theta); cos(theta) -sin(theta) ];
dy = dR*x;
end

function y = f2(x,theta)
y = 1./(1+exp(-theta*x)); 
end

function dy = df2(x,theta)
s = f2(x,theta);
dy = x.*(1-s).*s;
end

function jy = jf2(x,theta)
s = f2(x,theta);
jy = diag(theta.*(1-s).*s);
end

