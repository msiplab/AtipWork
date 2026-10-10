%[text] # Sample 2-2: Video processing
%[text] Advanced Topics in Image Processing, Lecture 2 "Input and Output of Images"
%[text] Shogo Muramatsu
%[text] Verified: MATLAB R2026b
%%
%[text] ## Preparation of a sample video
%[text] The JPEG sequence calcio000.jpg, ..., calcio149.jpg in the data folder is written to the
%[text] video file calcio.avi in the results folder (frame rate 30 frames/s, uncompressed AVI).
%[text] `VideoWriter` creates the writer object, `writeVideo` writes a frame.
[datfolder,resfolder] = atip.prjfolders();
nFrames = 150;
frameRate = 30;
% Output file
fileNameCalcio = fullfile(resfolder,'calcio.avi');
vwObj = VideoWriter(fileNameCalcio,'Uncompressed AVI');
vwObj.FrameRate = frameRate;
open(vwObj)
% Frame-by-frame processing
for iFrame = 1:nFrames
    % Read the current frame
    fileNameIn = fullfile(datfolder,sprintf('calcio%03d.jpg',iFrame-1));
    picture = imread(fileNameIn);
    % Write the frame
    writeVideo(vwObj,picture)
end
close(vwObj)
%%
%[text] ## Video sample play
%[text] `implay` opens a movie player (desktop only).
if usejava('desktop')
    implay(fileNameCalcio)
end
%%
%[text] ## Preparation of input video
%[text] Instantiation of a `VideoReader` object
videoReader = VideoReader(fileNameCalcio);
frameRate   = videoReader.FrameRate;
fprintf('%d x %d pixels, %g frames/s, %d frames\n', ...
    videoReader.Height, videoReader.Width, frameRate, videoReader.NumFrames)
%%
%[text] ## Preparation of output video
%[text] Instantiation of a `VideoWriter` object.  The video is saved without compression in the results folder.
fileNameOut = fullfile(resfolder,'calcio_gray.avi');
videoWriter = VideoWriter(fileNameOut,'Uncompressed AVI');
videoWriter.FrameRate = frameRate;
%%
%[text] ## Frame-by-frame processing
%[text] Grayscale conversion of each frame
open(videoWriter)
while hasFrame(videoReader)
    % Read a frame
    pictureIn = readFrame(videoReader);
    % Frame processing
    pictureOut = rgb2gray(pictureIn);
    % Write the frame
    writeVideo(videoWriter,pictureOut)
end
close(videoWriter)
%%
%[text] ## Output video play
if usejava('desktop')
    implay(fileNameOut)
else
    vr = VideoReader(fileNameOut);
    figure
    imshow(readFrame(vr))
    title('First frame of calcio\_gray.avi')
end
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
