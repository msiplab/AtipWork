%
% $Id: exFread.m,v 1.2 2006/05/29 12:08:53 sho Exp $
%
% Copyright (C) 2005-2006 Shogo MURAMATSU, All rights reserved
%

% 画像サイズ 高さ×幅
frameSize = [612 816];
nPixels = prod(frameSize);
% 読込精度を uint8 に
precision = 'uint8=>uint8';
% 読込モード'r'にてファイルをオープン
fileId = fopen('firenze.yyy', 'r');
% 画像データを列ベクトルとして読込む
pictureGray = fread(fileId, nPixels, precision);
fclose(fileId);
% 列ベクトルを配列に変換
pictureGray = reshape(pictureGray, frameSize);
%
imshow(pictureGray);
%
% end
