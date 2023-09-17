---
title: "パッケージ・モジュール"
---

## イメージ図

![](https://storage.googleapis.com/zenn-user-upload/4b6a859c1b92-20230917.png)

## パッケージ

- コンパイラの処理単位
- ソースファイル（`.go`）の集合体
- 1 ディレクトリのファイル群 = 1 パッケージ
- 同一パッケージ内で定義した変数、関数などは共有される
- ファイルの先頭に `package <パッケージ名>` とすることで、定義する
- パッケージ名とパッケージファイルを格納するディレクトリ名は極力一致させる

### `main` パッケージ

- プロジェクトには必ず `main` パッケージが必要
- `main` パッケージの `main()` 関数が golang プログラムのエントリーポイント

## モジュール

- パッケージの集合
- パッケージ群のバージョン管理や配布を行う単位
- `go.mod`　ファイルがあるディレクトリ以下のすべてのパッケージがモジュールの構成要素となる
- 基本的に 1 リポジトリ 1 モジュールで管理する
  - Go のプロジェクトを作成する → モジュールを作成する
- パッケージが git 等のバージョン管理ツールで管理されている場合はバージョンごとに異なるモジュールとなる
  - つまり、モジュールの実態は「**パッケージ(s) + バージョン**」

### モジュールの初期化

```shell
go mod init <モジュール名>
```

- `<モジュール名>` は `github.com/username/moduleA` のような表記
- モジュール名を公開しない場合は `moduleA` でも良い
- 上記コマンドでプロジェクトフォルダに `go.mod` が作成され、プロジェクトディレクトリ以下が「モジュール」扱いになる

  ```mod
  module moduleA

  go 1.20
  ```

### モジュールの追加

1. 必要なファイルで `import` 文を追加する
2. `go mod tidy` コマンドを実行する
3. `import` 文で追加したモジュールがインストールされ、初回だと `go.sum` ファイルが生成される

- `go mod tidy` は、コード上の `import` 文をを見て、足りないものは追加、インストールしたけど使ってないものは削除してくれる
- `go mod tidy` 以外にも、モジュールの追加方法として `go get <モジュール名>` がある
  - 不要モジュールの削除はしてくれないので、`tidy` でよさそう

### モジュールの削除

1. 不要なモジュールの `import` 文を削除する
2. `go mod tidy` を実行する

### 依存モジュールの更新

- `go get` コマンドでモジュールを指定して実行する
  ```shell
  go get github.com/google/go-cmp
  ```
- モジュールパスの後に `@` を続けて、モジュールのバージョンを指定できる

  ```shell
  go get github.com/google/go-cmp@v0.5.4
  ```

- すべてのモジュールを更新するには `./...` と指定する
  ```shell
  go get -u ./...
  ```

### `go get` と `go install`

https://qiita.com/eihigh/items/9fe52804610a8c4b7e41

- バイナリインストールには `go install`
- `go.mod` に追加する場合は、`go get` or `go mod tidy`

### `go.mod`

- `go.mod` は、モジュールのパスとバージョン情報を記述しておくファイル
- いくつかのディレクティブを使用して、依存関係を記述する

```mod
module github.com/github-name/repository-name/app/users

go 1.16

replace github.com/github-name/app/middleware => ../middleware

require (
  github.com/github-name/repository-name/app/middleware v0.0.0-00010101000000-000000000000
  github.com/go-sql-driver/mysql v1.6.0
  github.com/jinzhu/copier v0.3.5 // indirect
  github.com/labstack/echo/v4 v4.6.3
  github.com/pkg/errors v0.9.1 // indirect
  github.com/rs/xid v1.3.0 // indirect
  xorm.io/xorm v1.2.5
)
```

#### ディレクティブ

- ソースコードに記述される要素の 1 つ
- コードを解釈・変換するコンパイラなどへ指示を与えるためのもの

#### `module`

- 自分自身のモジュール名を定義するためのディレクティブ
- `go mod init` コマンドで指定したモジュール名が自動で設定される

#### `go`

- モジュールの記述を想定している Go バージョンを定義するためのディレクティブ
- そのバージョン以降に導入された言語使用の機能を使用すると、ビルドエラーになる

#### `require`

- `go.mod` ファイルの中心的な表記となるディレクティブ
- 依存先モジュールにインポートパスやバージョンを指定する
-

## 参考リンク

https://zenn.dev/yoonchulkoh/articles/9729d9e1304738
