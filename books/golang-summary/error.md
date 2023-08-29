---
title: "エラー処理"
---

## `error` インターフェース

Go では、JavaScript などの他の言語のような try-catch メカニズムはありません。

```js
try {
  // エラー発生
} catch (error) {
  // エラー処理
}
```

その代わりに、Go はエラーを表現するための `error` インターフェース型を標準で提供しています。
エラーインターフェースには `Error()` メソッドがあり、エラーメッセージを文字列で返します。
(`error` は小文字であるが、組み込みのインターフェースであるため、どのパッケージからでも使用可能)

```go
type error interface {
    Error() string
}
```

Go のエラーはこの `error` 型のインターフェースを使い、**値**で表現することになっています。
Go におけるエラー値は下のようにまとめられます。

- エラーがない場合 : `nil` として表現
- エラーが発生した場合 : `nil` ではない値として表現

Go では、`error` が `nil` かどうかを調べることで、エラーを処理することができます。

ファイルの中身を読み込む次のような関数を考えてみましょう。

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

Go では、関数から返されたエラー値を確認し、そのエラー値に基づいてエラー処理を行います。

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