---
title: "ざっくりDockerとは？"
---

## Docker は「実行環境を隔離できる」仕組み

![](https://storage.googleapis.com/zenn-user-upload/7417e9aa6774-20240603.png)

- サーバーには、複数のプログラムが動いている
  - Apache, Java, MySQL など
- 複数のプログラム・データをそれぞれ独立した環境に隔離できるのが Docker
- 隔離するのは、プログラム・データだけでなく、OS（っぽいもの）ごとでも可能
- つまり、何かしらの**実行環境**を隔離することができる

## なぜ隔離する必要があるのか？

プログラムは単独で動いているのではなく、実行環境やライブラリ、他のプログラムを使用している。

![](https://storage.googleapis.com/zenn-user-upload/f37263bed219-20240604.png)

ソフトウェアも、単体のプログラムではなく、複数のプログラムで構成されていることが多い。
また、異なるシステムが同じリソースを共有していることもある。

![](https://storage.googleapis.com/zenn-user-upload/63cfcabe5a7e-20240604.png)

その場合、以下のような問題が発生する可能性がある。

![](https://storage.googleapis.com/zenn-user-upload/353cef4928ef-20240604.png)

## 隔離するとは？

![](https://storage.googleapis.com/zenn-user-upload/d911856b979d-20240604.png)

- Docker があればコンテナ単位で「にゃんころプログラム」をインストールできる
- よって、1 つのマシンに複数バージョンをインストールできる

## コンテナと Docker Engine

![](https://storage.googleapis.com/zenn-user-upload/5404908f3f08-20240603.png)

- 隔離した環境のことを**コンテナ**という
  - コンテナを使えるようにするための仕組みが Docker
- Docker を仕様するには、**Docker のソフトウェア（Docker Engine）** を使用する
  - コンテナの作成・起動が可能になる

## コンテナはイメージから作る

- コンテナは **イメージ（image）** から作成する
- イメージはコンテナの素
- イメージはたくさんの種類がある
  - Apache のコンテナを作成したいなら、Apache のイメージを利用する
  - MySQL のコンテナを作成したいなら、MySQL のイメージを利用する

![](https://storage.googleapis.com/zenn-user-upload/76aa55276bf6-20240603.png)

## サーバーとは？

https://qiita.com/mi-1109/items/a8e5cfa0637ba2925b59

**サービスを提供するもの**

開発現場における「サーバー」は 2 種類の意味を持つ。

![](https://storage.googleapis.com/zenn-user-upload/6386e16b43f7-20240604.png)

![](https://storage.googleapis.com/zenn-user-upload/95dea110cd67-20240604.png)

「機能としてのサーバー」はソフトウェアで提供される。
専用のソフトウェアを物理マシンにインストールすることで、「サーバー」としての機能を持つことができる。

- Apache は Web サーバーとしての機能を提供するソフトウェア
- MySQL は DB サーバーとしての機能を提供するソフトウェア

![](https://storage.googleapis.com/zenn-user-upload/1aa0a0a3100d-20240604.png)

1 つの物理サーバーには複数のソフトウェアをインストールできる。
そのため、**「機能としてのサーバー」を 1 つの物理サーバーに同居できる。**

![](https://storage.googleapis.com/zenn-user-upload/08f82dca63a1-20240604.png)

そして、**サーバーには OS が必須**で、OS の上でソフトウェア（機能としてのサーバー）が動く。

![](https://storage.googleapis.com/zenn-user-upload/1d6cd22e3bd2-20240604.png)

## サーバーの OS は Linux が多数

「機能としてのサーバー」は Linux or Unix 系の OS が採用されることが多い。

![](https://storage.googleapis.com/zenn-user-upload/8b63f264054b-20240605.png)

## Docker は Linux OS 上で使用する

- **Docker を動かすには Linux OS が必要**
- Windows や Mac でも動かせるが、その場合は何かしらの形で Linux OS をマシンに入れる必要がある
- また、**コンテナに入れるプログラムも Linux 用のプログラムである必要がある**

![](https://storage.googleapis.com/zenn-user-upload/75000a76ce34-20240604.png)

## コンテナは複数のサーバーを安全に同居させる

予算や管理コストの関係で 1 台の物理サーバーに複数の機能サーバーを同居させることが Docker であれば**容易に実現できる**。
これは、コンテナ技術により成り立っている。

![](https://storage.googleapis.com/zenn-user-upload/2f777422590c-20240605.png)

異なるバージョンの Apache サーバーを 1 つのサーバーに複数同居させることができる。
しかも**安全に**。

## コンテナは他のマシンと共通できる

![](https://storage.googleapis.com/zenn-user-upload/357e20f31308-20240605.png)

- Docker を使用していれば、同じコンテナ環境を複数のマシンで共有できる
- よって、コンテナを共有するだけで開発環境を簡単に構築できる
- 開発サーバで作成したものをそのまま本番サーバーへ共有することも可能
- **Doker さえ入っていれば、物理的な環境差異を無視できる**

## 仮想化技術との違い

- Docker はサーバーを仮想化したものではない
- **実行環境を隔離する**もの
