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

- 関数も変数
- 他の変数のように関数を渡すことが可能

```go
import (
	"fmt"
	"math"
)

func compute(fn func(float64, float64) float64) float64 {
	return fn(3, 4)
}

func main() {
	hypot := func(x, y float64) float64 {
		return math.Sqrt(x*x + y*y)
	}

	fmt.Println(hypot(5, 12)) // 13
	fmt.Println(compute(hypot)) // 5
	fmt.Println(compute(math.Pow)) // 81
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

## 可変長引数

### 概要

- 関数が任意の数の引数を受け取ることを可能にする
- 引数の型の後に`...`を使用して定義する
- 可変長引数は、関数内でスライスとして扱われる

### 定義方法

- 可変長引数を持つ関数の例：`func sum(nums ...int) int`
- この例では、`nums`は`int`のスライスとして関数内で扱われる

### 関数内での使用

- 可変長引数は関数内でスライスのように使用できる
- 例：`for _, num := range nums`で`nums`の各要素をループ処理

### 可変長引数の呼び出し

- 関数を呼び出すときは、任意の数の引数を渡すことができる
- 例：`sum(1, 2, 3, 4)`

### スライスとしての引数渡し

- スライスを可変長引数として直接渡すこともできる
- この場合、スライスの後に`...`を付ける：`sum(slice...)`

### 制約

- 可変長引数は関数定義で最後に配置する必要がある
- 一つの関数に一つの可変長引数しか定義できない

### 使用例

```go
func sum(nums ...int) int {
    total := 0
    for _, num := range nums {
        total += num
    }
    return total
}

func main() {
    result := sum(1, 2, 3, 4)
    fmt.Println(result) // 出力: 10
}
```

この例では、`sum`関数は任意の数の整数を受け取り、それらを合計する。`main`関数では、`sum`に 4 つの整数を渡している。

## クロージャ

- クロージャは、関数の外部にある変数を参照することができる特殊な関数
- クロージャはこれらの外部変数にアクセスし、変更することが可能

```go
import "fmt"

func adder() func(int) int {
	sum := 0
	return func(x int) int { // この関数がクロージャ
		sum += x
		return sum
	}
}

func main() {
	pos, neg := adder(), adder()
	for i := 0; i < 10; i++ {
		fmt.Println(
			pos(i),
			neg(-2*i),
		)
	}
}

// 0 0
// 1 -2
// 3 -6
// 6 -12
// 10 -20
// 15 -30
// 21 -42
// 28 -56
// 36 -72
// 45 -90

```
