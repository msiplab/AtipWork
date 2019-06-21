I = im2double(imread('cameraman.tif'));
H00 = [1 1 ; 1 1 ]/2;
H01 = [1 -1; 1 -1]/2;
H10 = [1 1 ; -1 -1]/2;
H11 = [1 -1 ; -1 1 ]/2;

figure(1)
%%

J00 = downsample(downsample(imfilter(I,H00,'conv','circ'),2).',2).';
subplot(2,2,1);
imshow(J00/2)
imwrite(J00/2,'cameraman_ll1.png')

J01 = downsample(downsample(imfilter(I,H01,'conv','circ'),2).',2).';
subplot(2,2,2);
imshow(J01+.5)
imwrite(J01+.5,'cameraman_lh1.png')

J10 = downsample(downsample(imfilter(I,H10,'conv','circ'),2).',2).';
subplot(2,2,3);
imshow(J10+.5)
imwrite(J10+.5,'cameraman_hl1.png')

J11 = downsample(downsample(imfilter(I,H11,'conv','circ'),2).',2).';
subplot(2,2,4);
imshow(J11+.5)
imwrite(J11+.5,'cameraman_hh1.png')

A = [ J00/2 2*J01 ; 2*J10 2*J11 ];

%%
I = J00/2;

J00 = downsample(downsample(imfilter(I,H00,'conv','circ'),2).',2).';
subplot(2,2,1);
imshow(J00/2)
imwrite(J00/2,'cameraman_ll2.png')

J01 = downsample(downsample(imfilter(I,H01,'conv','circ'),2).',2).';
subplot(2,2,2);
imshow(J01+.5)
imwrite(J01+.5,'cameraman_lh2.png')

J10 = downsample(downsample(imfilter(I,H10,'conv','circ'),2).',2).';
subplot(2,2,3);
imshow(J10+.5)
imwrite(J10+.5,'cameraman_hl2.png')

J11 = downsample(downsample(imfilter(I,H11,'conv','circ'),2).',2).';
subplot(2,2,4);
imshow(J11+.5)
imwrite(J11+.5,'cameraman_hh2.png')

A(1:end/2,1:end/2) =  [ J00/2 2*J01 ; 2*J10 2*J11 ];

%%
I = J00/2;

J00 = downsample(downsample(imfilter(I,H00,'conv','circ'),2).',2).';
subplot(2,2,1);
imshow(J00/2)
imwrite(J00/2,'cameraman_ll3.png')

J01 = downsample(downsample(imfilter(I,H01,'conv','circ'),2).',2).';
subplot(2,2,2);
imshow(J01+.5)
imwrite(J01+.5,'cameraman_lh3.png')

J10 = downsample(downsample(imfilter(I,H10,'conv','circ'),2).',2).';
subplot(2,2,3);
imshow(J10+.5)
imwrite(J10+.5,'cameraman_hl3.png')

J11 = downsample(downsample(imfilter(I,H11,'conv','circ'),2).',2).';
subplot(2,2,4);
imshow(J11+.5)
imwrite(J11+.5,'cameraman_hh3.png')

A(1:end/4,1:end/4) =  [ J00/2 2*J01 ; 2*J10 2*J11 ];

%%
figure(2)
imshow(abs(A))
imwrite(A,'cameraman_mra.png')

