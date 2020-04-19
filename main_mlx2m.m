%% ライブスクリプトからMATLABスクリプトへの変換
%
% Copyright (c) Shogo MURAMATSU, 2020
% All rights resereved

srcDir = fullfile(pwd,'./livescripts/');
dstDir = './scripts/';
isVerbose = true;

%% ファイルの取得
list = ls([srcDir '*.mlx']);

%% ファイルの変換
for idx = 1:size(list,1)
    % ファイル名の抽出
    [~,fname,~] = fileparts(list(idx,:));
    % スクリプトへ変換
    msip.mlx2m(srcDir,fname,dstDir,isVerbose)
    % 変換後のスクリプトの内容
    %open(fullfile(dstDir,[fname '.m']))
end