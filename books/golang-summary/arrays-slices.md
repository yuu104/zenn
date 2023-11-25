---
title: "Array（配列）・Slice"
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

インデックスや値は `_` を入力することで捨てることが可能。

```go
for i, _ := range pow
for _, value := range pow
```

もしインデックスだけが必要なのであれば、2 つ目の値を省略する。

```go
for i := range pow
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
- `[4]int` であれば、`int` が 4 つ並んだ「値」として考える
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

- 配列は固定長であったが、Slice は可変長
- 配列との記述上の違いは型名の `[]` の中にデータ数を指定するか否か

```go
func main() {
    slc1 := []byte{0, 1, 2, 3, 4}
    fmt.Printf("Type: %[1]T , Value: %[1]v\n", slc1)
    // Output:
    // Type: []uint8 , Value: [0 1 2 3 4]
}
```

### 空の Slice を生成する

```go
var slc1 []byte         // ZERO value
slc2 := []byte{}        // empty Slice (size 0)
slc3 := make([]byte, 5) // empty Slice (size 5)
```

- ゼロ値とサイズ 0 の Slice に対して、`slc1[0]` などと指定すると、panic を吐く

### 配列を Slice に変換する

```go
func main() {
    ary1 := [5]byte{0, 1, 2, 3, 4}
    slc1 := ary1[:]
    slc2 := ary1[:2]
    fmt.Println(ary1) // [0, 1, 2, 3, 4]
    fmt.Println(slc1) // [0, 1, 2, 3, 4]
    fmt.Println(slc2) // [0, 1]
}
```

### Slice の一部を取り出す

```go
subSlice := mySlice[start:end]  // インデックスstartからend-1までの要素を含むSliceを取得
```

## Slice の実体

### Slice は配列への参照を持つ実体

```go
func main() {
    ary1 := [5]byte{0, 1, 2, 3, 4}
    slc1 := ary1[:]
    fmt.Printf("Pointer: %p , Refer: %p , Value: %v\n", &ary1, &ary1[0], ary1)
    fmt.Printf("Pointer: %p , Refer: %p , Value: %v\n", &slc1, &slc1[0], slc1)
    // Output:
    // Pointer: 0xc000012088 , Refer: 0xc000012088 , Value: [0 1 2 3 4]
    // Pointer: 0xc000004078 , Refer: 0xc000012088 , Value: [0 1 2 3 4]
}
```

- `&ary1[0]` と `&slc1[0]` のポインタ値は同じ
- つまり、Slice の中身は代入した配列と同じ
- Slice の実体は、以下の 3 つを属性として持つオブジェクト
  - 参照する配列へのポインタ値
  - 長さ（ `len()`）: Slice 内の要素数
  - 容量（`cap()`）: Slice が追加の要素を格納できるメモリスペースの量

![](https://storage.googleapis.com/zenn-user-upload/f729f97252df-20231105.png)

- Slice 変数を作成しても、それ自体が値を保持しているわけではない

ここで、

```go
slc1 := ary1[:]
```

は以下のように図示できる。

![](https://storage.googleapis.com/zenn-user-upload/236f1525e891-20231105.png)

```go
slc2 := ary1[2:4]
```

は以下のように図示できる。

![](https://storage.googleapis.com/zenn-user-upload/fd4e0a3a88d3-20231105.png)

さらに、`slc2` に対して、

```go
slc3 := sl2[:cap(slc2)]
```

とすると、

![](https://storage.googleapis.com/zenn-user-upload/41fa0f1909a3-20231105.png)

のように取り出せる。

```go
func main() {
    ary1 := [5]byte{0, 1, 2, 3, 4}
    slc1 := ary1[:]
    slc2 := ary1[2:4]
    slc3 := slc2[:cap(slc2)]
    fmt.Printf("Refer: %p , Len: %d , Cap: %d , Value: %v\n", &ary1[0], len(ary1), cap(ary1), ary1)
    fmt.Printf("Refer: %p , Len: %d , Cap: %d , Value: %v\n", &slc1[0], len(slc1), cap(slc1), slc1)
    fmt.Printf("Refer: %p , Len: %d , Cap: %d , Value: %v\n", &slc2[0], len(slc2), cap(slc2), slc2)
    fmt.Printf("Refer: %p , Len: %d , Cap: %d , Value: %v\n", &slc3[0], len(slc3), cap(slc3), slc3)
    // Output:
    // Refer: 0xc000012088 , Len: 5 , Cap: 5 , Value: [0 1 2 3 4]
    // Refer: 0xc000012088 , Len: 5 , Cap: 5 , Value: [0 1 2 3 4]
    // Refer: 0xc00001208a , Len: 2 , Cap: 3 , Value: [2 3]
    // Refer: 0xc00001208a , Len: 3 , Cap: 3 , Value: [2 3 4]
}
```

### Slice は参照のように振る舞う「値」

```go
func displaySliceByte(slc []byte) {
    fmt.Printf("Pointer: %p , Refer: %p , Value: %v\n", &slc, &slc[0], slc)
}

func main() {
    ary1 := [5]byte{0, 1, 2, 3, 4}
    slc1 := ary1[:]
    fmt.Printf("Pointer: %p , Refer: %p , Value: %v\n", &ary1, &ary1[0], ary1)
    fmt.Printf("Pointer: %p , Refer: %p , Value: %v\n", &slc1, &slc1[0], slc1)
    displaySliceByte(slc1)
    // Output:
    // Pointer: 0xc000102058 , Refer: 0xc000102058 , Value: [0 1 2 3 4]
    // Pointer: 0xc000100048 , Refer: 0xc000102058 , Value: [0 1 2 3 4]
    // Pointer: 0xc000100078 , Refer: 0xc000102058 , Value: [0 1 2 3 4]
}
```

- 3 つの配列・Slice は全て同一の配列を指している
- `displaySliceByte()` の引数として受け取った Slice と渡す前の Slice は異なるインスタンス
  - つまり、値渡し
- このように、Slice は「配列への参照のように振る舞う」だけで、本当の意味での「参照」ではない
- しかし、引数の Slice は同じ Array を参照するため、関数内で要素を変更すれば元の Slice と Array も変化する

```go
func displaySliceByte(slc []byte) {
    slc[0] = 9
    fmt.Println(ary) // [9 1 2 3 4]
}

func main() {
    ary1 := [5]byte{0, 1, 2, 3, 4}
    slc1 := ary1[:]
    displaySliceByte(slc1)

    fmt.Println(ary1) // [9 1 2 3 4]
    fmt.Println(slc1) // [9 1 2 3 4]
}
```

### Slice 要素の追加と capacity

- Slice へ要素を追加するには `append()` を使用する
- 引数に渡された Slice にデータを追加する組み込み関数

```go
var slc []int
slc = append(slc, 1) // [1]
```

- しかし、slice は固定長の Array を参照しているオブジェクトである
- そのため、`append()` は Slice が参照している Array に対して処理をしておらず、メモリ上で新たな Array を作成している

```go
func main() {
    var slc []int
    fmt.Printf("Pointer: %p , <ZERO value>\n", &slc)
    for i := 0; i < 5; i++ {
        slc = append(slc, i)
        fmt.Printf("Pointer: %p , Refer: %p , Value: %v (%d)\n", &slc, &slc[0], slc, cap(slc))
    }
    // Output:
    // Pointer: 0xc000004078 , <ZERO value>
    // Pointer: 0xc000004078 , Refer: 0xc000012088 , Value: [0] (1)
    // Pointer: 0xc000004078 , Refer: 0xc0000120d0 , Value: [0 1] (2)
    // Pointer: 0xc000004078 , Refer: 0xc0000141c0 , Value: [0 1 2] (4)
    // Pointer: 0xc000004078 , Refer: 0xc0000141c0 , Value: [0 1 2 3] (4)
    // Pointer: 0xc000004078 , Refer: 0xc00000e340 , Value: [0 1 2 3 4] (8)
}
```

- `append()` すると、`&slc[0]` が変化している
- つまり、メモリ上で新たに array を作成し、再代入により Slice `slc` が参照先を上書きしている
- しかし、`[0 1 2]` → `[0 1 2 3]` の `append` は `&slc[0]` が変化していない
- よく見ると、capacity も `4` のままで変化していない
- つまり、参照先 Array 用に割り当てた容量が足りなくなった際、それを増やすために新規の Array が確保されている

## Slice の複製

- 配列は「値」なので、比較可能で、代入時にはコピーが作成される
- Slice では `:=` 等の代入構文を使用しても内容の複製はされない

```go
s1 := []int{1,2,3}
s2 := s1 // これは複製ではない
s2[1] = 0

// 同じarrayを参照している
fmt.Println(s1) // [1 0 3]
fmt.Println(s2) // [1 0 3]
```

![](https://storage.googleapis.com/zenn-user-upload/51ae2d83c21c-20231105.png)

### `copy()`

```go
func main() {
    slc1 := []int{0, 1, 2, 3, 4}
    slc2 := slc1
    slc3 := make([]int, len(slc1), cap(slc1))
    copy(slc3, slc1)
    fmt.Printf("Pointer: %p , Refer: %p , Value: %v\n", &slc1, &slc1[0], slc1)
    fmt.Printf("Pointer: %p , Refer: %p , Value: %v\n", &slc2, &slc2[0], slc2)
    fmt.Printf("Pointer: %p , Refer: %p , Value: %v\n", &slc3, &slc3[0], slc3)
    // Output:
    // Pointer: 0xc000004078 , Refer: 0xc00000c2a0 , Value: [0 1 2 3 4]
    // Pointer: 0xc000004090 , Refer: 0xc00000c2a0 , Value: [0 1 2 3 4]
    // Pointer: 0xc0000040a8 , Refer: 0xc00000c2d0 , Value: [0 1 2 3 4]
}
```

- `:=` では Slice が参照する array の複製はできないため、`&slc1[0]` と `&slc2[0]` の値は同じ
- `copy()` を使用することで、array の複製ができる

### Slice 標準パッケージの `slices.Clone()`

- Go 1.21 から slices 標準パッケージが追加された

```go
package main

import (
    "fmt"
    "slices"
)

func main() {
    slc1 := []int{0, 1, 2, 3, 4}
    slc2 := slc1
    slc3 := slices.Clone(slc1)
    fmt.Printf("Pointer: %p , Refer: %p , Value: %v\n", &slc1, &slc1[0], slc1)
    fmt.Printf("Pointer: %p , Refer: %p , Value: %v\n", &slc2, &slc2[0], slc2)
    fmt.Printf("Pointer: %p , Refer: %p , Value: %v\n", &slc3, &slc3[0], slc3)
    // Output:
    // Pointer: 0xc000010018 , Refer: 0xc000072000 , Value: [0 1 2 3 4]
    // Pointer: 0xc000010030 , Refer: 0xc000072000 , Value: [0 1 2 3 4]
    // Pointer: 0xc000010048 , Refer: 0xc000072030 , Value: [0 1 2 3 4]
}
```

## Slice の比較

### `reflect.DeepEqual()`

```go
func main() {
    slc1 := []int{0, 1, 2, 3, 4}
    slc2 := []int{0, 1, 2, 3, 4}
    if reflect.DeepEqual(slc1, slc2) {
        fmt.Println("slc1 == slc2: true")
    } else {
        fmt.Println("slc1 == slc2: false")
    }
    // Output
    // slc1 == slc2: true
}
```

### Slice 標準パッケージの `slices.Clone()`

```go
package main

import (
    "fmt"
    "slices"
)

func main() {
    slc1 := []int{0, 1, 2, 3, 4}
    slc2 := []int{0, 1, 2, 3, 4}
    if slices.Equal(slc1, slc2) {
        fmt.Println("slc1 == slc2: true")
    } else {
        fmt.Println("slc1 == slc2: false")
    }
    // Output
    // slc1 == slc2: true
}
```

## Slice の length と capacity

- Slice の実体は、以下の 3 つを属性として持つオブジェクト
  - 参照する配列へのポインタ値
  - 長さ（ `len()`）
  - 容量（`cap()`）

![](https://storage.googleapis.com/zenn-user-upload/f729f97252df-20231105.png)

- 「長さ（length）」は Slice に含まれる要素の数
- 「容量（capacity）」は、Slice に割り当てられているバッファのサイズ
  - Slice の最初の要素から数えて、元となる配列の要素数でもある
- Slice `s` の長さと容量は、`len(s)` と `cap(s)` を使用して得ることができる

### capacity の増加

- Slice は可変長であることから、length と capacity の値も変化する
- `append()` により要素を追加する際、capacity を超えて値の追加を試みると、ランタイム上で新しいメモリ領域（新しい Array）を割り当てて Slice の capacity を自動で増やす

## Slice の空チェック

### 空は「長さ」でチェックする

- `len()` による**長さ**でチェックする

```go
func isEmpty(s []string) bool {
  return len(s) == 0
}
```

- `nil` でチェックしてはいけない

```go
func isEmpty(s []string) bool {
  return s == nil
}
```

### 「長さ」でチェックする理由

- **Slice が空になり、nil にならない**場合が発生する可能性があるため
- 「長さ」でチェックしないと漏れが発生する
- ポイントは
  - Slice を空で宣言しても宣言の仕方によって nil Slice か empty Slice になる
  - nil Slice と empty Slice ともに `len` と `cap` が 0

#### 空で宣言しても宣言の仕方によって nil Slice か empty Slice になる

- 宣言方法によって、slice が `nil` であるかが決まる

```go
func isEmptyByNil(intSlice []int) string {
    if intSlice == nil {
        return "nil!"
    } else {
        return "not nil!"
    }
}

func main() {
    // nil Slice
    // こう定義するとnilになる
    var nilSlice []int
    fmt.Println(nilSlice, len(nilSlice), cap(nilSlice)) // [] 0 0
    fmt.Printf("nilSlice: %s\n\n", isEmptyByNil(nilSlice)) // nilSlice: nil!

    // empty Slice
    // こう定義するとnilにはならず、lenとcapが0となる
    emptySlice := []int{}
    fmt.Println(emptySlice, len(emptySlice), cap(emptySlice)) // [] 0 0
    fmt.Printf("emptySlice: %s\n\n", isEmptyByNil(emptySlice)) // emptySlice: not nil!
}
```

#### nil Slice と empty Slice ともに len と cap が 0

- しかし、どちらの宣言方法でも `len` と `cap` が 0 であるため、「長さ」でチェックすれば漏れが発生することはない

```go
func isEmptyByLen(intSlice []int) string {
    if len(intSlice) == 0 {
        return "len is zero!"
    } else {
        return "len is not zero!"
    }
}

func main() {
    // こう定義するとnilになる
    var nilSlice []int
    fmt.Println(nilSlice, len(nilSlice), cap(nilSlice)) // [] 0 0
    fmt.Printf("nilSlice: %s\n\n", isEmptyByLen(nilSlice)) // nilSlice: len is zero!

    // こう定義するとnilにはならず、lenとcapが0のSliceとなる
    emptySlice := []int{}
    fmt.Println(emptySlice, len(emptySlice), cap(emptySlice)) // [] 0 0
    fmt.Printf("emptySlice: %s\n\n", isEmptyByLen(emptySlice)) // emptySlice: len is zero!
}
```

## 参考リンク

https://zenn.dev/spiegel/articles/20210315-array-and-Slice

https://qiita.com/seihmd/items/d9bc98a4f4f606ecaef7

https://qiita.com/Yashy/items/1d4f277998866b186e19

https://zenn.dev/sryoya/articles/6a8ae7daa20aa7
