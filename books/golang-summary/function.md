---
title: "関数"
---

## 基礎

- 関数は、0 個以上の引数を取ることができる
- 引数の型指定では、変数の**後ろ**に型名を記述する

```go
func add(x int, y int) int {
	return x + y
}

func main() {
  add(42, 13) // 関数を使用する
}
```

- 2 つ以上の引数が同じ型である場合、以下のように省略できる

```go
func add(x, y int) int {
  return x + y
}
```

## 複数の戻り値

```go
func swap(x, y string) (string, string) {
  return y, x
}

func main() {
  a, b := swap("hello", "world")
}
```

## Named return values

- 戻り値となる変数名を事前に設定しておける
- `return` に何も指定しなくて良くなる

```go
func split(sum int) (x, y int) {
	x = sum * 4 / 9 // 戻り値 `x`
	y = sum - x // 戻り値 `y`
	return
}
```

https://zenn.dev/yuyu_hf/articles/c7ab8e435509d2
