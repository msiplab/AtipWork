function download_img(isVerbose)
% DOWNLOAD_IMG 
%
% Copyright (c) Shogo MURAMATSU, 2018-2023
% All rights reserved.
%

% デフォルトの値を設定
if nargin < 1
    isVerbose = true;
end

% 画像サンプルのダウンロード
dstdir = './data/';
if exist(dstdir,'dir') == 7
    %fnames = {'lena' 'baboon' 'goldhill' 'barbara'};
    for idx = 1:24 %length(fnames)
        fname = "kodim"+num2str(idx,'%02d') + ".png"; % [ fnames{idx} '.png' ]
        if exist(fullfile(dstdir,fname),'file') ~= 2
            img = imread(...
                ...sprintf('http://homepages.cae.wisc.edu/~ece533/images/%s',...
                ...fname));
                "http://www.r0k.us/graphics/kodak/kodak/"+fname);                
            imwrite(img,fullfile(dstdir,fname))
            if isVerbose
                fprintf('Downloaded and saved %s in %s\n',fname,dstdir);
            end
        else
            if isVerbose
                fprintf('%s already exists in %s\n',fname,dstdir);
            end
        end
    end
    disp('See <a href="http://www.r0k.us/graphics/kodak/">Kodak Lossless True Color Image Suite</a>')
else
    me = MException('MsipException:NoSuchFolder', ...
        '%s folder does not exist',dstdir);
    throw(me)
end
