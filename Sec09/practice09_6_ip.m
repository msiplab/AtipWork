% practice09_6.m
%
% $Id: practice09_6_ip.m,v 1.3 2007/05/07 11:09:47 sho Exp $
%
% Copyright (C) 2006-2015 Shogo MURAMATSU, All rights reserved
%

%% �ꎟ����ʑ�FIR�t�B���^�̏���
% �J�b�g�I�t���g��
fc = 1/3; % (�~�� rad)

% �ʉ߈�̎d�l
passEdge = fc-1/10; % (�~�� rad)

% �j�~��̎d�l
stopEdge = fc+1/10; % (�~�� rad)

% ���e�덷�̎d�l
deltaPass = 0.01;
deltaStop = 0.01;

%% �ꎟ���t�B���^�̋ߎ��d�l
specFrq = [passEdge stopEdge];
specAmp = [1 0];
specErr = [deltaPass deltaStop];
spec = firpmord(specFrq,specAmp,specErr,2,'cell');
if (mod(spec{1},2)~=0)
    spec{1}=spec{1}+1; % �t�B���^�̃^�b�v������ƂȂ�悤�Ɏ����������ɏC��
end
halfOrder = spec{1}/2;
h = firpm(spec{:});

%% �[���~�Ώ̒��ʉ߃t�B���^�p�p�����[�^
parameters.A = -1/2;
parameters.B = 1/2;
parameters.C = 1/2;
parameters.D = 1/4;
parameters.E = 1/4;

%% ���ʐ��̌v�Z
nPoints = 64;
[f1, f0] = freqspace(nPoints);
[w1, w0] = meshgrid(pi*f1,pi*f0);
g = mcClellanTrans(w1, w0, parameters);

%% ���ʐ��̕\��
figure(1)
c = contour(f1, f0, g, cos(0.1*pi:0.1*pi:0.9*pi));
clabel(c)
xlabel('\omega_1 (\times \pi rad)')
ylabel('\omega_0 (\times \pi rad)')
pbaspect([1 1 1]);

%% �񎟌��t�B���^�݌v
T = [ parameters.D  parameters.B  parameters.E;
      parameters.C 2*parameters.A parameters.C;
      parameters.E  parameters.B  parameters.D]/2;
twoDimensionalFilter = ftrans2(h,T);
% �������́A
% delta = 1;
% twoDimensionalFilter = mcClellanTransImFilter(h, delta, T, 'full');

%% �C���p���X�����̕\��
figure(2)
mesh(-halfOrder:halfOrder,-halfOrder:halfOrder,...
    twoDimensionalFilter)
xlabel('n_1')
ylabel('n_0')

%% �U�������̕\��
figure(3)
freqz2cq(twoDimensionalFilter)
xlabel('\omega_1 (\times \pi rad)')
ylabel('\omega_0 (\times \pi rad)')
% end of practice09_6.m
