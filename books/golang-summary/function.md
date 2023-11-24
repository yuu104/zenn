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
