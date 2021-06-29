% ‰æ‘œ‚Ì“Ç
pictureRgb = imread('./data/firenzeRgb.jpg');%barbaraRgb.tif');
%pictureRgb = pictureRgb(1:608,:,:);

% ƒ‚ƒmƒNƒ‰æ‘œ‚Ö‚Ì•ÏŠ·
pictureGray = rgb2gray(im2double(pictureRgb));

% 5/3 ‡•ÏŠ·
[subLL2,subHL2,subLH2,subHH2] = im97trnscq_ip(pictureGray);
[subLL1,subHL1,subLH1,subHH1] = im97trnscq_ip(subLL2);
[subLL0,subHL0,subLH0,subHH0] = im97trnscq_ip(subLL1);

subHH2 = 1 * subHH2;
subLH2 = 1 * subLH2;
subHL2 = 1 * subHL2;
subHH1 = 1 * subHH1;
subLH1 = 1 * subLH1;
subHL1 = 1 * subHL1;
subHH0 = 1 * subHH0;
subLH0 = 1 * subLH0;
subHL0 = 1 * subHL0;

subband1 = [subLL0 4*abs(subHL0) ; 
    4*abs(subLH0) 4*abs(subHH0)];
subband2 = [subband1 4*abs(subHL1) ; 
    4*abs(subLH1) 4*abs(subHH1)];
subband3 = [ subband2 4*abs(subHL2);
    4*abs(subLH2) 4*abs(subHH2) ];
                
figure(1);imshow(subband3);

subLL1 = im97itrnscq_ip(subLL0,subHL0,subLH0,subHH0);
subLL2 = im97itrnscq_ip(subLL1,subHL1,subLH1,subHH1);
pictureRec = im97itrnscq_ip(subLL2,subHL2,subLH2,subHH2);

figure(2);imshow(pictureRec);
