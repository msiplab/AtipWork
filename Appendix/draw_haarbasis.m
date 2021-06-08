%% Haar
X = zeros(40);
factor = 5;
[C,S] = wavedec2(X,3,'haar');

offset = 0;
idx = 1;

bimg = cell(64,1);

% LLê¨ï™
idxS = 1;
C = 0*C;
subHeight = S(idxS,1);
subWidth  = S(idxS,2);
subNumel = subHeight*subWidth;
offsetRow = ceil(subHeight/factor*(factor-1)/2);
offsetCol = ceil(subWidth/factor*(factor-1)/2);
iCol = 1;
iRow = 1;
Y = zeros(subHeight,subWidth);
Y(offsetRow+iRow,offsetCol+iCol) = 1;
C(offset+1:offset+subHeight*subWidth) = Y(:).';
B = waverec2(C,S,'haar');
bimg{idx} = padarray(B+.5,[1 1],1,'both');
%
subplot(8,8,idx)
imshow(B+.5)
%imwrite(B+.5,sprintf('haar%02d.png',idx))
idx = idx + 1;
drawnow
offset = subNumel;

% LLê¨ï™à»äO
level = 1;
for idxS = 2:size(S,1)-1
    subHeight = S(idxS,1);
    subWidth  = S(idxS,2);
    subNumel = subHeight*subWidth;
    for iSub = 1:3
        C = 0*C;
        offsetRow = ceil(subHeight/factor*(factor-1)/2);
        offsetCol = ceil(subWidth/factor*(factor-1)/2);
        for iCol = 1:2^(level-1)
            for iRow = 1:2^(level-1)
                Y = zeros(subHeight,subWidth);
                Y(offsetRow+iRow,offsetCol+iCol) = 1;
                C(offset+1:offset+subHeight*subWidth) = Y(:).';
                B = waverec2(C,S,'haar');
                bimg{idx} = padarray(B+.5,[1 1],1,'both');
                subplot(8,8,idx)
                imshow(B+.5)
                % imwrite(B+.5,sprintf('haar%02d.png',idx))                
                idx = idx + 1;
                drawnow
            end
        end
        offset = offset + subNumel;
    end
    level = level + 1;
end

%%
idx = 1;
arrayB = [];
for iRow = 1:2
    rowB = [];
    for iCol = 1:2
        rowB = [ rowB ; bimg{idx}];
        idx = idx + 1;
    end
    arrayB = [ arrayB rowB ];
end

for lev = 2:3
    arrayBB = cell(3,1);
    for iSub = 1:3
        arrayBB{iSub} = [];
        for iRow = 1:2^(lev-1)
            rowB = [];
            for iCol = 1:2^(lev-1)
                rowB = [ rowB ; bimg{idx}];
                idx = idx + 1;
            end
            arrayBB{iSub} = [ arrayBB{iSub} rowB ];
        end
    end
    arrayB = [ arrayB arrayBB{2}; arrayBB{1} arrayBB{3}];
end

figure
imshow(arrayB)
imwrite(arrayB,'haarB.png');


%imwrite(arrayB,'haarB.png');
%ninesevenls = liftwave('9.7');

%r = waverec2(C,S,'haar')


