---
title: "typeキーワード - 新しい型の宣言"
---

- 新しいデータ型を定義する際に使用される
- 既存の型に基づいて新しい型を作成したり、より複雑な構造体（struct）やインターフェイスを定義したりすることができる

## 新しい型の定義

以下のように整数型のエイリアスを作ることができる

```go
import "fmt"

type MyInt int

func main() {
  var age MyInt = 20
  fmt.Println(age) // 20
}
```

- `MyInt` という新しい型は、`int` に基づいている
- `MyInt` は `int` と互換性があるが、型システムにおいては異なる型として扱かわれる

## 構造体（Struct）の定義

構造体の定義にも `type` が使用される。

```go
type Person struct {
    Name string
    Age  int
}
```

## インターフェースの定義

インターフェースの定義にも `type` が使用される。

```go
type Speaker interface {
    Speak() string
}
```

## メソッドの宣言

メソッドは `struct` 型だけでなく、任意の型（`type`）にも宣言できる。

```go
import (
	"fmt"
	"math"
)

type MyFloat float64

func (f MyFloat) Abs() float64 {
	if f < 0 {
		return float64(-f)
	}
	return float64(f)
}

func main() {
	f := MyFloat(-math.Sqrt2)
	fmt.Println(f.Abs()) // 1.4142135623730951
}
```
