function saivdr_setup(isCodegen)
%
if nargin < 1
    isCodegen = true;
end

% SaivDr パッケージバージョン
SAIVDR_VER = "4.2.2.2";
SAIVDR_DIR = "SaivDr-"+SAIVDR_VER;
if ~exist(SAIVDR_DIR,"dir")
    unzip("https://github.com/msiplab/SaivDr/archive/refs/tags/"+SAIVDR_VER+".zip")
else
    disp(SAIVDR_DIR+" exits.")
end
ccd = cd(SAIVDR_DIR);
setpath
if ~isCodegen
    disp("Skip code generation")
elseif isempty(dir("./mexcodes/fcn_*"))
    mybuild
else
    disp("MEX files exist.")
end
cd(ccd)
end