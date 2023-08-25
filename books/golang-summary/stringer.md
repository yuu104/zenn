---
title: "Stringers"
---

`fmt` パッケージ内にある `Stringer` インターフェースは、Go 言語においてカスタムな文字列表現を提供するための仕組みです。このインターフェースを実装することで、任意の型に対して `fmt` パッケージの関数（例えば `fmt.Printf` や `fmt.Println`）を使用した際に、その型のオブジェクトを自分自身のカスタムな文字列表現に変換することができます。

`Stringer` インターフェースは以下のように定義されています：

```go
type Stringer interface {
    String() string
}
```

このインターフェースは、`String` メソッドを持つ任意の型によって実装されます。`String` メソッドは、その型のオブジェクトを文字列表現に変換した文字列を返す必要があります。

以下に簡単な例を示します：

```go
package main

import "fmt"

type Person struct {
    FirstName string
    LastName  string
}

func (p Person) String() string {
    return fmt.Sprintf("%s %s", p.FirstName, p.LastName)
}

func main() {
    person := Person{
        FirstName: "John",
        LastName:  "Doe",
    }

    fmt.Println(person) // "John Doe"
}
```

この例では、`Person` 構造体が `Stringer` インターフェースを実装しています。`String` メソッド内で `fmt.Sprintf` を使用して、`FirstName` と `LastName` を結合したカスタムな文字列表現を生成しています。そして、`fmt.Println` を使用して `Person` オブジェクトを出力すると、`String` メソッドの結果が表示されます。

`Stringer` インターフェースを活用することで、自分自身の型のオブジェクトを独自の形式で出力することができ、デバッグやログ出力などで便利に使うことができます。
