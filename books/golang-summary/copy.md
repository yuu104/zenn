---
title: "copy関数"
---

配列やスライスをコピーするために使用される。

以下はスライス `s` をスライス `t` にコピーする例。

```go
package main

import "fmt"

func main() {
    s := []int{0, 10, 20, 30} // => [0 10 20 30] ←スライスsを作成

    t := make([]int, len(s))  // スライスtの骨組みを作成する
    fmt.Println(t)            // => [0 0 0 0] ←まだ値には0が入っている

    n := copy(t, s)           // スライスsをスライスtにコピーする

    fmt.Println(t)            // => [0 10 20 30] ←値がスライスsと同じ値になった
    fmt.Println(n)            // => 4 ←コピーされた要素の個数が返されている
}
```

### `copy` の引数、返り値

- 第一引数 : コピー先のスライス
- 第二引数 : コピー元のスライス
- 返り値 : コピーされた要素の個数

## コピー先とコピー元の長さが異なる場合

### コピー先のほうが長い場合

```go
package main

import "fmt"

func main() {
  s := []int{0, 10, 20, 30} // => [0 10 20 30] ←スライスsを作成

  t := make([]int, 5)  // 長さと容量が　5のスライスtの骨組みを作成する
  fmt.Println(t)            // => [0 0 0 0 0] ←まだ値には0が入っている

  n := copy(t, s)           // スライスsをスライスtにコピーする

  fmt.Println(t)            // => [0 10 20 30 0]
  fmt.Println(n)            // => 4 ←コピーされた要素の個数が返されている
}
```

### コピー元のほうが長い場合

```go
package main

import "fmt"

func main() {
  s := []int{0, 10, 20, 30} // => [0 10 20 30] ←スライスsを作成

  t := make([]int, 2)  // 長さと容量が　5のスライスtの骨組みを作成する
  fmt.Println(t)            // => [0 0] ←まだ値には0が入っている

  n := copy(t, s)           // スライスsをスライスtにコピーする

  fmt.Println(t)            // => [0 10]
  fmt.Println(n)            // => 2 ←コピーされた要素の個数が返されている
}
```

## 参考リンク

https://qiita.com/pon_maeda/items/06850524450d882e2bd5
