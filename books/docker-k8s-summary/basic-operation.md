---
title: "基本操作"
---

## Docker Engine の起動と終了

1. **起動**
   Docker Desctop を起動する
2. **終了**
   Docker Desctop を終了する
3. **自動起動の設定**
   - Docker Engine が起動し続けていても、**コンテナが動いていない限りは、大してリソースを使用しないので問題ない**
   - Docker Engine が終了したらコンテナも停止する
   - Docker Engine 復旧と同時に、コンテナも復旧させたい場合、Docker Engine の外にコンテナを起動するスクリプトを用意する
     ![](https://storage.googleapis.com/zenn-user-upload/90a639449375-20240608.png)

## コンテナ操作の基本

基本的に `docker` コマンドから始まる。

```shell
docker ~
```

基本的な構造は以下の通り。
![](https://storage.googleapis.com/zenn-user-upload/53b8c00b220c-20240608.png)

### コマンドと対象

`docker` コマンドの続きには、「コマンド」と「対象」を書く。
![](https://storage.googleapis.com/zenn-user-upload/5e9e47c01bc1-20240608.png)

- **コマンド**
  - 「何を」「どうする」を記述する場所
  - 上位コマンドが「何を」
  - 下位コマンドが「どうする」
- **対象**
  - コンテナ名やイメージ名など
  - 具体的な名前を指定する

「penguin（ペンギン）」というイメージを「container（コンテナ）」として「run（実行）」したい場合。

```shell
docker container run penguin
```

「penguin」イメージを「pull（ダウンロード）」したい場合。

```shell
docker image pull penguin
```

「penguin」イメージをコンテナとして「start（開始）」したい場合。

```shell
docker container run penguin
```

上位コマンドは省略できる場合がある

![](https://storage.googleapis.com/zenn-user-upload/688e6f6a4c46-20240608.png)

### オプション

コマンドに対して細かい設定をするもの。
指定できるオプションはコマンドによって異なる。

オプションは `-` や `--` から始まる（これはコマンド作成者の好みで決まる）。
記号をつけない場合もある。

```shell
-d
--all
```

コマンドに値を渡すケースもある。

```shell
# `--name` オプションに `penguin` という値を与えている
--name penguin
```

`-d` のように `-` と 1 文字の組み合わせのオプションは、まとめて記述できる。

```shell
# -d, -i, -tをまとめて記述する
-dit
```

### 引数

「対象」に対して、持たせたい値を書く。

- 文字コード
- ポート番号
- ...etc

引数を指定するケースは少ない。

```shell
# 記述例
--mode=1
--style nankyoku
```

## 代表的な Docker コマンド

![](https://storage.googleapis.com/zenn-user-upload/8918c30e5a42-20240608.png)

### コンテナ操作関連（`container`）

コンテナの起動・終了・一覧表示など。
コンテナの操作を行うためのコマンド。

| 副コマンド | 内容                                                                                                                                                                                                     | `container` の省略 | 主なオプション           |
| ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------ | ------------------------ |
| start      | コンテナを開始する                                                                                                                                                                                       | 可                 | -i                       |
| stop       | コンテナを停止する                                                                                                                                                                                       | 可                 | あり指定しない           |
| create     | Docker イメージからコンテナを作成する                                                                                                                                                                    | 可                 | --name -e -p -v          |
| run        | Docker イメージをダウンロードし、コンテナを作成して起動する（ダウンロードは必要な場合のみ）、`docker image pull`、`docker container create`、`docker container start` の一連の動作をひとまとめにしたもの | 可                 | --name -e -p -v -d -i -t |
| rm         | 停止したコンテナを削除する                                                                                                                                                                               | 可                 | -f -v                    |
| exec       | 実行中のコンテナ内でプログラムを実行する                                                                                                                                                                 | 可                 | -i -t                    |
| ls         | コンテナ一覧を表示する                                                                                                                                                                                   | `dpcker ps`        | -a                       |
| cp         | Docker コンテナと Docker ホスト間でファイルをコピーする                                                                                                                                                  | 可                 | あり指定しない           |
| commit     | Docker コンテナをイメージに変換する                                                                                                                                                                      | 可                 | あり指定しない           |

### イメージ操作関連（`image`）

| 副コマンド | 内容                                                      | `image` の省略 | 主なオプション   |
| ---------- | --------------------------------------------------------- | -------------- | ---------------- |
| pull       | Docker Hub などのリポジトリからイメージをダウンロードする | 可             | あまり指定しない |
| rm         | Docker イメージを削除する                                 | `docker rmi`   | あまり指定しない |
| ls         | 自分がダウンロードしたイメージ一覧を表示する              | 不可           | あまり指定しない |
| build      | Docker イメージを作成する                                 | 可             | -t               |

:::details build コマンド

`docker image build`コマンドは、Dockerfile を基にして Docker イメージをビルドするためのコマンドです。このコマンドを使用することで、アプリケーションの依存関係や設定を含むイメージを作成し、コンテナとしてデプロイできます。

### 基本構文

```bash
docker build [OPTIONS] PATH | URL | -
```

### 主なオプションとその説明

- `-t, --tag`: イメージに名前とタグを付けます。例: `myapp:latest`
- `-f, --file`: Dockerfile の場所を指定します。デフォルトは現在のディレクトリの Dockerfile です。
- `--build-arg`: ビルド時に利用する引数を指定します。例: `--build-arg VAR_NAME=value`
- `--no-cache`: キャッシュを使用せずにイメージをビルドします。
- `--rm`: 中間コンテナを削除します。デフォルトで有効です。
- `--pull`: 最新のベースイメージを常にプルします。

### 使用例

#### 1. 基本的なビルド

```bash
docker build -t myapp:latest .
```

現在のディレクトリにある Dockerfile を使用して、`myapp:latest`というタグを付けたイメージをビルドします。

#### 2. Dockerfile を指定する

```bash
docker build -f ./Dockerfile.dev -t myapp:dev .
```

`./Dockerfile.dev`という名前の Dockerfile を使用してビルドします。

#### 3. ビルド引数の使用

```Dockerfile
# Dockerfile
FROM node:14
ARG APP_VERSION
ENV APP_VERSION=${APP_VERSION}
COPY . /app
WORKDIR /app
RUN npm install
CMD ["node", "app.js"]
```

```bash
docker build --build-arg APP_VERSION=1.0.0 -t myapp:1.0.0 .
```

この例では、`APP_VERSION`引数を使用してバージョン情報をイメージに埋め込みます。

#### 4. キャッシュを無効にしてビルド

```bash
docker build --no-cache -t myapp:latest .
```

キャッシュを使用せずにイメージをビルドします。

### 実行例

以下は、典型的な`docker build`コマンドの実行例です。

```bash
docker build -t my-web-app:latest .
```

このコマンドは、現在のディレクトリにある Dockerfile を基に`my-web-app:latest`というタグを付けた Docker イメージをビルドします。

### トラブルシューティング

- **エラーのデバッグ**:

  - ビルドエラーが発生した場合、エラーメッセージを注意深く読み、Dockerfile の該当する部分を確認します。

- **キャッシュ問題**:

  - 変更が反映されない場合、キャッシュが原因であることが多いです。`--no-cache`オプションを使用してキャッシュを無効にしてビルドします。

- **ネットワーク問題**:
  - パッケージのダウンロードが失敗する場合、ネットワークの接続状態やプロキシ設定を確認します。

:::

### ボリューム操作関連（`voluem`）

:::details ボリュームとは？

コンテナで使用するデータを物理マシン（ホスト）に保存しておくためのストレージのこと。
![](https://storage.googleapis.com/zenn-user-upload/649defd20fa9-20240608.png)
![](https://storage.googleapis.com/zenn-user-upload/ba98f919a995-20240608.png)

:::

| 副コマンド | 内容                                               | `volume` の省略 | 主なオプション   |
| ---------- | -------------------------------------------------- | --------------- | ---------------- |
| create     | ボリュームを作る                                   | 不可            | --name           |
| inspect    | ボリュームの詳細情報を表示する                     | 不可            | あまり指定しない |
| ls         | ボリュームの一覧を表示する                         | 不可            | -a               |
| prune      | 現在マウントされていないボリュームをすべて削除する | 不可            | あまり指定しない |
| rm         | 指定したボリュームを削除する                       | 不可            | あまり指定しない |

### ネットワーク操作関連（`network`）

Docker ネットワークに関する操作を行うためのコマンド。

- Dcoker ネットワークの作成、削除
- コンテナとの接続、切断
- ...etc

| 副コマンド | 内容                                                       | `network` の省略 | 主なオプション   |
| ---------- | ---------------------------------------------------------- | ---------------- | ---------------- |
| connect    | コンテナをネットワークに接続する                           | 不可             | あまり指定しない |
| disconnect | コンテナをネットワークから切断する                         | 不可             | あまり指定しない |
| create     | ネットワークを作る                                         | 不可             | あまり指定しない |
| inspect    | ネットワークの詳細情報を表示する                           | 不可             | あまり指定しない |
| ls         | ネットワークの一覧を表示する                               | 不可             | あまり指定しない |
| prune      | 現在コンテナがつながっていないネットワークをすべて削除する | 不可             | あまり指定しない |
| rm         | 指定したネットワークを削除する                             | 不可             | あまり指定しない |

### その他の上位コマンド

| 上位コマンド | 内容                                                                        |
| ------------ | --------------------------------------------------------------------------- |
| checkpoint   | 現在の状態を一時的に保存し、後でその時点に戻ることができる。実験的な機能    |
| node         | Docker Swarm のノードを管理する機能                                         |
| plugin       | プラグインを管理する機能                                                    |
| secret       | Docker Swarm のシークレット情報を管理する機能                               |
| service      | Docker Swarm のサービスを管理する機能                                       |
| stack        | Docker Swarm や Kubernetes で、サービスをひとまとめにしたスタックを管理する |
| swarm        | Docker Swarm を管理する機能                                                 |
| system       | Docker Engine の情報を取得する                                              |

### 単独コマンド

`docker login` のように使う。

| 単独コマンド | 内容                                               | 主なオプション   |
| ------------ | -------------------------------------------------- | ---------------- |
| login        | Docker レジストリにログインする                    | -u -p            |
| logout       | Docker レジストリからログアウトする                | あまり指定しない |
| search       | Docker レジストリで検索する                        | あまり指定しない |
| version      | Docker Engine およびコマンドのバージョンを表示する | あまり指定しない |

## コンテナの作成・削除・起動・停止

### `docker container run`

コンテナを作成し、起動するコマンド。
イメージが Docker Engine 上に存在しない場合はイメージのダウンロードも行う。

以下のコマンドをまとめて行う。

- `docker image pull`
- `docker container create`
- `docker container start`

![](https://storage.googleapis.com/zenn-user-upload/4dbc0ab48972-20240608.png)

「対象」には使用するイメージ名を指定する。
コンテナの名称は `--name` オプションで指定する。
![](https://storage.googleapis.com/zenn-user-upload/d7605c111f43-20240608.png)

主要オプションは以下の通り。
| オプションの書式 | 内容 |
|-------------------------|-------------------------------------------|
| `--name コンテナ名` | コンテナ名を指定する |
| `-p ホストのポート番号:コンテナのポート番号` | ポート番号を指定する |
| `-v ホストのディスク:コンテナのディレクトリ` | ボリュームをマウントする |
| `--net=<ネットワーク名>` | コンテナをネットワークに接続する |
| `-e 環境変数名=値` | 環境変数を指定する |
| `-d` | バックグラウンドで実行する |
| `-i` | コンテナに操作端末（キーボード）をつなぐ |
| `-t` | 特殊キーを使用可能にする |
| `--help` | 使い方を表示する |
| `--rm` | コンテナが停止した時（`docker stop`）に自動的にコンテナを削除する |

### `docker container stop`

コンテナを停止するコマンド。
**コンテナを停止しなければ削除できない。**
![](https://storage.googleapis.com/zenn-user-upload/214be42206f4-20240608.png)

### `docker container rm`

コンテナを削除するコマンド。
**`docker stop` によりコンテナを停止しなければ削除できない。**
![](https://storage.googleapis.com/zenn-user-upload/aba23da3f561-20240609.png)

### `docker ps`

`docker container ls` の省略コマンド。
コンテナ一覧を表示する。

`docker ps` は現在稼働中のコンテナ一覧を表示する。
`docker ps -a` は停止しているものを含む、コンテナ一覧を表示する。
![](https://storage.googleapis.com/zenn-user-upload/4c920bb025aa-20240609.png)

実行結果の例は以下のようになる。

```shell
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
2b3b4afb0422        httpd               "httpd-foreground"       5 minutes ago       Up 5 minutes        80/tcp              apa000ex1
```

| 項目         | 内容                                                                                                                                                                    |
| ------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CONTAINER ID | コンテナ ID。ランダムな数字が振られる。本来の ID は 64 文字だが、先頭 12 文字のみの表記。12 文字のみでも（もしくは他と重複しなければそれ以下でも）、ID として使用できる |
| IMAGE        | 元となったイメージ名                                                                                                                                                    |
| COMMAND      | コンテナにデフォルトで起動するように構成されているプログラム名。あまり意識することはない                                                                                |
| CREATED      | 作られてから経過した時間                                                                                                                                                |
| STATUS       | 現在のステータス。動いている場合は「Up」、動いていない場合は「Exited」と表示される                                                                                      |
| PORTS        | 割り当てられているポート番号を示す。「ホストのポート番号 → コンテナのポート番号」の形式で表示される（ポート番号が同じときは、->以降は表示されない）                     |
| NAMES        | コンテナ名                                                                                                                                                              |

## イメージの削除

コンテナを削除してもイメージは残り続ける。
![](https://storage.googleapis.com/zenn-user-upload/61a5bbecf65a-20240609.png)

**イメージを削除するには、削除対象のイメージを使用しているコンテナを削除する必要がある。**
![](https://storage.googleapis.com/zenn-user-upload/a33f5b2aafbc-20240609.png)

### `docker image rm`

イメージを削除するには `docker image rm` を実行する。
![](https://storage.googleapis.com/zenn-user-upload/bfa743c9bb87-20240609.png)

「対象」にはイメージ名 or イメージ ID を指定する。

### `docker image ls`

現在保持しているイメージ一覧を確認するコマンド。

```shell
$docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
nginx               latest              4bb46517cac3        8 days ago          133MB
httpd               latest              a6ea92c35c43        2 weeks ago         166MB
mysql               latest              0d64f46acfd1        2 weeks ago         544MB
```

| 項目       | 内容                                                                                                                                          |
| ---------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| REPOSITORY | イメージ名                                                                                                                                    |
| TAG        | バージョン情報。イメージをダウンロードするときに指定していないと`latest`（最新版）をダウンロードしたことになる                                |
| IMAGE ID   | イメージ ID。本来の ID は 64 文字だが、先頭 12 文字のみの表記。12 文字のみでも（もしくは他と重複しなければそれ以下でも）、ID として使用できる |
| CREATED    | 作られてから経過した時間                                                                                                                      |
| SIZE       | イメージのファイルサイズ                                                                                                                      |

:::details 複数のバージョンを削除したいとき

```shell
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
mysql               5.7              718a6da099d8        2 weeks ago         448MB
mysql               8              0d64f46acfd1        2 weeks ago         544MB

```

上記のようにバージョンが異なる同じソフトウェアのイメージを保持している場合、イメージ ID or `イメージ名:バージョン` を指定して削除する。
`docker image rm mysql` だけでは区別できず、削除不可。
:::
