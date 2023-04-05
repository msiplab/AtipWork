# 「画像処理特論」サンプルMファイル
[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=msiplab/AtipWork)

本リポジトリには、画像処理特論の実習課題で利用するMファイル群と画像データが保存されています。

今回提供するMファイル郡は以下の環境で動作の確認を行いました。

- OS
  - Windows 10
  - Linux 

- MATLAB
  - R2020a

- ツールボックス
  - Signal Processing Toolbox
  - Image Processing Toolbox 

---
## 利用方法

- MATLAB を起動後、cd コマンドなどを利用して、展開したフォルダ（ディレクトリ）に移動して下さい。

      >> cd AtipWork

  この時点で、ls コマンドを実行すると

      >> ls
      
      +msip         .git          Appendix      data          main_mlx2m.m  tmp           
      .             .gitignore    LICENSE       livescripts   scripts       work          
      ..            2019before    README.md     main_m2mlx.m  setpath.m            
      
      >> 

  と表示されると思います。

- MATLAB のコマンドウィンドウ上で setpath スクリプトを実行して下さい。

      >> setpath
　
　setpath スクリプトは、本実習を行う前に毎回実行してください。
 
- テクスト第4章で利用する 'calcio.avi'ファイルは、mkCalcioAvi スクリプトにより作成できます。
　（setpath スクリプトがあるディレクトリにて）

      >> mkCalcioAvi

  上記コマンドを実行後、ls コマンドで 'calcio.avi'ファイルが data ディレクトリ内に作成されていることを確認してください。

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

- [MATLAB Academy](https://matlabacademy.mathworks.com/jp)
- [MATLAB Grader](https://grader.mathworks.com/)

## 参考文献
- 村松正吾，「[MATLABによる画像＆映像信号処理](http://www.cqpub.co.jp/hanbai/books/30/30941.htm)」，CQ出版社，2007年
- 村松正吾，「[冗長変換とその画像復元応用](https://www.jstage.jst.go.jp/article/isj/53/4/53_290/_article/-char/ja/)」，日本画像学会誌，Vol. 53 (2014) No. 4 p. 290-300
- 村松正吾，「[MATLABによる映像処理システム開発](https://www.jstage.jst.go.jp/article/itej/65/11/65_1571/_article/-char/ja/)」，映像情報メディア学会誌，65 巻 (2011) 11 号 p. 1571-1574
- 村松正吾，「[画像復元における分析・合成システム](https://www.journal.ieice.org/summary.php?id=k106_1_2&year=2023&lang=J)」，電子情報通信学会誌2023年1月号

---
2018年4月9日 村松正吾 作成
2019年4月8日 更新
2019年4月17日 更新
2020年4月19日 更新
