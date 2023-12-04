---
title: "変数・定数"
---

## `var` 宣言

- 変数を宣言する
- 宣言時に初期化子を与えることができる
- 初期化子がある場合、型を省略できる

```go
var age int = 30

var id = 1

var i, j int = 1, 2

var c, python java = true, false, "no!"
```

## 変数の短縮宣言

- `var` の代わりに、`:=` の代入文を使用できる
- 型は自動的に割り当てられる
- 明示的な代入が必須

```go
name := "John"
```

- **関数の外では利用できない**

## 定数

- `const` を使用する
- 定数は一度設定されたら変更できない

```go
const pi = 3.14
```

- **定数は、文字(character)、文字列(string)、boolean、数値(numeric)に使える**

## ゼロ値

- 変数に初期値を与えずに宣言すると、ゼロ値（zero value）が与えられる
- ゼロ値は型によって以下のように与えられる
  - 数値型(int,float など): `0`
  - bool 型: `false`
  - string 型: `""` (空文字列( empty string ))

## 複数の変数を同時に宣言する

```go
pi, title := 3.14, "Go"
```

```go
var (
  i int
  s string
  b bool
)
```

## シャドーイング

- スコープ内で既に宣言されている変数名を再利用すること
- これにより、外側のスコープにある同名の変数が新しい変数によって隠される（シャドーイングされる）状態が発生する

```go
package main

import (
	"fmt"
)

func main() {
	x := 10 // 外側のスコープで宣言
	fmt.Println(x) // 10
  fmt.Println(&x) // 0x1400001a108

	if true {
		x := 5 // 内側のスコープで新たに宣言（シャドーイング）
		fmt.Println(x) // 5
    fmt.Println(&x) // 0x1400001a118
	}

	fmt.Println(x) // 10, 内側のスコープのxはここではアクセス不可
  fmt.Println(&x) // 0x1400001a108
}
```
