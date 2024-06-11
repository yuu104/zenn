---
title: "ボリュームのマウント"
---

## ボリュームとは？

Docker コンテナとホスト間でデータを永続的に保存および共有するためのメカニズムで、**ストレージの 1 領域を区切ったもの。**
ハードディスクや SSD の区切られた 1 領域。
![](https://storage.googleapis.com/zenn-user-upload/4ec6335b10c2-20240609.png)

ボリュームはコンテナのライフサイクルとは独立して存在し、コンテナが削除されてもデータは保持される。

「ボリューム」とは「データを置く場所」として呼称される慣習があるが、「データを置く場所」はボリュームに加え、ディレクトリやファイル、メモリを含めた「**記憶領域**」が正しい。

## マウントとは？

ホストのファイルシステムの一部を Docker コンテナ内に接続する操作のこと。
これにより、ホスト上の特定のディレクトリやファイルをコンテナ内で使用できるようになる。
![](https://storage.googleapis.com/zenn-user-upload/12d89b5bd9a2-20240609.png)

## マウントの種類

### ボリュームマウント

Docker Engine が管理している領域内に**ボリュームを作成**し、ディスクとしてコンテナにマウントする。
![](https://storage.googleapis.com/zenn-user-upload/35967ca80c93-20240609.png)

- **メリット**
  - 手軽に扱える
- **デメリット**
  - ボリュームに対して直接操作しづらい
- **ユースケース**
  - 仮で使いたい場合
  - 滅多に触らないが、消してはいけないファイルを置く場合

### バインドマウント

Docker Engine の外にあるディレクトリをコンテナにマウントする。
![](https://storage.googleapis.com/zenn-user-upload/5f8a96f4f36c-20240609.png)

- **メリット**
  - ディレクトリだけでなく、ファイル単位でマウントできる
  - ディレクトリに対して直接ファイルを置いたり開いたりできる
- **ユースケース**
  - 頻繁に触りたいファイルがある場合

### 2 つのマウントの違い

| 項目             | ボリュームマウント            | バインドマウント                   |
| ---------------- | ----------------------------- | ---------------------------------- |
| 記憶領域         | ボリューム                    | ディレクトリやファイル             |
| マウント場所     | Docker Engine 管理下          | どこでも可能                       |
| マウント時の動作 | ボリュームを作成してマウント  | 既存のファイルやフォルダをマウント |
| 内容の編集       | Docker コンテナを経由して行う | 普通のファイルとして扱う           |
| バックアップ     | 複雑な手順                    | 普通のファイルとして扱う           |

ポイントは 3 つ。

1. **親となるパソコンから操作したいかどうか**
2. **環境依存を排除したいか**
3. **簡単かどうか**

## 一時メモリ（tmpfs）マウント

実はもう一つマウント方法がある。

メモリをマウント先に指定する。
ディスクを使用するよりも高速に読み書きできるため、アクセスを速くする目的で行なわれる。
しかし、Docker Engine の停止やホストの再起動などで消滅する。

## マウントするためのコマンド操作

**`run` コマンドにオプションとして指定する。**
マウントしたい記憶領域のパスを、コンテナの特定の場所であるかのように設定する。
![](https://storage.googleapis.com/zenn-user-upload/b31b0f7467cc-20240610.png)

### マウントするための手順

![](https://storage.googleapis.com/zenn-user-upload/b8247d34b6e6-20240610.png)

### ボリュームマウントのやり方

Apache コンテナを作成してみる。
![](https://storage.googleapis.com/zenn-user-upload/216be7418f42-20240610.png)

1. **ボリュームの作成**
   `apa000vol1` という名のボリュームを作成する。

   ```shell
   docker volume create apa000vol1
   ```

   :::details ボリューム系コマンド一覧
   | コマンド | 内容 | 省略 | 主なオプション |
   |--------------|-------------------------------------------|------|-------------------|
   | create | ボリュームを作る | 不可 | あまり指定しない |
   | inspect | ボリュームの詳細情報を表示する | 不可 | あまり指定しない |
   | ls | ボリュームの一覧を表示する | 不可 | あまり指定しない |
   | prune | 現在マウントされていないボリュームをすべて削除する | 不可 | あまり指定しない |
   | rm | 指定したボリュームを削除する | 不可 | あまり指定しない |

   :::

2. **Apache コンテナを起動する**

   ```shell
   docker run --name apa000ex21 -d -p 8091:80 -v apa000vol1:/user/local/apache2/htdocs httpd
   ```

   `-v` オプションを使用してマウントを行う。

   ```shell
   -v <ボリューム名>:<コンテナの記憶領域パス>
   ```

3. **作成したボリュームの詳細を確認する**

   ```shell
   docker volume inspect apa000vol1

   [
       {
           "CreatedAt": "2024-06-10T12:58:17Z",
           "Driver": "local",
           "Labels": null,
           "Mountpoint": "/var/lib/docker/volumes/apa000vol1/_data",
           "Name": "apa000vol1",
           "Options": null,
           "Scope": "local"
       }
   ]
   ```

   ```shell
   $ docker container inspect apa000ex21

   [
      ...略...
      "Mounts": [
            {
                "Type": "volume",
                "Name": "apa000vol1",
                "Source": "/var/lib/docker/volumes/apa000vol1/_data",
                "Destination": "/user/local/apache2/htdocs",
                "Driver": "local",
                "Mode": "z",
                "RW": true,
                "Propagation": ""
            }
        ],
      ...略...
   ]
   ```

   `Name`、`Source`、`Destination` を見ると、指定したボリュームが指定した場所にマウントされていることが分かる。

4. **コンテナの停止・削除とボリュームの削除**
   ```shell
   $ docker container stop apa000ex21
   $ docker container rm apa000ex21
   $ docker volume rm apa000vol1
   ```

### バインドマウントのやり方

![](https://storage.googleapis.com/zenn-user-upload/2e76dcead364-20240610.png)

1. **マウントしたいディレクトリを作成する**
   今回は `~/docker-sample` に作成する。
   ```shell
   $ cd ~/docker-sample
   $ pwd # 現在のパスを確認
   /Users/toyoshimayusei/docker-sample
   $ vim index.html # index.htmlを作成して適当に編集する
   ```
2. **Apache コンテナを起動する**

   ```shell
   docker run --name apa000ex20 -d -p 8090:80 -v /Users/toyoshimayusei/docker-sample:/usr/local/apache2/htdocs httpd
   ```

3. **ブラウザで Apache にアクセスして確認する**
   ![](https://storage.googleapis.com/zenn-user-upload/d5fab5dd9d77-20240611.png)

4. **コンテナの停止・削除**
   ```shell
   $ docker stop apa000ex20
   $ docker rm apa000ex20
   ```

## ボリュームマウントの確認方法
