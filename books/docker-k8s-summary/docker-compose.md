---
title: "Docker Compose"
---

## Docker Compose とは

複数の Docker コンテナを簡単に定義し、実行するためのツール。
コンテナの運用に関連するコマンドの内容を 1 つの定義ファイルに記述し、一気に実行・停止・破棄できる。

![](https://storage.googleapis.com/zenn-user-upload/ec01f449c706-20240616.png)

## Docker Compose の仕組み

定義ファイルを**YAML 形式**で用意し、ファイルの中身を「`up`（一括実行 = `run`）」したり、「`down`（コンテナとネットワーク一括停止・削除）」したりする。
![](https://storage.googleapis.com/zenn-user-upload/73fd3a5ea935-20240616.png)

`up` は、`run` に似ていて、定義ファイルの内容に従って、イメージのダウンロードやコンテナの作成・起動を複数一括で行う。定義ファイルにはネットワークやボリュームについても記述可能なため、周辺環境も同時に作成可能。
`down` はコンテナとネットワークの停止・削除を行う。ただし、ボリュームとイメージはそのまま。
削除ではなく、停止したい場合は `stop` を使用する。
![](https://storage.googleapis.com/zenn-user-upload/dca614705cf6-20240616.png)

## Docker Compose と Dockerfile の違い

- **Dockerfile**
  - イメージを作成する
- **Docker Compose**
  - コンテナと周辺環境（ネットワークやボリューム）を作成する

![](https://storage.googleapis.com/zenn-user-upload/5b2815e3211b-20240616.png)

## Docker Compose は別のソフトウェア

Docker Compose は、**Docker Engine とは別のソフトウェア**。
ただ、操作方法は Docker Engine と大差ない。
Docker Compose で作成したコンテナを Docker Engine で命令することも可能。

また、Docker Desktop に入っているので、別途インストールする必要がない。

## Docker Compose の使い方

定義ファイルは Dockerfile と同様、ホスト側に配置する。
ファイル名は必ず、**`docker-compose.yml`** とする。
![](https://storage.googleapis.com/zenn-user-upload/f77c947119fd-20240616.png)

`up` コマンドを実行すると、`docker-compose.yml` で定義した内容を基に Docker Compose が Docker Engine に対し各コンテナの作成・起動を行う。
![](https://storage.googleapis.com/zenn-user-upload/b893ae7f01d3-20240616.png)

## `docker-compose.yml`

複数のサービス（コンテナ）、ネットワーク、ボリュームを定義できる。

基本的な構造は以下の通り。

```yaml
version: "3" # Composeファイルのバージョン

services: # サービスの定義
  service_name: # サービス名
    image: image_name:tag # 使用するDockerイメージ
    build: # イメージのビルド設定（ビルドが必要な場合）
      context: ./path_to_dockerfile # Dockerfileの場所
      dockerfile: Dockerfile # Dockerfileのファイル名（省略可能）
    ports: # ポートのマッピング
      - "ホストポート:コンテナポート"
    volumes: # ボリュームのマッピング
      - ホストディレクトリ:コンテナディレクトリ
    environment: # 環境変数の設定
      - ENV_VAR_NAME=value
    command: # コンテナの実行コマンド
      - "コマンド"
    depends_on: # 依存するサービス
      - other_service_name

volumes: # ボリュームの定義
  volume_name:

networks: # ネットワークの定義
  network_name:
```

YAML 形式は、**スペースに意味がある言語**。
タブは意味を持たず、「半角スペース 2 つ」と最初に決めたら、その後も「半角スペース 2 つ」にする必要がある。

:::details 記述ルールまとめ

- 最初にバージョンを書く
- 大項目である「`services`」「`networks`」「`volumes`」に続いて設定内容を書く
- 親子関係はスペースで字下げして表す
- 字下げスペースは、同じ数の倍数とする
- 名前は、大項目の下に字下げして書く
- コンテナの設定内容は、名前の下に字下げして書く
- 「`-`」が入っていたら複数指定できる
- 名前の後ろには「`:`」をつける
- 「`:`」の後ろには空白が必要（例外的にすぐ改行するときは不要）
- コメントを入れたい場合は `#` を使う（コメントアウト）
- 文字列を入れる場合は、「`'`」「`"`」のどちらかでくくる

:::

:::details 定義ファイルの項目

**大項目**
| 項目 | 内容 |
|----------|------------------------------|
| services | コンテナに関する定義をする |
| networks | ネットワークに関する定義をする |
| volumes | ボリュームに関する定義をする |

**`services` の各サービスで指定できる項目**
| 項目 | docker run での対応 | 内容 |
|--------------|----------------------|------------------------------------------------|
| image | イメージ引数 | 利用するイメージを指定する |
| build | なし | Dockerfile を使用してイメージをビルドする |
| networks | --net | 接続するネットワークを指定する |
| volumes | -v, --mount | [記憶領域のマウントを設定する](https://amateur-engineer-blog.com/docer-compose-volumes) |
| ports | -p | ポートのマッピングを設定する |
| environment | -e | 環境変数を設定する |
| depends_on | なし | 別のサービスに依存することを示す。指定したサービスが先に起動される。 |
| restart | なし | コンテナが停止したときの再試行ポリシーを設定する |
| command | コマンド引数 | 起動時の既定のコマンドを上書きする |
| container_name | --name | 起動するコンテナ名を明示的に指定する |
| dns | --dns | カスタムな DNS サーバを明示的に設定する |
| env_file | なし | 環境設定情報を書いたファイルを読み込む |
| entrypoint | --entrypoint | 起動時の ENTRYPOINT を上書きする |
| external_links | --link | 外部リンクを設定する |
| extra_hosts | --add-host | 外部ホストの IP アドレスを明示的に指定する |
| logging | --log-driver | ログ出力先を設定する |
| network_mode | --network | ネットワークモードを設定する |

`image` と `build` を同時に利用した場合、

- `build` で指定された Dockerfile を使用してイメージをビルドする
- ビルドされたイメージに `image` で指定されたタグを付与する

:::

## `docker-compose` コマンド

Docker Compose は `docker-compose` コマンドを使用する。

### `up` ~ コンテナや周辺環境を作成する

定義ファイルに従って、コンテナ・ボリューム・ネットワークを作成・実行する。
定義ファイルの場所は `-f` オプションで指定する。

```shell
docker-compose -f <定義ファイルのパス> up <オプション>
```

カレントディレクトリに `docker-compose.yml` が存在する場合、`-f` は省略できる。

:::details オプション一覧

| オプション                | 内容                                                      |
| ------------------------- | --------------------------------------------------------- |
| -d                        | バックグラウンドで実行する                                |
| --no-color                | 白黒画面として表示する                                    |
| --no-deps                 | リンクしたサービスを表示しない                            |
| --force-recreate          | 設定やイメージに変更がなくても、コンテナを再生成する      |
| --no-recreate             | コンテナがすでに存在していれば再生成しない                |
| --no-build                | イメージが見つからなくてもビルドしない                    |
| --build                   | コンテナを開始前にイメージをビルドする                    |
| --abort-on-container-exit | コンテナが 1 つでも停止したら、すべてのコンテナを停止する |
| -t, --timeout             | コンテナを停止する際のタイムアウト秒数。既定は 10 秒      |
| --remove-orphans          | 定義ファイルに定義されていないサービス用のコンテナを削除  |
| --scale                   | コンテナの数を変える                                      |

:::

### `down` ~ コンテナとネットワークを削除するコマンド

定義ファイルの内容に従って、コンテナとネットワークを停止・削除する。
**ボリュームとイメージは削除しない。**

```shell
docker-compose -f <定義ファイルのパス> down <オプション>
```

:::details オプション一覧

| オプション       | 内容                                                                                                                                                                 |
| ---------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| --rmi 種類       | 破棄後にイメージを削除する。種類に「all」を指定したときは、利用した全イメージを削除する。「local」を指定したときは、image にカスタムタグがないイメージのみを削除する |
| -v, --volumes    | volumes に記述されているボリュームを削除する。ただし external が指定されているものは除く                                                                             |
| --remove-orphans | 定義ファイルで定義していないサービスのコンテナも削除する                                                                                                             |

:::

### `stop` ~ コンテナを停止する

定義ファイルの内容に従って、コンテナを停止する。

```shell
docker-compose -f <定義ファイルのパス> stop <オプション>
```

### その他コマンド一覧

| コマンド | 内容                                         |
| -------- | -------------------------------------------- |
| up       | コンテナを作成し、起動する                   |
| down     | コンテナとネットワークを停止および削除する   |
| ps       | コンテナ一覧を表示する                       |
| config   | 定義ファイルの確認と表示                     |
| port     | ポートの割り当てを表示する                   |
| logs     | コンテナの出力を表示する                     |
| start    | コンテナを開始する                           |
| stop     | コンテナを停止する                           |
| kill     | コンテナを強制停止する                       |
| exec     | コマンドを実行する                           |
| run      | コンテナを実行する                           |
| create   | コンテナを作成する                           |
| restart  | コンテナを再起動する                         |
| pause    | コンテナを一時停止する                       |
| unpause  | コンテナを再開する                           |
| rm       | 停止中のコンテナを削除する                   |
| build    | コンテナ用のイメージを構築または再構築する   |
| pull     | コンテナ用のイメージをダウンロードする       |
| scale    | コンテナ用コンテナの数を指定する             |
| events   | コンテナからリアルタイムにイベントを受信する |
| help     | ヘルプ表示                                   |
