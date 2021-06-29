%
% $Id: exGamma.m,v 1.2 2006/05/29 12:08:53 sho Exp $
%
% Copyright (C) 2005-2006 Shogo MURAMATSU, All rights reserved
%

x = [0.0:0.01:1.0];
hold off;
for i = -4:4
    gamma = 2^i;
    y = x.^gamma;
    plot(x,y);
    set(gca,'XTick',[0.0:0.2:1],'YTick',[0.0:0.2:1],'FontSize',12);
    hold on;
    str = sprintf('%6.4f',gamma);
    H = text(0.48+i/12,(0.5+i/12).^gamma,str,'FontSize',12);
    set(H,'BackgroundColor',[1 1 1]);
    H = text(0.4+i/12,(0.5+i/12).^gamma,'\gamma = ','FontSize',12);    
end;
axis square;
xlabel('x','FontSize',12);
ylabel('y','FontSize',12);
