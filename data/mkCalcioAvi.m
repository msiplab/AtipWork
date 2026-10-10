%
% Make the Calcio AVI file from the sequence of JPEG files
%
% Reads calcio000.jpg, ..., calcio149.jpg from the data folder of AtipWork
% and writes calcio.avi (uncompressed, 30 frames/s) to the results folder.
% Sample 2-2 (scripts/sample02_02.m) contains the same steps.
%
% Copyright (C) 2014-2026 Shogo MURAMATSU, All rights reserved
%
nFrames = 150;
frameRate = 30;
[datfolder,resfolder] = atip.prjfolders();

%% Output file
fileNameOut = fullfile(resfolder,'calcio.avi');
vwObj = VideoWriter(fileNameOut,'Uncompressed AVI');
vwObj.FrameRate = frameRate;
open(vwObj)

%% Frame-by-frame processing
for iFrame = 1:nFrames
    % Read the frame
    fileNameIn = fullfile(datfolder,sprintf('calcio%03d.jpg',iFrame-1));
    picture = imread(fileNameIn);
    % Write the frame
    writeVideo(vwObj,picture)
end
close(vwObj)
