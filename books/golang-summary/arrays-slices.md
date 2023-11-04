---
title: "配列・スライス"
---

## 配列（Array）

- 配列は「複合型（composite type）の一種
- 単一のデータ列で構成されている

### 宣言と初期化

5 つの文字列型の配列 `fruits` を宣言する。

```go
var fruits [5]string
```

```go
fruits := [5]string{"apple", "baana", "orange", "straberry", "grape"}
```

- 配列の長さは型の一部
- 配列のサイズを変えることはできない

### 要素へのアクセス

```go
fruits[0] = "Apple"
fruits[1] = "Banana"
```

### 要素数の取得

```go
length := len(fruits)
```

### 範囲内のループ

`range` を使用して、インデックスと要素のペアを取得できる。

```go
for index, fruit := range fruits {
  fmt.Printf("fruits[%d] = %s\n", index, fruit)
}
```

### 多次元配列

```go
// var matrix [3][3]int
matrix := [3][3]int{
  {1, 2, 3},
  {4, 5, 6},
  {7, 8, 9},
}

matrix[0][0] = 1
matrix[0][1] = 2

for i := 0; i < len(matrix); i++ {
  for j := 0; j < len(matrix[i]); j++ {
    fmt.Printf("matrix[%d][%d] = %d\n", i, j, matrix[i][j])
  }
}
```

## 配列は「値」である

- 変数 `ary` を図で表すならこんな感じ

![](https://storage.googleapis.com/zenn-user-upload/d3c1bf5c2fba-20231104.png)

- ポイントは、型名が `[4]int` の固定長データであること
- 配列の型や数が異なれば異なる型として扱われる
- また、配列は「**値**」である
- つまり、同じ型であれば `==` 演算子で同値性の評価ができる
  - 異なる型同士は評価できない

```go
func main() {
  ary1 := [4]int{1, 2, 3, 4}
  ary2 := [4]int{1, 2, 3, 4}
  ary3 := [4]int{2, 3, 4, 5}
  ary4 := [4]int64{1, 2, 3, 4}

  fmt.Printf("ary1 == ary2: %v\n", ary1 == ary2) // ary1 == ary2: true
  fmt.Printf("ary1 == ary3: %v\n", ary1 == ary3) // ary1 == ary3: false
  fmt.Printf("ary1 == ary4: %v\n", ary1 == ary4) // invalid operation: ary1 == ary4 (mismatched types [4]int and [4]int64)
}
```

- 配列は「**値**」であるため、`:=` 等による代入構文で内容も含めてインスタンスのコピーが発生する
- - `[4]int` であれば、`int` が 4 つ並んだ「値」として考える
- 関数の引数に配列を指定した場合も同様にコピーが渡される

```go
func displayArray4Int(ary [4]int) {
  fmt.Printf("Pointer: %p , Value: %v\n", &ary, ary)
}

func main() {
  ary1 := [4]int{1, 2, 3, 4}
  ary2 := ary1

  fmt.Printf("Pointer: %p , Value: %v\n", &ary1, ary1)
  fmt.Printf("Pointer: %p , Value: %v\n", &ary2, ary2)
  displayArray4Int(ary1)
  // Output: 全て異なるアドレス
  // Pointer: 0xc0000141a0 , Value: [1 2 3 4]
  // Pointer: 0xc0000141c0 , Value: [1 2 3 4]
  // Pointer: 0xc000014240 , Value: [1 2 3 4]
}
```

- 関数にインスタンス自体を渡したい場合、ポインタ値を渡す

```go
func referArray4Int(ary *[4]int) {
    fmt.Printf("Pointer: %p , Value: %v\n", ary, ary)
}

func main() {
    ary1 := [4]int{1, 2, 3, 4}

    fmt.Printf("Pointer: %p , Value: %v\n", &ary1, ary1)
    referArray4Int(&ary1)
    // Output:
    // Pointer: 0xc0000141a0 , Value: [1 2 3 4]
    // Pointer: 0xc0000141a0 , Value: &[1 2 3 4]
}
```

## スライス(Slice)

- 配列は固定長であったが、スライスは
