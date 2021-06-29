%
% $Id: exMovie.m,v 1.2 2006/05/29 12:08:53 sho Exp $
%
% Copyright (C) 2005-2006 Shogo MURAMATSU, All rights reserved
%

fileName = 'data/calcio.avi';
fileInfo = aviinfo(fileName);
frameRate = fileInfo.FramesPerSecond;
frameSeq = aviread(fileName);
nRepeats = 3;
movie(frameSeq, nRepeats, frameRate);
