---
title: "ユニットテスト"
---

ユニットテストはソフトウェア開発において非常に重要な部分で、各関数やメソッドが正しく動作することを保証するために使われる。
Go 言語では、標準ライブラリの testing パッケージを使用してユニットテストを書くことができる。
以下の `Add()` と `Divide()` についてユニットテストを行う。

```go
func Add(x, y int) int {
	return x + y
}

func Divide(x, y int) float32 {
	if y == 0 {
		return 0
	}
	return float32(x) / float32(y)
}
```

## テストファイルの作成

- テストファイルは通常、テスト対象のファイルと同じディレクトリに置き、ファイル名は `_test.go` で終わる
- 例えば、`math.go` に Add と Divide 関数があるなら、テストファイルは `math_test.go` と名付ける

![](https://storage.googleapis.com/zenn-user-upload/0c4c581f63b8-20231210.png)

## テスト関数の書き方

- テスト関数は Go の標準ライブラリ `testing` パッケージを使用して実行される
- テスト関数は `Test` で始まる名前を持ち、`testing.T` パラメータを取る
- `t.Errorf` または `t.Fatalf` を使用して、期待する結果と実際の結果が異なる場合にエラーメッセージを出力する
- `Errorf` はテストを続行させるが、`Fatalf` はテスト関数を即座に終了させる

```go
package main

import "testing"

func TestAdd(t *testing.T) {
    result := Add(2, 3)
    expected := 5
    if result != expected {
        t.Errorf("Add(2, 3) = %d; want %d", result, expected)
    }
}
```

## VSCode でテストファイル・コードを自動生成する

## テストの実行

- テストはコマンドラインから `go test` コマンドを使用して実行する
- カレントディレクトリのすべてのテストを実行するには、単に `go test` と入力する
- 特定のテストファイルだけを実行するには、ファイル名を指定する：例 `go test math_test.go`
- 特定のテスト関数のみを実行するには、`-run` フラグを使用する：例：`go test -run TestAdd`

## ユニットテストのポイント
