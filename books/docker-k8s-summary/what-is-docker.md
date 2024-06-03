---
title: "Dockerとは？"
---

## Docker は「データやプログラムを隔離できる」仕組み

![](https://storage.googleapis.com/zenn-user-upload/7417e9aa6774-20240603.png)

- サーバーでは、複数のプログラムが動いている
  - Apache, Java, MySQL など
- 複数のプログラム・データをそれぞれ独立した環境に隔離できるのが Docker
- 隔離するのは、プログラム・データだけでなく、OS（っぽいもの）ごとでも可能

## コンテナと Docker Engine

![](https://storage.googleapis.com/zenn-user-upload/5404908f3f08-20240603.png)\

- 隔離した環境のことを**コンテナ**という
  - コンテナを使えるようにするための仕組みが Docker
- Docker を仕様するには、Docker のソフトウェア（**Docker Engine**）を使用する
  - コンテナの作成・起動が可能になる

## コンテナはイメージから作る

- コンテナは**イメージ（image）**から作成する
- イメージはコンテナの素
- イメージはたくさんの種類がある
  - Apache のコンテナを作成したいなら、Apache のイメージを利用する
  - MySQL のコンテナを作成したいなら、MySQL のイメージを利用する

![](https://storage.googleapis.com/zenn-user-upload/76aa55276bf6-20240603.png)
