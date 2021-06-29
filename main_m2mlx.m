%% MATLABスクリプトからライブスクリプトへの変換
%
% Copyright (c) Shogo MURAMATSU, 2018
% All rights resereved

srcDir = './scripts/';
dstDir = fullfile(pwd,'/livescripts/');
isVerbose = true;

%% ファイルの取得
list = ls([srcDir '*.m']);

%% ファイルの変換
for idx = 1:size(list,1)
    % ファイル名の抽出    
    [~,fname,~] = fileparts(list(idx,:));
    % ライブスクリプトへ変換
    msip.m2mlx(srcDir,fname,dstDir,isVerbose)
    % 変換後のスクリプトの内容
    open(fullfile(dstDir,[fname '.mlx']))
end