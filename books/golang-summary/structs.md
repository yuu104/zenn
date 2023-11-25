---
title: "構造体"
---

**複数の異なるデータ型をまとめるために使用される型**

## 構造体の宣言

- `type` と `struct` を使用して宣言する
- オブジェクト指向言語にける `class` と似ている

```go
type Person struct {
    FirstName string
    LastName  string
    Age       int
}
```

## 構造体の初期化

初期化には複数の方法がある。

```go
p := Person{
  FirstName: "John",
  LastName:  "Doe",
  Age:       30,
}
```

```go
p := Person{"John", "Doe", 30}
```

```go
var p Person

p.FirstName = "John"
p.LastName = "Doe"
p.Age = 30
```

```go
p := new(Person)
p.FirstName = "John"
p.LastName = "Doe"
p.Age = 30
```

## 構造体へのアクセス

```go
fmt.Println("First Name:", p.FirstName)
fmt.Println("Last Name:", p.LastName)
fmt.Println("Age:", p.Age)
```

## 構造体のゼロ値

- 構造体の宣言時に初期値を定義しなかった場合、各フィールドはゼロ値で初期化される
- 数値型（`int` `float64`など）のゼロ値は`0`
- 文字列型（`string`）のゼロ値は空文字列`""`
- ブール型（`bool`）のゼロ値は`false`
- ポインタ スライス マップ チャネル 関数 インターフェイスのゼロ値は`nil`
- 明示的な初期化がなくても変数はデフォルト値で初期化されるため予期せぬ`null`や`undefined`のエラーを避けることができる

```go
package main

import "fmt"

type MyStruct struct {
    Number int
    Text   string
    Flag   bool
}

func main() {
    var s MyStruct
    fmt.Println(s) // {0  false}
}
```

## 構造体とポインタ

- 構造体のフィールドは、ポインタを通してアクセス可能

```go
type Person struct {
    FirstName string
    LastName  string
    Age       int
}

p := Person{
  FirstName: "John",
  LastName:  "Doe",
  Age:       30,
}

pPtr := &p

// 下記2行は同じ意味
(*pPtr).Age = 10
pPtr.Age = 10 // コンパイラが暗黙的に `(*pPtr).Age` に変換する
```

## メソッド

- 構造体にメソッド（関数）を定義できる
- メソッドの定義には、レシーバを使用する
- レシーバで指定した構造体と関数を関連付ける

```go
func レシーバ メソッド名(引数リスト) 戻り値リスト {
}
```

- レシーバは `(変数 型)` という形式で記述する

```go
type Person struct {
    FirstName string
    LastName  string
    Age       int
}

func (p Person) hello() {
  fmt.Printf("%s (%d)\n", p.FirstName, p.Age)
}

func main() {
  p := Person{
    FirstName: "John",
    LastName:  "Doe",
    Age:       30,
  }

  p.hello() // John (30)
}
```

## ポインタレシーバ

- メソッド内でフィールド値を変更する場合は、ポインタレシーバを利用する必要がある

```go
type Person struct {
    FirstName string
    LastName  string
    Age       int
}

func (p Person) hello() {
  fmt.Printf("%s (%d)\n", p.FirstName, p.Age)
}

// レシーバにポインタを使用する
func (p *Person) increment() {
  p.Age++
}

func main() {
  p := Person{
    FirstName: "John",
    LastName:  "Doe",
    Age:       30,
  }

  p.hello() // John (30)
  p.increment()
  p.hello() // John (31)
}
```

- `(p *Person)` のように、値ではなくポインターで渡す
- `p.hello()` は `(&p).hello()` へ暗黙的に変換される

## レシーバの変数を使用しない場合は記述しなくても良い

```go
type Person struct{ name string }


func (*Person) Shout(msg string) {
    fmt.Printf("%s!!!\n", msg)
}
```

## `struct` 型のポインタ変数がゼロ値の場合

- ポインタ変数がゼロ値の場合、その値は `nil` になる
- そのため、ゼロ値のポインタ変数に対して構造体のフィールドへアクセスしようとすると、ランタイムパニックが発生する

```go
package main

import "fmt"

type MyStruct struct {
    Field int
}

func main() {
    var s *MyStruct // `MyStruct` 型のポインタ変数

    fmt.Printf("%v, %T\n", s, s) // <nil>, *main.MyStruct
    fmt.Println(s.Field) // ランタイムパニックが発生する
}
```

- ポインタレシーバを使うメソッドを呼び出すことは可能
- ただし、メソッド内で構造体のフィールドへアクセスするとランタイムパニックになる
- よって、そのメソッド内でポインタが `nil` であるかどうかをチェックする必要がある

```go
package main

import "fmt"

type MyStruct struct {
    Field int
}

func (m *MyStruct) DoSomething() {
    if m == nil {
        fmt.Println("nil receiver")
        return
    }
    fmt.Println("Field:", m.Field)
}

func main() {
    var m *MyStruct // この時点で `m` は `nil`
    m.DoSomething() // nil receiver
}
```

## 値レシーバ vs ポインタレシーバ

- レシーバの値を変更したい場合はポインタレシーバ
- 統一性の観点から、一つでもポインタレシーバを使用する場合は値の変更有無にかかわらず全てポインタレシーバにする
-

## 構造体の埋め込み

- クラスの継承のようなもの
- 異なる構造体を組み合わせて新しい構造体を作成できる

```go
package main

import "fmt"

type Person struct {
   firstName string
}

func (a Person) name() string{ //Personのメソッド
    return a.firstName
}

type User struct {
     Person
}

func (a User) name() string { //Userのメソッド
    return a.firstName
}

func main(){
  bob := Person{"Bob"}
  mike := User{}
  mike.firstName = "Mike"

  fmt.Println(bob.name()) //=> Bob
  fmt.Println(mike.name()) //=> Mike
}

```
