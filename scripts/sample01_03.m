%[text] # Sample 1-3
%[text] ## 画像データの表現
%[text] FOR ループ
%[text] 画像処理特論
%[text] 村松 正吾 
%[text] 動作確認: MATLAB R2023a
%[text] ## Digital image representation
%[text] FOR loop
%[text] Advanced Topics in Image Processing
%[text] Shogo MURAMATSU
%[text] Verified: MATLAB R2023a 
%%
%[text] ### 変数 $s$ の初期化 
%[text] (Initialize variable $s$)
%[text]{"align":"center"} $s\\leftarrow 0$
s = 0;
%%
%[text] ### 累積加算
%[text] (Accumulation)
%[text]{"align":"center"} $s = \\sum\_{k=1}^{10}k$
for k=1:10
   s = s + k;
end
%%
%[text] ### 結果の表示
%[text] (Display result)
disp(s)
%%
%[text] © Copyright, Shogo MURAMATSU, All rights reserved.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
