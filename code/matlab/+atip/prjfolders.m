function [datfolder,resfolder,prjroot] = prjfolders()
%PRJFOLDERS Return the data and results folders of the AtipWork project
%
%   [DATFOLDER,RESFOLDER] = ATIP.PRJFOLDERS() returns the absolute paths of
%   the data and results folders right under the root of the AtipWork
%   project.  A folder that does not exist is created (results is not under
%   Git, so it does not exist right after cloning).
%
%   [DATFOLDER,RESFOLDER,PRJROOT] = ATIP.PRJFOLDERS() also returns the
%   project root.
%
%   If the project is not open, the root is inferred from the location of
%   this file (<root>/code/matlab/+atip/prjfolders.m).
%
%   Example:
%       [datfolder,resfolder] = atip.prjfolders();
%       X = imread(fullfile(datfolder,"kodim01.png"));
%       imwrite(X,fullfile(resfolder,"atip-01-org.png"))
%
%   See also ATIP.DOWNLOAD_IMG, ATIP.MSIPIMG
%
% Copyright (c) Shogo MURAMATSU, 2026
% All rights reserved.
%

prjroot = "";
try
    prj = matlab.project.currentProject;
    % When no project is open, an empty project may be returned without an
    % error (empty RootFolder).  Use the fallback below in that case.
    if ~isempty(prj) && strlength(string(prj.RootFolder)) > 0 ...
            && isfile(fullfile(prj.RootFolder,"AtipWork.prj"))
        prjroot = string(prj.RootFolder);
    end
catch
end
if strlength(prjroot) == 0
    % Infer from the location of this file:
    % <root>/code/matlab/+atip/prjfolders.m
    here = fileparts(mfilename("fullpath"));            % .../code/matlab/+atip
    prjroot = string(fileparts(fileparts(fileparts(here))));
end

datfolder = fullfile(prjroot,"data");
resfolder = fullfile(prjroot,"results");

for folder = [datfolder resfolder]
    if ~isfolder(folder)
        mkdir(folder)
    end
end

end
