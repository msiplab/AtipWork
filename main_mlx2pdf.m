function main_mlx2pdf(varargin)
%% ライブスクリプトからPDFへの変換
%
% Copyright (c) Shogo MURAMATSU, 2020
% All rights resereved

srcDir = fullfile(pwd,'./livescripts/');
dstDir = './documents/';
isVerbose = true;

%% ファイルの取得
if nargin < 1
    list = ls([srcDir '*.mlx']);
else
    list = ls(sprintf('%s/%s*.mlx',srcDir,varargin{1}));    
end

%% ファイルの変換
for idx = 1:size(list,1)
    % ファイル名の抽出
    [~,fname,~] = fileparts(list(idx,:));
    % スクリプトへ変換
    msip.mlx2pdf(srcDir,fname,dstDir,isVerbose)
    % 変換後のスクリプトの内容
    %open(fullfile(dstDir,[fname '.m']))
end