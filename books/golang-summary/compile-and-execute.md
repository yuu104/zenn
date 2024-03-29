---
title: "コンパイル・実行"
---

## `go run`

```shell
go run [ファイル名.go]
```

- Go ファイルを直接実行するコマンド
- コンパイルされた実行可能ファイルを生成せず、ソースコードを直接実行

## `go build`

```shell
go build [ファイル名.go]
```

- Go ファイルから実行可能ファイルを生成するコマンド
- 生成された実行可能ファイルはその後で直接実行可能
- `go build main.go` を実行すると、`main` ファイルが生成される
- `main` ファイルは実行可能ファイルなので、`./main` コマンドで実行できる

## `go build -o`

```shell
go build -o [実行可能ファイル名] [ファイル名.go]
```

- `-o` オプションをつけることで、ファイル名を指定できる

## `go test`

```shell
go test
```

- テストファイル（`_test.go`で終わるファイル）を実行するコマンド
- テストケースを実行し、結果を出力
