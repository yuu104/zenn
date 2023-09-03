---
title: "io.Reader インターフェース"
---

## `io.Reader` インターフェースとは？

`io` パッケージにあるインターフェース。
これは、データを読み取るための共通の方法を提供するインターフェースです。
このインターフェースは、異なるデータソースからデータを読み取るための統一的な手法を提供し、コードの一貫性と再利用性を高める役割を果たします。

## 何のためのインターフェースなのか？

`io.Reader` インターフェースの主な目的は、異なるデータソース（例: ファイル、ネットワーク接続、バッファなど）からのデータ読み取り操作を抽象化することです。
これにより、異なるデータソースに対して同じ読み取り操作を適用でき、コードの再利用性を向上させます。
具体的なデータソースに依存せず、統一的な読み取り方法を提供することで、コードの一貫性と保守性を高めるのが主な目的です。

## `Read` メソッド

`io.Reader` インターフェースは以下の構成になっています。

```go
type Reader interface {
	Read(p []byte) (n int, err error)
}
```

`Read` メソッドは、引数としてバイトスライス`p` を受け取り、読み取ったバイト数 `n` とエラー情報 `err` を返します。

- `p` には読み取ったデータを格納するためのバイトスライスを指定します
- `n` は実際に読み取ったバイト数を示します
- `err` はエラー情報を格納する `error` 型の変数です。
  エラーが発生しない場合、`err` は `nil` になります。
  一般的なエラーとして `io.EOF` があり、これはデータの末尾を示すものです。

## コード例

以下は、`Reader` インターフェースの使用例です。
例として、文字列からデータを読み取る `StringReader` 型を定義してみます。

```go
package main

import (
    "fmt"
    "io"
)

type StringReader struct {
    data string
    pos  int
}

func NewStringReader(s string) *StringReader {
    return &StringReader{data: s}
}

func (r *StringReader) Read(p []byte) (n int, err error) {
    if r.pos >= len(r.data) {
        return 0, io.EOF
    }
    n = copy(p, r.data[r.pos:])
    r.pos += n
    return n, nil
}

func main() {
    reader := NewStringReader("Hello, World!")
    buffer := make([]byte, 6)

    for {
        n, err := reader.Read(buffer)
        if err == io.EOF {
            break
        }
        fmt.Printf("Read %d bytes: %s\n", n, buffer[:n])
    }
}

```

この例では、`StringReader` が `io.Reader` インターフェースを実装しており、指定されたバイト数だけデータを読み取っています。
最終的に、`io.EOF` が返されるまでデータを読み込みます。

実行結果は以下になります。

```shell
Read 6 bytes: Hello,
Read 6 bytes:  World
Read 1 bytes: !
```

このプログラムは、`StringReader` からデータを読み取り、6 バイトずつ `buffer` に格納し、それを表示しています。
