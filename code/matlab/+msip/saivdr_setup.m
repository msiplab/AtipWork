function saivdr_setup(isCodegen)
%SAIVDR_SETUP Download SaivDr into the project and add it to the path
%
%   MSIP.SAIVDR_SETUP() downloads the SaivDr package (GitHub msiplab/SaivDr,
%   release SAIVDR_VER) as a zip file, unzips it into the folder "code" of
%   the AtipWork project (code/SaivDr-<version>, ignored by Git), runs its
%   setpath and builds the MEX files (mybuild) if they do not exist.
%
%   MSIP.SAIVDR_SETUP(ISCODEGEN) skips the code generation when ISCODEGEN
%   is false (default true).
%
%   The current folder is restored after the setup; nothing is written to
%   the current folder.
%
%   See also ATIP.PRJFOLDERS
%
% Copyright (c) Shogo MURAMATSU, 2018-2026
% All rights reserved.
%
arguments
    isCodegen (1,1) logical = true
end

% SaivDr package version
SAIVDR_VER = "4.2.2.2";

[~,~,prjroot] = atip.prjfolders();
codefolder = fullfile(prjroot,"code");
saivdrdir = fullfile(codefolder,"SaivDr-"+SAIVDR_VER);
if ~isfolder(saivdrdir)
    unzip("https://github.com/msiplab/SaivDr/archive/refs/tags/"+SAIVDR_VER+".zip",codefolder)
else
    disp("SaivDr-" + SAIVDR_VER + " exists in " + codefolder + ".")
end

% setpath and mybuild of SaivDr work in the SaivDr folder
ccd = cd(saivdrdir);
restore = onCleanup(@() cd(ccd));
setpath
if ~isCodegen
    disp("Skip code generation")
elseif isempty(dir(fullfile(saivdrdir,"mexcodes","fcn_*")))
    mybuild
else
    disp("MEX files exist.")
end
end
