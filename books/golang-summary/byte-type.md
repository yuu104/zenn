---
title: "byte型"
---

## byte 型とは何か？

- byte 型は、符号なし 8bit のデータを表すための整数型
- コンピュータ内で最小の単位である 1 バイト（8 ビット）のデータを表現する
- 文字やバイナリデータなど、さまざまな情報をバイト列として扱う際に使用される

## どのような値が入るのか？

10 進数で 0~255 までの範囲の整数値を取ることができる。
これは、8bit のバイナリパターンで表現できる範囲。

## byte 型の宣言と代入方法

### 変数宣言と初期化

```go
package main

import "fmt"

func main() {
    var b byte          // byte型の変数を宣言（初期値は0）
    b = 65              // byte型変数に整数値を代入
    fmt.Println(b)      // 出力: 65
}
```

### 短縮宣言と代入

```go
package main

import "fmt"

func main() {
    b := byte(97)       // byte型の変数を宣言して代入
    fmt.Println(b)      // 出力: 97
}
```

## 文字列をバイト列に変換

```go
package main

import "fmt"

func main() {
    str := "Hello"
    byteData := []byte(str)  // 文字列をバイト列に変換

    for _, b := range byteData {
        fmt.Println(b)
        // 72
        // 101
        // 108
        // 108
        // 111
    }
}
```

上記は、文字列 `Hello` をバイト列に変換し、そのバイト値を表示している。
`[]byte(str)` という表記は、文字列をバイトのスライスに変換する方法。

### 文字列をバイト値に変換するとは？

文字列をバイト値に変換することは、文字列内の各文字をその文字のエンコーディングに基づいて対応するバイト値に変換することを指します。テキストデータは、コンピュータ内でバイナリデータとして扱われるため、文字をバイトの数値として表現する必要があります。

UTF-8 エンコーディングのような多くのテキストエンコーディングでは、文字を複数のバイトで表現します。例えば、英字の「A」は ASCII コードでは 10 進数で 65、2 進数で「01000001」に対応します。このようなバイト値に変換することで、コンピュータは文字列を扱いやすいバイナリデータに変換することができます。

Golang の `[]byte` スライスを使用して文字列をバイト値に変換することができます。これにより、テキストをバイトの列として操作することができます。例えば、以下のコードは文字列 `Hello` をバイト値に変換し、各文字のバイト値を表示しています。

```go
package main

import "fmt"

func main() {
    str := "Hello"
    byteData := []byte(str)  // 文字列をバイト列に変換

    for _, b := range byteData {
        fmt.Println(b)
    }
}
```

上記のコードを実行すると、文字列 `Hello` の各文字のバイト値が表示されます。このような変換は、テキストデータをバイナリデータとして操作するために非常に重要です。

## バイトスライスを文字列に変換

`string()` キャストを使用する。

```go
package main

import (
	"fmt"
)

func main() {
	byteSlice := []byte{72, 101, 108, 108, 111} // "Hello"のASCIIコード

	// byteスライスを文字列に変換
	str := string(byteSlice)

	fmt.Println(str) // "Hello"と出力される
}

```
