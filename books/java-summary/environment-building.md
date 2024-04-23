---
title: "開発環境構築"
---

## 開発環境イメージ図

![](https://storage.googleapis.com/zenn-user-upload/fe88aa2c8f91-20240422.png)

![](https://storage.googleapis.com/zenn-user-upload/497c73fe5e36-20240422.png)

## JDK

- Java Development Kit の略
- Java のプログラム開発や実行を行うためのプログラムのセット
- JDK をインストすれば、Java でアプリケーション作成や実行まで一通りできる
- Java で開発するための SDK だと思えば OK
- JDK は以下 2 つを含んでいる
  1. JRE
  2. コンパイラ・デバッガ

## Java API（API）

- Java の公式開発者である Oracle（以前は Sun Microsystems）によって提供される公式のライブラリやインターフェースのこと
- サードパーティ製のライブラリは「Java ライブラリ」や「Java フレームワーク」と呼ばれるのが一般的
- Java API には以下 3 種類存在する
  - Java SE
  - Java EE（Jakarta EE）
  - Java Me

### Java SE

- Java Platform, Standard Edition の略
- Java で提供される API は非常に多く、Java SE はその中でも基本となる API をまとめたもの
- **Java SE は、JDK に標準で組み込まれており、別途インストールする必要がない**
- デスクトップアプリケーションなどを開発する場合は Java SE だけでも事足りるケースが多い

### Java EE（Jakarta EE）

- Java Platform, Enterprise Edition の略
- 大規模なシステムで開発する場合に必要となる API が含まれる
- Java EE は Java SE の拡張機能という位置づけ
- Java EE は 2017 年に oracle から Eclipse Foundation に移管済であり、名称は Java EE から Jakarta EE になった
- **使用するには別途インストールが必要**

### Java ME

- Java Platform, Micro Editon の略
- 組み込み機器やモバイルデバイスで動作するアプリケーション開発用の API が含まれる
- **使用するには別途インストールが必要**

## JVM

- Java Virtual Machine の略
- Java で作成したプログラムを OS で動作させるのに必要になる
- Java で作成した `.java` をコンパイルすると、中間コードと呼ばれる Java クラスファイル（`.class`）が出力される
- この `.class` はどの OS 環境でコンパイルしても同じものが生成される
- `.class` は単独では実行できず、実行環境の OS 上にインストールされた JVM で実行される
- 重要な点は、**各 OS に対して特別に設計された JVM が存在すること**
  - Windows 用、Linux 用、macOS 用の JVM があるイメージ
- Java プログラムが異なる OS で実行される際、実際に OS と直接対話するのは JVM である
- Java プログラムは、直接 OS の機能を使わず、JVM を通じて OS 機能を利用する
- 同じ `.java` や `.class` のコードが異なる OS でも動作するのは、JVM が OS の仕様を吸収してくれているから

## JRE

- Java アプリケーションを実行するために必要なソフトウェアのパッケージ
- Java のランタイム環境のこと
- 以下 3 つを含む
  1. JVM
  2. Java API
  3. その他の必要なランタイムコンポーネント

## AdoptOpenJDK + VSCode で環境構築

https://qiita.com/Shi-raCanth/items/351ebfb1ae3b0362c867
