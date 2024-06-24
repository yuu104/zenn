---
title: "コンテナのイメージ化"
---

![](https://storage.googleapis.com/zenn-user-upload/40e132118784-20240613.png)
コンテナのイメージ化により、コンテナ環境の共有やコンテナの移動が可能になる。
![](https://storage.googleapis.com/zenn-user-upload/2159efced2ca-20240613.png)

## イメージ化の手法

手法は 2 つある。

### `commit` でイメージを書き出す

![](https://storage.googleapis.com/zenn-user-upload/dc9b58c4b4bd-20240613.png)

コンテナを用意し、そこからコマンドでイメージを生成する。

- **メリット**
  - `commit` コマンド一発でイメージの生成が可能
  - 手軽
- **デメリット**
  - コンテナを作り込む必要がある
- **ユースケース**
  - 既に存在するコンテナを複製したい場合
  - 既に存在するコンテナを移動したい場合

```shell
docker commit <コンテナ名> <作成するイメージ名>
```

### Dockerfile でイメージを作成する

- `Dockerfile` という名前のファイルを用意し、それを build することでイメージを生成する
- **Dockerfile はイメージを作成することしかできない**
- 元となるイメージや、実行したいコマンドなどを記述する

Dockerfile は、「材料フォルダ」内に入れる。
「材料フォルダ」にはコンテナ内部に入れたいファイルなども置いておく。
![](https://storage.googleapis.com/zenn-user-upload/c8364a992749-20240615.png)

Dockerfile の記述例は以下のようになる。

```dockerfile
FROM <イメージ名>
COPY <コピー元パス> <コピー先パス>
RUN <Linuxのコマンド>
...
```

:::details 主要コマンド一覧

| コマンド    | 内容                                                                                                                   |
| ----------- | ---------------------------------------------------------------------------------------------------------------------- |
| FROM        | 元にするイメージを指定する                                                                                             |
| ADD         | イメージにファイルやフォルダを追加する                                                                                 |
| COPY        | イメージにファイルやフォルダを追加する                                                                                 |
| RUN         | イメージをビルドするときにコマンドを実行する                                                                           |
| CMD         | コンテナが起動したときに実行されるデフォルトのコマンドや引数を指定する。通常は `ENTRYPOINT` に渡す引数として使われる。 |
| ENTRYPOINT  | コンテナが起動した時に実行されるコマンド                                                                               |
| ONBUILD     | ビルド完了したときに任意の命令を実行する                                                                               |
| EXPOSE      | 通信を想定するポートをイメージの利用者に伝える                                                                         |
| VOLUME      | 永続データが保存される場所をイメージの利用者に伝える                                                                   |
| ENV         | 環境変数を定義する                                                                                                     |
| WORKDIR     | RUN, CMD, ENTRYPOINT, ADD, COPY の際の作業ディレクトリを指定する                                                       |
| SHELL       | ビルド時のシェルを指定する                                                                                             |
| LABEL       | 名前やバージョン番号、制作情報などを設定する                                                                           |
| USER        | RUN, CMD, ENTRYPOINT で指定するコマンドを実行するユーザーやグループを設定する                                          |
| ARG         | `docker build`時に指定できる引数を宣言する                                                                             |
| STOPSIGNAL  | `docker stop`時に、コンテナで実行しているプログラムに対して送信するシグナルを変更する                                  |
| HEALTHCHECK | コンテナの死活確認をするヘルスチェックの方法をカスタマイズする                                                         |

:::

Dockerfile を用意し、以下のコマンドを実行することでイメージの作成ができる。

```shell
docker build -t <作成するイメージ名> <材料フォルダのパス>
```

## コンテナを `commit` でイメージ化する

![](https://storage.googleapis.com/zenn-user-upload/19cc9a33f6e8-20240615.png)

1. **Apache コンテナの作成**
   `apa000ex22` という名で Apache コンテナを起動する。
   ```shell
   docker run --name apa000ex22 -d -p 8092:80 httpd
   ```
2. **コンテナをイメージに書き出す**
   `ex22_original1` というイメージを作成する。
   ```shell
   docker commit apa000ex22 ex22_original1
   ```
3. **イメージが作成されたことを確認する**

   ```shell
   $ docker image ls

   REPOSITORY              TAG       IMAGE ID       CREATED             SIZE
   ex22_original1          latest    064e77d25db2   About a minute ago  166MB
   ```

## Dockerfile でイメージを作成する

1. **材料の用意**
   ```shell
   $ cd ~
   $ mkdir apa_folder
   $ vim apa_folder/index.html
   ```
2. **Dockerfile を作成してイメージを書き出す準備をする**
   `apa_folder` 内に Dockerfile を作成する。

   ```shell
   $ vim ~/apa_folder/Dockerfile
   ```

   ```dockerfile: Dockerfile
   FROM httpd
   COPY index.html /usr/local/apache2/htdocs/
   ```

3. **イメージを書き出す**

   ```shell
   docker build -t ex22_original2 ~/apa_folder
   ```

4. **イメージが作成されたことを確認する**

   ```shell
   $ docker image ls

   REPOSITORY              TAG       IMAGE ID       CREATED             SIZE
   ex22_original2          latest    32ea92c35c43   About a minute ago  166MB
   ```

## Docker イメージをファイル化する

Docker イメージをファイルとしてエクスポートし、そのファイルを共有することができる。
手順は以下の通り。

1. **イメージをエクスポート**
   ```shell
   docker save -o <ファイル名>.tar <イメージ名>
   ```
2. **エクスポートしたファイルを共有**
   生成されたファイルを他の開発者に共有する。
3. **他の開発者がイメージをインポート**
   他の開発者に以下のコマンドを実行してもらい、イメージをインポートする。
   ```shell
   docker load -i <ファイル名>.tar
   ```
