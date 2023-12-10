---
title: "エラー処理"
---

## `error` インターフェース

Go では、JavaScript などの他の言語のような try-catch メカニズムは存在しない。

```js
try {
  // エラー発生
} catch (error) {
  // エラー処理
}
```

その代わりに、Go はエラーを表現するための `error` インターフェース型を標準で提供している。
`error` インターフェースには `Error()` メソッドがあり、エラーメッセージを文字列で返す。
(`error` は小文字であるが、組み込みのインターフェースであるため、どのパッケージからでも使用可能)

```go
type error interface {
    Error() string
}
```

Go のエラーはこの `error` 型のインターフェースを使い、**値**で表現することになっている。
Go におけるエラー値は下のようにまとめられる。

- エラーがない場合 : `nil` として表現
- エラーが発生した場合 : `nil` ではない値として表現

Go では、`error` が `nil` かどうかを調べることで、エラーを処理することがでる。

ファイルの中身を読み込む次のような関数を考えてみる。

```go
// ファイルを読み取りその内容を返すと共にerror型の値も返します
func ReadFile() ([]byte, error) {
    // os.Open関数を用いてファイルをオープンし、ファイルディスクリプタとエラー値を返します
    // ファイルが正常にオープンされた場合、エラー値はnilとなります。エラーが発生した場合、エラー値はnilでない値になります
    f, err := os.Open("test.txt")

    // もしerrがnilではない値の場合はファイルの開封に失敗しているので、この関数の実行結果はエラーということになり、発生したエラーを値として返します
    if err != nil {
        return nil, err
    }

    defer f.Close()

    // 同様に、ファイルの内容を読み取る処理も行います
    data, err := io.ReadAll(f)

    if err != nil {
        return nil, err
    }

    // ファイルオープンとファイル内容の読み取りに成功した場合はエラーなしと判断し、この関数のエラーをnilとして返します
    // このようにすることで、この関数の二つ目の返り値であるerrorの値を見ることで、実行結果がエラーなのかエラーでないのかを関数外から判定することができます
    return data, nil
}
```

Go では、関数から返されたエラー値を確認し、そのエラー値に基づいてエラー処理を行う。

:::message
Go ではエラーを `error` 型のインターフェースを満たした単なる**値**として考えることが重要
:::

`error` インターフェースを実装した値を `fmt` パッケージで出力すると、`Error` メソッドで定義した文字列が出力される。

```go
package main

import "fmt"

type NetworkError struct {
  message string
}

func (err *NetworkError) Error() string {
  return fmt.Sprintf("Network Error: %s", err.message)
}

func main() {
  err := &NetworkError{"ネットワークの不具合により、通信に失敗しました"}

  fmt.Println(err) // Network Error: ネットワークの不具合により、通信に失敗しました
}
```

## エラーを作成する方法

主に 3 つ存在する。

1. 標準ライブラリ：`errors.New()`
2. 標準ライブラリ : `fmt.Errorf()`
3. 独自で error interface を満たす型を作成する

### 標準ライブラリ：`errors.New()`

```go
err := errors.New("エラーメッセージ")
```

### 標準ライブラリ : `fmt.Errorf()`

フォーマット付きのエラーメッセージを生成することができる。

```go
err := fmt.Errorf("エラー発生: %v", someValue)
```

### 独自で error interface を満たす型を作成する

エラーが発生した時の情報を構造体のフィールドとして保持しておきたい場合などに有効。
`Error()` メソッドを実装していれば `error` インターフェイスを実装していることになる。

```go
type MyError struct {
    Msg string
    Code int
}

func (e *MyError) Error() string {
    return fmt.Sprintf("Code: %d, Msg: %s", e.Code, e.Msg)
}
```

## エラーのラップ、アンラップ

エラー情報に追加のコンテキストを提供したり、元のエラーを取り出すことができる。

### エラーのラップ

- 既存のエラーに追加情報を付け加えることを意味する
- エラーがどこで発生したか、なぜ発生したかをより詳しく伝えるのに役立つ
- Go 1.13 以降では、`fmt.Errorf()` 関数と `%w` フォーマット指示子を使用してエラーをラップできる。

```go
err := errors.New("エラーです")
fmt.Println(err)

err = fmt.Errorf("追加の説明：%w", err)
fmt.Println(err)
```

### エラーのアンラップ

- ラップされたエラーから元のエラーを取り出すプロセス
- Go 1.13 以降では、`errors` パッケージの `Unwrap()` 関数を使ってこれを行うことができる

```go
wrappedErr := fmt.Errorf("追加の説明: %w", err)
originalErr := errors.Unwrap(wrappedErr)
```

### ラップ・アンラップは `%w` を使用する

- `%w` を使用しない場合、エラーはラップされない
- `fmt.Errorf()` は新しいエラーを生成し、元のエラー（`err`）への参照や関連情報を持たない
- `%w` の代わりに `%v` を使用した場合

```go
wrappedErr := fmt.Errorf("追加の説明: %v", err)
```

- `wrappedErr` は単に新しい独立したエラーとして扱われる
- このコードでは、`wrappedErr` は `err` の文字列表現を含む新しいエラーメッセージを持っているが、`errors.Unwrap()` を使用して `err` を取り出すことはできない
- `%w` を使用しなかった場合、`errors.Unwrap()` は `nil` を返す

## `errors.Is()`

- 指定されたエラーが特定のエラー値か、もしくはそのエラーチェーンの中に含まれているかどうかを確認する
- エラーが特定の値と一致するかどうかをチェックする際に役立つ

```go
if errors.Is(err, targetError) {
    // errがtargetErrorと一致する場合、もしくはerrのエラーチェーン内にtargetErrorが含まれる場合の処理
}
```

- ここで `targetError` は、`err` と比較したい特定のエラー

## `errors.As()`

- エラー値が特定の型であるか、またはエラーチェーン内にその型のエラーが含まれているかをチェックする
- エラーが特定の型であるかどうかを確認し、その型の値としてエラーを扱いたい場合に使用する

```go
var targetErrType *MyCustomError
if errors.As(err, &targetErrType) {
    // errがMyCustomError型である場合、もしくはerrのエラーチェーン内にMyCustomError型が含まれる場合の処理
}
```

例えば、次のようなカスタムエラー型がある場合、

```go
type MyCustomError struct {
    Message string
}

func (e *MyCustomError) Error() string {
    return e.Message
}
```

関数がこのタイプのエラーを返す場合、`errors.As` を使用してそのエラーを特定し、エラーに含まれる追加情報にアクセスできる。

```go
err := someFunction()
var myErr *MyCustomError
if errors.As(err, &myErr) {
    fmt.Println("カスタムエラーメッセージ:", myErr.Message)
}
```
