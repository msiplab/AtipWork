% practice08_4.m
%
% $Id: practice08_4.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2005-2015 Shogo MURAMATSU, All rights reserved
%

%% �ړ����σt�B���^�̃C���p���X����
h = ones(3)/9.0;

%% 2-D FFT�̌v�Z
sizeFft = [64 64];
ampRes = abs(fftshift(fft2(h,sizeFft(1),sizeFft(2))));

%% ���g�������̕\��
[fx,fy] = freqspace(sizeFft,'meshgrid');
%[fx,fy] = meshgrid(...
%    -1:2/sizeFft(2):1-2/sizeFft(2), ...
%    -1:2/sizeFft(1):1-2/sizeFft(1));
mesh(fx,fy,ampRes);
xlabel('\omega_1 (\times \pi rad)');
ylabel('\omega_0 (\times \pi rad)');
zlabel('Magnitude');

% end of practice08_4.m
