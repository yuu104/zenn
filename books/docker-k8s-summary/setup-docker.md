---
title: "Dockerのセットアップ"
---

## Docker を使う方法は 3 つ

1. Linux マシンで Docker を使う
2. VM やレンタル環境に Docker をインスト流し、Wndows や Mac で操作する
3. Docker Desktop をインストールし、Windows や Mac で操作する

![](https://storage.googleapis.com/zenn-user-upload/53a4862aba6a-20240608.png)

Windows や Mac を使用している場合、Docker Desctop を使用するのがおすすめ。

## 流れ（Docker Desktop を使用する場合）

1. Docker Desktop をマシンにインストール
2. Docker Desctop を立ち上げ、Docker Engine を起動する

## Docker Desctop

Docker Engine や Linux OS などを含むパッケージ。
![](https://storage.googleapis.com/zenn-user-upload/13c04dfae058-20240608.png)

VM を使う場合との比較は以下の通り。
![](https://storage.googleapis.com/zenn-user-upload/7626523d1518-20240608.png)

- VM の場合はユーザーが**明示的に**「仮想ソフトウェアをインストールして、Linux をインストールして、そこに Docker Engine をインストールして...」と構築する
- Docker Desctop ではユーザーが仮想環境や Linux を**意識せずに**構築できる

## 64bit 版のマシンでないと Docker Engine をインストールできない

![](https://storage.googleapis.com/zenn-user-upload/344ae4b8e0fd-20240608.png)
