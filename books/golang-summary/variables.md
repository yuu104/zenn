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
