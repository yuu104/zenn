---
title: "Interface"
---

## Interface とは

- メソッドの集合を表す型

### 定義する

以下は、`Cooking`（料理）という名のインターフェースを実装した例。

```go
type Cooking interface {
  Cut() // 切る
  Bake() // 焼く
  Boil() // 茹でる
}
```

`Cooking` インターフェースには料理に関する様々な処理のメソッドを定義している。

次に、`Cooking` インターフェースを実装した構造体 `Soup`（スープ）を定義してみる。

```go
// スープの構造体を定義
type Soup struct {
  Name: string
}

// `Soup`　に対し、`Cooking` インターフェースを実装
func (v Sopu) Cut() {
  fmt.Printf("%v : 具材を切ります", v.Name)
}

func (v Soup) Bake() {
  fmt.Printf("%v : 具材を焼きます", v.Name)
}

func (v Soup) Boil() {
  fmt.Printf("%v : 具材を茹でます", v.Name)
}
```

Golang では、インターフェースを実装することを明示的に宣言する必要はない（Java のように `implements` キーワードは必要ない）。
Go では、interface の中にある関数名と同一の関数が全て実装されている構造体に**暗黙的**に実装される。

```go
func printBake(cook: Cooking) {
  cook.Bake()
}

func main() {
  var cook Cooking
  sopuA := Soup{"スープA"}

  cook = sopuA // `soupA` は `Cooling` インターフェースを実装しているため、代入可能

  printBake(cook) // 「スープA : 具材を焼きます」が出力される
}
```

以下の例はエラーになる

```go
type Cooking interface {
  Cut() // 切る
}

type Soup struct {
  Name: string
}

func (v *Sopu) Cut() {
  fmt.Printf("%v : 具材を切ります", v.Name)
}

func main() {
  var cook Cooking
  soup := Soup{"スープA"}

  cook = sopu // 型エラー
}
```

`soup` は `Cooking` インターフェースを実装した型を持つ変数ではない。
`func (v *Soup) Cut()` はポインタレシーバであるため、このメソッドは `Soup` ではなく `*Soup` の定義であるため。

- `soup` の型は `Soup`
- `func (v *Sopu) Cut()` は `*Soup` 型のメソッド

したがって、以下の代入はエラーにならない。

```go
cook = &sopu // `&soup` は `*Soup` 型のメソッドを持つ
```

## Interface の値

```go
package main

import "fmt"

type I interface {
  M()
}

type S struct {
  Name string
}
func (s *S) M() {
  fmt.Printf("hello, %s", s.Name)
}

func main() {
  var i I
  i = &S{"Taro"}

  fmt.Printf("%v, %T\n", i, i)
}
```

`fmt.Printf("%v, %T\n", i, i)` の結果は以下。

```shell
&{Taro}, main.T
```

変数 `i` はインターフェース型 `I` であるが、`i = &S{"Taro"}` により、`i` の実体は `&S{"Taro"}` となる。
