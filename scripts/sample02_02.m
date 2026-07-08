%[text] # Sample 2-2
%[text] ## 画像データの入出力
%[text] 動画像処理 
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Input and output of images
%[text] Video processing
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a
%%
%[text] ### サンプル画像の準備
%[text] (Preparation of sample image)
%[text] 本サンプルで利用する画像データを収めたdata フォルダにパスをとおして，サンプル動画を準備。
%[text] Create a path to the data folder that contains images used in this sample, and prepare a sample video.
addpath('./data')
close
% Preparation of a sample video
mkCalcioAvi
%[text] ### 動画像サンプルの再生
%[text] (Video sample play)
implay('calcio.avi');
%%
%[text] ### 入力動画の準備
%[text] (Preparation of input video)
%[text] VideoReaderオブジェクトの生成
%[text] Instantiation of VideoReader object
videoReader = VideoReader('calcio.avi');
frameRate   = videoReader.FrameRate;
%%
%[text] ### 出力動画の準備
%[text] (Preparation of output video)
%[text] VideoWriterオブジェクトの生成
%[text] 非圧縮で保存
%[text] Instantiation of VideoWriter object
%[text] Save without any compression.
videoWriter  = VideoWriter('calcio_gray.avi','Uncompressed AVI');
videoWriter.FrameRate = frameRate;
%%
%[text] ### フレーム毎の処理
%[text] (Frame-by-frame processing)
%[text] フレームごとのグレースケール変換
%[text] Frame-by-frame grayscale conversion
videoWriter.open();
while(videoReader.hasFrame())
    % Reading frame
    pictureIn = videoReader.readFrame();
    % Frame processing
    pictureOut = rgb2gray(pictureIn);
    % Writing frame
    videoWriter.writeVideo(pictureOut);
end
videoWriter.close();
%%
%[text] ### 動画像処理結果の再生
%[text] (Output video play)
implay('calcio_gray.avi');
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
