function download_img(isVerbose)
%DOWNLOAD_IMG Download the exercise images to the data folder
%
%   ATIP.DOWNLOAD_IMG() downloads kodim01.png ... kodim24.png of the Kodak
%   Lossless True Color Image Suite to the data folder of the AtipWork
%   project.  Files that already exist are not downloaded again.
%
%   ATIP.DOWNLOAD_IMG(ISVERBOSE) switches the progress messages (default true).
%
%   The images are not under Git.  Run this once after cloning.
%
%   See also ATIP.PRJFOLDERS, ATIP.MSIPIMG
%
% Copyright (c) Shogo MURAMATSU, 2018-2026
% All rights reserved.
%

arguments
    isVerbose (1,1) logical = true
end

datfolder = atip.prjfolders();

baseurl = "https://www.r0k.us/graphics/kodak/kodak/";
for idx = 1:24
    fname = "kodim" + num2str(idx,'%02d') + ".png";
    dstfile = fullfile(datfolder,fname);
    if isfile(dstfile)
        if isVerbose
            fprintf('%s already exists in %s\n',fname,datfolder);
        end
        continue
    end
    img = imread(baseurl + fname);
    imwrite(img,dstfile)
    if isVerbose
        fprintf('Downloaded and saved %s in %s\n',fname,datfolder);
    end
end

if isVerbose
    disp('Source: <a href="http://www.r0k.us/graphics/kodak/">Kodak Lossless True Color Image Suite</a>')
end

end
