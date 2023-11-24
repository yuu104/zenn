---
title: "型"
---

## 基本型

基本型は以下の通り

```
bool

string

int  int8  int16  int32  int64
uint uint8 uint16 uint32 uint64 uintptr

byte // uint8 の別名

rune // int32 の別名
     // Unicode のコードポイントを表す

float32 float64

complex64 complex128
```

- `int`, `uint`, `uintptr` は、
  - 32-bit のシステムでは 32bit
  - 64-bit のシステムでは 64 bit
- サイズ、符号なし整数の型を使用する特別な理由がない限り、整数には `int` を使用する

## 型変換

- 変数 `v` を `T` 型に変換するには、`T(v)`

```go
var i int = 42
var f float64 = float(i)
var u uint = uint(f)
```

```go
i := 42
f := float64(i)
u := uint(f)
```

## 型推論

```go
var i int
j := i // `i`は`int`型であるため、型推論により`j`は`int`型
```

```go
i := 42           // int
f := 3.142        // float64
g := 0.867 + 0.5i // complex128
```
