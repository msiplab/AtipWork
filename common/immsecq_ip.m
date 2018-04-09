function mse = immsecq_ip(x,y)
% IMMSECQ_IP
%
% $Id:$
%
diff = imsubtract(x,y);
mse = mean2(immultiply(diff,diff));
