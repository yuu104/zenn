---
title: "make()"
---

- 動的に配列、スライス、マップなどのメモリを割り当てるために使用する
- `make` は、`new` とは異なり、ゼロ値で初期化された配列やスライスを作成する

```go
func main() {
    // スライスをmakeで作成する
    s := make([]int, 3, 5)

    // スライスの要素を設定する
    s[0] = 1
    s[1] = 2
    s[2] = 3

    // スライスの要素を出力する
    fmt.Println(s) // => [1 2 3]

    // スライスの要素数と容量を出力する
    fmt.Printf("len=%d cap=%d\n", len(s), cap(s)) // => len=3 cap=5
}
```

```go
package main

import (
	"fmt"
)

func main() {
	s1 := make([]int, 0, 2)
	fmt.Printf("%v, %v, %v\n", s1, len(s1), cap(s1)) // [], 0, 2
	fmt.Println(s1 == nil) // false

	s2 := make([]int, 3)
	fmt.Printf("%v, %v, %v\n", s2, len(s2), cap(s2)) // [0 0 0], 3, 3
}

```

- **第一引数**
  - 型を指定する
- **第二引数**
  - 初期要素数（length）
- **第三引数**
  - 初期容量（capacity）
