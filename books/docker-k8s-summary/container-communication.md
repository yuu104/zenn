---
title: "コンテナ環境と通信する"
---

## Apache サーバーを起動する

Apache は Web サーバー。
以下のコマンドを実行し、コンテナ内に Web サーバーを立ち上げる。

```shell
docker run --name apa000ex1 -d  httpd
```

```shell
$ docker ps
CONTAINER ID   IMAGE     COMMAND              CREATED         STATUS         PORTS     NAMES
bb934ad77c2a   httpd     "httpd-foreground"   6 seconds ago   Up 6 seconds   80/tcp    apa000ex1
```

しかし、現状では以下のようにコンテナ外からサーバーにアクセスできない。

![](https://storage.googleapis.com/zenn-user-upload/f3061ed05ffa-20240609.png)

## なぜ通信できないのか？

**ポートフォワーディングを設定していないため。**
コンテナ内のポートをホストのポートにマッピングしていないため、外部からアクセスするための入口が開いていない。
![](https://storage.googleapis.com/zenn-user-upload/1d24f11b0512-20240609.png)

## どうすれば通信できるのか？

**ポートフォワーディングを設定する。**
![](https://storage.googleapis.com/zenn-user-upload/4862e5befd97-20240609.png)

ホストの任意のポート番号と、コンテナ内にある Web サーバーのポート 80 を繋ぐ。
![](https://storage.googleapis.com/zenn-user-upload/de011fc8f08d-20240609.png)

```shell
-p 8080:80
```

コンテナ起動時にポートフォワーディングするには以下のようにする。

```shell
docker run --name apa000ex1 -d -p 8080:80 httpd
```

## 複数のコンテナが通信できるようにする

場合によっては複数の Web サーバーを並列させることもある。
その場合は**通信させたいコンテナの数だけホストにポートを用意し、それぞれマッピングする。**
![](https://storage.googleapis.com/zenn-user-upload/cb50c1eb2f4e-20240609.png)
