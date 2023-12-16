---
title: "ユニットテスト"
---

ユニットテストはソフトウェア開発において非常に重要な部分で、各関数やメソッドが正しく動作することを保証するために使われる。
Go 言語では、標準ライブラリの testing パッケージを使用してユニットテストを書くことができる。
以下の `Add()` と `Divide()` についてユニットテストを行う。

```go: main.go
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

## テスト関数の書き方

- テスト関数は Go の標準ライブラリ `testing` パッケージを使用して実行される
- テスト関数は `Test` で始まる名前を持ち、`testing.T` パラメータを取る
- `t.Errorf` または `t.Fatalf` を使用して、期待する結果と実際の結果が異なる場合にエラーメッセージを出力する
- `Errorf` はテストを続行させるが、`Fatalf` はテスト関数を即座に終了させる

```go: main_test.go
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

テストを作成したい関数で右クリックし、`Go: Generate Unit Tests For Function` を選択する。
![](https://storage.googleapis.com/zenn-user-upload/0c4c581f63b8-20231210.png)

すると、テストファイルとコードの骨組みが自動で生成される。

```go: main_test.go
func TestAdd(t *testing.T) {
	type args struct {
		x int
		y int
	}
	tests := []struct {
		name string
		args args
		want int
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := Add(tt.args.x, tt.args.y); got != tt.want {
				t.Errorf("Add() = %v, want %v", got, tt.want)
			}
		})
	}
}
```

`test` スライスにテストケースを記述していく。

- `name` : テストケースの名前
- `args` : テスト対象の関数（`Add`）の引数
- `want` : テストの期待値

`t.Run` はサブテストを実行するための関数。単一のテスト関数の中で複数の異なるテストケースを実行でき、それぞれのテストケースを独立して扱えるようになる。
基本的には以下のように使用する。

```go
t.Run(name string, f func(t *testing.T))
```

- `name` : サブテストの名前。これは各テストケースを識別するために使われる
- `f` : 実行するテストケースの関数。`*testing.T` を引数に取る

実際にテストケースを追加するとこんな感じ。

```diff go: main_test.go
func TestAdd(t *testing.T) {
	type args struct {
		x int
		y int
	}
	tests := []struct {
		name string
		args args
		want int
	}{
		// TODO: Add test cases.
+		{
+			name: "1+2=3",
+			args: args{x: 1, y: 2},
+			want: 3,
+		},
+		{
+			name: "2+3=5",
+			args: args{x: 2, y: 3},
+			want: 5,
+		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := Add(tt.args.x, tt.args.y); got != tt.want {
				t.Errorf("Add() = %v, want %v", got, tt.want)
			}
		})
	}
}
```

## テストの実行

- テストはコマンドラインから `go test` コマンドを使用して実行する
- カレントディレクトリのすべてのテストを実行するには、単に `go test` と入力する
- 特定のテストファイルだけを実行するには、ファイル名を指定する：例 `go test main_test.go`
- 特定のテスト関数のみを実行するには、`-run` フラグを使用する：例：`go test -run TestAdd`
- `go test -v` のように、`-v` オプションを指定すると、テストの実行中により詳細な情報を出力する
  - 通常、`go test` はテストの結果として「成功」または「失敗」のみを報告する

## テストのカバレッジ計測

`Divide` 関数における以下のテストカバレッジを計測する。

```go: main.go
func TestDivide(t *testing.T) {
	type args struct {
		x int
		y int
	}
	tests := []struct {
		name string
		args args
		want float32
	}{
		// TODO: Add test cases.
		{
			name: "1/2=0.5",
			args: args{x: 1, y: 2},
			want: 0.5,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := Divide(tt.args.x, tt.args.y); got != tt.want {
				t.Errorf("Divide() = %v, want %v", got, tt.want)
			}
		})
	}
}
```

### カバレッジの基本コマンド

`-cover` オプションを使うと、カバレッジデータを生成できる。

```shell
go test -run TestDivide -cover
```

結果は以下のように表示される。

```shell
PASS
	go-basics	coverage: 50.0% of statements
ok  	go-basics	0.219s
```

### カバレッジプロファイルの生成

より詳細なカバレッジ情報が必要な場合は、カバレッジプロファイルをファイルに出力できる。

```shell
go test -run TestDivide -coverprofile=coverage.out
```

すると、以下のファイルが生成される。

```out: coverage.out
mode: set
go-basics/main.go:3.24,5.2 1 0
go-basics/main.go:7.31,8.12 1 1
go-basics/main.go:8.12,10.3 1 0
go-basics/main.go:11.2,11.32 1 1
go-basics/main.go:14.14,17.2 0 0
```

### カバレッジレポートの表示

`coverage.out` を見ただけでは分かりずらいため、以下のコマンドを実行し、詳細に表示する。

```shell
go tool cover -html=coverage.out
```

カバレッジデータが HTML 形式でブラウザに表示される。

![](https://storage.googleapis.com/zenn-user-upload/7776f5b3b43d-20231216.png)
