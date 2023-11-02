---
title: "パッケージ・モジュール"
---

## イメージ図

![](https://storage.googleapis.com/zenn-user-upload/ae0fb8418066-20231102.png)

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
- 上記コマンドによりプロジェクトフォルダに `go.mod` が作成され、プロジェクトディレクトリ以下が「モジュール」扱いになる

  ```mod:go.mod
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
- ダウンロードしたモジュールは「モジュールキャッシュのディレクトリ」配下に格納される
  - `go env | grep GOMODCACHE` コマンドでモジュールキャッシュの位置を確認できる

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

:::details ディレクティブとは？

- ソースコードに記述される要素の 1 つ
- コードを解釈・変換するコンパイラなどへ指示を与えるためのもの
- `go`, `module`, `require` など

:::

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

#### `module`

- 自分自身のモジュール名を定義するためのディレクティブ
- `go mod init` コマンドで指定したモジュール名が自動で設定される
- 以下のようにコメントで先頭に `Deprecated:` と記述すると、Go1.17 以降で`go get` した場合に警告を出すことができる
  ```mod
  // Deprecated: use github.com/ryo-yamaoka/gomod-test-3/v2
  module github.com/ryo-yamaoka/gomod-test-3
  ```

#### `go`

- モジュールの記述を想定している Go バージョンを定義するためのディレクティブ
- そのバージョン以降に導入された言語使用の機能を使用すると、ビルドエラーになる

#### `require`

- 依存先モジュールのインポートパスやバージョンを指定する
- ここで指定するバージョンは git の tag であり、コミットハッシュを一意に特定できるため、`go.mod` ファイルのみで依存関係を定義できる
  - 従って、node における `lock` ファイルのような類は Go modules には存在しない
- Go1.17 からは間接的依存先（=依存先の依存先）が自動的に追記されるようになった
  - `//indirect` が付く
- `+incompatible` と付いているものは、メジャーバージョンとモジュール名のサフィックスが一致していない
  - `v2.0.0` というタグが付いているのにモジュール末尾が `github.com/xxx/yyy` となっているケース等
  - Go module のバージョン管理では、バージョンが `v2.x.y` であれば `github.com/xxx/yyy/v2` となる必要がある

#### `exclude`

- このディレクティブにパスとバージョンを書くと、特定のバージョンを除外し、使用しないよう制御できる
- 制御対象は直接依存しているモジュールのみ
- 以下は、`v0.0.1` を `exclude` し、`v0.0.2` を `require` にしている

  ```mod
  module github.com/ryo-yamaoka/gomod-test-2

  go 1.17

  exclude github.com/ryo-yamaoka/gomod-test-3 v0.0.1

  require github.com/ryo-yamaoka/gomod-test-3 v0.0.2

  ```

#### `replace`

- モジュールのインポートパスを別の場所に置き換えるためのディレクティブ
- 以下のように記述する
  ```mod
  replace github.com/ryo-yamaoka/repo => github.com/another/repo
  ```
- ローカル上の自作モジュールをインポートする際などに使用する

#### `retract`

- Go1.16 から導入された
- 一度公開したモジュールを撤回するためのディレクティブ
- 間違えて公開したり脆弱性が発覚したりして利用を差止めたいといった場合に使用する
- 以下は、`v0.0.2` を `retract` している
  ```mod
  retract (
    v0.0.2 // Contains vulnerability CVE-xxxx
  )
  ```
- この状態で `v0.0.3`　以降を公開すると、`v0.0.2` は `go list -m -version` や `go get` の対象外となる
- 既にインポート済みの場合は引き続きビルドすることができ、`go mod tidy` で自動的にアップグレードされることもない

### `go.sum`

- 依存先モジュールの**ハッシュ**を記録するためのファイル
- 直接・間接を問わず記録する
- `go.mod` と共に git で管理され、ビルド再現性のために利用される
- しかし、モジュールの取得は `go.mod` の `require` の情報で簡潔できるため、`go.sum` 自体はなくてもビルド再現性は得られる

**では一体何のために `go.sum` が存在するのか？**

- `go.mod` を元に取得したモジュールが本当に `go.sum` 生成時のものと一致しているかチェックするため
- バージョンは git のタグを元に管理されている
  - その気になれば付け替えることが可能
- そのため、悪意のある第三者がリポジトリを乗っ取り、同じバージョンタグでマルウェアを仕込む可能性もある
- 従って、`go.sum` 生成時のモジュール内容のキャッシュと比較して同じかどうかを検証する

### ローカルモジュールの利用

- github などに公開されているモジュールはモジュールパスが公開先の URL であるため、`go` コマンドが自動で参照してくれる
- しかし、ローカルマシン上のモジュールは場所がわからない
- 従って、`go` コマンドにモジュールの場所を知らせる必要がある

- `go mod edit` コマンドにより、`go.mod` にモジュールの場所を定義する

```shell
go mod edit -replace "example.com/calc=/home/go/calc"
```

- `-replace` オプションの値は `<モジュールパス>=<ディレクトリ>` の形式で指定する
- コマンドを実行すると、`go.mod` の `replace` ディレクティブに定義される

  ```mod
  module example.com/myapp

  go 1.15

  replace example.com/calc => /home/go/calc
  ```

### プライベートリポジトリにあるモジュールの利用

- `go` コマンドはモジュールをダウンロードする際に、デフォルトでプロキシサーバを経由する
- プロキシサーバはプラーベートリポジトリの認証情報を知らない
- 従って、`go` コマンドに対してプロキシサーバを経由しないようにする必要がある
- 環境変数 `GOPRIVATE` にプライベートリポジトリのモジュールパスを記載する
  - これにより、プロキシを経由せずにダウンロードできる
  ```shell
  go env -w GOPRIVATE=github.com/<user>
  ```
- 次に、GitHub のパーソナルアクセストークンを生成し、git に設定する
- あとは `go mod tidy` などでモジュールを追加する

### 外部モジュール使用のイメージ図

![](https://storage.googleapis.com/zenn-user-upload/52b58e7bd744-20231102.png)

## 参考リンク

https://zenn.dev/yoonchulkoh/articles/9729d9e1304738
https://qiita.com/WisteriaWave/items/60a1052981131f95fbf6
https://zenn.dev/ryo_yamaoka/articles/595cf9e69229f9#fn-0ce5-2
https://osamu-tech-blog.com/go-go-modules/
https://www.twihike.dev/docs/golang-primer/using-modules#%E3%83%A2%E3%82%B8%E3%83%A5%E3%83%BC%E3%83%AB%E3%81%A8%E3%81%AF
