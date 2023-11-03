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
(*p).Age = 10
p.Age = 10
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
func (p *Person) increment {
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
