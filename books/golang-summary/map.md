---
title: "マップ（map）"
---

- マップは配列が基盤となっている
- JS のオブジェクトみたいな感じ
- キーと値のペアコレクション
- ゼロ値は `nil`
- `nil` マップはキーを持たず、キーを追加することもできない

## 宣言

### 初期化

```go
nameScore := map[string]int{
    "ryo": 11,
    "taro":  45,
}
fmt.Println(nameScore) // map[ryo:11 taro:45]
```

### 空のマップ作成

```go
nameScore := make(map[string]int)
fmt.Println(nameScore, nameScoew == nil) // map[] false
```

```go
var nameScore map[string]int
fmt.Println(nameScore, nameScore == nil) // map[] true
```

```go
nameScore := map[string]int{}
fmt.Println(nameScore, nameScore == nil) // map[] nil
```

## 項目の追加

```go
nameScore["jiro"] = 18
```

## 項目へのアクセス

- 存在しないキーにアクセスしても panic にはならない
- 存在しないキーにアクセスすると、要素型のゼロ値が返される

```go
fmt.Println(nameScore["jiro"])
```

## 存在チェック

```go
score, ok := nameScore["yoshio"]
if ok {
    fmt.Println("yoshio's score is", score)
}
```

`ok` は存在すれば `true`、存在しなければ `false`。

## 項目の削除

```go
delete(nameScore, "yoshio")
```

存在しない項目を削除しようとしても、Go は panic にならない。

## マップ内ループ

```go
nameScore := map[string]int{
    "ryo": 11,
    "taro":  45,
}
for name, score := range nameScore {
    fmt.Printf("%s\t%d\n", name, score)
}

// Output:
// ryo 11
// taro 45
```

## 構造体とマップ

```go
type Vertex struct {
	Lat, Long float64
}

var m map[string]Vertex

func main() {
	m = make(map[string]Vertex)
	m["Bell Labs"] = Vertex{
		40.68433, -74.39967,
	}
	fmt.Println(m["Bell Labs"])
}
```

https://zenn.dev/rstliz/articles/14b5de09e1a68a
