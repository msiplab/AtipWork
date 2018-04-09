%
% $Id: exHistEq.m,v 1.2 2006/05/29 12:08:53 sho Exp $
%
% Copyright (C) 2005-2006 Shogo MURAMATSU, All rights reserved
%

figure(1);
x = 0:7;
hx = [2 6 11 10 14 3 2 0];
bar(x,hx,'histc');
ylabel('âÊëfêî h_x','FontSize',12);
xlabel('ãPìxíl x','FontSize',12);

figure(2);
y = 0:7;
hy = [2 6 0 11 10 0 14 5];
bar(y,hy,'histc');
ylabel('âÊëfêî h_y','FontSize',12);
xlabel('ãPìxíl y','FontSize',12);


