close all
%%
I = im2double(imread('cameraman.tif'));
H00 = [1 1 ; 1 1 ]/2;
H01 = [1 -1; 1 -1]/2;
H10 = [1 1 ; -1 -1]/2;
H11 = [1 -1 ; -1 1 ]/2;

figure(1)
%%
nbins = 128;

J00 = downsample(downsample(imfilter(I,H00,'conv','circ'),2).',2).';
ax00 = subplot(2,2,1);
hist(ax00,J00(:),nbins)
%imwrite(J00/2,'cameraman_ll1.png')
ax00.YLim = [0 8000];
ax00.XLim = [0 2];
ax00.FontSize = 12;
xlabel('c_{\rm LL}')
grid on 

J01 = downsample(downsample(imfilter(I,H01,'conv','circ'),2).',2).';
ax01 = subplot(2,2,2);
hist(ax01,J01(:),nbins)
%imwrite(J01+.5,'cameraman_lh1.png')
ax01.YLim = [0 8000];
ax01.XLim = [-1 1];
ax01.FontSize = 12;
xlabel('c_{\rm LH}')
grid on 

J10 = downsample(downsample(imfilter(I,H10,'conv','circ'),2).',2).';
ax10 = subplot(2,2,3);
hist(ax10, J10(:),nbins)
%imwrite(J10+.5,'cameraman_hl1.png')
ax10.YLim = [0 8000];
ax10.XLim = [-1 1];
ax10.FontSize = 12;
xlabel('c_{\rm HL}')
grid on 

J11 = downsample(downsample(imfilter(I,H11,'conv','circ'),2).',2).';
ax11 = subplot(2,2,4);
hist(ax11, J11(:),nbins)
%imwrite(J11+.5,'cameraman_hh1.png')
ax11.YLim = [0 8000];
ax11.XLim = [-1 1];
ax11.FontSize = 12;
xlabel('c_{\rm HH}')
grid on 

%A = [ J00/2 2*J01 ; 2*J10 2*J11 ];

%{
I = J00/2;

J00 = downsample(downsample(imfilter(I,H00,'conv','circ'),2).',2).';
subplot(2,2,1);
imhist(J00)
%imwrite(J00/2,'cameraman_ll2.png')

J01 = downsample(downsample(imfilter(I,H01,'conv','circ'),2).',2).';
subplot(2,2,2);
imhist(J01)
%imwrite(J01+.5,'cameraman_lh2.png')

J10 = downsample(downsample(imfilter(I,H10,'conv','circ'),2).',2).';
subplot(2,2,3);
imhist(J10)
%imwrite(J10+.5,'cameraman_hl2.png')

J11 = downsample(downsample(imfilter(I,H11,'conv','circ'),2).',2).';
subplot(2,2,4);
imhist(J11)
%imwrite(J11+.5,'cameraman_hh2.png')

A(1:end/2,1:end/2) =  [ J00/2 2*J01 ; 2*J10 2*J11 ];

%%
I = J00/2;

J00 = downsample(downsample(imfilter(I,H00,'conv','circ'),2).',2).';
subplot(2,2,1);
imhist(J00)
%imwrite(J00/2,'cameraman_ll3.png')

J01 = downsample(downsample(imfilter(I,H01,'conv','circ'),2).',2).';
subplot(2,2,2);
imhist(J01)
%imwrite(J01+.5,'cameraman_lh3.png')

J10 = downsample(downsample(imfilter(I,H10,'conv','circ'),2).',2).';
subplot(2,2,3);
imhist(J10)
%imwrite(J10+.5,'cameraman_hl3.png')

J11 = downsample(downsample(imfilter(I,H11,'conv','circ'),2).',2).';
subplot(2,2,4);
imhist(J11)
%imwrite(J11+.5,'cameraman_hh3.png')

A(1:end/4,1:end/4) =  [ J00/2 2*J01 ; 2*J10 2*J11 ];
%}
%%
%figure(2)
%imshow(abs(A))
%imwrite(A,'cameraman_mra.png')

