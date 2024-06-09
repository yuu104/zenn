---
title: "Docker Network"
---

## 概要

- コンテナ間およびコンテナと外部ネットワーク間の通信を管理するための機能を提供する
- コンテナは独立した環境で動作するため、ネットワークを通じて他のコンテナや外部システムと通信する必要がある
- Docker Network はこの通信を効率的かつセキュアに行うためのインフラを提供する

## 目的

コンテナ間およびコンテナと外部ネットワーク間の通信を可能にする。

## WordPress 環境を構築するケース

- WordPress とは、Web サイトを作成できるソフトウェア
- サーバーにインストールして使うもの
- WordPress には以下の環境が必要
  - WordPress のプログラム
  - Web サーバー（Apache など）
  - PHP の実行環境
  - DB サーバー（MySQL など）

今回は以下のように 2 つのコンテナを使用して環境を構築する。
![](https://storage.googleapis.com/zenn-user-upload/b497034fa668-20240609.png)

WordPress コンテナと MySQL コンテナで構成されているため、この 2 つを繋げる必要がある。
ただ普通にコンテナを作っただけでは、コンテナは繋がらない。
そこで、**仮想敵なネットワークを作り、そこに 2 つのコンテナを所属させる**ことで、コンテナ同士を繋げる。

全体の流れは以下の通り。
![](https://storage.googleapis.com/zenn-user-upload/50f2c9d7da4b-20240609.png)

## Docker Network のコマンド

主に、以下の構成となる。

```shell
docker network 副コマンド
```

主な副コマンドは以下の通り。
| コマンド | 内容 | 省略 | 主なオプション |
|--------------|----------------------------------------------|------|-------------------|
| connect | コンテナをネットワークに接続する | 不可 | あまり指定しない |
| disconnect | コンテナをネットワークから切断する | 不可 | あまり指定しない |
| create | ネットワークを作る | 不可 | あまり指定しない |
| inspect | ネットワークの詳細情報を表示する | 不可 | あまり指定しない |
| ls | ネットワークの一覧を表示する | 不可 | あまり指定しない |
| prune | 現在コンテナがつながっていないネットワークをすべて削除する | 不可 | あまり指定しない |
| rm | 指定したネットワークを削除する | 不可 | あまり指定しない |

## Docker ネットワークを作成する

```shell
docker network create ネットワーク名
```

「wordpress000net1」という名前のネットワークを作成する。

```shell
docker network create wordpress000net1
```

## MySQL コンテナを作成する

```shell
docker run --name mysql000ex11 -dit --net=wordpress000net1 -e MYSQL_ROOT_PASSWORD=myrootpass -e MYSQL_DATABASE=wordpress000db -e MYSQL_USER=wordpress000kun -e MYSQL_PASSWORD=wkunpass mysql --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --default-authentication-plugin=mysql_native_password
```

オプション一覧：
| 項目 | オプション | 値 |
|-------------------------|------------------------------------|-------------------------|
| ネットワーク名 | --net | wordpress00net1 |
| MySQL のコンテナ名 | --name | mysql000ex11 |
| 実行オプション | -dit | （なし） |
| MySQL の root パスワード | -e MYSQL_ROOT_PASSWORD | myrootpass |
| MySQL のデータベース領域名 | -e MYSQL_DATABASE | wordpress00db |
| MySQL のユーザー名 | -e MYSQL_USER | wordpress00kun |
| MySQL のパスワード | -e MYSQL_PASSWORD | wkunpass |

引数一覧：
| 項目 | 引数 | 値 | 意味 |
|-----------------|----------------------------------|---------------------------|--------------------------------------|
| 文字コード | --character-set-server= | utf8mb4 | 文字コードを UTF8 にする |
| 照合順序 | --collation-server= | utf8mb4_unicode_ci | 照合順序を UTF8 にする |
| 認証方式 | --default-authentication-plugin= | mysql_native_password | 認証方式を古いもの（native）に変更する |

## WordPress コンテナを作成する

```shell
docker run --name wordpress000ex12 --net=wordpress000net1 -dit -p 8085:80 -e WORDPRESS_DB_HOST=mysql000ex11 -e WORDPRESS_DB_NAME=wordpress000db -e WORDPRESS_DB_USER=wordpress000kun -e WORDPRESS_DB_PASSWORD=wkunpass wordpress
```

オプション一覧：

| 項目                     | オプション               | 値（任意の名前や指定の値） |
| ------------------------ | ------------------------ | -------------------------- |
| ネットワーク名           | --net                    | wordpress000net1           |
| WordPress のコンテナ名   | --name                   | wordpress000ex12           |
| 実行オプション           | -dit                     | （なし）                   |
| ポート番号を指定         | -p                       | 8085:80                    |
| データベースのコンテナ名 | -e WORDPRESS_DB_HOST     | mysql000ex11               |
| データベース領域名       | -e WORDPRESS_DB_NAME     | wordpress000db             |
| データベースのユーザー名 | -e WORDPRESS_DB_USER     | wordpress000kun            |
| データベースのパスワード | -e WORDPRESS_DB_PASSWORD | wkunpass                   |

## WordPress 環境が立ち上がったか確認

```shell
docker ps
```

```shell
CONTAINER ID   IMAGE       COMMAND                   CREATED              STATUS              PORTS                  NAMES
0f4d671bb5f0   mysql       "docker-entrypoint.s…"   About a minute ago   Up About a minute   3306/tcp, 33060/tcp    mysql000ex11
5c4932900219   wordpress   "docker-entrypoint.s…"   9 minutes ago        Up 9 minutes        0.0.0.0:8085->80/tcp   wordpress000ex12
```

`http://localhost:8085` にアクセス。
![](https://storage.googleapis.com/zenn-user-upload/39accc9d679f-20240609.png)

## Docker ネットワークを削除する

```shell
docker network rm ネットワーク名
```

```shell
docker network rm wordpress000net1
```
