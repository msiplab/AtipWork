function m2mlx(srcDir,fname,dstDir,isVerbose)
%M2MLX
%
% Copyright (c) Shogo MURAMATSU, 2018
% All rights reserved

% デフォルトの値を設定
if nargin < 1
    srcDir = './scripts/';    
end
if nargin < 2
    fname = 'sample01_01';
end
if nargin < 3
    dstDir = fullfile( pwd, '/livescripts/');
end
if nargin < 4
    isVerbose = true;
end

% 出力フォルダを準備
if exist(dstDir,'dir') ~= 7
    mkdir(dstDir)
end

% スクリプトからライブスクリプトに変換
if exist(dstDir,'dir') == 7
    srcFile = fullfile(srcDir, [fname '.m']);
    dstFile = fullfile(dstDir, [fname '.mlx']);
    if exist(srcFile,'file') == 2
        matlab.internal.liveeditor.openAndSave(srcFile, dstFile);
        if isVerbose
            fprintf('Open as livescript and saved %s\n',srcFile);
        end
    else
        me = MException('MsipException:NoSuchFiler', ...
        sprintf('%s does not exist',strrep(srcFile,'\','\\')));
        throw(me)
    end
else
    me = MException('MsipException:NoSuchFolder', ...
    sprintf('%s does not exist',strrep(dstDir,'\','\\')));
    throw(me)
end
