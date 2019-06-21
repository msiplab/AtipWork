%% 
X = zeros(8);

bimg = cell(64,1);
for idx = 1:64
    C = X;
    C(idx) = 1;
    B = padarray(idct2(C)+.5,[16 16],.5,'both');
    bimg{idx} = padarray(B,[1 1],1,'both');
    imshow(bimg{idx})
end

 
%%
idx = 1;
arrayB = [];
for iRow = 1:8
    rowB = [];
    for iCol = 1:8
        rowB = [ rowB ; bimg{idx}];
        idx = idx + 1;
    end
    arrayB = [ arrayB rowB ];
end
figure
imshow(arrayB)

imwrite(arrayB,'dctB.png');
