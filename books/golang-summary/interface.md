---
title: "Interface"
---

## Interface とは

https://qiita.com/rtok/items/46eadbf7b0b7a1b0eb08#%E3%82%A4%E3%83%B3%E3%82%BF%E3%83%BC%E3%83%95%E3%82%A7%E3%83%BC%E3%82%B9%E3%81%AE%E5%AE%9F%E8%A3%85

- メソッドの集合を表す型

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

## interface はどんな型でも受け入れる

interface を使うとどんな型でも受け入れることができます。
例えば以下のコードは `do` という関数に interface 型の引数と返り値を取っています。

```go
package main

import (
  "fmt"
)

// 引数と返り値の型はなんでもOK
func do(any interface{}) interface{} {
  return any
}

func main() {
  fmt.Println(do(100))    // => 100
  fmt.Println(do("test")) // => test
  fmt.Println(do(true))   // => true
}
```

## interface と nil

```go
type I interface {
  M()
}

type T struct {
  S string
}

func (t *T) M() {
  if t == nil {
    fmt.Println("<nil>")
    return
  }
  fmt.Println(t.S)
}

func main() {
  var i I
  var t *T

  i = t
  printf("%v, %T\n", i, i) // <nil>, *main.T
  i.M() // <nil>
}
```

## 型アサーション

型アサーションにより、実体の型が何であるかを動的にチェックできる。

https://zenn.dev/shinkano/articles/4779726fb964d9

```go
x interface{} := "hello"

s, ok := x.(float64)
fmt.Println(s, ok) // 0, false

f := x.(float64) // panicになる
fmt.Println(f)
```

型アサーションを記述した返り値の 2 番目の変数 `ok` を書かなかった場合、チェックした型情報が間違っていてば panic を引き起こす。

## 型 switch

型スイッチ（Type Switch）は、Go 言語の特徴の一つであり、インターフェースの値の内部に格納されている具体的な型を判定するための仕組み。
型スイッチは主に switch 文の中で使用され、インターフェースが実装している具体的な型を特定して、それに応じて処理を行うために使用される。

型スイッチ（Type Switch）は、Go 言語の特徴の一つであり、インターフェースの値の内部に格納されている具体的な型を判定するための仕組みです。型スイッチは主に `switch` 文の中で使用され、インターフェースが実装している具体的な型を特定して、それに応じて処理を行うために使用されます。

型スイッチの一般的な構文は以下の通りです：

```go
switch value := interfaceVariable.(type) {
case Type1:
    // Type1 に対する処理
case Type2:
    // Type2 に対する処理
// 他の型に対する処理...
default:
    // 上記のいずれにも該当しない場合の処理
}
```

ここで `interfaceVariable` はインターフェース型の変数であり、`Type1`、`Type2` などは具体的な型です。`interfaceVariable.(type)` の部分で、インターフェース内に格納されている具体的な型がどれかを判定しています。

例を挙げて説明しましょう：

```go
package main

import "fmt"

func printType(i interface{}) {
    switch v := i.(type) {
    case int:
        fmt.Printf("This is an int: %d\n", v)
    case string:
        fmt.Printf("This is a string: %s\n", v)
    default:
        fmt.Printf("Unknown type: %T\n", v)
    }
}

func main() {
    printType(42)       // This is an int: 42
    printType("Hello")  // This is a string: Hello
    printType(3.14)     // Unknown type: float64
}
```

この例では、`printType` 関数がインターフェース型の引数を受け取り、その中に格納されている具体的な型に基づいて適切なメッセージを出力します。型スイッチを使用して、`i.(type)` の部分で具体的な型を判定しています。

型スイッチは、ランタイム時にインターフェースがどの具体的な型を持っているかを判断し、それに合わせた処理を行う場合に非常に便利です。
