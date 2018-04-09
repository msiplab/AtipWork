# 「画像処理特論」実習用Mファイル

本リポジトリには、画像処理特論の実習課題で利用するMファイル群(practiceXX_X.m)と画像データが保存されています。

今回提供するMファイル郡は以下の環境で動作の確認を行いました。

- OS
  - Windows 10
  - Linux 

- MATLAB
  - R2017b

- ツールボックス
  - Signal Processing Toolbox
  - Image Processing Toolbox (practiceXX_X_ip.mのみで利用） 

---
## 利用方法 

- MATLAB を起動後、cd コマンドなどを利用して、展開したフォルダ（ディレクトリ）に移動して下さい。

      >> cd AtipWork

  この時点で、ls コマンドを実行すると

      >> ls
        
      .          Appendix   Sec03      Sec06      Sec09      data       work       
      ..         LICENSE    Sec04      Sec07      Sec10      setpath.m  
      .git       README.md  Sec05      Sec08      common     tmp               
      
      >>

  と表示されると思います。

- MATLAB のコマンドウィンドウ上で setpath スクリプトを実行して下さい。

      >> setpath
　
　setpath スクリプトは、本実習を行う前に毎回実行してください。

- 引き続き、第4章で利用する 'calcio.avi'ファイルを作成するために、mkCalcioAvi スクリプトを実行してください。
　（setpath スクリプトがあるディレクトリにて）

      >> mkCalcioAvi

　続けて、ls コマンドで 'calcio.avi'ファイルが data ディレクトリ内に作成されていることを確認してください。

      >> ls data/calcio.avi
        
      calcio.avi  

　これで準備完了です。（作成は一度だけでOKです。）

- Mファイルを実行するには、ファイル名から .m の拡張子を除いてコマンド入力してください。例えば、practice03_1.m の実行の際は、setpath スクリプトがあるディレクトリにて、

      >> practice03_1
      >>

  と入力して下さい。

- Mファイルを編集するには、edit コマンドを利用してください。
  例えば、practice03_1.m を編集する場合は、

      >> edit practice03_1
      >>

  と入力して下さい。

以上

## リンク

- [Cody Coursework](https://coursework.mathworks.com/courses/4881-2018)

## 参考文献
- 村松正吾，「[MATLABによる画像＆映像信号処理](http://www.cqpub.co.jp/hanbai/books/30/30941.htm)」，CQ出版社，2007年

---
2018年4月9日 村松正吾
