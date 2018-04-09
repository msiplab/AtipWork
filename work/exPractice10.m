%%
picturewmv = frame2im(aviread('tmp/tempip.avi',2));
imwrite(picturewmv(73:73+144,89:89+176),'d:\temp\fig10-5a.tif');

%%
picturewomv = frame2im(aviread('tmp/tempip.avi',2));
imwrite(picturewomv(73:73+144,89:89+176),'d:\temp\fig10-5b.tif');

%%
picturewmv = frame2im(aviread('tmp/vertip.avi',2));
imwrite(picturewmv(73:73+144,89:89+176),'d:\temp\fig10-8a.tif');

%%
picturewomv = frame2im(aviread('tmp/vertip.avi',2));
imwrite(picturewomv(73:73+144,89:89+176),'d:\temp\fig10-8b.tif');

%%
picturewmv = frame2im(aviread('tmp/vtip.avi',2));
imwrite(picturewmv(73:73+144,89:89+176),'d:\temp\fig10-11a.tif');

%%
picturewomv = frame2im(aviread('tmp/vtip.avi',2));
imwrite(picturewomv(73:73+144,89:89+176),'d:\temp\fig10-11b.tif');

%%
picturewmv = frame2im(aviread('tmp/adpip.avi',2));
imwrite(picturewmv(73:73+144,89:89+176),'d:\temp\fig10-15a.tif');

%%
picturewomv = frame2im(aviread('tmp/adpip.avi',2));
imwrite(picturewomv(73:73+144,89:89+176),'d:\temp\fig10-15b.tif');

%%
picturewmv = frame2im(aviread('tmp/medip.avi',2));
imwrite(picturewmv(73:73+144,89:89+176),'d:\temp\fig10-17a.tif');

%%
picturewomv = frame2im(aviread('tmp/medip.avi',2));
imwrite(picturewomv(73:73+144,89:89+176),'d:\temp\fig10-17b.tif');

%%
picturewmv = imread('d:/temp/fig10-20org.tif');
imwrite(picturewmv(73:73+144,89:89+176),'d:\temp\fig10-20.tif');

%%
picturewmv = frame2im(aviread('tmp/mcvtip.avi',2));
imwrite(picturewmv(73:73+144,89:89+176),'d:\temp\fig10-28b.tif');

%%
picturewmv = imread('d:/temp/fig10-20org.tif');
imwrite(picturewmv(73:73+144,89:89+176),'d:\temp\fig10-20.tif');