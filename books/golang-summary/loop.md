---
title: "ループ処理"
---

## for 文

```go
sum := 0

for i := 0; i < 10; i++ {
  sum += 1
}
```

```go
sum := 1

for ; sum < 1000; {
  sum += sum
}
```

## while 文を表現する

- Go には `while` が存在しない
- `for` により表現する

```go
sum := 1

for sum < 1000 {
  sum += sum
}
```

## 無限ループ

- ループ条件を省略する

```go
for {
}
```

## for と range

- `range` はコレクション（スライス、マップ、文字列など）を繰り返し処理するためのキーワード
- コレクションの各要素に対して繰り返し処理を簡単に書ける

```go
mySlice := []int{1, 2, 3, 4}

for _, value := range mySlice {
    fmt.Println(value) // 1, 2, 3, 4 の順に出力される
}
```

### Slice や Array での使用

`range` は Slice や Array の各要素に対して、そのインデックスと値を返す。

```go
numbers := []int{10, 20, 30, 40}
for i, v := range numbers {
    fmt.Printf("Index: %d, Value: %d\n", i, v)
}
```

### map での使用

キーと値のペアを返す。

```go
capitals := map[string]string{"France": "Paris", "Italy": "Rome"}
for country, capital := range capitals {
    fmt.Printf("The capital of %s is %s\n", country, capital)
}
```

### 文字列での使用

各文字のインデックス（バイト単位）とその文字の Unicode コードポイントを返す。

```go
for i, c := range "go" {
    fmt.Printf("%d: %d\n", i, c)
}
// 出力: 0: 103 (gのUnicodeコードポイント)
//       1: 111 (oのUnicodeコードポイント)
```

### インデックスまたは値のみを使用する

`_`　で省略できる。

```go
for _, value := range numbers {
    fmt.Println(value)
}
```

値が不要な場合、以下のように省略できる。

```go
for key := range capitals {
    fmt.Println(key)
}
```

```go
for i := range numbers {
    fmt.Println(i)
}
```

### Slice や Array の値を変更する

1. **値の変更は元のスライスや配列に反映されない**

   - `range` はコレクションの各要素のコピーを作成する
   - だから、`range` のループ内で値を変更しても、それは元のスライスや配列には影響しない

   ```
   numbers := []int{1, 2, 3}
   for _, v := range numbers {
     v *= 2 // これは元のnumbersには影響しない
   }
   ```

2. **元の要素を変更するにはインデックスを使用する**

   - スライスや配列の要素を変更するには、インデックスを使って直接アクセスする必要がある

   ```go
     for i := range numbers {
      numbers[i] *= 2 // これで元のnumbersが変更される
    }
   ```
